# ENHANCEMENT BACKLOG INPUT (E6 / Tier 3) - 2026-07-25

STATUS: Gate 1 INPUT ONLY. Nothing here is locked. No code, no matrix.
This is the E7 R2 reference-capture deliverable (Tier 3 run) feeding E6
(Drawdown Reduction Tier 3 - PARTIAL-LOT close). Merge target when E6 is
opened: STATE.md "Enhancement backlog" E6 line + a locked-decisions block.
STATE.md was NOT modified by this analysis - fingerprint at read time:
sha256_16 8a43e899bd359493, 1262 lines, build E5-b37.
src/TRTM.mq5 at read time: 73dda148c79f1b27, 4568 lines (aligned, runtime==repo).

Source: ONE MT5 strategy-tester run of Shadow Trade Manager PRO v3.21
(third-party EA, reverse-engineered from logs only - no source access).
File: docs/STM Drawdown Reduction Tier3 Logs.txt (1084 lines). GBPAUD.s M15,
DooTechnology-Demo, build 5833, initial deposit 3000.00 USD, leverage 1:500.
Run recorded 2026.07.25 06:51. Point=0.00001, Digits=5, StopsLevel=25.0.
Config had ALL THREE tiers enabled:
  InpEnablePartialClose1=true  (PC1_MinTrades 4, PC1_MinProfitPoints 150)
  InpEnablePartialClose2=true  (PC2_MinTrades 4, PC2_ProfitPercent 1.0)
  InpEnablePartialClose3=true  (PC3_MinTrades 4, PC3_MinLots 0.02,
                                PC3_MinProfitPoints 200, PC3_ClosePercent 50.0)
Auto-Adjust raised the recovery interval 200 -> 350 pts for GBPAUD.s.
Recovery bar-close entry ON.

WHAT THE RUN GIVES: TWO Tier 3 fires on the same deep SELL sequence
(magic 100001), plus interleaved Tier 1 fires. This is the FIRST run with
non-zero Tier 3 behavior (both prior runs had InpEnablePartialClose3=false,
so E6 had ZERO observed behavior until now). Both Tier 3 fires recompute to
the cent below.

IMPORTANT: Shadow is a REFERENCE, not a spec. Items are marked OBSERVED
(evidenced in the log, arithmetic recomputed here) or OPEN (a TRTM Gate 1
sub-decision, deliberately NOT resolved in this input doc). Do not let an
OPEN item be mistaken later for verified reference behavior.

---

## HEADLINE FINDING

Tier 3 differs from Tier 1/Tier 2 in ONE structural way, and it is a big
one: **the anchor is only PARTIALLY closed (a lot "slice"), and the trigger
is evaluated against the CLOSING group's VWAP - the anchor counted at its
SLICE volume (the lots being closed), NOT its surviving remainder.**
Profitables still close FULLY; everything else (oldest anchor, direction-
derived close side, lot-weighted post-fire TP, count gate) matches Tier 1.
The gate is measured over the ACTUALLY-CLOSED lots, structurally the SAME as
Tier 1's group gate - Tier 3 just substitutes the anchor's slice for its
full volume, the remainder surviving untouched.

  Tier 1 (E4, SEALED): close the WHOLE anchor + all profitables; gate =
                       FULL-anchor group VWAP clears 150 pts per lot.
  Tier 3 (E6, this doc): SLICE the anchor (ClosePercent of its lots, floored
                       to lot step, anchor must be >= MinLots), close all
                       profitables fully; gate = SLICED-anchor group VWAP
                       clears MinProfitPoints (200) per lot.

Consequence, and the whole point of Tier 3: by dropping the deep-loss
anchor's weight in the VWAP, Tier 3 can harvest profit on ticks where Tier 1
and Tier 2 STRUCTURALLY cannot. In BOTH observed fires the FULL-anchor group
was at or below break-even (fire 1: +80 pts, ~+10 USD; fire 2: NEGATIVE, -77
pts), so Tier 1 (needs +150) and Tier 2 (needs ~+30 USD) both failed - only
the sliced-anchor reframing cleared 200 pts (both fires landed at ~+206 pts).
Tier 3 realizes a FRACTION of the anchor's loss in exchange for banking the
full profit of the newest positions, trimming basket exposure without
fully surrendering the oldest, most swap-expensive leg.

NEW money-path primitive vs Tier 1/2: a PARTIAL position close (close N of M
lots, position survives with M-N). Tier 1/2 only ever did full closes.
NOTE (a plus): Tier 3's gate is POINTS-based (per-lot VWAP margin), like
Tier 1 - so it does NOT introduce the cross-currency money valuation that
Tier 2 needed (T2-O7). No new FX path.

---

## FIRE 1 - 2026.06.25 15:47:58 (log lines 506-532)

Header (verbatim, lines 506-507):
    === DRAWDOWN REDUCTION TIER 3 TRIGGERED ===
    Basket VWAP (sliced anchor): 1.90990 | Full anchor vol: 0.02 | Slice vol: 0.01 | Remaining: 0.01

Basket = 9 open SELL positions. Bid/Ask at fire = 1.90756 / 1.90784.
Group closed: anchor #3 (SLICED) + profitables #16, #15.
  #3  anchor sell 0.02 @ 1.88594   -> sliced 0.01, 0.01 remains alive
  #16 prof.  sell 0.09 @ 1.91286   -> closed FULLY (deal #18, buy 0.09 @1.90784)
  #15 prof.  sell 0.08 @ 1.90957   -> closed FULLY (deal #19, buy 0.08 @1.90784)

### OBSERVED-1 - Trigger metric = SLICED-anchor group VWAP vs MinProfitPoints (points).
Close side = far side = Ask 1.90784 (SELL basket).
Sliced-anchor VWAP (anchor counted at 0.01, its SLICE vol = the lots closed):
    (0.01*1.88594 + 0.09*1.91286 + 0.08*1.90957) / (0.01+0.09+0.08)
  = 0.3437824 / 0.18 = 1.9099022  ->  1.90990  (matches log EXACTLY)
Margin in front of Ask: 1.90990 - 1.90784 = 0.0020622 = 206.2 pts >= 200. FIRE.

### OBSERVED-2 - Full-anchor group would FAIL Tier 1 AND Tier 2 at this tick.
Full-anchor VWAP (anchor at 0.02):
    (0.02*1.88594 + 0.09*1.91286 + 0.08*1.90957) / 0.19
  = 0.3626418 / 0.19 = 1.9086411 ; margin = 1.9086411 - 1.90784 = 80.1 pts.
  Tier 1 needs 150 -> FAILS.
Full-anchor group P/L in money:
    #3  (1.88594-1.90784)*0.02*1e5 = -43.80 AUD
    #16 (1.91286-1.90784)*0.09*1e5 = +45.18 AUD
    #15 (1.90957-1.90784)*0.08*1e5 = +13.84 AUD  ->  +15.22 AUD ~= +10 USD.
  Tier 2 needs ~1%*3000 ~= +30 USD -> FAILS.
=> At this tick ONLY Tier 3 (sliced) qualifies. The tiers did NOT compete;
   T3 fired because T1/T2 could not. (Precedence when MULTIPLE qualify is
   therefore UNOBSERVED - see T3-O6.)

### OBSERVED-3 - Slice sizing = floor(anchorLot * ClosePercent) to lot step, anchor >= MinLots.
Full anchor 0.02, ClosePercent 50% -> 0.010 -> slice 0.01, remaining 0.01.
Anchor 0.02 == MinLots 0.02 -> eligible. Realized close fraction = 50% (clean here).

### OBSERVED-4 - Close order = anchor-slice FIRST, then profitables DESCENDING ticket.
Deal order: #17 slices anchor #3 (buy 0.01), then #18 closes #16, #19 closes
#15. All on one sub-second tick (07:00:01.785 -> .792), one market buy per
leg, NO retry / NO partial-fill handling. Same fragile anchor-first ordering
TRTM already REJECTED for Tier 1 (E4 O5) - and here the FIRST leg is itself a
partial close, a new failure mode (see T3-O7).

### OBSERVED-5 - Post-fire = lot-weighted survivor TP + count re-index. SAME as Tier 1/2.
Survivors = 7 positions (#3 now 0.01, #4,#5,#6,#7,#8,#9). Log line 531:
"Avg Entry Price = 1.89921  Total Vol = 0.34  Count = 7". Recompute
LOT-WEIGHTED over survivors (anchor counted at its remaining 0.01):
    (0.01*1.88594 + 0.03*1.88917 + 0.04*1.89257 + 0.05*1.89610
     + 0.06*1.89973 + 0.07*1.90297 + 0.08*1.90620) / 0.34
  = 0.645730 / 0.34 = 1.899206  ->  1.89921  (matches EXACTLY; confirms
  Shadow's post-fire anchor is lot-weighted, same basis as TRTM's sealed E1).
Avg TP = 1.89921 - 200 pts = 1.89721 (log line 532). Count-based re-index
(7 survivors) is Shadow's; TRTM already REJECTED it for C3 preserved-index.

---

## FIRE 2 - 2026.07.02 15:31:07 (log lines 927-953)

Header (verbatim, lines 927-928):
    === DRAWDOWN REDUCTION TIER 3 TRIGGERED ===
    Basket VWAP (sliced anchor): 1.92888 | Full anchor vol: 0.03 | Slice vol: 0.01 | Remaining: 0.02

Basket = 13 open SELL positions. Bid/Ask at fire = 1.92653 / 1.92682.
Group closed: anchor #4 (SLICED) + profitables #31, #30.
  #4  anchor sell 0.03 @ 1.88917   -> sliced 0.01, 0.02 remains alive
  #31 prof.  sell 0.13 @ 1.93219   -> closed FULLY (deal #33, buy 0.13 @1.92682)
  #30 prof.  sell 0.12 @ 1.92861   -> closed FULLY (deal #34, buy 0.12 @1.92682)

### OBSERVED-6 - Sliced-anchor VWAP recompute (exact).
    (0.01*1.88917 + 0.13*1.93219 + 0.12*1.92861) / (0.01+0.13+0.12)
  = 0.5015096 / 0.26 = 1.9288831  ->  1.92888  (matches log EXACTLY)
Margin in front of Ask 1.92682: 1.92888 - 1.92682 = 0.0020631 = 206.3 pts
>= 200. FIRE. (Both fires cleared at ~206 pts - the fire condition is a
knife-edge just over the 200 threshold in both cases.)

### OBSERVED-7 - Full-anchor group here is UNDERWATER - fails ALL other tiers harder.
Full-anchor VWAP (anchor at 0.03):
    (0.03*1.88917 + 0.13*1.93219 + 0.12*1.92861) / 0.28
  = 0.539293 / 0.28 = 1.9260464 ; margin = 1.9260464 - 1.92682 = -77.4 pts.
NEGATIVE - the full group would close at a net LOSS. Tier 1 (needs +150) and
Tier 2 (needs positive money) both fail decisively. Only slicing the anchor
down to 0.01 turns a -77 pt group into a +206 pt group. This is the clearest
evidence of what Tier 3 is FOR.

### OBSERVED-8 - Slice floors to lot step; realized ClosePercent DIVERGES from nominal.
Full anchor 0.03, ClosePercent 50% -> 0.015 -> slice 0.01 (NOT 0.02),
remaining 0.02. So the slice is FLOORED to the lot step (0.015 -> 0.01), not
rounded (round-half-up would give 0.02). Realized fraction = 0.01/0.03 = 33%,
not the nominal 50%. Formula consistent with both fires:
    slice = max(1 step, floor(fullAnchorLot * ClosePercent / lotStep) * lotStep)
    fire 1: floor(0.02*0.5/0.01)=floor(1.0)=1 -> 0.01
    fire 2: floor(0.03*0.5/0.01)=floor(1.5)=1 -> 0.01
Both give a 0.01 slice. See T3-O4 (rounding mode is a TRTM decision).

### OBSERVED-9 - Anchor TRANSFERRED between fires (oldest-survivor rule holds).
Fire 1 anchor was #3; fire 2 anchor is #4. Between the fires #3 left the book
(TP/close), so the oldest SURVIVOR became #4 and Tier 3 sliced that. Survivor
list at fire 2 (log line 952, Count 11) contains no #3. Same "anchor = oldest
survivor, transfers when the prior anchor is gone" rule as Tier 1/2.
NOTE: a sliced anchor STAYS the anchor at reduced volume - fire 1 left #3 at
0.01, which is now BELOW MinLots 0.02, so #3 could not be sliced again. What
Tier 3 does when the oldest survivor is < MinLots is UNOBSERVED (see T3-O3).

### OBSERVED-10 - Cosmetic deltas (already-decided / informational).
(a) Completion line "=== TIER 3 COMPLETE: 2 positions closed + anchor sliced. ==="
    - note the distinct "+ anchor sliced" wording (2 full + 1 partial).
(b) F3 defect RECURS: the three close deals each log "Confirmed initial deal
    #N. Position count is 0." - close deals routed through the initial-entry
    branch. TRTM guardrail (E4 matrix X-5 / MarkEAClosed liveness) already
    covers this class. Here it also mis-logs the PARTIAL slice deal as an
    initial deal - same defect, extra reason to attribute by our own state.

---

## WHAT TIER 3 ADDS OVER TIER 1 / TIER 2 (why it is not redundant)

- Tier 1: full-anchor points threshold. Cannot fire when the anchor loss
  outweighs the profitables (the exact deep-drawdown case).
- Tier 2: full-anchor money threshold (percent of balance). Same limitation,
  measured in money.
- Tier 3: SLICES the anchor first, so the gate is measured against a smaller
  realized loss. It fires precisely in the deep-drawdown regime the other two
  are locked out of, at the cost of only partially relieving the oldest leg
  and leaving a reduced-lot anchor alive. It is a gentler, deeper-reaching
  pressure valve. Whether TRTM wants a THIRD trigger with a partial-close
  money path is a Gate 1 call (T3-O0).

---

## OPEN SUB-DECISIONS FOR E6 GATE 1 (resolve ONE at a time, most foundational first)

T3-O0 ADOPT? Is Tier 3 adopted as a DISTINCT third trigger alongside sealed
  Tier 1 + Tier 2 (default-off input, like InpEnableTier1/Tier2), or declined/
  parked? Most foundational - gates all the rest. It introduces the first
  PARTIAL-lot close in the codebase.

T3-O1 PARTIAL-CLOSE PRIMITIVE (the genuinely new money path): closing N of M
  lots on one position, leaving M-N alive at the same entry/ticket. Decide the
  MT5 mechanism (CTrade::PositionClosePartial), lot normalization, and the
  broker-minimum / lot-step / min-remaining constraints. Nothing in the sealed
  core does partial closes.

T3-O2 GATE ON SLICED-ANCHOR VWAP (the defining behavior). The trigger is
  evaluated with the anchor at its SLICE volume (the lots being closed, NOT the
  surviving remainder - OBSERVED, exact both fires; fire 2 forces slice 0.01
  over remainder 0.02), which is what lets Tier 3 fire where full-anchor T1/T2
  cannot.
  Confirm TRTM wants this reframing (it IS the value of Tier 3) and lock the
  naming: it is the CLOSE-GROUP VWAP with a sliced anchor, never the whole
  floating basket. MinProfitPoints is Tier 3's OWN threshold (200 here, vs
  T1's 150) - decide the default.

T3-O3 MinLots SEMANTICS + sub-MinLots anchor. OBSERVED: MinLots gates anchor
  ELIGIBILITY (anchor full vol must be >= MinLots to be sliceable). UNOBSERVED:
  what happens when the oldest survivor is < MinLots (fire 1 left #3 at 0.01 <
  0.02). Options: skip to next-oldest sliceable anchor / close the sub-MinLots
  anchor FULLY (Tier-1 style) / stand Tier 3 down. Must be decided, not
  observed.

T3-O4 SLICE ROUNDING. OBSERVED floor-to-lot-step (0.015 -> 0.01), so realized
  close fraction diverges from nominal ClosePercent (33% vs 50% in fire 2).
  Decide rounding mode (floor / round / ceil), the minimum slice (1 lot step),
  and the interaction with T3-O3's min-remaining. Recompute both fires under
  the chosen rule in the matrix.

T3-O5 ANCHOR PERSISTENCE vs C3 PRESERVED INDEX. The sliced anchor SURVIVES as
  a reduced-volume position at its ladder ADDRESS. C3 (E4) says a rung is an
  address with a DERIVED lot = ComputeLevelLot(N). A partial slice leaves the
  address holding a NON-derived lot (0.01 of a computed 0.02). Decide how the
  preserved-index invariant treats a partially-consumed anchor address:
  does it re-arm to the full computed lot, stay at the residual, or is the
  anchor address special? This is the sharpest interaction with the SEALED
  ladder and needs must-NOT-fire rows in the matrix.

T3-O6 PRECEDENCE among Tier 1 / Tier 2 / Tier 3 (the big one; UNOBSERVED).
  All three were enabled but Tier 3 only fired when T1/T2 gates FAILED at full
  anchor - the competition was never exercised. STRUCTURAL RISK: Tier 3's
  sliced-anchor gate is MORE permissive, so if it is evaluated it could
  pre-empt a full T1/T2 close that would have relieved MORE exposure. E5 built
  a 2-way dispatcher (Tier 2 percent FIRST, then Tier 1 points). E6 extends it
  to 3 tiers - decide the order and whether a tick may fire only ONE tier.
  Recommendation direction (NOT locked): evaluate the FULL-anchor tiers (T1/T2)
  before the partial tier (T3), so Tier 3 is the last-resort valve only when a
  full close does not qualify - but this is a Gate 1 decision with money
  consequences, decided not observed.

T3-O7 CLOSE ORDER + PARTIAL FILL. Shadow does anchor-slice FIRST, then
  profitables descending (OBSERVED), the order TRTM rejected for T1/T2 (E4 O5:
  profitables-first / anchor-last / abort-on-failure so profit is banked before
  the loss leg). For Tier 3 the anchor leg is itself a PARTIAL close - decide
  ordering AND the failure rule if the slice partially fills or the group
  aborts mid-way (the sliced-anchor gate assumed a specific slice volume; a
  short fill breaks the tested margin). Near-certain to inherit E4 O5's
  profitables-first/abort discipline; confirm and extend to the partial leg.

T3-O8 FAR-SIDE DERIVATION, BOTH LAPS. Inherit E4 O4 (direction-derived: SELL
  closes at Ask - OBSERVED both fires; BUY at Bid - platform invariant). Tier 3
  BUY fire is UNOBSERVED (all Shadow data is SELL). Matrix carries both laps.

T3-O9 POST-FIRE TP + RECOVERY REFRESH. Inherit sealed behavior: lot-weighted
  survivor VWAP TP (OBSERVED exact, matches E1 basis) with the reduced anchor
  counted at its residual lot; C3 preserved-index re-arm (reject Shadow's
  count re-index). Confirm the survivor VWAP includes the residual anchor slice
  at its remaining volume (fire 1 recompute confirms it does).

Nothing above is locked. E6 opens at Gate 1 with T3-O0, one question per
message, concrete numbers, recommendation each, rejected alternatives
recorded in STATE.md's locked-decisions log - same protocol as E4/E5.
NOTE: E6 is the FIRST enhancement to introduce a partial-lot close; T3-O1/O5
touch primitives and the sealed ladder that no prior tier did. Expect a
larger matrix than E5's shared-dispatcher reuse.
