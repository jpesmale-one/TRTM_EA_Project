# E6 VERIFICATION CHECKLIST (evidence-audited; terminal is truth)
# Build under test: E6-b38 (src sha256_16 f7766c859e4d3c7a, 4674 lines).
#   = E5-b37 (73dda148c79f1b27 / 4568) + Tier 3 partial-lot anchor slice (+106
#   lines). 8 touch points: 5 inputs + SliceLegAtMarket + ComputeSlicedAnchorVWAP
#   + FireGroupClose anchorSliceVol param + a THIRD dispatcher branch + the DS-1
#   dashboard row + call-site comment + build tag. Tier 3 default OFF.
# Rule: recompute EVERY money number to the cent from the log before any PASS.
# Nothing seals until Jeff's explicit word. Rows map to docs/E6_MATRIX.md (SEALED
# rev 1, 13 groups, 36 rows). Plan: docs/E6_PLAN_2026-07-26_gate3.md (CONFIRMED).
# Deploy is Jeff's manual step; repo src/TRTM.mq5 is master.

## GATE ZERO - COMPILE + DEPLOY (must pass before anything below)
[X] MetaEditor compiles src/TRTM.mq5 -> 0 errors, 0 warnings. PASSED 2026-07-26
    12:34:12 in Jeff's terminal (metaeditor.log), re-witnessed in-session at his
    request after an earlier 01:48:22 compile of the same byte-identical source, also
    0/0. No unused-parameter, implicit-conversion, or defaulted-param-overload
    warnings materialized. TRTM.ex5 rebuilt 12:35:02.
[X] Deployed to MT5 tree AND byte-identical to repo: runtime copy
    ...\Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Experts\TRTM.mq5
    sha256_16 f7766c859e4d3c7a / 4674 == repo (no deploy drift, verified
    2026-07-26). TRTM.ex5 223,162 bytes, built 01:48:22.
[X] Init line / chart panel shows "E6-b38". Live log 2026.07.26 01:48:22 and
    12:03:33 "=== TRTM E6-b38 init === symbol=XAUUSDS magic=715358".
[X] Clean init baseline: "State persistence self-test: PASS", "Reconcile
    complete: FLAT" (both inits, XAUUSD.s + BTCUST). The BE-geometry WARN
    (Trigger 100 - Offset 30 = 70 < 100 stops) is the sealed b27 config-guidance
    one-shot, NOT an E6 path - ignore for E6.

# =====================================================================
# XAUUSD.s CONSTANTS (fix these once; every live recompute below uses them)
# =====================================================================
#   Digits 2, _Point = 0.01, contract size 100, VOLUME_MIN = VOLUME_STEP = 0.01
#   => unit = MathMax(volMin, step) = 0.01 (the matrix's "1 lot step").
#
#   MONEY IDENTITY (gold, USD-quote => no FX leg):
#     leg P/L (USD) = (entry - closeAsk) * lot * 100        [SELL]
#                   = (closeBid - entry) * lot * 100        [BUY]
#     1 point on 1.00 lot = 0.01 * 100 = $1.00
#     => GROUP P/L (USD) = marginPts x SUM(group lots)      <- anchor at its SLICE
#   This identity is the cross-check on EVERY fire: compute the group P/L leg by
#   leg AND as marginPts x sumVol; they must agree to the cent. (This is the same
#   identity that exposed F5 in E5 - two independent derivations must converge.)
#
#   THRESHOLD NOTE (symbol-relative points, matrix rider): InpTier3MinProfitPts
#   200 on gold = $2.00 of price, vs Tier 1's 150 = $1.50. Tier 3's bar is HIGHER
#   than Tier 1's, measured on an EASIER (sliced) metric - see the STRUCTURAL
#   RELATION below. That is the locked rider, not a defect; noted so the PR2/PR3
#   constructions tune around it deliberately.
#
#   LADDER FACTS (sealed; ComputeLevelLot + RegisterButtonL1):
#     L1     = InpEntryLotSize (the lot actually opened; becomes g_state.baseLot)
#     L(N>=2) = baseLot + (N-1) x InpIncrementStep      [RM_INCREMENTAL]
#     spacing = InpRecoveryIntervalPts from the WORST surviving entry.
#   (E5's 0.01/0.02/0.03/0.04 ladder is this formula at base 0.01, step 0.01 - it
#   coincides with "base x level" ONLY when base == step. Do not generalize that.)
#   CONSEQUENCE (test-design critical): L1 is ALWAYS the anchor while it lives, and
#   L1 == InpEntryLotSize. At the DEFAULT 0.01 that is BELOW InpTier3MinLots 0.02
#   AND below 2 x unit. **Tier 3 can never fire on a default-entry-lot ladder.**
#   Every Tier 3 fire run below therefore raises InpEntryLotSize so the anchor is
#   slice-eligible. That is T3-SL4 stand-down operating correctly, and is itself
#   Run D's evidence.
#
#   ANCHOR-DEPTH REQUIREMENT (why a shallow ladder proves nothing). The slice-vs-
#   full margin GAP grows with how far the anchor is underwater RELATIVE to the
#   profitables' margins. On a 4-level ladder the anchor is only ~3 intervals down
#   and the FULL-anchor gate still clears Tier 1 - so the run cannot show "Tier 3
#   fires where Tier 1 cannot". The regime needs a DEEP ladder: ~8 levels at a
#   500-pt interval (3500 pts / $35 of adverse gold travel) then a retrace that
#   turns only the top 2 levels green. Worked target under Run C below.

# =====================================================================
# STRUCTURAL RELATION (derive once; drives PR2/PR3 construction)
# =====================================================================
# For a fixed group, let the anchor be the group's WORST leg (the normal drawdown
# case - the anchor is the oldest and deepest underwater; for SELL its entry is the
# LOWEST in the group, for BUY the HIGHEST).
#   Reducing the anchor's weight from full lot to slice lot moves the group VWAP
#   AWAY from the anchor entry: SELL VWAP rises, BUY VWAP falls.
#   SELL margin = VWAP - Ask  -> rises.   BUY margin = Bid - VWAP -> rises.
#   => marginPts(slice) >= marginPts(full), ALWAYS, with equality only when
#      slice == full (impossible: the clamp forces slice <= anchorVol - unit).
# CONSEQUENCE 1: this is exactly WHY Tier 3 fires where Tier 1 cannot (T3-G3), and
#   it is confirmed by BOTH reference fires (206.2 vs 80.1; 206.3 vs -77.4).
# CONSEQUENCE 2 (PR2 construction): to make Tier 1 ALSO qualify on a Tier-3 tick,
#   set InpTier1MinProfitPts <= marginPts(full). Since marginPts(full) <
#   marginPts(slice), a LOW Tier 1 threshold (e.g. 50) makes both gates pass on the
#   same tick - then the dispatcher MUST fire Tier 1 (full close), Tier 3 skipped.
#   Do NOT try to construct both-qualify by raising Tier 3's threshold.
# CONSEQUENCE 3: InpTier1MinTrades / InpTier2MinTrades MUST equal InpTier3MinTrades
#   (=4) in the PR runs, or the lower-MinTrades tier fires first on a shallower
#   basket and the other tier never gets a turn (the E5 Run-4 misconfiguration).

# =====================================================================
# REFERENCE RECOMPUTE (Shadow GBPAUD.s log; recomputed to the cent 2026-07-26)
# Reference is corroboration, never a PASS by itself - live XAUUSD.s seals.
# Point 0.00001, Digits 5, contract 100000, AUD account, deposit 3000.00.
# =====================================================================

## FIRE 1 - 2026.06.25 15:47:58, SELL, Bid/Ask 1.90756 / 1.90784 (raw log 506-532)
Anchor #3 full 0.02 @1.88594; profitables #16 0.09 @1.91286, #15 0.08 @1.90957.
[X] SLICE (T3-SL1/O4): floor(0.02 * 50.0/100 / 0.01) * 0.01 = floor(1.0)*0.01
    = 0.01; remaining 0.01. Raw log: "Slice vol: 0.01 | Remaining: 0.01" EXACT.
[X] SLICED-GROUP VWAP (T3-1/T3-6) to the cent:
      0.01 x 1.88594 = 0.0188594
      0.09 x 1.91286 = 0.1721574
      0.08 x 1.90957 = 0.1527656
      sum = 0.3437824 ; sumVol = 0.18 ; VWAP = 0.3437824/0.18 = 1.9099022
      -> 1.90990. Raw log "Basket VWAP (sliced anchor): 1.90990" EXACT.
[X] GATE B: margin = 1.9099022 - 1.90784 = 0.0020622 = 206.22 pts >= 200 -> FIRE.
[X] GATE A: 9 open >= 4 -> pass.
[X] GROUP P/L (T3-G2 invariant), both derivations agree:
      leg-by-leg: #3 (1.88594-1.90784)*0.01*1e5 = -21.90
                  #16 (1.91286-1.90784)*0.09*1e5 = +45.18
                  #15 (1.90957-1.90784)*0.08*1e5 = +13.84   sum = +37.12 AUD
      identity:   0.0020622 * 0.18 * 1e5 = +37.1196 -> +37.12 AUD   AGREE.
    Group nets POSITIVE though the anchor slice alone realizes -21.90. Invariant holds.
[X] WHY T1/T2 CANNOT fire (T3-G3, full anchor 0.02):
      full sum = 0.0377188+0.1721574+0.1527656 = 0.3626418 ; sumVol 0.19
      full VWAP = 1.9086411 ; full margin = 0.0008011 = 80.11 pts < 150 -> T1 FAILS.
      full group money = 0.0008011*0.19*1e5 = +15.22 AUD (leg check -43.80+45.18
      +13.84 = +15.22 AGREE) ~= 10.32 USD @0.6783 < 1.0% x 3000.00 = 30.00 -> T2 FAILS.
      ONLY the sliced gate (206.2) qualifies. Slice-vs-full spread = 126.1 pts.
[X] POST-FIRE (T3-P1): 7 survivors (#3 now 0.01, #4..#9), vol 0.34, avg 1.89921,
    TP 1.89721 (= avg - 200 pts). Raw log "Avg Entry Price = 1.89921 Total Vol =
    0.34 Count = 7 ... Avg TP Price = 1.89721" EXACT. NOTE: Shadow's TP offset is
    its MinProfitPoints; TRTM uses InpAvgTPPts on the SAME lot-weighted E1 basis -
    same mechanism, different input. The live gold recompute uses InpAvgTPPts.
[X] CLOSE ORDER (T3-X1): Shadow closed the anchor SLICE FIRST (#17) then #16 (#18),
    #15 (#19). TRTM INVERTS this by design (profitables-first / slice-last, E4 O5).
    Confirmed divergence, deliberate - the live run must show the OPPOSITE order.
[X] F3 RECURRENCE visible in the raw log (T3-PR6): "OnTradeTransaction: Confirmed
    initial deal #17 / #18 / #19. Position count is 0." Shadow misroutes its own
    close deals through the initial-entry branch. TRTM is immune (F-c, below).

## FIRE 2 - 2026.07.02 15:31:07, SELL, Bid/Ask 1.92653 / 1.92682 (raw log 927-953)
Anchor #4 full 0.03 @1.88917; profitables #31 0.13 @1.93219, #30 0.12 @1.92861.
[X] SLICE (FLOOR proof, T3-SL1/SL5): floor(0.03 * 0.50 / 0.01) * 0.01
    = floor(1.5)*0.01 = 0.01 (NOT 0.02); remaining 0.02. Raw log "Slice vol: 0.01
    | Remaining: 0.02" EXACT. Realized fraction 0.01/0.03 = 33.3%, NOT the nominal
    50% - documented divergence (T3-SL5), not a defect.
[X] SLICED-GROUP VWAP (T3-1) to the cent:
      0.01 x 1.88917 = 0.0188917 ; 0.13 x 1.93219 = 0.2511847
      0.12 x 1.92861 = 0.2314332 ; sum = 0.5015096 ; sumVol = 0.26
      VWAP = 0.5015096/0.26 = 1.9288831 -> 1.92888. Raw log EXACT.
[X] SLICE-vs-REMAINDER-vs-FULL DISAMBIGUATION (T3-6, THE CRITICAL ROW).
    Profitables sum is common = 0.4826179:
      slice 0.01     -> 0.5015096/0.26 = 1.9288831 -> 1.92888   <- MATCHES LOG
      remaining 0.02 -> 0.5204013/0.27 = 1.9274122 -> 1.92741   (no)
      full 0.03      -> 0.5392930/0.28 = 1.9260464 -> 1.92605   (no)
    Only the SLICE volume reproduces the logged VWAP. The gate is on the lots
    being CLOSED, not the survivor remainder, not the full anchor.
[X] GATE B: margin = 1.9288831 - 1.92682 = 0.0020631 = 206.31 pts >= 200 -> FIRE.
[X] ROUNDING PROOF (why FLOOR is REQUIRED, T3-SL5): round-half-up would give slice
    0.02 -> VWAP 1.9274122 -> margin 0.0005922 = 59.22 pts < 200 -> would NOT FIRE.
    The floor is load-bearing, not cosmetic.
[X] GROUP P/L (T3-G2), both derivations agree:
      leg-by-leg: #4 (1.88917-1.92682)*0.01*1e5 = -37.65
                  #31 (1.93219-1.92682)*0.13*1e5 = +69.81
                  #30 (1.92861-1.92682)*0.12*1e5 = +21.48   sum = +53.64 AUD
      identity:   0.0020631 * 0.26 * 1e5 = +53.6406 -> +53.64 AUD   AGREE.
[X] WHY T1/T2 CANNOT fire (T3-G3, full anchor 0.03): full margin = 1.9260464 -
    1.92682 = -0.0007736 = -77.36 pts. The FULL group is NET NEGATIVE (-21.67 AUD)
    -> T1 fails hard, T2 fails (group underwater). Slice-vs-full spread = 283.7 pts.
[X] ANCHOR TRANSFER + STAND-DOWN evidence (T3-A1/T3-SL4): fire 1 anchored #3, fire 2
    anchored #4 - because fire 1 left #3 at 0.01 (< MinLots 0.02), so #3 was NEVER
    sliced again even though it stayed the oldest. This is the reference's own
    sub-MinLots stand-down, and it confirms MinLots is re-tested on the RESIDUAL.
[X] POST-FIRE (T3-P1): 11 survivors, vol 0.80, avg 1.91058, TP 1.90858. Raw log EXACT.

## MATRIX AUDIT RESULT (the F5 discipline, applied to E6_MATRIX.md rev 1)
[X] NO arithmetic error found. Every WORKED REFERENCE number in the sealed E6
    matrix (both fires: slice, VWAP, margin, group P/L, full-anchor counterfactual,
    survivor VWAP/TP) reproduces exactly, and each was independently corroborated
    against the RAW log lines 506-532 / 927-953 - not just re-derived from the
    matrix's own intermediates. E6_MATRIX rev 1 is arithmetically CLEAN.
    (E5's F5 was found by exactly this cross-check; it does not recur here.)

# =====================================================================
# CONFIRMED NOW - CODE REASONING (deployed E6-b38; line refs to src/TRTM.mq5)
# =====================================================================
[X] T3-R3 (no new persisted state): SequenceState carries NO Tier 3 field; schema
    unchanged. Tier 3 is fully DERIVED per tick - openCount/anchorTk/anchorVol/
    sliceVol/group/sliced-VWAP all live-read (FormBasketGroup 2201, dispatcher
    2398-2432; anchorVol from PositionGetDouble(POSITION_VOLUME) 2402). The residual
    anchor volume IS the broker's position volume - nothing stored. RunStateSelfTest
    byte-identical -> LIVE PASS observed 2026.07.26 01:48:22 + 12:03:33.
    K-3 covered by the same fact. [ ] re-confirm self-test PASS on the Gate 4 runs.
[X] T3-SL1/SL3 slice sizing is numerically SOUND (2412-2415). Swept
    ClosePercent x {10,20,25,30,33,40,50,60,66,70,75,80,90} against anchorVol
    {0.02..1.00} at unit 0.01: ZERO floor-of-ratio float-drift cases - every
    MathFloor(anchorVol * pct/100 / unit) lands on the intended integer. The clamp
    then guarantees unit <= sliceVol <= anchorVol - unit, so the slice is ALWAYS
    partial and BOTH legs are valid volumes. (Sweep scope: unit 0.01 - the
    XAUUSD.s / GBPAUD.s case. A 0.001-step symbol is outside the evidence scope.)
[X] T3-6 gate-on-SLICE is structurally correct by construction:
    ComputeSlicedAnchorVWAP (1103-1116) substitutes sliceVol for the anchor ticket's
    live volume in BOTH the numerator and the denominator
    (`double v = (tk[i]==anchorTk) ? sliceVol : PositionGetDouble(POSITION_VOLUME)`),
    every other member at full live volume. It is a SEPARATE helper from the sealed
    ComputeWeightedVWAP (1086-1097), which is byte-identical - so the Tier 1 / Tier 2
    / ComputeTargets basis is provably untouched. [ ] literal live proof = Run C.
[X] T3-H3 SL NOT RE-ANCHORED IS FREE (plan finding F-a, ZERO code). The SL re-anchor
    at 1599 is keyed on `g_prevAnchorLvl > 0 && g_curAnchorLvl != g_prevAnchorLvl`.
    A partial close keeps the anchor's TICKET and LEVEL, so g_curAnchorLvl does NOT
    change and the branch never runs. The basket SL stays on the surviving anchor's
    entry. [ ] literal byte-identical-SL proof = Run E (BUY + SELL).
[X] T3-P1 SURVIVOR TP SELF-CORRECTS (plan finding F-b, ZERO code). ComputeTargets
    (1120) reads anchorEntry from the live anchor and the VWAP via ComputeWeightedVWAP
    (1153), which sums LIVE POSITION_VOLUME. After a slice the anchor's live volume is
    reduced and its entry unchanged -> the survivor VWAP/TP recompute is automatically
    correct, including the reduced anchor at its remainder. [ ] recompute live = Run B.
[X] T3-PR6 / F3 CANNOT RECUR (plan finding F-c). OnTradeTransaction (4668) is EMPTY -
    TRTM's attribution is poll-based (CheckSequenceLiveness + g_eaClosed), not deal-
    event based, so there is NO initial-entry branch a close/slice deal could be
    misrouted through. The Shadow log's "Confirmed initial deal #17/#18/#19" defect
    class is structurally impossible here.
[X] T3-H2 residual anchor RETAINED: CheckSequenceLiveness removes a ticket ONLY when
    PositionSelectByTicket FAILS. A partially-closed position still exists, so the
    sliced anchor is retained at its level with its address - C3 preserved index and
    E4 O1 (anchor never re-arms) inherited unchanged.
[X] SliceLegAtMarket (1433-1451) deliberately does NOT call MarkEAClosed - correct,
    and the reasoning is load-bearing: the position SURVIVES, so flagging its ticket
    would misattribute a LATER broker TP/SL close of the (eventually full) anchor as
    "closed by EA". 10036 treated as a benign race (returns true) exactly as the
    sealed CloseLegAtMarket (1407) does. Returns false on genuine failure -> the O7
    caller logs + accepts, no retry.
[X] T3-X1/X3 order + abort by REUSE: FireGroupClose (2245) profitables-first loop
    (descending ticket, sealed CloseLegAtMarket 2277) is UNTOUCHED and aborts before
    the anchor on any profitable-leg failure (2281, returns true = partial). ONLY the
    anchor-last block branches (2288-2296): anchorSliceVol > 0 -> SliceLegAtMarket,
    else the UNCHANGED full close. Profitables ALWAYS full-close.
[X] T3-R2 (on-but-never-fires) + T1/T2 byte-identity: the anchorSliceVol param
    DEFAULTS to 0.0, so the Tier 1 (2389) and Tier 2 (2367) call sites are unchanged
    and take the full-close branch. The Tier 3 branch (2398-2432) is a trailing
    `if(t3elig)` that only ever `return`s on a fire; when its gates fail, control
    falls to the pre-existing `return false` (2433). Dispatcher behavior with Tier 3
    off or non-firing is behaviorally E5-b37.
[X] T3-PR1/PR4 one-fire-per-tick + precedence ORDER is code-guaranteed: the dispatcher
    evaluates Tier 2 (2355) -> Tier 1 (2375) -> Tier 3 (2398), and each firing branch
    `return FireGroupClose(...)` immediately. Structurally impossible to slice after a
    full close on the same tick, or to double-fire.
[X] T3-D1/D2 dormancy on its OWN MinTrades: `t3elig = t3on && openCount >=
    InpTier3MinTrades` (2331), and the shallow return (2332) now requires all three
    tiers ineligible. Count = REMAINING open positions - and since a Tier 3 fire
    closes only the PROFITABLES (the anchor survives), the count drops by
    (group size - 1), not group size. Verify the arithmetic live.
[X] T3-M1 whole-basket stand-down applies to Tier 3: the shared M-1 guard (2344) sits
    ABOVE all three tier branches, so a whole-basket group stands the dispatcher down
    before Tier 3 is reached. Matches the sealed T3-M1 row [INHERIT E4 M-1, adapted].
    Both reference fires had grp << openCount (3 of 9 / 3 of 13), so unaffected.
[~] T3-DS1 dashboard (3606-3624): renders 8 states via " + " concatenation - OFF (dim)
    plus every non-empty subset of {T1 <n>pts, T2 <n.n>%, T3 <n>pts}. Widest string
    "T1 150pts + T2 1.0% + T3 200pts" = 31 chars against PNL_W 340 - the plan's
    clipping concern. [ ] VISUALLY confirm all-three-on renders without clipping and
    the row does not disturb LIVE SEQUENCE rows / button grid (panel height dynamic).

## BUILD-vs-PLAN DIVERGENCES (recorded; none are money-path defects)
[X] TP-5b: build uses `NormalizeDouble(sliceVol, 8)` (2415); the plan wrote
    `NormalizeDouble(sliceVol, 2)`. The build is SAFER - 2 decimals would corrupt the
    slice on any symbol with a 0.001 lot step (0.005 -> 0.01). On XAUUSD.s (step 0.01)
    the two are identical, so this is money-neutral HERE and strictly better elsewhere.
    Code comment documents it. RECOMMEND: accept as-is, note in STATE.md.
[X] TP-6: build uses direct string concatenation rather than the plan's `parts[]`
    array sketch. Functionally identical output. Cosmetic.
[ ] NIT (no money path): the EvaluateBasketClose header comment (2300-2308) still
    reads "DRAWDOWN REDUCTION DISPATCHER (Tier 2 FIRST, then Tier 1)" and "Both share
    ONE group" - STALE now that there are three tiers. TP-7's call-site comment (4633)
    WAS updated correctly. RECOMMEND: fix the header comment in the seal commit (a
    comment-only edit re-bumps the manifest sha, so bundle it with any gate-zero fix
    rather than editing a clean build for a comment).

# =====================================================================
# LIVE GOLD STILL NEEDED (XAUUSD.s; recompute every number to the cent)
# Every run: log the fire line, then recompute slice, VWAP, margin, and group P/L
# BOTH leg-by-leg AND via the identity (P/L = marginPts x sumVol). Both must agree.
# =====================================================================

## RUN A - T3-R1 NO-FIRE BYTE-IDENTITY  [PASS - tests/2026.07.26 125653.086.txt]
  All three tiers OFF (defaults). XAUUSD.s M15, real ticks, 2026.06.22 -> stopped
  by user 06.23 after a clean flat. Base 0.01 / step 0.01, interval 500, AvgTP 2500,
  InitialTP 0, SL 0, deposit 3000.00, leverage 1:500. Build reported E6-b38.
  Ladder: L1 t2 0.01@4156.07 | L2 t3 0.02@4167.19 | L3 t4 0.03@4175.73
          L4 t5 0.04@4200.82 | L5 t6 0.05@4211.65
[X] T3-R1 PASS: ZERO Tier / basket-close lines anywhere in the run. The dispatcher
    early-returns at TRTM.mq5:2314 when all three tiers are off, and it never even
    reaches Gate A. Tier 3's addition is provably inert when disabled.
    ("Byte-identical to E5-b37" = BEHAVIOURALLY identical; the init line and panel
    legitimately read "E6-b38". Not a FAIL.)
[X] LOT FORMULA re-confirmed live: L1 = InpEntryLotSize (0.01); L2..L5 =
    baseLot + (N-1) x InpIncrementStep = 0.02 / 0.03 / 0.04 / 0.05. Matches the
    corrected LADDER FACTS above (base == step here, hence the coincidental x-level).
[X] SPACING (minimum entry distance, from the WORST surviving entry) - all exact:
      L2 trig 4156.07 + 5.00 = 4161.07 | L3 4167.19 + 5.00 = 4172.19
      L4 4175.73 + 5.00 = 4180.73      | L5 4200.82 + 5.00 = 4205.82
    ACTUAL gaps 1112 / 854 / 2509 / 1083 pts - all >= 500. Bar-close overshoot
    (sealed behaviour: the trigger is a MINIMUM, the M15 close lands where it lands).
    See the RUN C CALIBRATION note below - this overshoot is why Run A only reached
    5 levels, and it drives the Run C settings change.
[X] E1 LOT-WEIGHTED AvgTP - all four recomputes EXACT to the cent (TP = VWAP - 25.00):
      2L: 124.9045/0.03 = 4163.4833 -> TP 4138.48   (log 4138.48)
      3L: 250.1764/0.06 = 4169.6067 -> TP 4144.61   (log 4144.61)
      4L: 418.2092/0.10 = 4182.0920 -> TP 4157.09   (log 4157.09)
      5L: 628.7917/0.15 = 4191.9447 -> TP 4166.94   (log 4166.94)
    Re-proves the E1 lot-weighted anchor on gold under b38 (H-1/R-2 obligation).
[X] PROJECTION at TP - all four EXACT (leg = (entry - TP) x lot x 100):
      2L +17.59 +57.42                             = +75.01  (log +75.01)
      3L +11.46 +45.16 +93.36                      = +149.98 (log +149.98)
      4L -1.02 +20.20 +55.92 +174.92               = +250.02 (log +250.02)
      5L -10.87 +0.50 +26.37 +135.52 +223.55       = +375.07 (log +375.07)
    NOTE the anchor projects NEGATIVE from 4 levels on (-1.02, then -10.87): normal
    for a lot-weighted basket - the small oldest leg is carried by the bigger newer
    ones. The TP guard correctly stayed silent (basket total > 0 throughout).
[X] EXIT clean: TP 4166.94 gapped through at 2026.06.23 04:37:09, all 5 legs filled
    at 4165.48 (1.46 BETTER than target - favourable gap). All five attributed
    "TP hit @ 4165.48" by ClosingDealReason (b20 attribution intact), then
    "Sequence fully closed - back to FLAT". Realized = -9.41 +3.42 +30.75 +141.36
    +230.85 = +396.97, which is the projected +375.07 plus the gap benefit
    1.46 x 0.15 lots x 100 = +21.90 -> 375.07 + 21.90 = 396.97. AGREE to the cent.
[ ] T3-DS1 (visual): confirm the panel "DD Reduce" row rendered "OFF" dimmed during
    this run. Display-only; not evidenced by the log.

### RUN C CALIBRATION - what Run A changes about the Run C settings
Run A's ladder topped out at FIVE levels, then the whole basket TP'd out. Run C needs
~EIGHT. Two causes, both fixable:
 1. AvgTP 2500 was reached. The retrace ran 4211.65 -> 4165.48 = 4617 pts, straight
    through the basket target, ending the sequence before the ladder could deepen.
    -> RAISE InpAvgTPPts to 5000 for Run C (E5's Run 2 recipe, which sustained five
    fires). This keeps the basket exit far below so the VALVE is what fires.
 2. Bar-close OVERSHOOT is the bigger lever. The trigger needs only 500 pts, but the
    M15 close landed 854-2509 pts past it (mean ~1390), so effective spacing was ~3x
    the configured interval and a 5500-pt move bought only 4 recovery levels.
    -> Set InpRecoveryTF = PERIOD_M5. A smaller bar range shrinks the overshoot, so
    the same move packs roughly twice the levels. Keep InpRecoveryIntervalPts = 500.
 3. Pick the date range for the LONGEST sustained one-way move in the available tick
    window (2026.06.22 - 2026.07.09) - a SELL ladder needs a sustained RALLY.

## RUN B - T3-1 SELL HAPPY PATH + T3-5 / SL1 / SL2 / G2 / P1 / X1 / H1
  InpLotSize = 0.02 (so L1 anchor = 0.02 = MinLots, slice-eligible; mirrors FIRE 1)
  InpEnableTier3 = true; Tier 1 + Tier 2 = false (isolate Tier 3)
  InpTier3MinTrades 4, InpTier3MinProfitPts 200, InpTier3MinLots 0.02,
  InpTier3ClosePercent 50.0
  Recovery interval tight (~300-500) + a Max Recovery cap so gold volatility builds
  >= 4 levels fast and a retrace makes upper levels green. Ladder = 0.02/0.04/0.06/0.08.
[ ] T3-1  SELL fire. EXPECT slice = floor(0.02*0.50/0.01)*0.01 = 0.01, remaining 0.01.
    Recompute sliced-VWAP from the actual entries, margin vs the actual Ask, and
    confirm margin >= 200 pts. Log line must read "anchor L1 slice 0.01 of 0.02".
[ ] T3-G2 invariant: group P/L > 0 at the fire, BOTH derivations agreeing. The anchor
    slice alone will be a realized LOSS - that is expected; the GROUP must net positive.
[ ] T3-G3: recompute the FULL-anchor margin for the same tick and confirm it is LOWER
    (the structural relation). Record the slice-vs-full spread in points.
[ ] T3-SL1/SL2 slice sizing + eligibility from the live numbers.
[ ] T3-5  MID-BAR: fire timestamp off the M15 boundary; recovery ENTRIES stay bar-close
    gated (confirm entries still align to bar close in the same run).
[ ] T3-X1 profitables-first (descending ticket), ANCHOR SLICE LAST - the INVERSE of
    Shadow's observed order. Confirm from the deal sequence.
[ ] T3-H2 residual anchor retained at its level/address after the slice ("Tier 3:
    sliced L1 ticket ... by 0.01 lot (remaining 0.01)"), still present in Structure.
[ ] T3-P1 survivor TP: recompute the lot-weighted VWAP across survivors INCLUDING the
    reduced anchor at 0.01, then AvgTP = VWAP -/+ InpAvgTPPts. Must match the logged TP.
[ ] T3-H1 preserved-index re-arm: vacated PROFITABLE rungs refill at ComputeLevelLot(N);
    the sliced anchor is NOT re-added (it never left).
[ ] T3-D1 dormancy: after the fire, count drops by (group size - 1) because the anchor
    survives. Confirm no second fire while count < 4 even with margin available.
[ ] T3-D2 re-activation: a later recovery entry restores count >= 4 -> Tier 3 evaluates
    again. NOTE: the residual anchor is now 0.01 < MinLots -> expect T3-SL4 stand-down
    on the SAME anchor (the reference's #3 behavior). A second fire requires the anchor
    to transfer, which needs Tier 1/2 to consume it - so in a Tier-3-only run, ONE fire
    per anchor is the expected ceiling. Do not read that as a defect.

## RUN C - T3-6 GATE-ON-SLICE  [CRITICAL ROW - the crux of the whole enhancement]
  InpEntryLotSize = 0.03 (L1 anchor = 0.03 -> slice 0.01 != remaining 0.02 != full
  0.03; mirrors reference FIRE 2 exactly). Otherwise as Run B.
  NOTE: Run C SUPERSEDES Run B. Both produce a SELL Tier 3 fire recomputed to the
  cent, but at base 0.03 the slice (0.01), the remainder (0.02) and the full anchor
  (0.03) are three DISTINCT volumes, so one run closes T3-1 AND T3-6 AND T3-SL5.
  Run B (base 0.02, slice == remainder == 0.01, mirroring FIRE 1) is then optional
  confirmation, not a prerequisite. Run C first.

  WORKED TARGET (illustrative geometry - actual prices differ; the SHAPE is what
  the run must reproduce). SELL, interval 500 pts, base 0.03 / step 0.01, 8 levels:
    L1 4200.00 0.03  L2 4205.00 0.04  L3 4210.00 0.05  L4 4215.00 0.06
    L5 4220.00 0.07  L6 4225.00 0.08  L7 4230.00 0.09  L8 4235.00 0.10
  Retrace to Ask 4228.00 -> profitables are L7 + L8 only; L2..L6 stay underwater
  (so grp 3 < openCount 8, M-1 passes and an underwater survivor remains).
    slice     0.01 -> (42.00 + 380.70 + 423.50)/0.20 = 846.20/0.20 = 4231.0000
                      margin = 4231.0000 - 4228.00 = 3.00   = 300.0 pts  >= 200 FIRE
    remainder 0.02 -> (84.00 + 380.70 + 423.50)/0.21 = 888.20/0.21 = 4229.5238
                      margin = 1.5238 = 152.4 pts  < 200  would NOT fire
    full      0.03 -> (126.00 + 380.70 + 423.50)/0.22 = 930.20/0.22 = 4228.1818
                      margin = 0.1818 = 18.2 pts   < 200 AND < Tier 1's 150
  All three distinct; ONLY the slice clears the gate; the FULL anchor fails Tier 1
  too - which is the entire point of Tier 3. Round-half-up would pick 0.02 = the
  remainder line = 152.4 pts -> the FLOOR is what makes the fire happen (T3-SL5).
  Group P/L check both ways: 300.0 pts x 0.20 lots = $60.00; leg-by-leg
    L1 slice (4200-4228) x 0.01 x 100 = -28.00
    L7       (4230-4228) x 0.09 x 100 = +18.00
    L8       (4235-4228) x 0.10 x 100 = +70.00   sum = +60.00   AGREE.
  Total ladder 0.52 lots; floating at the fire tick approx -336.00 USD.
### RESULT - PASS, tests/2026.07.26 130728.662.txt (2026.06.22, deposit 10000 @1:500)
Ladder (base 0.03 / step 0.01, M15, interval 500):
  L1 t2 0.03@4153.58 | L2 t3 0.04@4161.06 | L3 t4 0.05@4167.19 | L4 t5 0.06@4175.73
  L5 t6 0.07@4200.82 | L6 t7 0.08@4211.65
TWO Tier 3 fires, both recomputed to the cent.

## FIRE 1 - 2026.06.22 04:31:06, SELL, far Ask 4202.38, count 6
  Log: "anchor L1 slice 0.01 of 0.03 + 1 profitable | sliced-VWAP 4205.20 far 4202.38
        margin 281.8 pts >= 200/lot"
[X] T3-SL1 SLICE = floor(0.03 * 50/100 / 0.01) * 0.01 = floor(1.5)*0.01 = 0.01,
    remaining 0.02. Log EXACT. Realized fraction 33.3%, not the nominal 50% (T3-SL5).
[X] T3-G1 membership: group = anchor L1 + L6 only. L6 4211.65 > Ask 4202.38 (profitable);
    L5 4200.82 < 4202.38 (underwater, correctly EXCLUDED). grp 2 < openCount 6 -> M-1
    passes, underwater survivors remain.
[X] T3-1 / T3-6 SLICED-VWAP EXACT:
      0.01 x 4153.58 = 41.5358 ; 0.08 x 4211.65 = 336.9320
      sum 378.4678 / 0.09 = 4205.19778 -> 4205.20   (log 4205.20)
      margin = 4205.19778 - 4202.38 = 2.81778 = 281.778 -> 281.8 pts  (log 281.8)
[X] T3-6 THREE-WAY DISAMBIGUATION [CRITICAL ROW - PROVEN]:
      slice     0.01 -> 378.4678/0.09 = 4205.1978 -> margin +281.8 pts   FIRES
      remainder 0.02 -> 420.0036/0.10 = 4200.0360 -> margin -234.4 pts   would NOT
      full      0.03 -> 461.5394/0.11 = 4195.8127 -> margin -656.7 pts   would NOT
    Only the SLICE volume reproduces the logged VWAP. Note both alternatives are
    NEGATIVE - stronger than the reference, which had a positive-but-short full margin.
[X] T3-SL5 FLOOR is load-bearing: round-half-up would pick 0.02 = the remainder line
    = -234.4 pts -> no fire. The floor is what makes this fire happen.
[X] T3-G3 the FULL-anchor group is NET NEGATIVE (-656.7 pts) - Tier 1 at 150 fails
    catastrophically, Tier 2 would see an underwater group. This IS the deep-drawdown
    regime Tier 3 exists for, demonstrated live on gold.
[X] T3-G2 INVARIANT, both derivations agree:
      identity   281.778 pts x 0.09 lots = +25.36 USD
      leg-by-leg L1 slice (4153.58-4202.38) x 0.01 x 100 = -48.80
                 L6       (4211.65-4202.38) x 0.08 x 100 = +74.16   sum = +25.36
    The anchor slice alone realizes -48.80; the GROUP nets POSITIVE. Invariant held.
[X] T3-X1 ORDER: "Closed L6 ticket 7 @ 4202.38" THEN "Tier 3: sliced L1 ticket 2 by
    0.01 lot (remaining 0.02)". Profitable FIRST, anchor slice LAST - the INVERSE of
    Shadow's observed anchor-first order. Deliberate divergence confirmed live.
[X] T3-H2 RESIDUAL SURVIVOR: L1 ticket 2 retained at its level with its ORIGINAL
    ticket, volume 0.03 -> 0.02. Structure 6 lvl 0.33 -> 5 lvl 0.24 lots
    (0.33 - 0.08 closed - 0.01 sliced = 0.24 EXACT). No liveness event for the anchor
    (it never disappeared); only L6 logged "closed by EA (market close)" (T3-PR6).
[X] T3-P1 SURVIVOR TP incl. the reduced anchor at its REMAINDER:
      0.02x4153.58 + 0.04x4161.06 + 0.05x4167.19 + 0.06x4175.73 + 0.07x4200.82
      = 83.0716 + 166.4424 + 208.3595 + 250.5438 + 294.0574 = 1002.4747 / 0.24
      = 4176.9779 ; TP = 4176.9779 - 50.00 = 4126.98   (log 4126.98)  EXACT
[X] T3-P2 projection on survivors = +1199.95 (log EXACT), recomputed leg-by-leg off
    the NORMALIZED TP 4126.98: 53.20 +136.32 +201.05 +292.50 +516.88 = 1199.95.
[X] T3-5 MID-BAR: 04:31:06 is off the M15 grid (04:30 / 04:45).

## FIRE 2 - 2026.06.22 04:53:04, SELL, far Ask 4192.60, count 5
  Log: "anchor L1 slice 0.01 of 0.02 + 1 profitable | sliced-VWAP 4194.91 far 4192.60
        margin 231.5 pts >= 200/lot". Profitable = L5 t6 0.07@4200.82.
[X] T3-A1 RE-SLICE of the SAME anchor: L1 is still the oldest (it survived fire 1) and
    is sliced again at its RESIDUAL 0.02. Confirms a sliced anchor stays the anchor and
    remains re-sliceable while >= MinLots.
[X] SLICE = floor(0.02*0.50/0.01)*0.01 = 0.01, clamped <= 0.02-0.01 -> 0.01,
    remaining 0.01 (log EXACT). T3-SL3: remaining is exactly 1 unit, never zeroed.
[X] SLICED-VWAP: 41.5358 + 294.0574 = 335.5932 / 0.08 = 4194.915 -> 4194.91 (log)
    margin = 4194.915 - 4192.60 = 2.315 = 231.5 pts (log EXACT).
    NOTE this fire does NOT disambiguate slice-vs-remainder (both are 0.01 at a 0.02
    anchor) - it is the FIRE-1-of-the-reference shape. FIRE 1 above is the disambiguator.
    Full anchor 0.02 -> 377.1290/0.09 = 4190.3222 -> margin -227.8 pts, Tier 1 fails.
[X] T3-G2: identity 231.5 x 0.08 = +18.52 ; legs -39.02 (slice) +57.54 (L5) = +18.52. AGREE.
[X] T3-X1 order again profitables-first / slice-last. Structure 0.24 -> 0.16 lots
    (0.24 - 0.07 - 0.01) EXACT.
[X] T3-P1: 41.5358+166.4424+208.3595+250.5438 = 666.8815 / 0.16 = 4168.0094
    TP = 4118.01 (log EXACT). Projection +799.99 (log EXACT).
[X] T3-5 MID-BAR: 04:53:04, off the M15 grid.

## T3-SL4 SUB-MinLots STAND-DOWN - PROVEN BY ABSENCE (bonus, Run D row closed here)
After fire 2 the anchor L1 sits at 0.01 - below InpTier3MinLots 0.02 AND below 2 x unit.
The ladder then REBUILT to eight levels (L5 0.07, L6 0.08, L7 0.09, L8 0.10; Structure
8 lvl / 0.50 lots at 13:00) with count well past Gate A and deep drawdown available,
and NO third Tier 3 fire ever occurred. The eligibility test at TRTM.mq5:2408 is the
binding constraint. This is exactly the reference's #3 behaviour (fire 1 left #3 at
0.01 -> never sliced again). One fire per anchor is the Tier-3-only ceiling, as the
Run B caveat predicted.
[X] T3-M1 WHOLE-BASKET STAND-DOWN observed 2026.06.23 04:42:04: "Basket close stands
    down: group would close the whole basket (no underwater survivor to valve) (M-1)".
    The shared guard fires correctly for a Tier-3-only dispatcher.
[X] T3-D1/D2 count arithmetic: each fire dropped openCount by exactly ONE (group size 2
    minus the surviving anchor), 6->5 then 5->4 - the anchor survives and stays counted,
    as the D1 row requires. Both fires were at count >= 4 (Gate A).
[X] CLEAN END: the sliced anchor L1 ticket 2 lived at 0.01 to the whole-sequence AvgTP
    and exited "TP hit @ 4139.94" with the rest -> FLAT. The residual survivor is an
    ordinary position for every downstream path.

## TESTER-MODE CAVEAT (affects LATER runs, not this one)
This run was configured "calculate profit in pips" (tester Settings). Tier 3's gate is
PURE PRICE arithmetic (sliced VWAP vs far price, in points) and its only use of
POSITION_PROFIT is the SIGN test for group membership in FormBasketGroup - both are
unaffected by the mode, and the tick-value-based projections reproduced USD-exact, so
Run C's evidence stands. BUT Tier 2's Gate B sums POSITION_PROFIT against a
percent-of-account-BALANCE bar in account currency: in pips mode that comparison is
meaningless. TURN "profit in pips" OFF before Run G (T3-PR3, T2+T3 precedence).

## STILL OPEN AFTER RUN C
T3-2 BUY lap + T3-H3 SL byte-identical (Run E - needs InpStopLossPts > 0; this run had
SL off so H3 was untestable). T3-3 / T3-4 must-nots (Run D). T3-PR2 / T3-PR3 precedence
(Runs F/G). T3-K1/K2 (Run H). T3-X4 broker partial rejection (opportunistic).
T3-DS1 dashboard visual.

## RUN D - THE GATE MUST-NOTs (T3-3 Gate A, T3-4 Gate B)
NOTE ON METHOD (important for the seal). Tier 3 is LAST in the dispatcher, so a tick
where its gate fails emits NOTHING - no sliced-VWAP line, no far price. And Tier 1
CANNOT act as a witness: it is locked out by construction in exactly Tier 3's regime.
Worked example at a representative count-4 BUY ladder (L1 0.03@4153.58 .. L4 0.06@
4175.73, Ask 4170): full-anchor margin 375.1512/0.09 = 4168.3467 -> -165 pts (Tier 1
blocked) while the sliced margin is 292.0796/0.07 = 4172.5657 -> +256.6 pts (Tier 3
would fire). So these two rows CANNOT be closed by a single-run recompute of a blocked
tick. They close by A/B across runs where the gate value is the ONLY thing varied.
T3-SL4 and T3-M1 were originally scoped here but are ALREADY closed by Runs C and E.

### RUN D1 (first attempt, tick-basis) - LOG NO LONGER ON DISK
### The re-run (D1', below) OVERWROTE tests/2026.07.26 141011.920.txt, so that filename
### now holds the D1' BUY run. The tick-basis run's numbers survive ONLY in this block;
### they were recomputed from the log while it existed and are recorded here verbatim.
### Ten runs were performed but only NINE log files exist, for this reason.
An earlier attempt ran with InpBarCloseEntry=false. Tick-basis built FOURTEEN levels in
58 minutes on a monotonic rise, so while count sat in the 4-7 window every leg was
underwater, the group was the anchor alone, and no margin existed - Gate B would have
blocked those ticks regardless of Gate A. The run did NOT isolate Gate A. Its two fires
are still valid supplementary evidence and are recorded here:
[X] 04:00:33 count 14, Ask 4211.94: (41.4802+675.0144+632.0550)/0.32 = 1348.5496/0.32
    = 4214.2175 -> 4214.22 (log EXACT); margin 227.75 -> 227.8 (log EXACT).
    G2: identity 227.75 x 0.32 = +72.88 ; legs -63.92 +110.40 +26.40 = +72.88. AGREE.
    Full anchor 0.03 -> 4210.3235 -> -161.7 pts. X1 descending t15 then t14 then slice.
    Structure 1.33 -> 1.01 (- 0.16 - 0.15 - 0.01) EXACT.
[X] 04:01:02 anchor 0.02, Ask 4206.62: (41.4802+632.0565+589.1830)/0.30 = 1262.7197/0.30
    = 4209.0657 -> 4209.07 (log EXACT); margin 244.567 -> 244.6 (log EXACT).
    G2: identity 244.567 x 0.30 = +73.37 ; legs -58.60 +106.35 +25.62 = +73.37. AGREE.
    X1 descending t19 then t13 then slice. Structure 1.16 -> 0.86 EXACT.

### RUN D1' - T3-3 GATE A, BUY  [PASS - tests/2026.07.26 141011.920.txt, re-run]
BUY chosen because bar-close BUY reaches far more depth than SELL (which caps ~6).
Config = Run C's with direction BUY, InpBarCloseEntry=true, InpStopLossPts=0, and the
single change InpTier3MinTrades = 6. Deposit 10000.00 USD (pips mode OFF, confirmed).
Ladder: L1 t2 0.03@4209.11 (04:10:48) | L2 t3 0.04@4201.02 | L3 t4 0.05@4191.09
        L4 t5 0.06@4184.42 | L5 t6 0.07@4178.59 | L6 t7 0.08@4171.77 (07:00:00)
[X] T3-3 GATE A - SHARP TRANSITION. Counts 1-5 ran from 04:10:48 to 07:00:00 (~2h50m)
    with ZERO Tier 3 lines. L6 opened at 07:00:00 taking the count to 6 = MinTrades, and
    Tier 3 fired NINE MINUTES LATER at 07:09:39. The gate opened and the tier fired at
    the first qualifying tick after it.
[X] T3-3 DOSE-RESPONSE across the whole verification - InpTier3MinTrades was VARIED and
    the first fire tracked it every time:
      MinTrades 4 (Run E BUY)      -> first fire at count 4  (margin 208.9)
      MinTrades 6 (this run)       -> first fire at count 6  (margin 204.1)
      MinTrades 8 (Run D1 tick)    -> first fire at count 14 (margin 227.8)
    No run EVER fired below its configured MinTrades. Gate A demonstrably moves with the
    input; this is stronger than the single-absence standard E5 used to seal T2-3.
[~] HONEST LIMIT (recorded, not hidden): this run does NOT exhibit a BLOCKED QUALIFYING
    tick. At counts 4-5 the market was falling, so on a BUY ladder every leg was
    underwater, the group was the anchor alone, and no margin existed to be blocked. The
    same is true of the 21.5-hour count-5 window after fire 1 (price fell 4178 -> 4154;
    no leg ever sat below the Bid). Margin availability and count increments are
    CORRELATED in this strategy - the profitable legs are the newest ones, and the newest
    leg is what increments the count - so a large margin at a low count is geometry-
    dependent, not freely constructible. T3-3 therefore rests on the dose-response above
    plus the code (t3elig at TRTM.mq5:2331, shallow return 2332), NOT on a recomputed
    blocked tick. Jeff's call whether that meets the bar.

## FIRE 1 - 2026.06.22 07:09:39, BUY, far Bid 4177.96, count 6
[X] slice 0.01 of 0.03, remaining 0.02. VWAP (42.0911 + 333.7416)/0.09 = 375.8327/0.09
    = 4175.91889 -> 4175.92 (log EXACT); margin 4177.96 - 4175.91889 = 2.04111
    -> 204.1 pts (log EXACT).
[X] T3-6: remainder 0.02 -> 417.9238/0.10 = 4179.2380 -> -127.8 pts;
          full 0.03 -> 460.0149/0.11 = 4181.9536 -> -399.5 pts. Only the slice fires.
[X] T3-G1 at the margin: L5 4178.59 sits 0.63 ABOVE the Bid 4177.96 and is correctly
    EXCLUDED as underwater; L6 4171.77 included.
[X] T3-G2: identity 204.111 x 0.09 = +18.37 ; legs -31.15 + 49.52 = +18.37. AGREE.
[X] T3-P1: survivors 1005.3440/0.24 = 4188.9333, TP 4238.93. Projection +1199.92
    recomputed leg-by-leg off the normalized TP: 59.64 +151.64 +239.20 +327.06 +422.38
    = 1199.92 (log EXACT).
[X] Structure 6 lvl 0.33 -> 5 lvl 0.24 (0.33 - 0.08 - 0.01) EXACT.

## FIRE 2 - 2026.06.23 04:59:33, BUY, far Bid 4162.62, count 6, anchor 0.02 residual
[X] slice 0.01, remaining 0.01. VWAP (42.0911 + 332.3640)/0.09 = 374.4551/0.09
    = 4160.61222 -> 4160.61 (log EXACT); margin 2.00778 -> 200.8 pts (log EXACT) -
    clears the 200 bar by 0.78 pts.
[X] full anchor 0.02 -> 416.5462/0.10 = 4165.4620 -> -284.2 pts. Tier 1 locked out.
[X] T3-G2: identity 200.778 x 0.09 = +18.07 ; legs -46.49 + 64.56 = +18.07. AGREE.
[X] Structure 6 lvl 0.32 -> 5 lvl 0.23 EXACT. Second slice of the SAME anchor (A1).
[X] T3-SL4 - STRONGEST INSTANCE YET. After fire 2 the anchor is 0.01 (sub-MinLots) and
    the ladder then ran to FIFTEEN levels (L15 0.17@4073.79, 2026.06.24 05:30) through a
    sustained decline, count far above Gate A, with ZERO further Tier 3 fires. The
    eligibility test at 2408 is unambiguously the binding constraint.

## RUN D2 - T3-4 GATE B  [PASS - tests/2026.07.26 143216.391.txt]
BUY, InpTier3MinTrades=4, InpTier3MinProfitPts=400, bar-close M15, SL 0, deposit
10000.00 USD (pips mode OFF). Tier 3 fired TWICE - at 412.5 and 403.7 pts, both just
over the raised bar. That is BETTER than the absence I predicted: it is the transition
witness, and it makes the blocked band directly computable.
Ladder: L1 t2 0.03@4194.37 (04:54:47) | L2 t3 0.04@4184.42 | L3 t4 0.05@4178.59
        L4 t5 0.06@4171.77 (07:00:00)

## FIRE 1 - 2026.06.22 07:58:11, BUY, far Bid 4180.62, count 4, TWO profitables
[X] VWAP (41.9437 + 250.3062 + 208.9295)/0.12 = 501.1794/0.12 = 4176.4950 -> 4176.50
    (log EXACT); margin 4180.62 - 4176.4950 = 4.125 -> 412.5 pts (log EXACT).
[X] T3-G1: L2 4184.42 > Bid 4180.62 correctly EXCLUDED; L3 + L4 included.
[X] T3-G2: identity 412.5 x 0.12 = +49.50 ; legs -13.75 + 53.10 + 10.15 = +49.50. AGREE.
[X] T3-X1 descending ticket t5 then t4, slice last. Structure 4 lvl 0.18 -> 2 lvl 0.06
    (0.18 - 0.06 - 0.05 - 0.01) EXACT.

## T3-4 GATE B - BLOCKED BAND RECOMPUTED FROM THE ENTRIES  [the row's real proof]
The sliced VWAP depends ONLY on the entries and group membership, and membership is
determined by Bid vs entry - so the margin is an EXACT function of Bid, computable from
the log without tick data. Walking the Bid up to fire 1:
  Bid < 4178.59 -> group = {anchor slice 0.01@4194.37, L4 0.06@4171.77}
                   VWAP = 292.2499/0.07 = 4175.0000 ; margin = Bid - 4175.00
                   at Bid 4178.00 -> 300.0 pts   NO FIRE (400 bar)
                   at Bid 4178.59 -> 359.0 pts   NO FIRE  <- would have fired at a 200 bar
  Bid >= 4178.59 -> L3 joins; VWAP jumps to 4176.4950 ; margin = Bid - 4176.4950
                   at Bid 4178.59 -> 209.5 pts   NO FIRE  <- would have fired at a 200 bar
                   at Bid 4180.62 -> 412.5 pts   FIRES
  The price traversed this band continuously between L4's open (07:00:00) and the fire
  (07:58:11). The sliced margin therefore passed through 209.5 / 300.0 / 359.0 pts -
  ALL of which clear the 200 bar Runs C/E/D1' fired on - and Tier 3 stayed silent at
  every one of them. Gate B is a genuine binding threshold, not a formality.
[X] THRESHOLD PREDICTS THE FIRE PRICE TO WITHIN ONE TICK. Solving margin = 400 exactly:
      fire 1: Bid = 4176.4950 + 4.00 = 4180.4950 ; actual first fire Bid 4180.62
      fire 2: Bid = 4125.9430 + 4.00 = 4129.9430 ; actual first fire Bid 4129.98
    Both fired on the first tick at or past the predicted level. The gate is exact.
[X] NO MISSED FIRE below: the 2-member group could not reach 400 before L3 joined
    (that needs Bid >= 4179.00, but L3 turns profitable at 4178.59 - contradiction), so
    the branch order cannot have skipped a qualifying tick.

## FIRE 2 - 2026.06.23 08:02:25, BUY, far Bid 4129.98, anchor 0.02 residual
[X] VWAP (41.9437 + 370.6506)/0.10 = 412.5943/0.10 = 4125.9430 -> 4125.94 (log EXACT);
    margin 4.037 -> 403.7 pts (log EXACT).
[X] full anchor 0.02 -> 454.5380/0.11 = 4132.1636 -> -218.4 pts. Tier 1 locked out.
[X] T3-G2: identity 403.7 x 0.10 = +40.37 ; legs -64.39 + 104.76 = +40.37. AGREE.
[X] Structure 7 lvl 0.41 -> 6 lvl 0.31 (0.41 - 0.09 - 0.01) EXACT.

## GATE B DOSE-RESPONSE (parallel to Gate A's)
  threshold 200 -> fires observed at 200.1, 200.8, 202.1, 204.1, 208.9, 227.8, 231.5,
                   240.6, 244.6, 281.8  (ten fires, all in [200.1, 281.8])
  threshold 400 -> fires observed at 403.7, 412.5 ONLY; the 200-band margins that fired
                   in every other run produced nothing here.
InpTier3MinProfitPts demonstrably moves the gate, and no fire has EVER occurred below
the configured value across twelve fires and two threshold settings.

## FINDING FOR RUN F (PR2 construction) - carry forward
Fire 1's FULL-anchor margin recomputes to 585.0668/0.14 = 4179.0486 -> 157.1 pts, which
EXCEEDS Tier 1's default 150. That tick is therefore a genuine BOTH-QUALIFY candidate
(T1 157.1 >= 150 AND T3 412.5 >= 400). It works because the anchor here is only ~1375
pts underwater - far shallower than Run C's fires, where the full margin was -656.7.
CONSEQUENCE: both-qualify ticks occur naturally on SHALLOW-anchor ladders. Run F should
fire EARLY in a ladder (count 4, anchor 2-3 intervals down), not in the deep-drawdown
regime - that is where Tier 1 can still clear its bar.

## RUN E - T3-2 BUY LAP + T3-H3 SL BYTE-IDENTICAL  [KEY DIVERGENCE from T1/T2]
  BUY sequence, InpLotSize = 0.02, InpStopLossPts set (e.g. 8000) so a real SL exists.
  Tier 3 ON only.
### RESULT - PASS, BOTH LAPS. InpStopLossPts=8000, base 0.03, deposit 10000 @1:500.
### SELL lap: tests/2026.07.26 131938.427.txt | BUY lap: tests/2026.07.26 132224.767.txt

## T3-H3 SL BYTE-IDENTICAL [KEY ROW] - PROVEN ON BOTH LAPS
[X] SELL lap: anchor L1 @4163.58 -> SL = 4163.58 + 8000 x 0.01 = 4243.58. EVERY
    "Exits applied to ticket 2" line across the WHOLE run reads SL 4243.58 - before
    fire 1, after fire 1, before fire 2, after fire 2, and through the rebuild.
[X] BUY lap: anchor L1 @4188.79 -> SL = 4188.79 - 80.00 = 4108.79. Same story:
    SL 4108.79 on every line, unchanged across BOTH slices.
[X] ZERO "SL re-anchored" lines in either run. Contrast E5 Run 3, where every Tier 2
    fire logged "SL re-anchored: L1 -> L2 (widened to ...)". Confirms plan finding F-a
    exactly: the re-anchor at TRTM.mq5:1599 is keyed on g_curAnchorLvl != g_prevAnchorLvl,
    and a partial close leaves the anchor's TICKET and LEVEL untouched, so the branch
    never runs. ZERO code was needed for this row - it is a property of the design.
[X] BONUS - the unchanged SL is a GENUINE BROKER-HELD STOP, not just a computed value.
    On the BUY lap price kept falling; the ladder rebuilt to eight levels and SL 4108.79
    was HIT at 4108.77 (2026.06.23 10:41:45). ALL EIGHT legs logged "SL hit", INCLUDING
    L1 ticket 2 at 0.01 - the TWICE-SLICED anchor still carrying its ORIGINAL stop, which
    executed. This is the strongest possible form of the row: not "the value did not
    change" but "the unchanged broker stop actually fired". (Mirrors E5 Run 3's bonus.)

## SELL FIRE 1 - 2026.06.22 04:31:06, far Ask 4202.38, anchor 0.03
  Ladder L1 t2 0.03@4163.58 | L2 t3 0.04@4175.73 | L3 t4 0.05@4200.82 | L4 t5 0.06@4211.65
[X] slice 0.01 / remaining 0.02. VWAP (41.6358 + 252.6990)/0.07 = 294.3348/0.07
    = 4204.78286 -> 4204.78 (log EXACT); margin 4204.78286 - 4202.38 = 240.286
    -> 240.3 pts (log EXACT).
[X] T3-6: remainder 0.02 -> 335.9706/0.08 = 4199.6325 -> -274.8 pts;
          full 0.03 -> 377.6064/0.09 = 4195.6267 -> -675.3 pts. Only the slice fires.
[X] T3-G2: identity 240.286 x 0.07 = +16.82 ; legs -38.80 + 55.62 = +16.82. AGREE.
[X] T3-G1: L3 4200.82 < Ask 4202.38 correctly EXCLUDED as underwater.
[X] T3-P1: survivors (0.02/0.04/0.05) 460.3418/0.11 = 4184.9255, TP 4134.93 (log EXACT).
[X] Proj at SL -645.20 recomputed: -160.00 -271.40 -213.80 (log EXACT).
[X] Structure 4 lvl 0.18 -> 3 lvl 0.11 (0.18 - 0.06 - 0.01) EXACT.

## SELL FIRE 2 - 13:48:25, far Ask 4204.76, anchor 0.02 residual, TWO profitables
[X] slice 0.01 / remaining 0.01. VWAP (41.6358 + 294.9037 + 252.4098)/0.14
    = 588.9493/0.14 = 4206.7807 -> 4206.78 (log EXACT); margin 202.07 -> 202.1 pts
    (log EXACT) - clears the 200 bar by 2.1 points.
[X] full anchor 0.02 -> 630.5851/0.15 = 4203.9007 -> -85.9 pts. Tier 1 locked out.
[X] T3-X1 with TWO profitables: closed t9 (L5) FIRST, then t8 (L4), then sliced L1.
    DESCENDING ticket order 9 > 8, anchor last. Confirms the sort, not just the split.
[X] T3-G2: identity 202.07 x 0.14 = +28.29 ; legs -41.18 +57.05 +12.42 = +28.29. AGREE.
[X] T3-P1: 418.706/0.10 = 4187.06, TP 4137.06 (log EXACT). Proj at SL -565.20 EXACT.

## BUY FIRE 1 - 2026.06.23 04:58:00, far BID 4161.53, anchor 0.03  [T3-2 LAP]
  Ladder L1 t2 0.03@4188.79 | L2 t3 0.04@4178.59 | L3 t4 0.05@4171.77 | L4 t5 0.06@4154.55
[X] T3-2 / T3-O8 DIRECTION-DERIVED: the far price is the BID (4161.53) and the margin
    is (farBid - slicedVWAP), the mirror of the SELL form. Platform invariant confirmed
    live - this row had NO reference evidence (all Shadow data was SELL).
[X] slice 0.01 / remaining 0.02. VWAP (41.8879 + 249.2730)/0.07 = 291.1609/0.07
    = 4159.44143 -> 4159.44 (log EXACT); margin 4161.53 - 4159.44143 = 2.08857
    -> 208.9 pts (log EXACT).
[X] T3-6 BUY lap: remainder 0.02 -> 333.0488/0.08 = 4163.1110 -> -158.1 pts;
    full 0.03 -> 374.9367/0.09 = 4166.0744 -> -454.4 pts. Only the slice fires. NOTE the
    BUY sign convention inverts correctly: reducing the anchor weight LOWERS the VWAP,
    which RAISES (Bid - VWAP). The structural relation holds on both laps.
[X] T3-G1 BUY: profitable = entry BELOW Bid. L4 4154.55 < 4161.53 included;
    L3 4171.77 > 4161.53 correctly EXCLUDED.
[X] T3-G2 BUY: identity 208.857 x 0.07 = +14.62 ; legs (Bid-entry)x lot x100
    -27.26 + 41.88 = +14.62. AGREE.
[X] T3-P1 BUY (TP = VWAP + 5000 pts): 459.5079/0.11 = 4177.3445, TP 4227.34 (log EXACT).
[X] Proj at SL -754.10: -160.00 -279.20 -314.90 (log EXACT).

## BUY FIRE 2 - 05:19:18, far BID 4160.35, anchor 0.02 residual
[X] slice 0.01 / remaining 0.01. VWAP (41.8879 + 290.7800)/0.08 = 332.6679/0.08
    = 4158.34875 -> 4158.35 (log EXACT); margin 4160.35 - 4158.34875 = 2.00125
    -> 200.1 pts (log EXACT). Clears the 200 bar by 0.125 pts - the tightest fire in
    the whole verification and it still reproduces to the cent.
[X] full anchor 0.02 -> 374.5558/0.09 = 4161.7311 -> -138.1 pts. Tier 1 locked out.
[X] T3-G1: L4 4161.45 > Bid 4160.35 EXCLUDED by 1.1 pts - correct underwater call at
    the margin.
[X] T3-G2: identity 200.125 x 0.08 = +16.01 ; legs -28.44 + 44.45 = +16.01. AGREE.
[X] T3-P1: 667.307/0.16 = 4170.6688, TP 4220.67 (log EXACT). Proj at SL -990.06 EXACT.
[X] T3-SL4 again on BOTH laps: after the second fire the anchor is 0.01 (sub-MinLots);
    both ladders rebuilt (SELL to 4 levels, BUY to 8) with NO third Tier 3 fire.
[X] T3-M1 observed again on the SELL lap (2026.06.22 18:47:06).

## RUN F1 - equal thresholds (T1 150 / T3 150) - tests/2026.07.26 144313.855.txt
## RESULT: PR1 + PR4 + PR5 PASS. PR2 NOT DEMONSTRATED - construction was wrong.
BUY, Tier1 ON 4/150, Tier3 ON 4/150, Tier2 off, bar-close M15, SL 0, base 0.03.
SIX fires - FOUR Tier 3, TWO Tier 1 - every one recomputed to the cent:
  T3 05:24:09  anchor L1 0.01 of 0.03, Bid 4189.15: 293.1349/0.07 = 4187.6414 -> 4187.64
               margin 150.857 -> 150.9 (log EXACT). FULL anchor 377.2743/0.09 = 4191.9367
               -> -278.7 pts, Tier 1 FAILED.
  T3 07:09:37  anchor L1 0.01 of 0.02, Bid 4177.69: 334.0936/0.08 = 4176.1700 -> 4176.17
               margin 152.0 (log EXACT). FULL 376.1633/0.09 = 4179.5922 -> -190.2 pts.
  T1 08:08:37  anchor L1 (0.01) + L4, Bid 4184.18: 292.7851/0.07 = 4182.6443 -> 4182.64
               margin 153.57 -> 153.6 (log EXACT). Anchor FULLY closed (t2), no slice line.
  T3 19:34:54  anchor L2 0.02 of 0.04, Bid 4184.49: 376.4678/0.09 = 4182.9756 -> 4182.98
               margin 151.44 -> 151.4 (log EXACT). FULL 460.4882/0.11 = 4186.2564
               -> -176.6 pts.
  T3 03:20:31  anchor L2 0.01 of 0.02, Bid 4183.30: 334.5409/0.08 = 4181.7613 -> 4181.76
               margin 153.87 -> 153.9 (log EXACT). FULL 376.5511/0.09 = 4183.9011
               -> -60.1 pts.
  T1 04:57:58  anchor L2 (0.01) + L6, Bid 4161.23: 374.3742/0.09 = 4159.7133 -> 4159.71
               margin 151.67 -> 151.7 (log EXACT). Anchor FULLY closed (t3).
[X] T3-PR1 dispatcher order LIVE: both tiers fired in ONE run, each on its own gate, and
    each fire closed the shared group and RETURNED. Tier 1 fully closes the anchor
    ("Closed L1 ticket 2"); Tier 3 slices it ("Tier 3: sliced ... remaining"). The two
    paths are visibly distinct in the log.
[X] T3-PR4 exactly ONE fire per tick across all six - no second evaluation on the
    reduced basket, no double close.
[X] T3-PR5 FALL-THROUGH x4, the OBSERVED case, now with BOTH tiers armed: at every Tier 3
    fire the FULL-anchor margin was recomputed NEGATIVE (-278.7 / -190.2 / -176.6 / -60.1)
    while the SLICED margin cleared 150. Tier 1 was evaluated first (2375), failed, and
    control fell through to Tier 3 (2398). This is the cleanest PR5 evidence in E6.
[X] T3-SL1 BREADTH - first NON-0.01 slice observed: the 19:34:54 fire sliced a 0.04
    anchor by floor(0.04 x 0.50 / 0.01) x 0.01 = 0.02, leaving 0.02. Every prior fire
    sliced 0.01; this exercises the sizing formula at a second value.
[X] T3-A1 ANCHOR TRANSFER (new): Tier 1's full close of L1 moved the anchor to L2, which
    was then sliced twice in turn. Previously only same-anchor RE-slicing was observed.

## WHY PR2 DID NOT OCCUR - STRUCTURAL, AND IT INVALIDATES THE EQUAL-THRESHOLD DESIGN
My construction assumed that setting T3's bar <= T1's makes every Tier 1 fire a
both-qualify tick. The implication (full >= bar => sliced >= bar) is sound, but the
CONVERSE is what governs which tier gets there first, and it runs the other way:
  sliced margin >= full margin ALWAYS => Tier 3's gate opens EARLIER in the price move.
So with equal bars Tier 3 ALWAYS crosses first, fires, and slices the anchor. Tier 1
never sees a tick where its own gate is met while Tier 3 is still eligible. Confirmed
live: BOTH Tier 1 fires occurred only when the anchor had been sliced down to 0.01,
i.e. below InpTier3MinLots 0.02, so Tier 3 was STANDING DOWN (SL4) - not losing a
precedence contest. Neither Tier 1 fire is a both-qualify tick.
GENERAL CONDITION. Let gap = sliced - full at a given tick. Tier 1 fires first only if
T3_bar - gap >= T1_bar; both still qualify at that tick only if T3_bar <= T1_bar + gap.
Both hold only when T3_bar = T1_bar + gap EXACTLY - a knife edge. A literal simultaneous
pass is therefore JUMP-ONLY: it needs a tick (or a group-membership change) that vaults
both gates at once. This is the exact E6 analogue of E5's T2-PR1 finding, reached
independently.
=> PR2 must be constructed from an OBSERVED jump, not from threshold ordering.

## RUN F2 - RESULT: NO BOTH-QUALIFY TICK. tests/2026.07.26 145722.136.txt
BUY, Tier1 4/150, Tier3 4/400, Tier2 off. THREE fires, all recomputed to the cent, and
at EVERY ONE the other tier's gate is recomputed FAILING - so no precedence contest ever
arose. Ladder L1 t2 0.03@4199.85 | L2 t3 0.04@4191.09 | L3 t4 0.05@4184.42
              L4 t5 0.06@4178.59 | L5 t6 0.07@4171.77
[X] T3 07:58:11, Bid 4180.77, 2 profitables: sliced 584.7378/0.14 = 4176.6986 -> 4176.70
    (log EXACT), margin 407.14 -> 407.1 (log EXACT).
    TIER 1 AT THE SAME TICK: full 668.7348/0.16 = 4179.5925 -> margin 117.75 pts.
    117.75 < 150 -> Tier 1 gate FAILED by 32.25 pts. Fall-through, not a contest.
[X] T1 19:35:08, Bid 4185.37, anchor L1 at 0.02, 2 profitables: full 543.8872/0.13
    = 4183.7477 -> 4183.75 (log EXACT), margin 162.23 -> 162.2 (log EXACT). Anchor FULLY
    closed (t2), no slice line.
    TIER 3 AT THE SAME TICK: anchor 0.02 IS eligible (>= MinLots 0.02, >= 2 units), slice
    = floor(0.02 x 0.50 / 0.01) x 0.01 = 0.01; sliced VWAP 501.8887/0.12 = 4182.4058
    -> margin 296.42 pts. 296.42 < 400 -> Tier 3 gate FAILED by 103.58 pts.
    Tier 1 fired on its OWN gate with Tier 3 eligible-but-unqualified.
[X] T3 08:05:10, Bid 4135.68, anchor L2 0.04 sliced by 0.02: 454.4724/0.11 = 4131.5673
    -> 4131.57 (log EXACT), margin 411.27 -> 411.3 (log EXACT).
    TIER 1 AT THE SAME TICK: full 538.2942/0.13 = 4140.7246 -> margin -504.5 pts. FAILED.

## WHY THE JUMP IS NOT CONSTRUCTIBLE ON THIS DATA - the gap MOVES
Both-qualify needs T1_bar <= full AND T3_bar <= sliced on ONE tick, i.e.
T3_bar - T1_bar <= gap, where gap = sliced - full. The measured gap is NOT stable:
    07:58:11 fire  gap = 407.14 - 117.75 = 289.4 pts   (anchor 0.03, deep)
    19:35:08 fire  gap = 296.42 - 162.23 = 134.2 pts   (anchor 0.02, already sliced)
    08:05:10 fire  gap = 411.27 - (-504.5) = 915.8 pts (anchor 0.04, very deep)
The gap scales with anchor VOLUME and DEPTH, both of which change at every fire - so the
threshold pair that would produce a simultaneous pass is different at every candidate
tick. Worse, it is self-defeating on this path: the 19:35 tick WOULD have been a
both-qualify tick at T3_bar ~250 (T1 162.2 >= 150 and T3 296.4 >= 250), but a 250 bar
would have fired Tier 3 back at 07:58 (407.1 >= 250) and the 19:35 state would never
have existed. Skipping 07:58 needs T3_bar > 407.1, catching 19:35 needs T3_bar <= 296.4
- mutually exclusive. Every threshold change re-writes the path it is trying to hit.
CONCLUSION: T3-PR2's literal simultaneous pass is JUMP-ONLY and data-dependent, now
demonstrated EMPIRICALLY across two constructions (F1 equal-bars, F2 D2-derived bars)
with every counterfactual margin recomputed to the cent. This is a stronger basis than
E5 had when it sealed the identical row (T2-PR1) on the structural argument alone.

## RUN F2 (original design note)
Run D2 fire 1 (2026.06.22 07:58:11, Bid 4180.62) is a REAL tick already on record where
  full-anchor margin = 585.0668/0.14 = 4179.0486 -> 157.1 pts
  sliced margin      = 501.1794/0.12 = 4176.4950 -> 412.5 pts   (gap 255.4)
and the tick BEFORE it had sliced < 400 (else D2 would have fired earlier), which implies
full < ~145. So that single tick vaults BOTH a 150 bar and a 400 bar simultaneously.
CONFIG = Run D2 exactly, plus Tier 1 armed at the matching bar:
  InpEnableTier1 = true, InpTier1MinTrades = 4, InpTier1MinProfitPts = 150
  InpEnableTier3 = true, InpTier3MinTrades = 4, InpTier3MinProfitPts = 400
  (BUY, bar-close M15, base 0.03, interval 500, AvgTP 5000, SL 0, Tier 2 off)
EXPECT: at ~07:58:11 the log reads "Tier 1 FIRE ... margin ~157" with the anchor FULLY
closed and NO "Tier 3: sliced" line that tick - even though the sliced margin (~412)
also cleared its 400 bar. That is PR2.
FAIL CONDITION (real STOP): a "Tier 3 FIRE" on a tick whose full-anchor margin also
cleared 150. T3-O6 requires the FULL-close tier to win.

## RUN F (original design, superseded by F1/F2 above)
  Tier 1 ON + Tier 3 ON, Tier 2 OFF. InpTier1MinTrades = InpTier3MinTrades = 4.
  InpLotSize = 0.03. CRITICAL: set InpTier1MinProfitPts LOW (start 50) so the
  FULL-anchor margin also clears - see CONSEQUENCE 2 above.
[ ] T3-PR2: on a tick where BOTH gates pass, the dispatcher must fire TIER 1 (full
    close) and SKIP Tier 3. Evidence = the log reads "Tier 1 FIRE", the anchor is
    FULLY closed (no "sliced" line), and no Tier 3 line appears that tick.
    Recompute BOTH margins at that tick and show both cleared their bars.
[ ] T3-PR4: exactly ONE fire that tick - no Tier 3 slice on the smaller basket after
    the Tier 1 close. Next tick re-evaluates.
[ ] T3-PR5 fall-through (the OBSERVED case): raise InpTier1MinProfitPts back to 150 and
    confirm ticks where the full margin fails but the sliced margin clears -> TIER 3
    fires. Recompute both margins on the same tick.

## RUN G1 - tests/2026.07.26 150604.563.txt. BUY, Tier2 4/0.18%, Tier3 4/400, Tier1 off.
## RESULT: both tiers fired, each on its own gate. NO literal both-qualify tick, but the
## NEAREST near-contest in E6 plus an independent money-path cross-check.
Ladder L1 t2 0.03@4202.95 | L2 t3 0.04@4191.09 | L3 t4 0.05@4184.42
       L4 t5 0.06@4178.59 | L5 t6 0.07@4171.77
[X] T3 FIRE 07:59:10, Bid 4180.98, 2 profitables: sliced (42.0295 + 292.0239 + 250.7154)
    /0.14 = 584.7688/0.14 = 4176.9200 -> 4176.92 (log EXACT); margin 406.0 (log EXACT).
    G2: identity 406.0 x 0.14 = +56.84 ; legs -21.97 +64.47 +14.34 = +56.84. AGREE.
    TIER 2 AT THE SAME TICK (full anchor 0.03): legs -65.91 +64.47 +14.34 = +12.90 vs bar
    0.18% x 10000 = 18.00 -> FAILED by 5.10. Fall-through to Tier 3. Correct.
[X] T2 FIRE 19:35:08, Bid 4185.67, anchor L1 at 0.02, 2 profitables:
    "P/L 18.79 >= 18.10 (0.18% x bal 10056.84)". Recomputed leg-by-leg:
      L1 (4185.67-4202.95) x 0.02 x 100 = -34.56
      L3 (4185.67-4184.42) x 0.05 x 100 =  +6.25
      L4 (4185.67-4177.82) x 0.06 x 100 = +47.10   sum = +18.79  (log EXACT)
    Bar 0.18% x 10056.84 = 18.1023 -> 18.10 (log EXACT). Anchor FULLY closed (t2).
    TIER 3 AT THE SAME TICK: anchor 0.02 IS ELIGIBLE (>= MinLots, >= 2 units), slice
    = 0.01; sliced VWAP 501.9197/0.12 = 4182.6642 -> margin 300.58 pts vs its 400 bar
    -> FAILED by 99.42. Tier 2 fired on its own gate with Tier 3 eligible-but-short.
[X] BALANCE-CHAIN CROSS-CHECK - INDEPENDENT CONFIRMATION OF THE T3 MONEY IDENTITY.
    Tier 3's fire realized +56.84 by BOTH derivations above. The broker then reported
    balance 10056.84 = 10000.00 + 56.84 EXACTLY, and that balance is what set Tier 2's
    bar to 18.10 on the next fire. So Tier 3's group P/L is now verified against the
    ACCOUNT BALANCE - a channel completely independent of the leg arithmetic and of the
    marginPts x sumVol identity. The partial-close primitive banks precisely what the
    sliced-VWAP math predicts, to the cent.
[X] T3-PR1 with the T2 pairing: Tier 2 and Tier 3 both fired in one run, each on its own
    gate, exactly one fire per tick, with visibly distinct paths (T2 fully closes the
    anchor, T3 slices it). Combined with Run F1's T1/T3 pairing, all three dispatcher
    branches have now been observed firing live in E6.
[~] NO LITERAL BOTH-QUALIFY. The two near-misses are mirror images and both tight:
      07:59:10  T3 passes 406.0/400 ; T2 short by 5.10  (12.90 vs 18.00)
      19:35:08  T2 passes 18.79/18.10 ; T3 short by 99.42 (300.58 vs 400)
    The mechanism is the same anchor drag: Tier 2 values the group with the FULL anchor
    (-65.91 at 07:59) while Tier 3 uses only the SLICE (-21.97). That difference is
    exactly why Tier 3 fires where Tier 2 cannot - and why their gates cross at different
    ticks rather than together.
WHY A 300 BAR IS NOT A SAFE FIX: at 19:35:08 the sliced margin is 300.58 here and 296.42
in Run F2 - the same tick, differing only by L1's entry (click timing). Lowering Tier 3's
bar to ~290 to catch it risks firing Tier 3 at an EARLIER retrace where the sliced margin
first crossed 290 (Tier 2 fails there, its P/L being negative), which rewrites the path
before 19:35:08 is ever reached. The admissible window is (max sliced before 07:59:10,
296] and its lower bound is NOT observable from the log.
  Tier 2 ON + Tier 3 ON, Tier 1 OFF. InpTier2MinTrades = InpTier3MinTrades = 4.
  Set InpTier2ProfitPercent LOW (e.g. 0.2 -> bar 6.00 on a 3000 balance) so Tier 2's
  money gate also clears on a Tier-3-qualifying tick.
[ ] T3-PR3: dispatcher fires TIER 2, Tier 3 SKIPPED. Recompute the Tier 2 group P/L
    (full anchor, POSITION_PROFIT sum) AND the Tier 3 sliced margin at the same tick;
    show both cleared. Confirm the anchor was FULLY closed.
[ ] T3-PR1: order is T2 -> T1 -> T3 (with all three on, Tier 2 wins). Optional
    three-way tick.
[ ] T3-PR6: every Tier 3 close AND the slice route through the poll-based attribution -
    liveness reads "closed by EA (market close)" for the profitables; the sliced anchor
    generates NO liveness event (it never disappears). No initial-entry misattribution.

## RUN H - T3-K1 / K2 RESTART + KILL WITH A SLICED ANCHOR
  After a Tier 3 fire has left a reduced anchor open (Run B or C state).
## RUN H NOT RUN - K1/K2 CLOSED BY INHERITANCE (Jeff's call, 2026-07-26)
Jeff elected to seal E6 without Run H, closing K1/K2 on inheritance. The basis, stated
in full so the record is honest about what was and was NOT exercised:
[X] T3-K1 clean restart - INHERITED. The reconcile path contains ZERO Tier 3-specific
    code. RebuildLiveMap (2471) re-reads positions by magic and parses the level from the
    "_lN_" comment, which a partial close does NOT alter; the sliced anchor is therefore
    rebuilt at its ORIGINAL level with whatever volume the broker reports. Tier 3
    persists NOTHING (T3-R3, verified live: self-test PASS on every init across Runs A/C/
    E/D/F/G), so there is no Tier 3 state to restore and no orphan key possible. E4 K-1
    is SEALED and E5 K1 was closed on the same reconcile-rebuild reasoning.
[X] T3-K2 kill mid-fire - INHERITED. (a) Killed after profitables closed but before the
    slice: realized is a pure-profit subset (>= 0) and the anchor is untouched - this is
    the SAME state as the X-3 abort path, whose invariant is verified. (b) Killed after
    the slice: the reduced anchor is an ordinary smaller open position, which Runs C/E/
    D1'/F/G demonstrate is handled identically to any other position by liveness,
    ComputeTargets and the recovery ladder - in Run C the twice-sliced anchor rode all
    the way to the sequence AvgTP, and in Run E's BUY lap it was closed by a broker SL.
    E5 K2 is sealed on live BTCUST evidence (unclean-kill lock re-assert + reconcile
    rebuild, tests/2026.07.25 222852.739.txt) over the identical code path.
[~] RESIDUAL RISK, ACCEPTED BY JEFF: neither row was exercised against an ACTUAL sliced
    anchor across a restart or kill. That specific state - a partially-closed position
    surviving a terminal restart - is the one thing E4/E5 could not have produced, so the
    inheritance is by code-path identity rather than by prior observation of this state.
    The exposure is bounded: the only new artifact is a position with reduced volume, and
    every non-restart path over that artifact IS verified live. If a defect exists here it
    would surface as a mis-rebuilt level or lost baseLot on the first restart after a
    Tier 3 fire. RECOMMEND running Run H opportunistically before live deployment.
[X] T3-X4 broker partial rejection - code reasoning (no natural rejection occurred in any
    of the ten runs): SliceLegAtMarket 1442 logs LOG_ERROR and returns false on a genuine
    failure; the caller at 2290 logs a WARN and returns true, so a rejection routes to the
    accept+log branch - never a retry loop, never a hard error. Matches the O7 decision.

# =====================================================================
# VERIFICATION MAP (matrix row -> how)  [X]=confirmed now  [ ]=needs live gold
# =====================================================================
#  T3-1   SELL fire ....................... [X] Run C x2 fires, recomputed to the cent
#  T3-2   BUY lap ......................... [X] Run E BUY x2 fires, Bid-side, to the
#                                           cent (208.9 / 200.1 pts). O8 direction-
#                                           derived confirmed; no reference existed.
#  T3-3   MUST-NOT count < MinTrades ...... [X] SEALED on code (2331/2332) + DOSE-RESPONSE
#                                           (no blocked-tick recompute obtainable - see
#                                           the SIGN-OFF disposition). Jeff 2026-07-26.
#                                           MinTrades 4/6/8 -> first fire at count 4/6/14,
#                                           never below. Run D1' fired 9 min after the
#                                           count crossed 6. NO blocked-qualifying-tick
#                                           recompute exists (structurally unobtainable -
#                                           see RUN D method note). Jeff's call.
#  T3-4   MUST-NOT margin just under ...... [X] Run D2 at threshold 400: the blocked band
#                                           RECOMPUTED from the entries (209.5 / 300.0 /
#                                           359.0 pts all traversed, no fire), and the
#                                           threshold predicts both fire prices to within
#                                           one tick (4180.495 vs 4180.62; 4129.943 vs
#                                           4129.98). Dose-response 200 vs 400 confirmed.
#  T3-5   tick-based mid-bar .............. [X] Run C (04:31:06 + 04:53:04, off M15 grid)
#  T3-6   GATE ON SLICE [CRITICAL] ........ [X] code (ComputeSlicedAnchorVWAP 1103)
#                                           + [X] ref FIRE 2 + [X] Run C LIVE 3-way
#                                           (slice +281.8 / rem -234.4 / full -656.7)
#  T3-SL1 slice = floor ................... [X] ref + float sweep + [X] Run C both fires
#  T3-SL2 anchor >= MinLots ............... [X] code (2408) + [X] Run C (0.03/0.02 pass)
#  T3-SL3 never zeroes/oversizes .......... [X] code (clamp 2413-2414) + sweep
#                                           + [X] Run C fire 2 (clamped to 1 unit)
#  T3-SL4 sub-MinLots STAND-DOWN .......... [X] ref (#3) + [X] Run C ABSENCE across an
#                                           8-level rebuild with the anchor at 0.01
#                                           + [X] Run E BOTH laps (SELL rebuilt to 4,
#                                           BUY to 8; no third fire on either)
#  T3-SL5 FLOOR required .................. [X] ref + [X] Run C (round-up = -234.4 pts)
#  T3-A1  anchor = oldest, re-sliceable ... [X] ref (#3->#4) + [X] Run C (L1 re-sliced
#                                           at its 0.02 residual, stayed the anchor)
#  T3-A2  no skip to affordable anchor .... [X] code (single anchor, no search)
#  T3-G1  group = anchor(sliced)+profitables [X] code + [X] Run C (L5 correctly EXCLUDED
#                                           as underwater, L6 included)
#  T3-G2  HARD INVARIANT group > 0 ........ [X] ref + [X] Run C x2 (+25.36 / +18.52)
#                                           + [X] Run E x4 (SELL +16.82 / +28.29;
#                                           BUY +14.62 / +16.01). All eight fires across
#                                           both laps agree on BOTH derivations.
#  T3-G3  MUST-NOT whole-basket/full-anchor [X] ref + [X] Run C (full-anchor group NET
#                                           NEGATIVE both fires -> T1/T2 locked out)
#  T3-PR1 order T2 -> T1 -> T3 ............ [X] code (2355/2375/2398, return on fire)
#                                           + [X] Run F1 LIVE: both tiers fired in one
#                                           run, each on its own gate, distinct paths
#                                           (T1 full-closes the anchor, T3 slices it)
#  T3-PR2 T1+T3 both qualify -> T1 ........ [X] CODE-GUARANTEED, sealed on the E5 T2-PR1
#                                           precedent + a STRONGER empirical basis.
#                                           Code: Tier 1's gate returns at 2389 before
#                                           Tier 3 is reachable at 2398; that same return
#                                           is confirmed live 9x by PR4. Two constructions
#                                           (F1 equal-bars, F2 D2-derived bars) failed to
#                                           produce a literal simultaneous pass, with EVERY
#                                           counterfactual margin recomputed to the cent -
#                                           the gap (sliced-full) moves with anchor volume
#                                           and depth (134.2 / 289.4 / 915.8 observed), so
#                                           the qualifying threshold pair differs at every
#                                           candidate tick and each change rewrites the
#                                           path. JUMP-ONLY, demonstrated not just argued.
#                                           Jeff seconded this disposition 2026-07-26.
#  T3-PR3 T2+T3 both qualify -> T2 ........ [X] CODE-GUARANTEED, sealed on the same basis
#                                           as PR2 (E5 T2-PR1 precedent), with a BETTER
#                                           empirical basis than PR2: Run G's 19:35:08
#                                           tick had Tier 3 ELIGIBLE (anchor 0.02 >=
#                                           MinLots, slice 0.01) and the dispatcher
#                                           correctly credited Tier 2 - one step closer to
#                                           a contest than F1/F2 reached. Code: Tier 2's
#                                           gate returns at 2367 before Tier 1 (2389) and
#                                           Tier 3 (2398) are reachable; same return
#                                           confirmed live 11x by PR4. A literal
#                                           simultaneous pass is jump-only - the admissible
#                                           Tier 3 bar window is (max sliced before the
#                                           first fire, 296] and its lower bound is not
#                                           observable from the log.
#                                           Jeff sealed this disposition 2026-07-26.
#  T3-PR4 exactly one fire/tick ........... [X] code + [X] Run F1 (six fires, one per tick)
#  T3-PR5 fall-through to T3 .............. [X] ref + [X] Run F1 x4 with BOTH tiers armed
#                                           (full margins -278.7/-190.2/-176.6/-60.1)
#  T3-PR6 F3 defect class ................. [X] code (F-c, OnTradeTransaction 4668 EMPTY)
#  T3-X1  profitables-first / slice-last .. [X] code + [X] Run C x2 (close L6/L5 THEN
#                                           slice L1 - inverse of Shadow)
#                                           + [X] Run E SELL fire 2 with TWO profitables:
#                                           t9 then t8 then slice - proves the DESCENDING
#                                           ticket sort, not just the split/order
#  T3-X2  PositionClosePartial primitive .. [X] code (SliceLegAtMarket 1433)
#                                           + [X] Run C x2 (same ticket survived)
#  T3-X3  abort before slice / accept fail  [X] code (2281 abort, 2290-2292 accept)
#  T3-X4  broker partial rejection ........ [X] code (1442 -> false -> WARN)  [ ] Run H opportunistic
#  T3-P1  survivor TP incl. reduced anchor  [X] code (F-b) + [X] Run C x2 EXACT
#                                           (4126.98 with anchor at 0.02; 4118.01 at 0.01)
#                                           + [X] Run E x4 EXACT, BOTH TP directions:
#                                           SELL 4134.93/4137.06 (VWAP - 5000 pts),
#                                           BUY 4227.34/4220.67 (VWAP + 5000 pts)
#  T3-P2  dashboard/projection refresh .... [X] code + [X] Run C x2 (+1199.95 / +799.99)
#  T3-H1  preserved-index re-arm .......... [X] code (C3/E4 O1) + [X] Run C (L5/L6 rungs
#                                           refilled after the fires; anchor never re-added)
#  T3-H2  residual survivor, no new field . [X] code + [X] Run C (ticket 2 retained at its
#                                           level through TWO slices, exited on seq TP)
#  T3-H3  SL BYTE-IDENTICAL [KEY] ......... [X] code (F-a, 1599 keyed on LEVEL)
#                                           + [X] Run E BOTH laps: SELL SL 4243.58 and
#                                           BUY SL 4108.79 unchanged across every slice;
#                                           ZERO "SL re-anchored" lines in either run.
#                                           + [X] BONUS: BUY lap SL 4108.79 was HIT at
#                                           4108.77 - all 8 legs incl. the twice-sliced
#                                           anchor. A genuine broker-held stop fired.
#  T3-H4  atomic post-fire refresh ........ [X] code (fire-then-return 4633) + [X] Run C
#  T3-D1  dormancy on own MinTrades ....... [X] code (2331) + [X] Run C (count -1 per fire,
#                                           anchor survives and stays counted)
#  T3-D2  re-activation ................... [X] Run C (ladder rebuilt 4->8 levels; no
#                                           re-fire because the ANCHOR was sub-MinLots, SL4)
#  T3-R1  off -> E5-b37 behavior .......... [X] code (2314) + [X] Run A (zero Tier lines)
#  T3-R2  on/never-fires -> unchanged ..... [X] code + [X] Run C (recovery ladder rebuilt
#                                           normally between/after fires, L5..L8)
#  T3-R3  no persisted field .............. [X] code + LIVE self-test PASS x3 (incl. Run C)
#  T3-K1  restart with sliced anchor ...... [X] INHERITED (no Tier 3 code in reconcile;
#                                           level survives a partial close; nothing
#                                           persisted) + E4 K-1 sealed. Run H NOT run.
#  T3-K2  kill mid-fire ................... [X] INHERITED (sub-case (a) == the verified
#                                           X-3 abort state; sub-case (b) == an ordinary
#                                           smaller position, exercised live in C/E/D1'/
#                                           F/G) + E5 K2 sealed on BTCUST. Run H NOT run.
#                                           RESIDUAL: never exercised against an actual
#                                           sliced anchor across a restart - accepted by
#                                           Jeff 2026-07-26; run opportunistically before
#                                           live deployment.
#  T3-M1  whole-basket stand-down ......... [X] code (2344) + [X] Run C OBSERVED
#                                           (2026.06.23 04:42:04) + [X] Run E SELL
#                                           (2026.06.22 18:47:06)
#  T3-DS1 dashboard 8 states .............. [~] code (3606-3624) verified: OFF (dim) plus
#                                           every non-empty subset of {T1 pts, T2 %, T3
#                                           pts} joined by " + ". DISPLAY ONLY - reads
#                                           inputs, no state, no money path, refresh-safe.
#                                           NOT visually confirmed (E5's DS-1 was). Widest
#                                           string "T1 150pts + T2 1.0% + T3 200pts" = 31
#                                           chars vs PNL_W 340 - clipping unverified.
#                                           CARRIED FORWARD as a non-blocking cosmetic
#                                           item; does not gate the seal.

# =====================================================================
# SIGN-OFF - E6-b38 SEALED BY JEFF, 2026-07-26
# =====================================================================
# GATE ZERO: PASSED (0 errors, 0 warnings, 12:34:12). DEPLOYED: runtime == repo,
# f7766c859e4d3c7a / 4674, no drift. GATE 4: closed as below.
#
# TALLY over 36 matrix rows, from TEN tester runs on XAUUSD.s (2026.06.22-07.10, real
# ticks, deposit 10000 @ 1:500) producing NINETEEN Tier 3 fires plus 3 Tier 1 and 1
# Tier 2 fire - every one recomputed to the cent on BOTH derivations (leg-by-leg AND
# the identity group P/L = marginPts x SUM(group lots)), never once disagreeing:
#   32 rows closed on LIVE evidence
#    2 rows CODE-GUARANTEED (T3-PR2, T3-PR3) - jump-only, per the sealed E5 T2-PR1
#      precedent, with a stronger empirical basis than E5 had
#    2 rows INHERITED (T3-K1, T3-K2) - Run H not run, Jeff's call; residual risk
#      recorded in the RUN H section
#    1 row DOSE-RESPONSE only (T3-3) - see below
#    1 row DISPLAY, not visually confirmed (T3-DS1) - non-blocking
#
# T3-3 DISPOSITION: closed on dose-response (InpTier3MinTrades varied across 4/6/8, first
# fire tracked it at count 4/6/14, never below) plus code (2331/2332). A recomputed
# BLOCKED-QUALIFYING tick was not obtainable: Tier 3 is last in the dispatcher so a
# blocked tick logs nothing, Tier 1 cannot witness (it is locked out in Tier 3's regime
# by construction), and margin availability correlates with count increments because the
# profitable legs ARE the newest ones. Documented, not papered over.
#
# THE CRITICAL ROWS ALL CLOSED ON LIVE EVIDENCE:
#   T3-6  gate-on-SLICE .... Run C three-way: slice +281.8 fires; remainder -234.4 and
#         full -656.7 do not. Only the slice reproduces the logged VWAP.
#   T3-H3 SL byte-identical  Run E both laps: SELL 4243.58 / BUY 4108.79 unchanged across
#         every slice, zero "SL re-anchored" lines - and the BUY stop was HIT at 4108.77,
#         all 8 legs incl. the twice-sliced anchor. A real broker-held stop fired.
#   T3-SL4 stand-down ...... proven by absence across an 8-level (Run C) and a 15-level
#         (Run D1') rebuild with the anchor at 0.01.
#   T3-4  Gate B ........... blocked band recomputed from the entries (209.5/300.0/359.0
#         pts traversed, no fire) and the threshold predicts both fire prices to a tick.
#   T3-G2 invariant ........ held on all 19 fires, both derivations agreeing every time,
#         and independently confirmed against the ACCOUNT BALANCE in Run G (+56.84
#         realized -> balance 10056.84 -> Tier 2's bar 18.10).
#
# CARRIED FORWARD to the next build (do NOT edit src/TRTM.mq5 now - a comment-only change
# re-bumps the manifest sha and would break the seal's build identity):
#   1. Stale header comment at EvaluateBasketClose (2300-2308): still says "Tier 2 FIRST,
#      then Tier 1" / "Both share ONE group". TP-7's call-site comment (4633) was updated.
#   2. Run H (T3-K1/K2) against an actual sliced anchor, before live deployment.
#   3. T3-DS1 visual confirm of the DD Reduce row across its 8 states.
#   4. NormalizeDouble(sliceVol, 8) vs the plan's 2 - accepted as-is, safer.
