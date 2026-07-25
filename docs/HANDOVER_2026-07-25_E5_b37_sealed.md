# TRTM Handover - 2026-07-25 (E5 Tier 2 SEALED at E5-b37)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md header:
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT 73dda148c79f1b27
   - wc -l src/TRTM.mq5                      EXPECT 4568
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   BOTH repo src AND the MT5 runtime copy are now E5-b37 (73dda148c79f1b27 / 4568) -
   E5-b37 was compiled + deployed this session, so runtime == repo. Report aligned in
   one line, or STOP on a REPO-vs-manifest mismatch.
2. Nothing is mid-pipeline. Read section 3 to pick the next backlog item.

## 2. WHERE THE PROJECT STANDS
- CORE loop SEALED. E1 (lot-weighted anchor) SEALED. E4 (Drawdown Reduction Tier 1,
  point-based basket close) SEALED/CLOSED at E4-b36. E5 (Drawdown Reduction Tier 2,
  percent-of-balance basket close) SEALED/CLOSED at E5-b37 this session. Do NOT re-open
  any of them.
- E5-b37 = E4-b36 + the Tier 2 shared-dispatcher refactor (+85 lines): EvaluateTier1 ->
  FormBasketGroup + FireGroupClose (O5) + EvaluateBasketClose dispatcher (Tier 2
  percent-of-balance FIRST, then Tier 1 points) + 3 inputs + the DS-1 "DD Reduce"
  dashboard row. Tier 2 default OFF, fully DERIVED per tick (no persisted state).

## 3. NEXT SESSION - pick a fresh enhancement-backlog item (open its Gate 1)
No item is in-flight. Remaining backlog (STATE.md "Enhancement backlog"):
- E2  Stage 8 Step 2: draggable EXIT (SL/TP) lines LIVE. Money-path UX. Gate 1 -> matrix
      -> plan. (TRTM-native, NOT reference-derived.)
- E3  Stage 9 Step 3: auto-entry stub (MQL_TESTER-gated). Optimization infra; reuse the
      OFFSET seed held in reserve. (TRTM-native.)
- E6  Drawdown Reduction Tier 3 (partial-lot close). ZERO observed behavior in the Shadow
      runs - needs an E7 R2 reference run FIRST. Reference-derived.
- E7  Reference-EA behavior capture (research task, no gates): R2 (Tier 3 enabled), R5 (BE
      reference, price-favourable + Tier 1 disabled). R3 (buy sequence) de-prioritized.
Open with one question (which item + rec), then Gate 1 sub-decisions one at a time.

## 4. E5 VERIFICATION SUMMARY (sealed; full detail in docs/E5_VERIFY_CHECKLIST.md)
All 34 matrix rows (E5_MATRIX.md SEALED rev 2) recomputed to the cent / confirmed:
- Money paths (XAUUSD.s tester, USD-quote = G-V2 identity): SELL fire x5 + BUY fire x2,
  group P/L = sum POSITION_PROFIT, bar = InpTier2ProfitPercent% x live ACCOUNT_BALANCE
  (balance chain proven, NOT equity). Anchor oldest-transfer, profitables-first/anchor-
  last close, SELL@Ask / BUY@Bid, tick/mid-bar, lot-weighted survivor TP, SL re-anchor
  (BUY x2 + a real broker-SL hit), preserved-index re-arm, dormancy, must-nots, M-1
  whole-basket stand-down (observed), R1/R2/R3 regression, V1/V2/V3 identity.
- Precedence (T2-PR1..PR4): Tier-2-first credit+return + Tier-1 fall-through x4, live-
  recomputed. Both-gates-pass is STRUCTURALLY jump-only (money = margin_pts x SUM(group
  lots), so the two metrics cross the same margin only at a point); the tie-break is
  code-guaranteed (dispatcher checks Tier 2 first).
- K1/K2 restart/kill: LIVE BTCUST demo (symbol-agnostic per the 2026-07-18 seal amendment)
  - unclean-kill lock re-assert + reconcile rebuilt the basket from live positions, no
  orphan Tier 2 state. DS-1 dashboard 4 states: Jeff visual-confirmed.

## 5. GIT / DEPLOY STATE
- E5-b37 COMPILED clean + DEPLOYED (runtime == repo 73dda148c79f1b27 / 4568) + SEALED.
- E5-b37 is UNCOMMITTED (Jeff testing before commit - his call). Working tree carries
  src/TRTM.mq5 + STATE.md + docs/E5_* (MATRIX/PLAN/VERIFY_CHECKLIST/ENHANCEMENT_INPUT/
  this handover + the prior built handover) + CONTINUATION_TEMPLATE.md + the untracked
  reference log "docs/STM Drawdown Reduction Tier2 Logs.txt".
- E4-b36 committed locally, NOT pushed. E1 pushed (origin/main @ 864effe).

## 6. FINDINGS
- F5 (RAISED + ANNOTATED 2026-07-25): the sealed E5_MATRIX WORKED REFERENCE / G-PR
  precedence evidence and the T2-O4 EVIDENCE mis-stated the reference Tier-2-fire margin
  (181.6 pts) via a /0.31 division slip; the value consistent with the logged 31.40 USD
  group P/L is 149.3 pts (< 150), so Tier 1's gate was NOT met at that reference fire - it
  evidences only that Tier 2 fired, NOT precedence. Annotated in E5_MATRIX.md (WORKED
  REFERENCE / G-PR / T2-PR1 / Status), STATE.md T2-O4, and the findings register. Evidence-
  only; the Tier-2-first DECISION is unchanged and is now backed by live PR evidence.
- F3 (Shadow close-deal-as-initial) - guarded by matrix X-5 / T2-PR5 (all E5 closes
  attributed "closed by EA" in liveness; confirmed across every fire). F4 (Shadow BE
  unobserved) - unchanged design note.

## 7. WORKING AGREEMENTS (binding; from CLAUDE.md)
Gate order: locked decisions -> sealed matrix -> confirmed plan -> surgical build ->
evidence-audited verification -> seal on Jeff's explicit word. One question per message.
Terminal is truth; recompute every money number before PASS. STATE.md ships with EVERY
build; bump TRTM_BUILD every delivery. Repo src/TRTM.mq5 is master; MT5 tree is deploy-only
(Jeff's manual step). Money changes need explicit confirmation.
