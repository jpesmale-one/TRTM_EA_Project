# E1 - Lot-weighted anchor - CODE PLAN (Gate 3, rev 1)
# Base build: Stage9s2-b33 (b732b80fddf75fda / 4296 lines).
# Target build: E1-bNN (label TBC by Jeff).
# Matrix: docs/E1_MATRIX.md (SEALED 2026-07-23, 25 rows).
#
# GOAL: every place the sequence anchor average is COMPUTED switches from
# simple mean sum(entry)/count to lot-weighted sum(lot*entry)/sum(lot).
# One formula, applied at all compute sites; no site left on simple.

## Touch points

# REVISED at build time: TP-1 (a shared LotWeightedAvgEntry helper) was
# drafted then REMOVED before handoff. Both consumers already own a
# position loop, so the helper had no caller = dead code + unused-function
# warning risk at gate zero. Lot-weighting is done IN-LOOP at each site
# (no redundant per-tick pass, as promised at Gate 3). The single-basis
# guarantee (matrix C-1) is enforced by value recompute, not a shared
# call. A shared helper is deferred to E4, which needs the average outside
# these loops. Only TP-2 and TP-3 ship.

### TP-2  ComputeTargets loop - weight the accumulator (S-A, S-B)
WHERE: lines 1073-1091, 1106.
WHAT:
  - line 1073: add `double sumVol = 0.0;` beside sumPrice.
  - loop body (1085): fetch vol = PositionGetDouble(POSITION_VOLUME);
    change `sumPrice += entry;` -> `sumPrice += vol*entry; sumVol += vol;`
    (counted still increments for the count==0 guard.)
  - line 1091: `g_curAvgEntry = (sumVol>0.0) ? sumPrice/sumVol : 0.0;`
    update the comment: "lot-weighted avg (E1); BE/trail/TP reference".
  - line 1106 (avg-TP): `sumPrice/counted` -> `g_curAvgEntry` (already the
    weighted value this pass; removes the inline duplicate math entirely).
  - anchorEntry / minLvl (1080-1084): UNCHANGED - the SL anchor is the
    LOWEST-LEVEL entry, not the average (matrix R-3 / SL path untouched).
  - levelCount==1 TP branch (1096): UNCHANGED - uses anchorEntry, EQ-1.
  - lines 1100-1104 stale comment ("simple average implemented to match
    spec until then"): REPLACE with the E1 decision reference.
WHY: converts the money anchor (BE/trail via g_curAvgEntry) and the
avg-TP in one loop, no second pass.

### TP-3  ComputeProjection loop - weight the display average (S-C)
WHERE: lines 1856-1871.
WHAT: the loop already reads `vol` (1862) and accumulates `lots += vol`.
  - add `double sumWV = 0.0;`
  - in-loop: `sumWV += vol*entry;` (sumPrice/counted retained ONLY if
    still referenced elsewhere - it is not after this change; remove
    sumPrice + counted, use lots as the volume total).
  - line 1870-1871: `avgEntry = (lots>0.0) ? sumWV/lots : 0.0;`
  - update the 1846-1847 comment ("simple avg entry") -> "lot-weighted".
WHY: dashboard avg-entry row + "Proj at TP/SL" now derive from the SAME
weighted anchor as the engine (matrix C-2, the b26/S8-25 drift class).
pTP/pSL per-position math (1867-1868) is UNCHANGED - it is per-leg
(tp-entry)*vol, independent of the average; only the displayed avgEntry
changes.

## UNCHANGED (explicit - named, not assumed)
- Recovery: ComputeLevelLot (1755) + closed-form/normalizer (1773/1801)
  + level spacing (anchor+N*interval) - E1 does not read/write them
  (matrix R-1/R-2/R-3).
- SL anchor: anchorEntry = lowest-level entry (1083, 1110) - NOT the
  average; SL path bit-identical.
- CostCoverPoints (1143): per-position swap/comm/vol sum, average-
  independent - untouched (matrix P-3).
- Manual exit substitution (Stage 8): manualTP/manualSL override paths,
  [MANUAL] tag, adoption/reconcile - untouched; E1 only changes the
  COMPUTED value (matrix C-3).
- State: no persisted field added; g_curAvgEntry is already a per-pass
  non-persisted global (ResetTargets 995 clears it). State schema +
  RunStateSelfTest byte-identical; backward-compat N/A (matrix K-2).
- OnChartEvent / panel button paths / tester poll - untouched.
- BE/trail OFFSET + trigger + ratchet mechanics - only the REFERENCE
  price changes basis; step/distance/activation logic identical.

## Equal-lot no-op guarantee (matrix G-EQ)
When all lot_i equal, sum(lot*entry)/sum(lot) == sum(entry)/count
algebraically. On a stalled martingale band or equal-lot sequence the
output is bit-identical to b33 - the must-NOT rows (EQ-1..EQ-4, R-1/R-2)
are satisfied by construction, verified by recompute.

## Estimated line delta
+8 to +14 lines net (helper ~7-9; TP-2 +2/-1 net; TP-3 +1/-1 net;
comment swaps neutral). One file (src/TRTM.mq5). CRLF/ASCII, brace-
balanced. TRTM_BUILD bump + STATE.md sha256_16/lines recomputed in the
SAME delivery. Compile is gate zero (Jeff's terminal).

## Status
DRAFT rev 1 - NOT CONFIRMED. Awaiting Jeff. No code until confirmed.
