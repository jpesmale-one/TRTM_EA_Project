# E1 - Lot-weighted anchor - SCENARIO MATRIX (rev 1)
# Base build: Stage9s2-b33 (b732b80fddf75fda / 4296 lines).
# Target build: E1-bNN (label TBC by Jeff).
#
# SCOPE: replace the SIMPLE-average sequence anchor (mean of open entry
# prices) with the LOT-WEIGHTED average sum(lot_i*entry_i)/sum(lot_i) at
# EVERY site that computes it. Sites (grep of sumPrice/counted +
# g_curAvgEntry, TRTM.mq5 b33):
#   S-A  g_curAvgEntry global      line 1091  -> BE stop (1183), BE trigger
#        (1208), trail activation (1191), trail trigger (1253)
#   S-B  TP inline sumPrice/counted line 1106 -> avg-TP (levelCount>1 only)
#   S-C  ComputeProjection          line 1871 -> dashboard "Proj at TP/SL"
#        (3338) + displayed avg-entry row
# All three computations become lot-weighted. Recovery is NOT touched:
# ComputeLevelLot (1755, sealed closed-form) and level spacing (anchor +
# N*interval, does not read the average) are UNCHANGED.
#
# LOCKED DECISIONS (Gate 1, 2026-07-23 - see STATE.md locked-decisions):
#  G1  Basis = LOT-WEIGHTED average of open entries, ALL sites (Option A).
#      Rejected B (TP-only) + C (keep simple).
#  G2  Applies to avg-TP, BE stop+trigger, trail activation+trigger, AND
#      the dashboard projection/avg-entry (scope correction: display must
#      not drift from engine, b26/S8-25 class).
#  G3  Recovery untouched (lot sizing + spacing byte-identical).
#  G4  E4 (Tier 1) remains BLOCKED until E1 lands - E4 must not land first.
#
# STATE ADDED: none persisted. g_curAvgEntry is already a non-persisted
# per-pass global; only its FORMULA changes. No new struct field => MQL5
# uninit-field trap N/A, state self-test / backward-compat UNCHANGED.
#
# ARITHMETIC BASIS (audited to the cent in every evidence row):
#   simple   = sum(entry_i) / count
#   weighted = sum(lot_i * entry_i) / sum(lot_i)
#   They are EQUAL iff all lot_i are equal. The sealed closed-form stall
#   (base 0.01 / mult 1.5 -> L3-L6 all 0.02) makes many bands equal-lot,
#   where weighted == simple and E1 is a no-op by construction. Evidence
#   rows that only exercise a stalled band PROVE NOTHING - see G-U group.
#
# WORKED REFERENCE (from Gate 1, live 0.02/0.02/0.03 BUY,
# entries 4018.20/4018.30/4018.53):
#   simple   = 12055.03 / 3      = 4018.3433
#   weighted = 281.28671 / 0.07  = 4018.3843   (+4.1 pts, anchor higher)
#   avg-TP(+300): 4021.3433 -> 4021.3843 ; BE(+30): 4018.6433 -> 4018.6843
#   Later/larger lot pulls a BUY anchor UP => TP/BE/trail all further away.

## Group G-EQ - Equal-lot MUST-NOT (E1 is a no-op here; proves no regression)
EQ-1  Single level (levelCount==1)                                  -> anchor path unused (TP uses anchorEntry at 1096, not the avg branch). MUST-NOT: any value change vs b33. Weighted N/A at count 1.
EQ-2  2 equal lots 0.02/0.02 BUY, entries E1/E2                     -> weighted == simple == (E1+E2)/2 EXACTLY. TP/BE/trail prices BIT-IDENTICAL to b33. Recompute both formulas, show equality.
EQ-3  Stalled martingale band, e.g. L3-L6 all 0.02 (base .01/mult 1.5) -> every level equal lot => weighted==simple at each level. MUST-NOT: any TP/BE/trail/projection delta vs b33 across the whole stalled run.
EQ-4  Equal-lot SELL lap (mirror of EQ-2)                           -> direction-signed anchor unchanged; weighted==simple; SELL TP/BE/trail bit-identical to b33.

## Group G-U - Unequal-lot (the actual E1 change; weighted != simple)
U-1   3 levels 0.02/0.02/0.03 BUY (the reference sequence)          -> anchor = weighted 4018.3843 not simple 4018.3433. avg-TP = 4021.3843, BE stop = 4018.6843, trail activation = weighted + offset + dist. Every number recomputed to the cent, weighted basis confirmed in the log.
U-2   SAME sequence, SELL direction (unequal lots)                  -> anchor pulled the OTHER way (larger late lot pulls SELL anchor DOWN); TP/BE/trail all shift by the direction-signed delta. Sign proven, not assumed (O4-class: no fixed-side read).
U-3   Ascending lots where a curve STEP occurs (e.g. 0.02/0.03/0.05) -> weighted diverges from simple by MORE than U-1; recompute; confirm the step (not a stall) is where the two bases separate.
U-4   Descending / mixed lots (e.g. 0.05/0.02/0.02 by tier)         -> weighted pulled toward the EARLY large lot (BUY anchor lower than simple, opposite of U-1). Proves the formula is lot-driven, not order-driven. Recompute.
U-5   Unequal lots via RM_MANUAL multiplier list (not martingale)   -> weighted correct for arbitrary lot ratios; not tied to the closed-form curve. One recomputed sequence.

## Group G-P - Path coverage (each anchor consumer, on an UNEQUAL sequence)
P-1   avg-TP (S-B, line 1106), levelCount>1 unequal                 -> TP = weighted + dir*InpAvgTPPts. Value logged = weighted basis. (levelCount==1 still uses anchorEntry, EQ-1.)
P-2   BE trigger (S-A, line 1208), unequal sequence                 -> BE arms when profitPx crosses weighted+trigger (LATER than simple for U-1's higher anchor). Arm price recomputed; log names the weighted ref.
P-3   BE stop price (S-A, BEStopPrice 1183), unequal                -> floor = weighted + offset [+ cost cover]. CostCoverPoints UNCHANGED (it already sums real per-position vol/swap/comm, independent of the average). Recompute floor.
P-4   Trail activation (S-A, 1191) + ratchet, unequal               -> activation = weighted + offset + dist; ratchet steps unchanged. Activation price recomputed on weighted.
P-5   Dashboard "Proj at TP/SL" + avg-entry row (S-C, 1871/3338)    -> displayed avg-entry = weighted; projection pTP/pSL computed against the weighted-derived tp/sl. MUST match the engine's TP/BE exactly (no b26 drift).

## Group G-C - Consistency / display-vs-engine (b26/S8-25 class)
C-1   MUST-NOT: any site still on simple average after E1            -> grep confirms NO surviving sumPrice/counted (unweighted) among S-A/S-B/S-C. All three read ONE lot-weighted computation (shared helper); no fourth copy re-introduced.
C-2   MUST-NOT: dashboard projects a DIFFERENT average than the engine places. Displayed avg-entry, Proj at TP/SL, and the actual placed TP/BE all derive from the SAME weighted value in the same pass. (The exact defect b26 fixed for manual values, now for the basis.)
C-3   Manual TP/SL owned (Stage 8) + unequal lots                    -> manual substitution UNCHANGED; when computed is shown it is the weighted computed; [MANUAL] tag logic byte-identical. Weighted only affects the COMPUTED value, never the manual override path.
C-4   LogStructure projection (1876) on an unequal sequence          -> "projected at TP/SL" line uses the weighted anchor via ComputeProjection; matches the dashboard and the engine. One recomputed structure line.

## Group G-R - Recovery MUST-NOT (E1 must not touch the ladder)
R-1   MUST-NOT: ComputeLevelLot (1755) output bit-identical to b33   -> every level's lot on the same inputs unchanged. E1 does not read or write the lot path. grep-confirm untouched.
R-2   MUST-NOT: level SPACING (next-level trigger price) unchanged   -> recovery entries land at the same prices as b33 (spacing uses anchor+N*interval, not the average). Unequal sequence, compare entry prices.
R-3   MUST-NOT: base lot / g_state.baseLot semantics unchanged; L1-closes-survives behavior intact.

## Group G-K - Restart / kill / re-init (stateful safety spine)
K-1   RESTART (recompile / re-attach) mid unequal sequence          -> on re-init the anchor RECOMPUTES from live positions as weighted (it is a per-pass global, ResetTargets 995 clears it). No persisted average to go stale. Verify post-restart TP/BE == pre-restart weighted.
K-2   KILL (hard, OnDeinit skipped) mid sequence, restart           -> state file schema UNCHANGED (no new key); RunStateSelfTest byte-identical; positions re-read, weighted anchor rebuilt. No orphan simple-avg value anywhere.
K-3   Anchor-level change (g_curAnchorLvl shift, line 1499) unequal  -> the anchor-level-change SL re-anchor INFO (1499-1502) still fires on level change; now reports the weighted-derived SL. Behavior unchanged, value weighted.

## Out of scope
E4 Tier 1 basket close (separate feature, BLOCKED on E1). E2 draggable
exit lines. E3 auto-entry. CostCoverPoints internal math (unchanged).
Recovery lot/spacing (G-R proves untouched).

## Status
SEALED by Jeff 2026-07-23. rev 1. 25 rows, 6 groups.
Must-NOT rows: EQ-1, EQ-2, EQ-3, EQ-4, C-1, C-2, R-1, R-2, R-3.
Unequal-lot (mandatory per Gate 1): U-1..U-5, all of G-P, C-2/C-4.
Restart/kill: K-1, K-2. BUY + SELL laps: EQ-2/EQ-4, U-1/U-2.
Code plan (Gate 3) next. Live findings later become new M-rows.
