# TRTM Handover - 2026-07-26 (E6 Tier 3 BUILT at E6-b38, pre-compile)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md header:
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT f7766c859e4d3c7a
   - wc -l src/TRTM.mq5                      EXPECT 4674
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   REPO src is E6-b38 and MUST match the manifest (f7766c859e4d3c7a / 4674).
   The MT5 RUNTIME COPY is EXPECTED TO STILL BE E5-b37 (73dda148c79f1b27 / 4568):
   E6-b38 is built but NOT compiled and NOT deployed. So report "repo aligned at
   E6-b38; runtime lags at E5-b37 (compile+deploy pending)" - this is EXPECTED,
   NOT a STOP. (If the repo src does not match f7766c859e4d3c7a / 4674, THAT is a
   real STOP.)
2. Read section 3. E6 is mid-pipeline at the Gate 3->4 boundary (built, awaiting
   compile then verification), not closed.

## 2. WHERE THE PROJECT STANDS
- CORE + E1 SEALED. E4 (Drawdown Reduction Tier 1, points) SEALED at E4-b36.
  E5 (Drawdown Reduction Tier 2, percent-of-balance) SEALED at E5-b37. Do NOT
  re-open E1/E4/E5.
- E6 (Drawdown Reduction Tier 3 - PARTIAL-LOT anchor slice): Gate 1 LOCKED (all
  ten sub-decisions + Gate A), matrix SEALED (rev 1), plan CONFIRMED, BUILT E6-b38.
  Tier 3 = Tier 1's group close, but the OLDEST anchor contributes only a SLICE
  (ClosePercent of its lots, floored, anchor >= MinLots) to BOTH the close AND the
  gate; profitables close FULLY; the anchor SURVIVES at reduced volume; the gate is
  the SLICED-anchor group VWAP clearing MinProfitPoints (points). Fires in the
  deep-drawdown regime the full-anchor tiers can't. Dispatched LAST (T2->T1->T3).
  - Reference analysis: docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md (E7 R2 run; two
    Tier 3 fires recomputed to the cent).
  - Matrix: docs/E6_MATRIX.md (SEALED rev 1; 13 row-groups, 36 rows).
  - Plan: docs/E6_PLAN_2026-07-26_gate3.md (CONFIRMED; TP-1..TP-8).
  - Locked decisions: STATE.md log - T3-O0 (adopt, default-off InpEnableTier3), O1
    (PositionClosePartial, no MarkEAClosed), O2 (gate on SLICE-vol VWAP), O3
    (MinLots eligibility + sub-MinLots stand-down), O4 (slice=floor, clamped
    partial), O5 (residual survivor, C3+E4 O1, nothing stored), O6 (precedence
    T2->T1->T3 single-fire), O7 (profitables-first/slice-last/abort), O8 (dir-
    derived far side, both laps), O9 (E1 VWAP TP + C3 index), Gate A
    (InpTier3MinTrades=4).
  - New inputs: InpEnableTier3 (false), InpTier3MinTrades (4), InpTier3MinProfitPts
    (200), InpTier3MinLots (0.02), InpTier3ClosePercent (50.0).
- E8 (profit-funded follow-on slice - Jeff's idea) PARKED with its own Gate 1;
  depends on E6 landing. A directional tail-risk lever (realizes loss vs the
  recovery thesis) - see the E8 backlog entry + STATE.md T3-O6 spin-out note.

## 3. NEXT SESSION - E6 at the GATE 3->4 boundary (Jeff: compile + test THERE)
Jeff's call: compile + deploy + live-test all happen NEXT session, not this one.
Order:
1. GATE ZERO (compile) is Jeff's manual step on his terminal, NOT yet done. If
   there are compiler errors/warnings -> fix in src/TRTM.mq5, re-run hygiene
   (CRLF/ASCII/brace), re-bump the manifest sha/lines. Money paths unchanged unless
   a fix touches them (then recompute). 0/0 expected.
2. Draft docs/E6_VERIFY_CHECKLIST.md from the sealed matrix (mirror
   docs/E5_VERIFY_CHECKLIST.md) and recompute EVERY money number to the cent.
   Coverage (from the plan's VERIFICATION MAP), LIVE XAUUSD.s (points symbol-
   relative; NO cross-currency leg):
   - T3-1 SELL + T3-2 BUY fire: recompute slice, sliced-VWAP, margin to the cent.
   - T3-6 gate-on-SLICE: construct a >2-unit anchor (e.g. 0.03) so slice (0.01) !=
     full; prove the gate uses the slice vol (full-anchor margin would FAIL).
   - T3-SL4 sub-MinLots STAND-DOWN (anchor at 1 unit -> no Tier 3 fire); T3-SL5
     FLOOR (0.03 -> 0.01; round-up would not clear).
   - T3-H3 SL BYTE-IDENTICAL across a slice (the anchor keeps its level, so the
     re-anchor branch never runs); T3-P1 survivor TP incl. the reduced anchor.
   - T3-PR2/PR3 CONSTRUCTED both-qualify ticks (tune thresholds so T1+T3 / T2+T3
     both pass) -> the FULL tier fires, Tier 3 SKIPPED (UNOBSERVED in the run).
   - T3-X1/X3 order + abort; T3-D1/D2 dormancy; T3-M1 whole-basket stand-down;
     T3-G2 invariant; T3-K1/K2 restart + kill mid-fire with a sliced anchor.
   - T3-R1 (off -> byte-identical E5-b37), T3-R2 (on/never-fires -> T1/T2/recovery
     unchanged), T3-R3 (no new persisted field -> self-test byte-identical).
   - DS-1 dashboard: T1/T2/T3 combinations render; row does not disturb the grid.
3. Jeff deploys the compiled build (his step); Gate 4 evidence-audited run.
4. Seal on Jeff's explicit word only -> manifest flips E6-b38 to deployed/sealed.

## 4. CODE DELIVERED THIS SESSION (E6-b38, +106 lines vs E5-b37, 4568->4674)
EXTENDS E5-b37's shared dispatcher (no restructure). 8 touch points:
- InpEnableTier3 + 4 Tier 3 inputs (after the Tier 2 group).
- ComputeSlicedAnchorVWAP() - sibling of ComputeWeightedVWAP; anchor counted at
  its SLICE volume (the gate crux, T3-6). Sealed VWAP untouched.
- SliceLegAtMarket() - sibling of CloseLegAtMarket using PositionClosePartial;
  CRITICALLY does NOT MarkEAClosed (the anchor survives; a stale flag would
  misattribute a later broker TP/SL close of the full anchor).
- FireGroupClose() gains a trailing anchorSliceVol=0.0 param; when >0 the anchor-
  LAST leg slices, else full-closes. Default 0.0 -> T1/T2 call sites unchanged =>
  behavior-identical to E5-b37 (T3-R2). Profitables-first loop untouched.
- EvaluateBasketClose() gains t3on/t3elig (Gate A) + a Tier 3 branch AFTER Tier 1
  (T2->T1->T3, T3-O6): anchor eligibility (>= MinLots and >= 2 units), slice sizing
  (floor to unit, clamp [unit, anchorVol-unit], NormalizeDouble .,8 matching
  ComputeLevelLot), sliced-VWAP gate vs direction-derived far price, fire.
- Dashboard "DD Reduce" row extended to a third tier (display-only); T1/T2/off
  states render IDENTICALLY to E5-b37.
- TRTM_BUILD -> E6-b38; OnTick call-site comment updated.
THREE zero-code findings (verify-only, documented in the plan): F-a SL not re-
anchored is FREE (re-anchor keyed on anchor LEVEL, unchanged by a slice); F-b
survivor TP self-corrects (ComputeTargets reads live volume); F-c F3 impossible
(OnTradeTransaction is EMPTY - attribution poll-based; CheckSequenceLiveness
retains the surviving partial anchor). NO new global, NO new persisted field
(self-test unaffected, T3-R3). Hygiene: CRLF clean (CR=LF=4674), ASCII-only,
brace delta -1 (pre-existing baseline), parens balanced.

## 5. GIT / DEPLOY STATE
- E6-b38 is UNCOMMITTED (Jeff tests before commit - his call). Working tree adds
  src/TRTM.mq5 + STATE.md + docs/E6_MATRIX.md + docs/E6_PLAN_2026-07-26_gate3.md +
  docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md + this handover + the untracked
  reference log "docs/STM Drawdown Reduction Tier3 Logs.txt".
- E5-b37 committed locally (d094c65), NOT pushed. E4-b36 committed, not pushed.
  E1 pushed (origin/main @ 864effe). So local main is ahead of origin by 3
  (E4 docs -> E4-b36 seal -> E5-b37 seal), with E6-b38 uncommitted on top.
- MT5 tree: still E5-b37 (E6-b38 not compiled/deployed). Deploy is Jeff's step.

## 6. FINDINGS
- No new defects. F3 (Shadow close-deal-as-initial) recurs in the Tier 3 log
  (close deals #17/#18/#19, #32/#33/#34 "count 0") - IMPOSSIBLE in TRTM
  (OnTradeTransaction empty; poll-based attribution). F4 (Shadow BE unobserved) -
  unchanged design note. F5 (E5 sealed-matrix precedence arithmetic) - resolved
  evidence-only 2026-07-25, decision unchanged.
- T3-O6 both-qualify precedence (T1+T3 / T2+T3) is UNOBSERVED in the reference
  (the tiers never competed - Tier 3 fired only when the full tiers failed). It is
  built per decision (dispatcher order) and MUST be verified LIVE via constructed
  ticks (checklist rows T3-PR2/PR3).

## 7. WORKING AGREEMENTS (binding; from CLAUDE.md)
Gate order: locked decisions -> sealed matrix -> confirmed plan -> surgical build
-> evidence-audited verification -> seal on Jeff's explicit word. One question per
message. Terminal is truth; recompute every money number before PASS. STATE.md
ships with EVERY build; bump TRTM_BUILD every delivery. Repo src/TRTM.mq5 is master;
MT5 tree is deploy-only (Jeff's manual step). Money changes need explicit confirmation.
