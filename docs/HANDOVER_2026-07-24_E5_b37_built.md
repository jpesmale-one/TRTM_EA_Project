# TRTM Handover - 2026-07-24 (E5 Tier 2 BUILT at E5-b37, pre-compile)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md header:
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT 73dda148c79f1b27
   - wc -l src/TRTM.mq5                      EXPECT 4568
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   REPO src is E5-b37 and MUST match the manifest (73dda148c79f1b27 / 4568).
   The MT5 RUNTIME COPY is EXPECTED TO STILL BE E4-b36 (7e14479c83d672a4 / 4483):
   E5-b37 is built but NOT compiled and NOT deployed. So report "repo aligned;
   runtime lags at E4-b36 (deploy pending)" - this is EXPECTED, not a STOP.
   (If the repo src does not match 73dda148c79f1b27 / 4568, THAT is a real STOP.)
2. Read section 3. E5 is mid-pipeline at Gate 4 (verification), not closed.

## 2. WHERE THE PROJECT STANDS
- CORE + E1 (lot-weighted anchor) SEALED. E4 (Drawdown Reduction Tier 1) SEALED
  and CLOSED at E4-b36. Do NOT re-open E4.
- E5 (Drawdown Reduction Tier 2 - percent-of-balance basket close): Gate 1 LOCKED,
  matrix SEALED (rev 2), plan CONFIRMED, BUILT E5-b37. Tier 2 = Tier 1's close
  machinery fired by a MONEY test (close-group P/L >= InpTier2ProfitPercent% of
  account BALANCE) instead of per-lot points, evaluated Tier-2-FIRST then Tier 1.
  - Reference analysis: docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md (E7 R1 run).
  - Matrix: docs/E5_MATRIX.md (SEALED rev 2; 13 groups, 31 rows incl. G-DS/DS-1).
  - Plan: docs/E5_PLAN_2026-07-24_gate3.md (CONFIRMED; TP-1..TP-7).
  - Locked decisions: STATE.md log - T2-O0 (separate default-off tier,
    InpEnableTier2), T2-O1 (base=BALANCE), T2-O2 (measured=close-GROUP P/L),
    T2-O4 (precedence Tier2-first/fall-through, shared group, 1 fire/tick, M-1
    both), Gate A (InpTier2MinTrades=4 + count dormancy), T2-O5/O6 (inherit E4
    close order + far-side), T2-O3 (default 1.0%), T2-O7 (sum POSITION_PROFIT,
    price-only).
  - New inputs: InpEnableTier2 (false), InpTier2MinTrades (4),
    InpTier2ProfitPercent (1.0).

## 3. NEXT SESSION - E5 is at GATE 4 (verification), pending Jeff's compile FIRST
GATE ZERO (compile) is Jeff's manual step on his terminal and is NOT yet done.
Order for the next session:
1. If Jeff has compiler errors -> fix in src/TRTM.mq5, re-run hygiene (CRLF/ASCII/
   brace), re-bump the manifest sha/lines. Money paths unchanged unless a fix
   touches them (then recompute).
2. Once it compiles clean (0/0), Jeff deploys to the MT5 tree (his step); then
   Gate 4 evidence-audited verification on a LIVE XAUUSD.s run.
3. Build the E5 verification checklist (mirror docs/E4_VERIFY_CHECKLIST.md) and
   recompute EVERY money number to the cent. Coverage (from the plan's map):
   - T2-1 SELL + T2-2 BUY fire (group P/L >= %-bar; XAUUSD.s is USD-quote so
     G-V2 conversion is identity - recompute the money path minus the FX leg).
   - T2-PR1/PR2/PR3/PR4 precedence + fall-through: construct a tick where BOTH
     gates pass (tune InpTier1MinProfitPts / InpTier2ProfitPercent) and confirm
     Tier 2 is credited, one fire, identical group.
   - T2-3/T2-4/T2-6/T2-7 must-not; T2-D1/D2 dormancy (own MinTrades); T2-X1/X2/X3
     execution order + abort; T2-H1/H2/H3 re-arm/atomic/SL re-anchor; T2-M1
     whole-basket stand-down; T2-P1/P2 post-fire recompute; T2-K1/K2 restart/kill.
   - T2-R1 (Tier 2 off -> behavior == E4-b36), T2-R2 (Tier 2 on, never fires ->
     Tier 1 + recovery == E4-b36), T2-R3 (no new persisted field -> self-test
     byte-identical).
   - DS-1 dashboard: verify all four states (none/T1/T2/both) render and the row
     does not disturb the LIVE SEQUENCE rows or the button grid.
4. Seal on Jeff's explicit word only.

## 4. CODE DELIVERED THIS SESSION (E5-b37, +85 lines vs b36)
Single-path refactor of the sealed EvaluateTier1 into shared helpers +
dispatcher (Jeff chose shared-dispatcher over a Tier 2 clone):
- FormBasketGroup() - the ONE scan + anchor + group build (side-effect-free).
- FireGroupClose(...tierTag) - the O5 fire (profitables-first/anchor-last/abort),
  reused by BOTH tiers via the sealed CloseLegAtMarket - O5 in one place.
- EvaluateBasketClose() - dispatcher: shared guards/group/M-1, then Tier 2 Gate B
  (sum POSITION_PROFIT >= pct% x balance) FIRST, else Tier 1 Gate B (VWAP margin).
- OnTick call site -> EvaluateBasketClose().
- Dashboard "DD Reduce" CONFIG row (DS-1, display-only).
- TRTM_BUILD -> E5-b37; two stale EvaluateTier1 comment refs updated.
Behavior-preservation: with Tier 2 OFF the Tier-1-only path is behavior-identical
to E4-b36 (same test order + same fire); only cosmetic change is the M-1 stand-
down log wording (now tier-agnostic "Basket close stands down"). Hygiene: CRLF
clean (CR=LF=4568), ASCII-only, brace delta -1 (pre-existing baseline).

## 5. GIT / DEPLOY STATE
- E5-b37 is UNCOMMITTED (Jeff testing before commit - his call). Working tree has
  src/TRTM.mq5 + STATE.md + docs/E5_* + docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md
  + docs/HANDOVER_2026-07-24_E5_b37_built.md + the untracked reference log
  "docs/STM Drawdown Reduction Tier2 Logs.txt".
- E4-b36 committed locally, NOT pushed. E1 pushed (origin/main @ 864effe).
- MT5 tree: still E4-b36 (E5-b37 not deployed). Deploy is Jeff's manual step.

## 6. FINDINGS
- No new findings. F3 (Shadow close-deal-as-initial) recurs in the Tier 2 log
  (close deals #23/#24/#25 "count 0") - already guarded by matrix X-5 / T2-PR5.
- F4 (Shadow BE unobserved) - unchanged design note.
- T2-O7 note (not a defect): Shadow's swap handling is undeterminable from the log
  (the "Basket P/L" back-solves the FX rate); TRTM chose price-only POSITION_PROFIT
  on Tier-1-consistency grounds.

## 7. WORKING AGREEMENTS (binding; from CLAUDE.md)
Gate order: locked decisions -> sealed matrix -> confirmed plan -> surgical build
-> evidence-audited verification -> seal on Jeff's explicit word. One question per
message. Terminal is truth; recompute every money number before PASS. STATE.md
ships with EVERY build; bump TRTM_BUILD every delivery. Repo src/TRTM.mq5 is master;
MT5 tree is deploy-only (Jeff's manual step). Money changes need explicit confirmation.
