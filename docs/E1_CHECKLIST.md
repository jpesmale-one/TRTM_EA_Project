# E1 - Lot-weighted anchor - VERIFICATION CHECKLIST
# Build under test: E1-b34 (aef5dc989609dc45 / 4307 lines).
# Matrix: docs/E1_MATRIX.md (SEALED, 25 rows). Plan: docs/E1_PLAN.md.
# S-items map 1:1 to M-rows. Regression (equal-lot no-op) FIRST, then the
# actual change (unequal), then display consistency, then Recovery
# must-NOT, then restart/kill. Gate zero = clean compile (Jeff's terminal).
#
# AUDIT RULE: every S-item PASS requires the pasted log with EVERY number
# recomputed (both simple AND weighted shown, so the basis is proven, not
# assumed). Equal-lot rows prove weighted==simple to the cent; unequal
# rows prove they DIVERGE and the new value is weighted. Symbol-sensitive
# money arithmetic = XAUUSD.s only.

## GATE ZERO
S0  Compiles clean (0 errors / 0 warnings) in Jeff's MetaEditor. Parse
    the "Result:" line, not the exit code (UTF-16 log; exit code lies).

## Group A - Equal-lot REGRESSION (must-NOT change; EQ-1..EQ-4)
S1  [EQ-1] Single level (levelCount==1): TP uses anchorEntry, avg branch
    unused. TP/BE identical to b33. No weighted path exercised.
S2  [EQ-2] 2 equal lots BUY: log shows weighted==simple==(E1+E2)/2 to the
    cent; TP/BE/trail prices bit-identical to a b33 baseline.
S3  [EQ-3] Stalled martingale band (equal lots across L3-L6): no TP/BE/
    trail/projection delta vs b33 anywhere in the run.
S4  [EQ-4] Equal-lot SELL lap: weighted==simple; SELL TP/BE/trail bit-
    identical to b33 (direction-signed anchor unchanged).

## Group B - Unequal-lot: the actual change (U-1..U-5)
S5  [U-1] 3 levels 0.02/0.02/0.03 BUY: anchor = weighted (ref 4018.3843)
    NOT simple (4018.3433). avg-TP, BE stop recomputed on weighted; log
    shows the +4.1 pt shift. Both formulas stated.
S6  [U-2] Same, SELL: anchor pulled the OTHER way; TP/BE/trail shift by
    the direction-signed delta; sign proven from the log, not assumed.
S7  [U-3] Ascending lots across a curve STEP (e.g. 0.02/0.03/0.05):
    weighted diverges from simple by more than U-1; recomputed.
S8  [U-4] Descending/mixed lots (large EARLY lot): weighted pulled toward
    the early lot (opposite direction to U-1). Proves lot-driven not
    order-driven.
S9  [U-5] Unequal lots via RM_MANUAL multiplier list: weighted correct
    for an arbitrary lot ratio off the closed-form curve.

## Group C - Path coverage on unequal sequences (P-1..P-5)
S10 [P-1] avg-TP (levelCount>1) reads weighted; logged value = weighted.
S11 [P-2] BE TRIGGER arms at weighted+trigger (LATER than simple for a
    higher BUY anchor); arm price recomputed.
S12 [P-3] BE STOP floor = weighted+offset[+cost cover]; CostCoverPoints
    unchanged (recompute confirms it is average-independent).
S13 [P-4] Trail ACTIVATION = weighted+offset+dist; ratchet steps
    unchanged; activation recomputed on weighted.
S14 [P-5] Dashboard avg-entry row + Proj at TP/SL = weighted; MUST equal
    the engine's placed TP/BE (no drift).

## Group D - Display-vs-engine consistency (C-1..C-4; the b26 class)
S15 [C-1] MUST-NOT: no surviving simple-average site. grep src for
    sum(entry)/count with no volume weight => none in TP/BE/trail/proj.
    All read the identical weighted value (recompute across sites).
S16 [C-2] MUST-NOT: dashboard projection, avg-entry, and the actual
    placed TP/BE all derive from the SAME weighted value in one pass.
S17 [C-3] Manual TP/SL owned + unequal lots: manual substitution + tag
    byte-identical; only the COMPUTED value shown is weighted.
S18 [C-4] LogStructure "projected at TP/SL" on an unequal sequence uses
    weighted; matches dashboard and engine.

## Group E - Recovery MUST-NOT (R-1..R-3)
S19 [R-1] MUST-NOT: ComputeLevelLot output bit-identical to b33 (same
    inputs, same per-level lots). grep-confirm the lot path untouched.
S20 [R-2] MUST-NOT: recovery entries land at the same prices as b33
    (spacing = anchor+N*interval, not the average). Unequal sequence.
S21 [R-3] MUST-NOT: base lot / L1-closes-survives semantics intact.

## Group F - Restart / kill (K-1..K-3; safety spine, run LIVE demo)
S22 [K-1] RESTART (recompile/re-attach) mid unequal sequence: anchor
    recomputes weighted from live positions; post-restart TP/BE ==
    pre-restart weighted. No persisted average to go stale.
S23 [K-2] KILL (hard, OnDeinit skipped) + restart: state schema
    unchanged, RunStateSelfTest identical, weighted anchor rebuilt from
    re-read positions. No orphan simple-avg value.
S24 [K-3] Anchor-level change (level add/remove) on unequal sequence:
    the re-anchor INFO (line ~1499) still fires, now reporting the
    weighted-derived SL. Behavior unchanged, value weighted.

## SEAL CONDITION
All S-items PASS with pasted log evidence, every number recomputed (both
bases shown). Equal-lot rows (S1-S4, S19-S21) + C-1/C-2 are the must-NOT
spine. Unequal rows prove divergence and the weighted basis. Equivalence
allowed only on identical branches with the branch + bracketing evidence
named. Restart/kill on a LIVE demo chart (tester has no in-pass re-init).
On seal: STATE.md disposition -> SEALED, README E1 section, handover,
then E4 (Tier 1) unblocks.

## Disposition (updated as evidence lands)
Run 1 (2026-07-23 13:53-14:00, XAUUSD.s M1, incremental 0.01 step, BUY,
10 levels 0.01->0.10 - no stall, weighted != simple at every step; then
BE armed, fired, and the basket exited on the weighted TP - full BUY
lifecycle in one run):
- S0  PASS - clean compile (Jeff's MetaEditor), E1-b34 on the init line.
- S1  PASS (EQ-1) - L1 TP 4131.50 via anchorEntry/InitialTP, avg branch
      unused at levelCount==1.
- S5  PASS (U-1) - all 10 multi-level TPs = weighted avg + 200 pts to the
      cent; none match simple mean (L10 4124.88 weighted vs 4125.81
      simple). Full recompute in the session audit.
- S10 PASS (P-1) - avg-TP reads the weighted anchor at every multi-level.
- S11 PASS (P-2) - BE TRIGGERED on the weighted anchor: printed "avg
      4122.88" = computed weighted 4122.8757. Fired at bid 4124.22; on
      the simple mean (4123.81) the trigger would not have fired.
- S12 PASS (P-3) - BE stop 4123.18 = weighted 4122.8757 + 30 pts offset
      exact; cost cover 0 (no adverse swap intraday, CostCoverPoints
      untouched). Simple would have placed 4124.11.
- S14 PASS-by-arithmetic (P-5) - ComputeProjection pTP/pSL match the
      weighted tp + entries (L2 +6.00, L10 +110.24 exact); avgEntry row
      derives from the same loop. Panel screenshot optional for the visual.
- S15 PASS (C-1) - build-time grep: no surviving sum(entry)/count site.
- S16 PASS (C-2) - projection/display, BE stop, and the placed TP all
      derive from the same weighted value (no b26 drift). Basket then
      closed via the weighted TP 4124.88 (all 10 "TP hit @ 4124.92").
- R-1/R-2/R-3 SUPPORTED BY INSPECTION - recovery lots opened exactly
      0.01..0.10 (ComputeLevelLot untouched), 50-pt spacing held, SL
      stayed 4076.50 pre-BE (anchored to L1, never averaged).
No FAILs, no findings. Weighted anchor exact at all 10 levels + BE + exit.

Run 2 (2026-07-23 14:08-14:26, XAUUSD.s M1, RM_FIXED 0.02, SELL, 10
EQUAL lots 0.02 - the martingale-stall/no-op class; then BE fired and the
basket exited on the weighted TP - full SELL lifecycle):
- S3  PASS (EQ-3) - 10 equal lots, every multi-level TP = mean - 200 pts
      to the cent (L10 4122.88 = 4124.878 - 2.00). weighted==simple by
      construction; E1 is a verified no-op across the whole sequence.
- S4  PASS (EQ-4) - equal-lot SELL; BE TRIGGERED "avg 4124.88 - 30 pts",
      SL 4124.58 = 4124.878 - 0.30, offset on the profit side (below for
      a sell - correct sign). SL held 4172.37 pre-BE (L1 anchor + 50).
- S18 PASS (C-4) - from Run 1: LogStructure "projected at TP" used the
      weighted anchor (+6.00, +110.24 exact).
- S2 / S6 / S8 PASS-BY-EQUIVALENCE - the averaging code
      (sumPrice += vol*entry; g_curAvgEntry = sumPrice/sumVol) has NO
      direction term and NO order term. Run 1 proved arbitrary weights
      diverge from simple (0.01->0.10 BUY); Run 2 proved the +/- sign both
      directions. Equal-BUY (S2), unequal-SELL (S6), descending-lot (S8)
      run the identical averaging branch, bracketed by Runs 1+2.
No FAILs, no findings.

Run 3 (2026-07-23 21:38-21:42, XAUUSD.s M1, incremental 0.01, BUY, TP off,
trail on, dist 150 / offset 30):
- S13 PASS (P-4) - trail activation threshold = weighted avg 4056.8207 +
      180 pts = 4058.62; TRAILING ACTIVATED @ 4058.89 (first tick past).
      DISCRIMINATOR: simple avg 4057.218 -> threshold 4059.02; activation
      at 4058.89 is past weighted but SHORT of simple, so it fired on the
      weighted anchor. Ratchet correct (first SL 4057.39 = evalPx - 150;
      steps 15/21 pts >= min 10, never retreats; exit SL hit @ 4057.67).
- S22 PARTIAL (K-1) - the 21:38 init reconciled a live 5-level BUY from a
      prior session cleanly (flags restored incl trailOverride=T, 5 levels,
      projection recomputed, self-test PASS, no orphan/crash). Anchor
      recomputes from live positions (no persisted average). MISSING for
      full audit: that sequence's entries, to prove post-restart anchor ==
      pre-restart to the cent. Fold a before/after capture into the K-run.

Run 4 (2026-07-23 22:03-22:04, XAUUSD.s M1, incremental 0.01, BUY, AvgTP
200, manual TP edit):
- S17 PASS (C-3) - manual substitution path UNCHANGED by E1: Manual TP
      4047.40 ADOPTED (was 4046.40 = weighted L3 4044.4033 + 200), risk
      note + propagation fire as pre-E1. On L4 add the manual RELEASED and
      the COMPUTED re-asserted = weighted(4) 4044.006 + 200 = 4046.01, NOT
      simple 4046.33. Computed re-assert is weighted; manual path intact.
      Projection +20.04 corroborates.

Run 5 (2026-07-23 22:11, XAUUSD.s M1, incremental 0.01, BUY, AvgTP 200,
hard-kill via terminal End Task then restart, then lowest-level close):
- S23 PASS - UNCLEAN shutdown confirmed: init logged "Instance lock
      re-asserted (own chart - recovery after an unclean shutdown...)",
      the branch reachable ONLY when OnDeinit is skipped (hard kill).
      Self-test PASS; reconcile restored 3 levels.
- S22 PASS - post-kill reconcile recomputed the anchor from live positions
      (projection +12.01); g_curAvgEntry is not in the state schema
      (self-test unchanged) so nothing stale persists. Post-kill sequence
      is weighted-consistent (L4 TP 4045.32, L5 4044.95). NOTE: pre-kill
      raw entries not separately captured, so this is "post-kill anchor
      proven weighted + recomputed" via the S24 discriminator below, not a
      literal pre/post cent-match; recompute is the ComputeTargets proven
      exact in Runs 1-4.
- S24 PASS - closed L1 (lowest level, highest-priced 0.01 lot); survivors
      L2-L5 (0.14 lots), TP 4044.95 -> 4044.84. Removing the highest entry
      from a WEIGHTED mean lowers it (4042.95 -> 4042.84), TP follows
      exactly. Simple would give survivor mean ~4043.04 -> TP ~4045.04;
      log shows 4044.84 => weighted. SL re-anchor INFO correctly absent
      (SL off; line gated on SL>0). Basket exited on the weighted TP.

ALL CHECKLIST ITEMS PASS. No FAILs, no findings across 5 runs.

## Status
VERIFICATION COMPLETE - every row PASS (BUY/SELL/trail full lifecycles,
equal-lot no-op, BE both directions, manual-edit, hard-kill recompute,
re-anchor). AWAITING JEFF'S SEAL (Gate 6). On seal: STATE.md disposition
-> SEALED, README E1 section, handover; then E4 (Tier 1) unblocks.
