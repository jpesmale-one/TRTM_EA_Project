# TRTM Handover - 2026-07-24 (E4 SEALED at E4-b36)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md header:
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT 7e14479c83d672a4
   - wc -l src/TRTM.mq5                      EXPECT 4483
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0) - EXPECT the same
   All match = say "aligned" in one line. (Verified aligned at seal 2026-07-24.)
2. Read section 3. E4 is CLOSED - do not re-open it; pick the next backlog item.

## 2. WHERE THE PROJECT STANDS
- CORE COMPLETE (sealed). E1 (lot-weighted anchor) SEALED E1-b34, pushed to
  origin/main.
- E4 (Drawdown Reduction Tier 1) SEALED at E4-b36 (2026-07-24). Point-based basket
  close: when the basket is deep (Gate A count >= MinTrades) and the oldest anchor
  plus every currently-profitable position clears MinProfitPoints/lot (Gate B),
  close that group - profitables first, anchor last, abort-anchor on any
  profitable-leg failure. M-1 guard: stands down when the group is the WHOLE basket
  (no underwater survivor) so it never pre-empts the sequence's own AvgTP.
  - Matrix docs/E4_MATRIX.md rev 2 SEALED (37 rows incl. G-M/M-1).
  - Plan docs/E4_PLAN_2026-07-24_gate3.md; full evidence docs/E4_VERIFY_CHECKLIST.md.
  - Inputs added: InpEnableTier1 (false), InpTier1MinTrades (4), InpTier1MinProfitPts
    (150, forex-native default; gold users scale up ~10x - a gold test needs
    interval/threshold ~10x wider, see the checklist).

## 3. NEXT SESSION - E4 is done; pick the next backlog item
Queued (unchanged, none started): E2 draggable exit lines; E3 auto-entry; E5/E6
(Tier 2 percent / Tier 3 partial-lot) need E7 R1/R2 reference runs first; E7 is
research not a build. Each new item starts at Gate 1 (locked decisions), one
sub-decision at a time, most foundational first.

## 4. VERIFICATION SUMMARY (E4-b36, all recomputed to the cent)
Fire path BOTH directions (SELL GBPAUD.s, BUY XAUUSD.s), re-arm (H-2 address-based,
H-4 anchor-never, O-1/O-2), dormancy D-1 (observed), H-6 SL re-anchor (SELL x4
exact; BUY reasoning + direction-signed), X-2/X-3 abort (code reasoning), K-1/K-2/K-3
restart (LIVE demo kill+reconcile), C-1/C-2/H-1, P1 no-fire byte-identity, M-1
whole-basket stand-down (observed - sequence AvgTP banked +2500 vs Tier1 +500;
validated decision (A) over (B) on the anchor-sole-loser case), gate zero b36.

## 5. FINDINGS
- F3 (Shadow close-deals-as-initial defect) - guardrail = matrix X-5, VERIFIED
  (all EA closes attributed via MarkEAClosed/liveness in every run). Closed.
- F4 (Shadow BE unobserved) - design note, unchanged.
- New M-1 (live finding 2026-07-24): whole-basket fire pre-empted the sequence
  AvgTP -> guard added + verified. Closed.

## 6. GIT / DEPLOY STATE
- E4-b36 committed locally this session (src + E4 docs + tester evidence). Local
  main ahead of origin (E4 not pushed - Jeff decides when to push).
- MT5 tree: b36 DEPLOYED and aligned (src == runtime == manifest at seal).

## 7. WORKING AGREEMENTS (binding; from CLAUDE.md)
Gate order: locked decisions -> sealed matrix -> confirmed plan -> surgical build
-> evidence-audited verification -> seal on Jeff's explicit word. One question per
message. Terminal is truth; recompute every money number before PASS. STATE.md
ships with EVERY build; bump TRTM_BUILD every delivery. Repo src/TRTM.mq5 is master;
MT5 tree is deploy-only (Jeff's manual step). Money changes need explicit confirmation.
