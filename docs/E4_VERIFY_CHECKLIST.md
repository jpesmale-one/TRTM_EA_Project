# E4 VERIFICATION CHECKLIST (evidence-audited; terminal is truth)
# Build under test: E4-b36 (src sha256_16 7e14479c83d672a4, 4483 lines).
#   = E4-b35 (c286d11e1f79131c) + the M-1 whole-basket stand-down guard ONLY.
#   M-1 is a pure guard: it returns false ONLY when grp >= openCount (whole
#   basket in group). EVERY prior verified fire was PARTIAL (grp < openCount),
#   so all b35 evidence below CARRIES FORWARD unchanged. The one exception is
#   the live gold SELL fire (whole basket) - under b36 that case STANDS DOWN.
# Rule: recompute EVERY money number to the cent from the log before any PASS.
# Nothing seals until Jeff's explicit word. Rows map to docs/E4_MATRIX.md.

## CONFIRMED SO FAR (2026-07-24, GBPAUD.s tester run, interval 200)
[X] GATE ZERO: compiled 0/0, deployed, init line "E4-b35". (XAUUSD.s + tester.)
[X] K-3: state self-test PASS on init -> schema v4 unchanged, no new persisted key.
[X] C-1 (VWAP helper): recomputed lot-weighted VWAP vs logged TP at 4 depths -
    4-level 1.887501 -> TP 1.88550; 12-level 1.900896 -> 1.89890; survivor 10-level
    (post-fire, assumption-free) 1.899633 -> 1.89763. All match logged TP to the cent.
[X] T-6 (must-not): 12-level SELL basket, all underwater (monotonic rise), Gate A
    satisfied throughout, ZERO profitables -> NO fire. Anchor-only group blocked
    by Gate B, absence proven. Also shows Gate A alone never fires it.

## FIRE PATH VERIFIED (fire1 2026-06-24 15:04:30, SELL, 3-leg group)
Group: anchor L1 (0.01@1.88186) + L12 (0.12@1.90932) + L13 (0.13@~1.91167*).
Close/far 1.90793; logged VWAP 1.90944, margin 150.9 pts (>=150, "just clears").
[X] T-1  fire on the first qualifying tick, margin just clears (150.9 >= 150).
[X] T-5  MID-BAR fire (15:04:30, off the M15 grid); tick-based, not bar-gated.
[X] A-1  anchor = L1 (lowest level / oldest / deep loser), not cheapest-to-close.
[X] G-1  group = anchor + ALL currently-profitable (L12, L13 = only 2 above Ask).
[X] G-2  two framings identical: 0.26 lots x 150.9 pts = 39.23 lot-pts = per-leg
         sum (L1 -26.07 + L12 +16.68 + L13 +48.62).
[X] G-3  combined realized = +39.23 lot-pts (>0); anchor alone -26.07. Invariant held.
[X] X-1  order: profitables FIRST desc ticket (14 -> 13), ANCHOR L1 LAST. Not anchor-first.
[X] X-5  all 3 legs "closed by EA (market close)" in liveness - not mis-tagged (F3).
[X] H-5  atomic: next tick pruned the 3 closed legs (13 -> 10 levels, 0.91 -> 0.65 lots)
         and recomputed before any further eval.
[X] P-1  survivor TP recomputed on lot-weighted survivor VWAP -> 1.89763 (to the cent).
[ ] LITERAL cent-PASS on the group VWAP still wants L13's logged OPEN entry (back-
    solved to 1.91167, consistent with L12 1.90932 + 200pt trigger + spread).

## RUN 2 (tests/2026.07.24 112008.674.txt - interval 250, SL 5000 ON, 4 fires)
Fires: F1 06-24 14:02 anchor L1 (150.5pt); F2 06-25 19:18 anchor L2 (153.9);
F3 06-30 14:13 anchor L3 (156.8); F4 07-02 15:30 anchor L4, 4-leg (154.0).
[X] Fire1 group VWAP LITERAL cent-PASS: L1 0.01@1.88566 + L9 0.09@1.91055 +
    L10 0.10@1.91309 -> VWAP 1.9105755 (logged 1.91058); margin 150.55 (logged
    150.5); G-3 both framings +30.11 lot-pts.
[X] A-2 anchor TRANSFERS L1->L2->L3->L4 across 4 fires (then ->L5 via re-anchor).
[X] X-1 all 4 fires: profitables first desc ticket, ANCHOR LAST (F1 11>10>2,
    F2 16>15>3, F3 25>24>4, F4 33>32>31>L4).
[X] H-2 address-based re-arm: after F1 (survivors L2-L8) recovery re-opens L9@0.09
    (count-reindex would be 0.08); climbs L10@0.10..L17@0.17, lot=0.01xlevel always.
[X] H-4 closed anchors (L1/L2/L3/L4) NEVER re-open; re-arm only at the top.
[X] O-1/O-2 re-armed L9/L10 closed again in F2 - repeated refill+close, each net +.
[X] H-6 SL re-anchor, 4x to the cent: new SL = new-anchor entry + 5000pt ->
    L2 1.93874, L3 1.94257, L4 1.94536, L5 1.94833 (all logged exact). SL never
    references a closed ticket; widens with the structure.
[X] T-5 all fires MID-BAR (14:02:34/19:18:28/14:13:30/15:30:36, off M15 grid).

## RUN 3 - P1 NO-FIRE BYTE-IDENTITY (tests/2026.07.24 131750.190.txt, Tier1=FALSE)
[X] P1 / R-1/2/3: recovery ladder L2-L10 BYTE-IDENTICAL to run 2 (1.88874, 1.89257,
    1.89536, 1.89833, 1.90153, 1.90515, 1.90774, 1.91055, 1.91309) despite a
    different L1 tick (1.88516 vs 1.88566) - ladder converges from L2, recovery
    flow unperturbed by E4.
[X] H-1: lots 0.01..0.16 incremental, identical progression.
[X] C-1/C-2: TP lot-weighted VWAP recompute exact - 4-level VWAP 1.892179 -> TP
    1.89018 (logged 1.89018). SL anchored L1+5000 = 1.93516, stable (no re-anchor,
    Tier1 off). Single money-path basis intact.
[X] Zero Tier 1 fires; basket ran to a clean whole-sequence TP (07-02 10:51) +
    clean deinit. Only difference vs run 2 = Tier 1's presence. Lift-outs inert.

## RUN 4 - BUY LAP + GOLD (tests/2026.07.24 150601.097.txt, XAUUSD.s, 5 BUY fires)
Gold-scaled: interval 1000 ($10), InitialTP 3000, AvgTP 2500, SL 0, MinProfit 500.
Fires anchor L1->L2->L3->L4->L5, margins 568.3/500.9/518.2/501.1/503.7 pts.
[X] T-2 BUY mirror to the cent: far = BID, margin = BID - VWAP. F1 anchor L1
    0.01@4207.50 + L6 0.06@4118.34 -> VWAP 4131.077 (logged 4131.08); margin
    4136.76-4131.08 = 568.3 (logged). F2 VWAP 4109.230/margin 500.9 (both logged).
[X] G-2/G-3 BUY: F1 combined -70.74 + 110.52 = +39.78 lot-pts = 0.07 x 568.3 (>0).
[X] X-1 BUY: profitables first desc ticket, anchor LAST (F1 7>2, F2 13>12>3).
[X] A-2 BUY: anchor transfers L1->L5 across 5 fires. H-2 BUY: re-arm L6@0.06
    (address-based). X-5 BUY attribution. T-5 mid-bar. P-1 survivor recompute.
[X] GOLD money math: VWAP/margin exact at _Point 0.01; F1 banked ~$39.78.
    MONEY PATH NOW PROVEN IN BOTH DIRECTIONS.

## STILL NEEDED
[ ] H-6 BUY mirror (SL was 0 this run) - covered by SELL proof + direction-signed
    ComputeTargets; a literal check = one gold BUY run with InpStopLossPts>0.
[X] D-1/D-2 + T-3 - CONFIRMED by code reasoning + observation. Gate A
    (TRTM.mq5:2164) is a plain count check on live tracked positions. D-1: a fire
    dropping survivors < MinTrades -> Gate A false -> no fire regardless of margin
    (dormant). D-2: recovery rebuilds count >= MinTrades -> Gate A passes ->
    re-evaluates. T-3 is the SAME check pre-activation, OBSERVED in all 4 runs
    (Tier 1 never fired below 4 open). Run C (cap=4) confirmed the cap holds the
    ladder at 5 (Max Recovery Trades WARN) but the capped bottom L5@4142 never
    profited on the ~4136 bounce -> no fire (correct T-6), no live dormancy shown;
    the mechanism is trivial and reasoning-confirmed. Optional live demo: tighter
    interval (~500) + cap + full window so a bounce profits multiple packed levels.
[ ] T-4 (margin just UNDER threshold) - Gate B blocker; shown by T-6 (anchor-only
    negative margin) and every fire clearing >= threshold. Explicit near-miss optional.
[X] X-2/X-3 abort - CONFIRMED by code reasoning (TRTM.mq5:2231-2247; not tester-
    provable, fills always succeed). CloseLegAtMarket returns false ONLY on a
    genuine reject (retcode != DONE and != 10036). X-2: profitable-leg false ->
    return at 2239 BEFORE the anchor close (2244) -> anchor untouched, realized =
    profit subset (each leg POSITION_PROFIT>0, MarkEAClosed) >= 0. X-3: anchor
    false at 2244 -> logs only, anchor stays open, realized = pure profit. G-3
    holds in both partials (anchor loss realized only after profitables banked).
    No orphan state (closed legs MarkEAClosed, pruned next tick).
[X] K-1/K-2/K-3 - CONFIRMED, live demo XAUUSD.s 2026-07-24 15:57 (KILL mid-sequence).
    Unclean-shutdown lock re-assert (kill signature, not clean deinit); state
    self-test PASS (schema v4 intact); Reconcile rebuilt the 4-level SELL basket
    (0.10 lots) entirely from LIVE positions; NO Tier 1 state restored because none
    is persisted (SequenceState has no Tier 1 field - fully derived per tick). No
    orphan key. Tier 1 re-EVALUATED off rebuilt g_state next tick (fired 16:02;
    under b36 that same whole-basket case STANDS DOWN - still clean re-eval).

## LIVE FINDING -> M-1 (b36). Live gold demo SELL fire 2026-07-24 16:02
Group = anchor L1 + 3 profitable = WHOLE basket (4 legs) -> closed everything ->
FLAT. Margin VWAP 4048.98 - Ask 4047.45 = 152.8 pts (live gold, mirror math ok).
BUT it pre-empted the sequence AvgTP (200 pts, projected +19.98): banked ~150 not
~200. Since group==basket, Tier1 VWAP == sequence VWAP, so MinProfit(150) <
AvgTP(200) => Tier1 always fires first. Fix = M-1 stand-down guard (build E4-b36).
[X] Live SELL fire mirror/attribution/order were correct (X-1 L4>L3>L2>L1, X-5) -
    but this exact whole-basket fire is SUPERSEDED by M-1 (now stands down).

## b36 VERIFY (tests/2026.07.24 170104.650.txt, XAUUSD.s, cap=4/interval 500)
[X] GATE ZERO b36: init line "TRTM E4-b36". (recompiled + deployed)
[X] M-1 REGRESSION: PARTIAL fires still fire on b36 - BUY group 3 legs (of 5 open),
    margin 515.4 = Bid 4195.33 - VWAP 4190.18; 2nd fire 507.4. grp(3) < openCount
    -> M-1 inert, fires normally. Guard does not touch real valves.
## b36 run 2 (tests/2026.07.24 170104.650.txt, SELL, interval 300, cap 4)
[X] M-1 REGRESSION again: partial SELL fire group 4 of 5, margin 520.2 = VWAP
    4204.28 - Ask 4199.08; order L5>L4>L3>L1(anchor last); leaves underwater L2.
    grp(4)<openCount(5) -> M-1 inert. Partials unaffected on b36 (confirmed 2x).
[X] D-1 DORMANCY - now OBSERVED (was reasoning): the fire dropped count to 1,
    re-armed only to 3 (never back to 4) -> Tier 1 DORMANT; sequence resolved via
    its OWN broker TP @ 4176.65 (take-profit triggered), not Tier 1. Fire ->
    count<MinTrades -> dormant -> sequence TP banks. Upgrades D-1 to observed.
[X] M-1 STAND-DOWN - VERIFIED (tests/2026.07.24 172008.317.txt; cap=1, MinTrades=2).
    2-level SELL (L1 4207.95 + L2 4210.98); when L2 went green (L1 anchor still
    UNDERWATER at Ask ~4210.9) -> grp(2)==openCount(2) -> logged:
    "Tier 1 stands down: group would close the whole basket ... (M-1)". NO Tier 1
    fire. The sequence then banked via its OWN TP @ 4184.97 = VWAP 4209.967 - 2500pt
    (to the cent) - i.e. +2500 pts, vs the +500 Tier1 would have clipped under b35.
    Also empirically validates (A) over (B): the anchor was the SOLE loser and (A)
    correctly stood down (B would have fired). M-1 delivers its invariant.

## E4-b36 SEALED by Jeff 2026-07-24
All rows green: fire path both directions (to the cent), re-arm, dormancy (observed),
H-6 SELL (4x) + BUY (reasoning + direction-signed), X-2/X-3 (reasoning), K-1/K-2/K-3
(live), C-1/C-2, H-1, P1 byte-identity, M-1 stand-down (observed), gate zero b36.
Optional-only (NOT blocking, deferred): H-6 BUY literal (SL-on gold BUY), a live
gold PARTIAL fire for the strict "live" qualifier (tester gold partials + live
reconcile already cover the gold money math). E4 CLOSED. Manifest bumped to E4-b36.
[ ] LIVE demo XAUUSD touch before final seal (one live fire + restart). Gold MONEY
    math already proven here; demo covers the "live" qualifier + restart.

## GATE ZERO - COMPILE (must pass before anything below)
[X] MetaEditor compiles src/TRTM.mq5 -> 0 errors / 0 warnings. (2026-07-24)
[X] Init line / chart panel shows "E4-b35".

## TEST INPUTS (set on the chart under test)
  InpEnableTier1       = true
  InpTier1MinTrades    = 4
  InpTier1MinProfitPts = 150
  Recovery interval 300, base 0.01 (defaults). Symbol XAUUSD.s only for money
  evidence. Gold's volatility is the test lever (reach L4+ fast).

## PRIORITY 1 - NO-FIRE BYTE-IDENTITY (proves the two lift-outs are inert)
Run with InpEnableTier1 = FALSE. This is the core regression.
[ ] R-1/R-2/R-3: build a multi-level sequence; recovery entries land at the
    same prices + lots as b34 (interval spacing, ComputeLevelLot). No behavior
    change anywhere.
[ ] H-1: ComputeLevelLot output unchanged (spot-check L1..L6 lots vs b34).
[ ] C-1/C-2: dashboard avg-entry == engine anchor (no display-vs-engine drift);
    TP sits at lot-weighted VWAP + InpAvgTPPts exactly as b34.
[ ] Money spot-check: pick one live basket, hand-compute lot-weighted VWAP and
    confirm g_curAvgEntry (Structure log) matches to the cent.
    PASS = E4 with Tier 1 off is indistinguishable from b34.

## PRIORITY 2 - HAPPY-PATH FIRE (T-1, A-1, G-1, X-1, G-3)  [SELL lap]
Enable Tier 1. Build a SELL basket >= 4 open; let price retrace so the recent
(higher-entry) levels go profitable while the oldest (anchor) stays underwater.
[ ] Fire log appears MID-BAR (T-5, tick-based - not on M15 boundary):
    "Tier 1 FIRE: SELL group N leg(s) (anchor Lx + M profitable) | VWAP .. far
     .. margin .. pts >= 150/lot".
[ ] A-1: anchor = the OLDEST / lowest level number (not the cheapest to close).
[ ] X-1: close order in the Experts log = profitables FIRST (descending ticket),
    ANCHOR LAST. MUST NOT be anchor-first.
[ ] RECOMPUTE: from the group tickets/lots/entries in the log, compute
    VWAP = sum(lot*entry)/sum(lot); margin = VWAP - Ask (SELL). Confirm the
    logged margin matches AND margin >= 150. (Ref shape: run B fire1 = 152 pts.)
[ ] G-3: sum the realized per-leg P/L (all group legs) -> strictly > 0.

## PRIORITY 3 - H-6 SL RE-ANCHOR (the one careful row)  [set InpStopLossPts > 0]
Default SL is OFF; H-6 only exists with SL on. Set e.g. InpStopLossPts = 1500.
[ ] Before fire: every tracked position carries SL anchored to the lowest level.
[ ] Fire closes the anchor (lowest level). NEXT tick log:
    "SL re-anchored: Lx -> Ly (widened ...)".
[ ] Survivors' broker SL now references the NEW lowest survivor's entry, NEVER a
    closed ticket. Basket never shows 0/unset SL between fire and re-anchor.
[ ] BUY lap: repeat on a BUY basket (SL side is direction-signed) - re-anchor
    mirrors (SL below anchor entry).
    PASS = SL always references a live lowest survivor; never unprotected.

## PRIORITY 4 - DORMANCY + RE-ARM (D-1, D-2, H-2, H-4, O-3)
[ ] D-1: a fire that drops open count below 4 -> Tier 1 goes DORMANT; no second
    fire while count < 4 even if a big margin is available. Prove the absence.
[ ] D-2: recovery rebuilds count to >= 4 -> Tier 1 evaluates again.
[ ] H-2 (at a curve STEP, not a stall band): first recovery entry after a fire
    refills at ComputeLevelLot(ADDRESS) - i.e. max(surviving level)+1's lot, NOT
    a re-counted lot. Pick a config where the step lot differs from the count lot
    (e.g. martingale x1.5 so L7/L8 differ) so the row proves something (H-3).
[ ] H-4: only HIGHER closed rungs re-arm; the closed anchor address is never
    re-added.

## PRIORITY 5 - MUST-NOT / ABSENCE ROWS (prove no fire)
[ ] T-3: count < 4 with a large margin available -> NO fire (Gate A blocks).
[ ] T-4: count >= 4 but margin recomputed just under 150 -> NO fire (Gate B).
[ ] T-6: count >= 4 but ZERO profitables (anchor-only group) -> margin negative,
    NO fire.
[ ] X-5 (F3 guardrail): Tier 1 closes are attributed as EA closes in the
    liveness log ("closed by EA (market close)"), NOT as initial entries / count 0.

## PRIORITY 6 - RESTART / KILL (K-1, K-2, K-3)  [stateful spine]
[ ] K-1: recompile / re-attach mid-sequence with Tier 1 armed -> count/anchor/
    VWAP rebuilt from live positions; Tier 1 re-evaluates cleanly. No orphan key.
[ ] K-3: state file schema unchanged (RunStateSelfTest passes; no new persisted
    field). grep-confirm no new StateSave key.
[ ] X-2/X-3 abort (opportunistic - hard to force): if a leg close ever fails,
    confirm the anchor is left open and realized stays a profit subset >= 0.

## SIGN-OFF
Every PASS carries the recomputed number in the run notes. When all priorities
are green on XAUUSD.s evidence, Jeff seals E4-b35 -> then bump STATE.md manifest
(build/sha/lines), update handover, commit.
