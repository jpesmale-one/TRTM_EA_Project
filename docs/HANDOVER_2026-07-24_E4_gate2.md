# TRTM Handover - 2026-07-24 (E4 Gate 1 locked + Gate 2 matrix SEALED).
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are
# truth. Disk + git override conversation/auto-memory.
# NO build this session - docs only. src/TRTM.mq5 UNCHANGED at E1-b34.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md:
   - git status (see section 6 - STATE.md + two new docs may be uncommitted)
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT aef5dc989609dc45
   - wc -l src/TRTM.mq5                      EXPECT 4307
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   All four match = say "aligned" in one line. (Build did NOT change this
   session - E4 is still pre-code.)
2. Read section 3. Do not re-plan sealed work or re-open locked decisions.

## 2. WHERE THE PROJECT STANDS
- CORE COMPLETE (sealed). E1 (lot-weighted anchor) SEALED E1-b34 2026-07-23,
  and PUSHED to origin this session (origin/main @ 864effe includes 77cfca6).
- E4 (Drawdown Reduction Tier 1) advanced two gates this session, NO code:
  - GATE 1 (locked decisions) COMPLETE. O1-O5 all locked in STATE.md's
    locked-decisions log (+ the pre-existing CHOSEN C1-C4). Summary:
    O1 unrestricted refill (only higher rungs re-arm, anchor never; C3
       derived-only, no re-arm-travel, no per-rung state).
    O2 flat MinProfitPoints (scaling parked); TWO-GATE trigger (Gate A count
       >= MinTrades new input / Gate B group combined >= threshold); HARD
       INVARIANT group never closes at combined loss; dormancy below MinTrades.
    O3 no post-fire suppression (bar-close gating + atomic state refresh).
    O4 direction-derived far price (SELL->Ask, BUY->Bid), basis = platform
       invariant (buy closes at Bid); E7 R3 de-prioritized as a result.
    O5 profitables-first / anchor-last + bounded retry + abort-anchor on any
       profitable-leg failure (inverts Shadow's fragile anchor-first).
  - GATE 2 (money-path matrix) SEALED. docs/E4_MATRIX.md rev 1, 36 rows,
    11 groups (G-T trigger, G-A anchor, G-G group+invariant, G-H auto-heal,
    G-O re-arm, G-D dormancy, G-X execution, G-P post-fire recompute, G-C E1
    consistency, G-R recovery must-not, G-K restart/kill). Sealed by Jeff
    2026-07-24.

## 3. NEXT SESSION - resume at E4 GATE 3 (confirmed code plan)
- The matrix is sealed - DO NOT re-plan sealed rows. Produce the surgical
  code plan: touch points, insertion order, and how each maps to a matrix row.
- Expect the plan to be SMALL. Grounded reads this session:
  * REUSE CloseSequenceAtMarket for the group close (O5) - no new close path.
  * The re-arm math is ALREADY address-based: ComputeRecoveryTrigger
    (TRTM.mq5:1919-1924) sets nextLvl = max(surviving levels)+1, monotonic,
    non-reused; the liveness sweep preserves per-ticket levels[]; ComputeLevelLot
    derives lot from the level number. So C3 needs little/no change to the
    closed-form - H-2 is a CONFIRM row, not a rewrite.
  * THE ONE REAL RISK = H-6 SL RE-ANCHOR. Tier 1's anchor (C1 oldest = lowest
    level) is the position the basket SL hangs on; closing it must re-anchor the
    SL to the new lowest survivor (g_curAnchorLvl handler ~1499). This is the
    only E4 path reaching sealed SL behavior - plan it with care, BUY+SELL laps.
  * New Tier 1 evaluation is TICK-based (T-5), distinct from InpBarCloseEntry
    which gates recovery ENTRIES only.
- Input surface to add (plan finalizes): InpEnableTier1 (bool, default false),
  InpTier1MinTrades (int, default 4), InpTier1MinProfitPts (int). The GOLD
  default for InpTier1MinProfitPts is the open PLAN-TIME value (Shadow's 150
  was GBPAUD 5-digit; XAUUSD.s _Point 0.01 -> 150 pts = $1.50 move) - O2 rider.
- Other queued (unchanged): E2 draggable exit lines; E3 auto-entry; E5/E6 need
  E7 R1/R2 reference runs; E7 is research not a build.

## 4. FINDINGS
- F3 (Shadow close-deals-as-initial defect, count 0) - RE-CONFIRMED in the
  run B fire log Jeff pasted this session; guardrail is matrix row X-5.
- F4 (Shadow BE unobserved) - still a design note, unchanged.
- F1/F2 resolved earlier. No new findings this session.

## 5. EMPIRICAL / EVIDENCE NOTES (terminal is truth)
- Run B fire 1 (14:57:40) re-verified against the raw log Jeff pasted: group
  #2 0.01@1.88135 (anchor) + #11 0.10@1.91309 + #10 0.09@1.90975, close Ask
  1.90848, VWAP 1.910008, margin 152.0 pts, Shadow closed ANCHOR FIRST then
  #11/#10 (TRTM inverts this, O5). Confirms O4 SELL->Ask and the O5 gap
  (no failure branch exists in Shadow's logs).
- BUY-side close-at-Bid is a PLATFORM invariant already exercised by TRTM's
  sealed TP/manual-exit paths - no Shadow buy fire needed (O4 basis).

## 6. TODO for Jeff / git state
- origin/main @ 864effe (E1 pushed). Local main is AHEAD only by uncommitted
  working changes: STATE.md (Gate 1 locked decisions), docs/E4_MATRIX.md (new,
  sealed), docs/HANDOVER_2026-07-24_E4_gate2.md (new, this file). Decide
  whether to commit these before next session so the resume git-status is
  clean. Nothing is auto-committed.
- MT5 tree UNTOUCHED (no build). Repo src still master = MT5 copy at b34.

## 7. WORKING AGREEMENTS (binding; from CLAUDE.md)
Gate order: locked decisions -> sealed matrix -> confirmed plan -> surgical
build -> evidence-audited verification -> seal on Jeff's explicit word. One
question per message. Terminal is truth; recompute every money number before
PASS. STATE.md ships with EVERY build; bump TRTM_BUILD every delivery. Repo
src/TRTM.mq5 is master; MT5 tree is deploy-only (Jeff's manual step). Money
changes need explicit confirmation. Chat concise; traces go in artifact files.
