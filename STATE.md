# TRTM SYNC MANIFEST - update with EVERY build delivery
# Resume protocol (repo-based; see CLAUDE.md section 0). First action on
# resume: git status + sha256_16 + wc -l of src/TRTM.mq5 AND the MT5
# runtime copy, all compared to this manifest. Match = aligned in one
# line. Disk + git are truth, never conversation or auto memory.

build: b40
file: TRTM.mq5
sha256_16: 2e902e9032d820a9
lines: 4974
date: 2026-07-30
# b40 - DOCUMENTATION-ONLY BUILD, 2026-07-30. NOT a behaviour change.
#   REPO src    = b40 (2e902e9032d820a9 / 4974)  <- this manifest tracks REPO.
#   MT5 runtime = b40 (2e902e9032d820a9 / 4974) - DEPLOYED + RECOMPILED by Jeff
#     2026-07-30, verified byte-identical to repo. EA re-initialized "=== TRTM b40
#     init ===" on XAUUSD.s (magic 715358), self-test PASS, Reconcile FLAT, stops
#     level 100 pts. Repo and runtime ALIGNED - the resume protocol should say so.
# WHY: the file header still claimed Stage 5 "[>] in progress" and Stages 6/7 "[ ]"
#   unbuilt - both sealed weeks ago - and four other comment blocks asserted states that
#   had since become false. A comment that lies is worse than no comment: the next cold
#   start reads it as truth.
# PROVEN COMMENT-ONLY: `git diff -U0` filtered to non-comment lines shows EXACTLY ONE
#   changed line on each side - "#define TRTM_BUILD b39" -> "b40". Nothing else
#   executable was added or removed. b40 is BEHAVIOURALLY IDENTICAL to b39, so every
#   b39 Gate 4 evidence row carries forward UNCHANGED and needs no re-run.
# SIX FIXES:
#   1. File header - stage status was 3 builds stale. Now lists Stages 1-10 sealed,
#      E1/E4/E5/E6/b39 sealed (with b39's caveat named), backlog, and a note that the
#      "Stage N (bNN)" / "E4 C-1" / "matrix W-3" markers are the AUDIT TRAIL, not noise.
#   2. NormalizeSymbol - "Stage 2 WILL reuse this" (it shipped). Now also records the
#      E9-P2 consumer and the W-7 evidence: XAUUSD.s -> XAUUSDS (715358) vs XAUUSD+ ->
#      XAUUSD (758105), so Jeff's two accounts CANNOT collide.
#   3. StateSave/Load header - "later stages" (they are done). Now states the b2 flat-
#      marker rule instead.
#   4. Exit-engine header - said avg-entry TP and SL re-anchoring were "DORMANT until
#      Stage 4" and that ALL manual edits are reverted. Both false since Stage 4/Stage 8:
#      every exit path is live, and b24-b28 CLASSIFY non-zero manual edits (adopt or
#      refuse) rather than blanket-revert. Also records E1's lot-weighted VWAP basis.
#   5/6. Two comments written during b39 cited LINE NUMBERS that b39's own edits then
#      shifted (ComputeRecoveryTrigger "2009-2011", Reconcile's baseLot WARN "2766+").
#      Replaced with function-name references - line numbers rot on every build.
# GATE ZERO: PASSED 2026-07-30 - 0 errors, 0 warnings, 2214 ms, cpu='X64 Regular'.
# HYGIENE: 0 bare LF, ASCII-only, brace/paren/bracket deltas all 0.
# DELTA: +35 lines (4939 -> 4974), all comment text.
# Prior SEALED build: b39 (12c69766c709bd0d / 4939, sealed 2026-07-30, commit aed4b26).
# b39 SEALED BY JEFF 2026-07-30 - WITH ONE EXPLICIT CAVEAT, SEE BELOW. Async-fill
# registration hotfix, implemented per the CONFIRMED plan docs/B39_PLAN_2026-07-29_gate3.md
# (10 touch points) + TP-11 (E9-P6) added at a post-build audit. GATE ZERO PASSED,
# DEPLOYED, GATE 4 CLOSED WITH CAVEAT, SEALED.
# b39 superseded E6-b38. SUPERSEDED IN TURN by b40 (documentation-only, see the header
# above) - b40 is BEHAVIOURALLY IDENTICAL, so everything below stands unchanged.
#   b39 identity for the record = 12c69766c709bd0d / 4939, deployed 2026-07-29.
# *** SEAL CAVEAT - READ THIS BEFORE TRUSTING THE WATCHER ***
#   A-1 and W-1..W-6 closed on CODE INSPECTION, NOT EVIDENCE. WatchUntrackedLevels has
#   never adopted a position in any run. On Vantage the TRADE_RETCODE_PLACED signature is
#   ROUTINE (reproduced live, Run 5) but the fill lands within the tick, so the fast path
#   never missed. The registration MISS behind the 2026-07-27 incident is a TIMING TAIL,
#   not reproducible on demand on any account available. Jeff will not run further tests
#   on the Cent LIVE account to chase it. PARKED: if it recurs, the journal is the
#   reproduction - "order accepted but no position yet" -> "Watcher: L<n> REGISTERED" ->
#   "Exits applied" closes the rows on live evidence; an orphan with NO watcher line is a
#   b39 DEFECT, capture the log and reopen. Full reasoning in the Gate 4 evidence log.
# GATE 4 CLOSED ON EVIDENCE: R-1 R-2 R-3 R-4 (no regression, 3 brokers, tester + live +
#   restart-with-open-positions), A-3, A-5, O-3, O-4 (the last three proven ON THE LIVE
#   CENT ACCOUNT that produced the incident), K-3, TP-10, E9-P2 (normalized comparator on
#   3 suffixes .s / + / .sc). Two Tier 3 fires recomputed to the cent on BOTH derivations.
# ALSO OPEN ON INSPECTION: L-1..L-4 (need a deliberately corrupted comment), F-1..F-5
#   (flat-state rebuild never triggered), K-1/K-2/K-4 (Run H not run).
# GATE ZERO: PASSED 2026-07-29 - 0 errors, 0 warnings, 2590 ms, cpu='X64 Regular',
#   compiled from the REPO copy with MetaEditor64 (Vantage terminal build) against the
#   D0E8209F MQL5 include tree. The .ex5 and compile log were deleted after witnessing -
#   they are build artifacts, and the MT5 tree was NOT touched.
# HYGIENE: 0 bare LF, ASCII-only (0 bytes > 127), brace/paren/bracket deltas all 0 and
#   identical to the b38 baseline. No new input, no new global, NO NEW PERSISTED FIELD,
#   no state-schema change (R-3 by construction).
# DELTA: +265 lines (4674 -> 4939) across ELEVEN touch points, per the CONFIRMED plan
#   docs/B39_PLAN_2026-07-29_gate3.md + TP-11 (E9-P6, added at post-build audit).
# GATE ZERO RE-RUN after TP-11: 0 errors, 0 warnings, 2134 ms. Hygiene re-verified
#   (0 bare LF, ASCII-only, all delimiter deltas 0).
# CARRIED FORWARD to the next build (NOT fixed in b39):
#   (1) Run H (K-1/K-2) against an actual SLICED anchor on Vantage, + K-4 (do comments
#       survive a PARTIAL CLOSE on Vantage). Overdue since the E6 seal.
#   (2) T3-DS1 dashboard visual confirm (display-only, no money path).
#   (3) E9: O3 filling-mode negotiation, O4 netting guard, O5 exemode init guidance,
#       O6 comment-integrity detection, PLUS b39's own deferrals - the never-filled
#       timeout (E9-O2e), account-scoped identity (W-7), and unifying
#       AdoptionCandidateExists with TryAdopt (they duplicate admission logic today
#       and MUST be kept in step - see E9-P6).
# Prior SEALED build: E6-b38 (f7766c859e4d3c7a / 4674, sealed 2026-07-26, commit
#   8722fcc). b39 is UNCOMMITTED as of the seal - committing it is Jeff's call.
# E6-b38 SEALED BY JEFF 2026-07-26. Drawdown Reduction Tier 3 (partial-lot anchor
# slice) implemented per the CONFIRMED plan docs/E6_PLAN_2026-07-26_gate3.md (8 touch
# points, +106 lines 4568->4674). GATE ZERO PASSED, DEPLOYED, GATE 4 CLOSED, SEALED.
# E6-b38 is now the CURRENT SEALED BUILD (supersedes E5-b37).
#   REPO src    = E6-b38 (f7766c859e4d3c7a / 4674)  <- this manifest tracks REPO.
#   MT5 runtime = E6-b38 (f7766c859e4d3c7a / 4674)  - byte-identical to repo, no
#     deploy drift. Resume protocol should now show repo and runtime ALIGNED.
# GATE ZERO: compiled 2026-07-26 12:34:12 in Jeff's terminal - 0 errors, 0 warnings
#   (metaeditor.log; re-witnessed in-session at Jeff's request after an earlier
#   01:48:22 compile of the same byte-identical source, also 0/0). TRTM.ex5 rebuilt
#   12:35:02; EA re-initialized "=== TRTM E6-b38 init ===" on XAUUSD.s + BTCUST,
#   self-test PASS, Reconcile FLAT.
# GATE 4: CLOSED 2026-07-26. docs/E6_VERIFY_CHECKLIST.md - 36 rows: 32 closed on LIVE
#   evidence, 2 CODE-GUARANTEED (PR2/PR3, jump-only per the sealed E5 T2-PR1 precedent),
#   2 INHERITED (K1/K2, Run H not run - Jeff's call, residual risk recorded), 1
#   dose-response (T3-3), 1 display not visually confirmed (DS1, non-blocking).
#   TEN tester runs on XAUUSD.s real ticks -> 19 Tier 3 fires + 3 Tier 1 + 1 Tier 2, every
#   one recomputed to the cent on BOTH derivations (leg-by-leg AND marginPts x sumVol),
#   never disagreeing once.
# CARRIED FORWARD to the next build (NOT fixed now - a comment-only edit would re-bump the
#   manifest sha and break this seal's build identity):
#   (1) stale EvaluateBasketClose header comment 2300-2308; (2) Run H against an actual
#   sliced anchor before live deployment; (3) DS1 visual confirm.
# Prior SEALED build: E5-b37 (compiled+deployed+verified 2026-07-25, all 34 E5
# rows). E6-b38 is COMMITTED (8722fcc) and PUSHED (origin/main = 8722fcc); E5-b37
# (d094c65) and E4-b36 went up with it. Hygiene: 0 bare LF, ASCII-only, brace delta
# -1 (baseline-preserved), parens balanced; no new global, no new persisted field.

## Environment note
ALL charts are DEMO; multi-symbol attachments are test surface.
Checklist EVIDENCE comes from XAUUSD.s only.
Broker facts: Doo Prime XAUUSD.s stops level (broker minimum SL/TP
distance) is DYNAMIC - 100 pts was a sample observed at one init; it has
ranged ~20-100 pts within one evening. Never treat it as a constant;
guidance logs must say "at init". The sealed b28 deferral evidence
(93 < 100 pts) was audited against that 100-pt init sample.
DEPLOY NOTE (b24): no policy selector - manual exit adoption is live
behavior on EVERY chart b24 is attached to. Flagged and accepted.

## CORE STATUS - COMPLETE (2026-07-22, first Claude Code session)
Core trade functionality is CLOSED. Sealed: Stages 1-7, Stage 8 Step 1,
Stage 9 Steps 1-2, Stage 10 observability. The full live loop - entry,
grid/martingale levels, SL/TP, break-even, manual-exit adoption,
recovery, state persistence, observability - is built and demo-verified.
Nothing in the core loop is unbuilt or unverified.

Reconciliation - the b33 handover section 3 "queued" list was STALE;
these three were already PASS and sealed under Stage 8 Step 1, not
remaining work:
- SELL lap (direction symmetry): DONE. Three SELL sequences PASS
  (S8-10(S)/S8-15(S)/S8-6(S), 2026-07-20) satisfy the STAGE8_MATRIX
  spot-check symmetry contract (matrix is BUY-worded, direction-
  symmetric, evidence = BUY + SELL spot-checks). Jeff confirmed closed
  2026-07-22.
- M6-1 (post-BE SL adoption above floor): DONE, PASS 07:16:42, sealed.
- S8-17 (trail-arm TP release): DONE, PASS 16:01:01, sealed.

## Enhancement backlog (TRTM-only; post-core; NONE started)
Plan phase next. Each is a fresh delivery through the gates when picked.
E4-E7 merged 2026-07-23 from docs/ENHANCEMENT_INPUT_2026-07-23_tier1.md
(Gate 1 INPUT only - nothing locked, no matrix, no code). E4-E7 are
reverse-engineered from a third-party reference EA (Shadow Trade Manager
PRO v3.21) via tester logs only; each item is tagged OBSERVED (evidenced,
arithmetic recomputed in the input doc) or CHOSEN (Jeff's TRTM design
decision). Shadow is a REFERENCE, never a spec. The input doc holds the
full arithmetic and per-fire evidence; entries below are the durable
summary.
E1 (SEALED E1-b34, 2026-07-23) BE/TP/trail anchor -> LOT-WEIGHTED, ALL
   PATHS + DASHBOARD. DONE - all gates cleared, sealed by Jeff after 5
   live runs (see b34 changes for the seal evidence). Lot-weighted average
   replaced the simple-average anchor across avg-TP, BE stop/trigger, trail
   activation/trigger, AND the dashboard projection/avg-entry. Two
   compute sites converted in-loop (ComputeTargets, ComputeProjection);
   a shared helper was drafted then removed (dead code, deferred to E4).
   Docs: E1_MATRIX.md (sealed, 25 rows), E1_PLAN.md, E1_CHECKLIST.md (all
   PASS). Lot-weighted is the
   financially correct basket break-even; simple average only coincides
   when all lots are equal. NEW COUPLING: E4's Tier 1 trigger computes
   from a lot-weighted VWAP - landing E4 while TP/BE stays simple-average
   puts two averaging bases in one money path (section 7 consistency
   break). Therefore E1 and E4 are ONE Gate 1, OR E1 lands FIRST and E4
   follows. E4 MUST NOT land before E1. Matrix caveat: under the sealed
   closed-form stall (base 0.01/mult 1.5 -> L3-L6 all 0.02) equal lots
   are common, so simple and weighted coincide across a stalled band -
   any E1 matrix MUST include an unequal-lot sequence or it proves
   nothing. Full evidence + rationale below in "Parked additions".
E2 Stage 8 Step 2 - draggable EXIT (SL/TP) lines LIVE. Not built; only
   the pending PLACEMENT line exists today. Money-path UX; Gate 1 ->
   matrix -> plan.
E3 Stage 9 Step 3 - auto-entry stub (MQL_TESTER-gated). Optimization
   infra, required before parameter optimization. Reuse the OFFSET seed
   (rejected for Step 2, held in reserve for Step 3).
E4 (NEW 2026-07-23) Drawdown Reduction Tier 1 - point-based basket
   close. One-line: when the basket is deep, close the OLDEST position
   together with every currently-profitable position, but only if that
   group's combined P/L clears a per-lot profit threshold. Money-path;
   full Gate 1 -> matrix -> plan. DEPENDS ON E1 (lot-weighted) - now
   SATISFIED: E1 sealed E1-b34 2026-07-23, so E4 is UNBLOCKED. NOT STARTED;
   next up when picked, opens with its own Gate 1.
   OBSERVED (Shadow, both runs, arithmetic in input doc): trigger = open
   count >= MinTrades (was 4) AND group (anchor + ALL profitables) VWAP
   >= MinProfitPoints (was 150 pts) in front of the FAR-side market
   price. Sells close at Ask (confirmed 3x); buys would close at Bid
   (NOT observed). Evaluation TICK-based, not bar-gated (both fires
   mid-bar). On fire: close every member at market, anchor first then
   profitables descending ticket, then recompute sequence TP + refresh
   ladder. Threshold restated: group must net >= MinProfitPoints per lot
   (VWAP framing is the lot-size-independent form) => group can NEVER
   close at combined loss; only the anchor realizes a loss. Anchor cost
   MEASURED to escalate (run B: fire1 anchor 0.01 -26.99 lot-pts; fire2
   anchor 0.02 -43.92, +63%) - the squeeze C1 accepts.
   CHOSEN for TRTM (Jeff 2026-07-23):
     C1 anchor = OLDEST position strictly; transfers to next-oldest when
        it closes; NO skip-to-affordable. Rationale: oldest = most
        swap-expensive; Tier 1 failing to fire on an expensive anchor is
        acceptable, not a defect. Rejected skip-ahead (leaves oldest
        alive longest, unpredictable next-close). Cost accepted:
        cost-to-close rises each fire so Tier 1 fires progressively less
        often. Evidence note: Shadow CANNOT confirm its own anchor rule
        and no ordinary run can - in an unbroken additive ladder
        oldest = deepest = smallest-lot coincide structurally; behavior
        (#2 then #3 across both fires) agrees with C1 but the RULE is
        unproven. Edge case named: on a V/whipsaw the oldest can be the
        shallowest loser - the rationale that always holds is "oldest =
        most swap-expensive", not "oldest = deepest".
     C2 at least one profitable position NOT mandatory; threshold test
        alone governs (Shadow never fired with zero profitables -
        unevidenced, a TRTM choice).
     C3 PRESERVED LADDER INDEX (diverges from Shadow, which re-indexes by
        count). A rung is an ADDRESS not a counter position: Level N
        always = (price from anchor + N*interval, lot =
        ComputeLevelLot(N)); price revisits a level -> refills at that
        level's lot. Still nothing stored (both derived). Rationale:
        restores basket weight so lot-weighted VWAP/TP returns to where
        the sequence earned it; Shadow's re-index leaves the basket
        permanently lighter at the top, pushing TP further away and
        compounding across heals. Rejected count-based re-index (silently
        discards rungs, degrades TP). WARNING: C3 touches the SEALED
        martingale path (ComputeLevelLot 1752/1776, normalizer 1798) and
        the level counter - the matrix MUST carry must-NOT-fire rows
        proving closed-form output is bit-identical for the no-heal case,
        and rows sited at a curve STEP not inside a stall (a stall makes
        preserved-index and count-re-index indistinguishable).
     C4 3-second post-fire recovery suppression (Shadow hardcodes it);
        TRTM to decide input vs hardcoded - see O3.
   OPEN sub-decisions (resolve in E4's Gate 1): O1 rung re-arm after a
     Tier 1 close (preserved index allows repeated whipsaw refill; each
     cycle net-positive by construction so no loss leak, but ladder
     CONSUMPTION is real - 9 fires empties it; decide whether a closed
     rung needs extra travel before re-arming; the existing 3 entry gates
     do NOT bound the count, bar-close bounds only the rate). O2 threshold
     scaling with depth (flat 150 for first and ninth fire; later fires
     already harder under C1 - a knob, decide or park). O3 post-fire
     suppression window input vs hardcoded (C4). O4 BUY-side far-price =
     Bid (NOT observed - no buy sequence exists); matrix MUST carry a SELL
     lap AND a BUY lap, close-side price DIRECTION-DERIVED never a fixed
     Bid/Ask read (known defect class, surfaces on one direction only).
     O5 group close ordering + partial-fill handling (Shadow: anchor-first
     then profitables descending, separate market orders, no retry; a
     mid-group leg failure leaves a partially-closed group whose combined
     P/L no longer matches what was tested - needs a rule; unaddressed by
     Shadow logs).
E5 (SEALED E5-b37 2026-07-25) Drawdown Reduction Tier 2 -
   percent-based (Shadow InpPC2_ProfitPercent/InpPC2_MinTrades). E7 R1 reference
   run DELIVERED 2026-07-24 (docs/STM Drawdown Reduction Tier2 Logs.txt; analysis
   docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md) - one Tier 2 fire captured and
   recomputed. Tier 2 = Tier 1's close machinery fired by a MONEY test (group P/L
   >= ProfitPercent% of account BALANCE) instead of per-lot points. T2-O0 LOCKED:
   separate default-off tier (InpEnableTier2), see locked-decisions log. DONE - all
   gates cleared (Gate 1 T2-O0..O7 locked; matrix SEALED rev 2; plan CONFIRMED; built
   E5-b37; verified + SEALED 2026-07-25). Reuses Tier 1's sealed close machinery via a
   shared dispatcher: Tier 2 (group P/L >= % of BALANCE) evaluated FIRST, then Tier 1
   (points). See seal entry in the locked-decisions log + docs/E5_VERIFY_CHECKLIST.md.
E6 (NEW 2026-07-23) Drawdown Reduction Tier 3 - partial-lot close
   (Shadow InpPC3_MinTrades/MinLots/MinProfitPoints/ClosePercent).
   DISABLED in both runs - ZERO observed behavior. Input names imply
   closing a PERCENTAGE of a position's lots (a different mechanism from
   E4); requires its own reference run (E7 R2).
E7 (NEW 2026-07-23) Reference-EA behavior capture - RESEARCH task, NOT a
   TRTM build, no gates, pure evidence gathering. Rerun Shadow with
   disabled features ON to get E5/E6 data and close E4's unobserved
   branches: R1 InpEnablePartialClose2=true (Tier 2); R2
   InpEnablePartialClose3=true (Tier 3); R3 a BUY sequence (all data
   today SELL-only) - SUPERSEDED 2026-07-23: O4 was decided from the
   platform invariant (buy closes at Bid, already TRTM's sealed-core
   behavior), so R3 is NO LONGER NEEDED for O4 and nothing in E4 blocks
   on it; de-prioritized, retains only general buy-side corroboration; R5 a BE reference run (price
   favourable to basket AND Tier 1 disabled so it cannot harvest
   positions before BE arms - see F4; only if Shadow's BE is ever wanted
   as a reference, TRTM's own BE is sealed). R4 WITHDRAWN 2026-07-23: a
   different run cannot separate oldest/deepest/smallest-lot (they
   coincide by construction in every additive ladder; verified against
   run B's two fires); disambiguation would need an artificial basket,
   no longer a faithful reference. Formally parked as
   undeterminable-by-observation; C1 does not depend on the answer.
   R2 (Tier 3) DELIVERED 2026-07-25: docs/STM Drawdown Reduction Tier3
   Logs.txt captured 2 Tier 3 fires; analysis
   docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md (both fires recomputed to the
   cent). Unblocked E6; E6 Gate 1 is now OPEN (see locked-decisions log
   T3-O0/O2/O3/O4/O5/O6 locked 2026-07-25..26).
E8 (NEW 2026-07-26, Jeff's idea; ADOPTED, own Gate 1 pending) PROFIT-FUNDED
   TAIL SLICE - CHOSEN, TRTM-native (NOT reference-derived). After a full
   T1/T2 close banks net profit +P on a tick, spend up to a fraction f of P
   to ALSO partial-slice the NEW anchor (next-oldest survivor = deepest
   remaining loser), the combined tick staying net >= (1-f)*P >= 0. Reuses
   the Tier 3 partial-close primitive (E6 O1) but with a DIFFERENT funding
   source/gate: standalone Tier 3 fires on a self-funding group that is
   itself net-positive (guaranteed win); E8's slice realizes a PURE loss on
   a loser, funded only by the just-banked harvest. RISK CHARACTER (must be
   costed at Gate 1, cf. the 2026-07-21 martingale-basis R-a rejection): it
   is a DIRECTIONAL tail-risk lever that bets AGAINST the basket's own
   mean-reversion recovery thesis (the deep losers are held precisely to
   profit when price reverts to TP); nets NEUTRAL at the instant (pays L out
   of P), buying reduced future tail variance + a VWAP nudge toward TP, at
   the cost of banked profit if price reverts. DEPENDS ON E6 (needs the
   partial-close primitive + dispatcher landed first). Open sub-decisions to
   spec at E8 Gate 1: E8-O1 reinvest fraction f (input; default off / 0);
   E8-O2 target = new anchor only vs next-N losers; E8-O3 atomic sequencing
   (harvest must be REALIZED before the funded slice is sized - no
   hypothetical funding; partial-fill discipline); E8-O4 how L is measured
   (realized close P/L in account currency; cross-currency valuation
   collapses on USD-quote symbols); E8-O5 gate/skip when f*P < 1-lot-step
   loss (nothing affordable to slice); E8-O6 interaction with the T3 gate
   and single-fire rule (E8 rides a T1/T2 fire, so it is NOT a separate
   dispatcher branch - it is a follow-on to a full-close fire). NOT STARTED;
   no matrix, no code.

## Verified (demo, logs audited)
Stages 1-7 SEALED (S7 sealed 2026-07-16 on b23; kill tests on b21).
Stage 8 Step 1 SEALED by Jeff 2026-07-20 on b28 (see seal section).
Stage 8 Step 2 (draggable lines) is the only parked Stage 8 item.
Stage 9 Step 1 SEALED by Jeff 2026-07-20 on b29 (tester interactive).
Stage 10 (observability batch) SEALED by Jeff 2026-07-21 at Stage10-b32.
A1 guards A/B/C, A2 (reworked b31), A3 (>0 branch), A4 all PASS with
audited live logs; A5 + A3 0-stops sub-case accepted by inspection.
Full scoreboard in HANDOVER_2026-07-21_stage10_b32.md.

## b34 changes (E1: lot-weighted anchor - SEALED by Jeff 2026-07-23).
## MONEY PATH - anchor basis change. All gates cleared (locked-decisions
## 2026-07-23; docs/E1_MATRIX.md 25 rows; docs/E1_PLAN.md;
## docs/E1_CHECKLIST.md all PASS across 5 live runs). +11 lines
## (4296 -> 4307). Compiled clean (0/0, Jeff's terminal).
1. ComputeTargets: loop now accumulates sumPrice=sum(lot*entry) + sumVol;
   g_curAvgEntry = sumPrice/sumVol (was sum(entry)/count). avg-TP (>1
   level) reads g_curAvgEntry (inline sum/count duplicate removed).
   anchorEntry (lowest-level SL anchor) + levelCount==1 TP UNCHANGED.
   Stale "simple average implemented to match spec" comment replaced.
2. ComputeProjection: loop now accumulates sumWV=sum(lot*entry); avgEntry
   = sumWV/lots (was sum(entry)/count). Drives dashboard avg-entry row +
   "Proj at TP/SL" - now the SAME lot-weighted basis as the engine (no
   b26/S8-25 display drift). Per-leg pTP/pSL math untouched.
3. Lot-weighted computed IN-LOOP at both existing scan sites (no
   redundant per-tick pass). A shared helper was drafted then REMOVED
   before handoff (it had no caller - both consumers own a loop - so it
   was dead code / unused-function warning risk at gate zero); deferred
   to E4, which needs the average outside these loops. C-1 single-basis
   guarantee is enforced by matrix recompute, not code sharing.
UNCHANGED (money/state): Recovery lot sizing (ComputeLevelLot) + level
spacing; SL anchor (lowest-level entry); CostCoverPoints; manual-exit
substitution + [MANUAL] tag; state schema + RunStateSelfTest (no new
persisted field - g_curAvgEntry already per-pass non-persisted). Equal-
lot sequences are bit-identical to b33 by construction (weighted==simple
when lots equal). Hygiene: 0 bare LF, ASCII-only, brace delta preserved
(-1 pre-existing string/comment brace, +2/+2 from the new helper).
STATUS: SEALED by Jeff 2026-07-23. Verified across 5 live demo runs on
XAUUSD.s (audited to the cent, docs/E1_CHECKLIST.md): unequal-lot BUY
10-level lifecycle (weighted TP exact every level + BE fire + weighted-TP
exit), equal-lot SELL 10-level no-op (weighted==simple) + SELL BE, trail
activation (weighted threshold discriminated vs simple), manual-TP edit
(path unchanged, computed re-assert weighted), hard-kill recompute +
lowest-level re-anchor. SELL/descending/manual-list by equivalence (the
averaging code has no direction/order term). No FAILs, no findings.
Empirical: XAUUSD.s stops level read 100 pts at 22:03/22:11 inits (within
the DYNAMIC 20-100 band). E4 (Tier 1) is now UNBLOCKED - E1 has landed.

## b33 changes (Stage 9 Step 2: tester pending-line NUDGE, matrix SEALED
## 2026-07-21). ZERO money paths (trade-primitive count 8=8 vs b32).
1. INPUT InpTesterNudgePts (default 50) + "=== Tester (Stage 9) ===" group.
   Global g_nudgePts clamped >=1 in OnInit (N1-5). LogTesterModeOnce now
   says "12 buttons" and announces the nudge step.
2. NEW FN NudgePendingLine(dir) [helper-before-caller, above
   HandlePanelClick]: moves ONLY PLINE OBJPROP_PRICE by +/- g_nudgePts;
   reads g_pendDir, never writes (N3-4); no-line -> INFO "no pending line
   to move" (N3-3, not silent). Free movement either side of market;
   CONFIRM stays sole authority (G4).
3. DISPATCH B_PUP/B_PDN in HandlePanelClick (reuse shared un-press +
   PanelRefresh). 
4. LAYOUT (placing branch): TESTER-only 4-button row CONFIRM|+|-|CANCEL
   via x-cursor; LIVE else-branch byte-identical (bw2+40 CONFIRM, N3-1).
   Nudge buttons collapse to 10x10 off when not placing, tester-guarded
   so the live panel never creates the objects.
5. POLL ARRAY 10 -> 12 (B_PUP/B_PDN appended last; up-before-dn = N1-4
   order); loop bound now ArraySize (no second magic number). Existing 10
   dispatch order + behavior unchanged.
No persisted field added (state schema/self-test unchanged, N4-2). Line
delta +60 (est. was +40; tester layout split + comments ran longer).
STATUS: SEALED by Jeff 2026-07-21. All 20 checklist items resolved
(12 PASS audited, S13/S14 equivalence, S15/S17/S19/S20 inspection).
S1 full lifecycle recomputed exact to the cent; money engines proven
byte-identical to b32. No FAILs, no new parked items.

## b32 changes (Stage 10: A5 reword, 2026-07-21)
Finding (evidence: every reason-5 deinit this session -> "acquired (no
existing lock)"): OnDeinit calls ReleaseInstanceLock() UNCONDITIONALLY,
so a clean re-init (param change, recompile) releases the lock and the
next init logs "acquired", NOT "re-asserted". The re-assert branch
(owner==ChartID + fresh heartbeat + lock present) is therefore only
reachable via an UNCLEAN shutdown that skips OnDeinit. b29's and b31's
"parameter-change re-init" descriptor named an unreachable case.
FIX (wording only, line count unchanged): re-assert message now names
ONLY the unclean-shutdown-survivor case and notes a clean re-init
releases the lock first. A5 accepted by INSPECTION: trigger branch
byte-identical to b29, string-only change, and forcing a hard-kill +
fast-restart purely to watch a wording line is disproportionate.

## b31 changes (Stage 10: A2 REWORK after live FAIL, 2026-07-21)
Live verification found A2-as-b30 broken two ways (evidence retained):
- S10-11 FAIL: init sibling never fires - MQL_TRADE_ALLOWED reads TRUE at
  OnInit even with F7 "Allow Algo Trading" unchecked (12:45 init silent,
  12:46 send blocked "by client"). Flag does not track the checkbox at
  init on this MT5 build.
- TP4 (flag-aware 10027) was on the PENDING path only; the common
  MARKET-entry path (E7) printed MT's generic string, no cause hint
  (12:46 BUY 10027). BUT the flag IS correct at TRADE time: 12:55 pending
  10027 with box off printed the EA-checkbox branch = S10-15 PASS.
b31 fix (ZERO money paths, +8 lines 4228->4236):
1. Removed the dead init sibling (TP3). Toolbar-off at init still covered
   by the existing WARN.
2. New helper AutoTradingDisabledHint() - single source for the 3-branch
   10027 cause hint, called at SEND time only (flag reliable there).
3. E7 (market entry) now appends the hint on 10027 (was bare).
4. P6 (pending) now calls the helper (+ keeps "Distance was fine.") -
   no duplicated branch logic to drift.

## b30 changes (Stage 10: observability batch, matrix SEALED 2026-07-21)
Design: STAGE10_MATRIX.md (20 rows) + STAGE10_PLAN.md (7 touch points).
ZERO money paths - emission/wording only. +31 lines (4197 -> 4228).
Compile is gate zero (Jeff's terminal); not yet compiled.
1. A1 (M1): Guards A/B/C blocked-while-flat now FILE-log a WARN, not
   dashboard-only. Reason-tracked via transient g_flatBlockReasonLogged
   (0/1/2/3): one WARN per reason, re-announce on reason switch, re-arm
   on clear or when a sequence opens. reasonNow set only in the flat
   branch => never fires while a sequence is live (M1-7). Closes the
   Inputs-Reset silent path that bit Jeff (Guard A blocked, no journal).
2. A2 (M2): per-EA MQL_TRADE_ALLOWED now checked. Init sibling WARN
   (gated toolbar-ON && program-OFF, no double-blame) names the EA
   properties checkbox. 10027 diagnostic now reads both flags live and
   names the ACTUAL off-switch (toolbar / EA-checkbox / toggled-at-send)
   instead of always blaming the toolbar - same class as the b27
   distance/10027 misdirect fix.
3. A3 (M3): broker-geometry INFO now says "no fixed stops/freeze
   reported (0 pts)" + dynamic caveat when the broker reports 0, instead
   of a bare "0 pts" that read as known-safe.
4. A4 (M3): tick/ask recovery-signal branch now logs an INFO naming the
   tick basis (was silent; only bar-close mode logged, at 1970).
5. A5 (M3): own-chart lock re-assert message now names the unclean-
   shutdown-survivor case, not only parameter-change re-init.
6. A6 PARKED - manual-SL-refused throttle; never observed spamming
   (Jeff 2026-07-21). Re-opens only on real repeat evidence.
No persisted field added => state-file schema / self-test unchanged.

## FINDING (raise with Jeff) - stale broker fact in this manifest
The Environment note above states "Doo Prime XAUUSD.s stops level =
100 pts" as a constant, but the b29 handover empirical ledger records
it as DYNAMIC 20-100 pts intraday (sampled). A3 (above) codifies the
dynamic reality. The "= 100 pts" line should be reworded to "sampled
100 pts; DYNAMIC 20-100 intraday" - not silently changed here because
it underpins sealed b28 deferral evidence (93 < 100). RESOLVED 2026-07-23:
the Environment note already read DYNAMIC (not a "= 100 pts" constant);
Jeff confirmed the wording and it now names the stops level as the broker
minimum SL/TP distance and ties the 100-pt sample to the sealed 93 < 100
evidence. See F2 below.

## FINDINGS (raise with Jeff) - 2026-07-23 enhancement input merge
From docs/ENHANCEMENT_INPUT_2026-07-23_tier1.md. F1-F4 RAISED, none
applied to code or to the referenced STATE.md text yet.
F1. E1 wording (backlog above): the ORIGINAL E1 line read the choice as
    open ("SIMPLE avg vs lot-weighted"). Jeff directed LOT-WEIGHTED
    2026-07-23. E1 has been reworded in the backlog to record the
    intended direction while keeping the Gate 1 requirement. The
    "Parked additions 2026-07-20" evidence block (below) is UNCHANGED -
    it still states simple-vs-lot-weighted as pending because it is the
    dated evidence record, not the decision. Do not edit that block.
F2. RESOLVED 2026-07-23. The stale-broker-fact FINDING immediately above
    (stops level "= 100 pts" constant vs the DYNAMIC 20-100 pts ledger)
    was found already corrected in the Environment note - it read DYNAMIC,
    not a constant. Jeff confirmed the wording; the note now names the
    stops level as the broker minimum SL/TP distance and ties the 100-pt
    init sample to the sealed b28 93 < 100 deferral evidence. No code
    change (doc clarity only).
F3. Shadow log cosmetic (reference-EA defect, informational): its three
    Tier 1 CLOSING deals each print "Confirmed initial deal #N. Position
    count is 0", misclassifying close-deals as initial entries and
    reporting count 0 while 7 positions remained open. Recorded as a
    defect CLASS for TRTM to avoid - close deals must NOT route through
    the initial-entry branch. Not a TRTM bug; a design guardrail note.
F4. Shadow's break-even engine is UNOBSERVED across the full four-day
    run despite InpEnableBreakEven=true: no BE line, no SL modification,
    no armed message; every modify carries sl: 0.00000. Reason
    demonstrated (not assumed): price ran persistently AGAINST the
    basket, and the two times positions moved into profit Tier 1 closed
    them (14:57 06.24, 15:48 06.25) before any held the 200-pt trigger.
    STRUCTURAL NOTE worth carrying into TRTM design thinking: an
    aggressive Tier 1 can systematically harvest exactly the positions a
    BE engine would otherwise arm on. TRTM's own BE is sealed; if
    Shadow's BE is ever wanted as a reference it needs E7 R5 (price
    favourable AND Tier 1 disabled).
F5. RAISED + ANNOTATED 2026-07-25 (E5 Gate 4 recompute). The sealed E5_MATRIX.md
    WORKED REFERENCE (Tier 2 fire VWAP 1.9311258 / margin 181.6 pts) and the T2-O4
    locked decision claimed Tier 1's gate was ALSO met at the 07/02 15:30 Tier 2
    fire, "proving" Tier-2-first precedence. RECOMPUTE (two independent ways:
    0.5985490/0.31, and the group-P/L identity 46.29/(0.31*1e5)) gives margin
    149.3 pts (VWAP 1.9308032), BELOW the 150 threshold - Tier 1's gate was NOT met.
    The matrix numerator was 0.5986490, exactly 0.0001 above the real 0.5985490 (a
    division slip). CONSEQUENCE: the reference run has ZERO both-gates-pass
    observations; T2-PR1 precedence has NO reference support and MUST be verified
    LIVE (constructed both-gates-pass tick, already in the plan's verify map). NOT a
    code defect (Tier-2-first is correctly implemented + money-neutral per T2-PR4),
    NOT a re-seal, NOT a STOP. Matrix (WORKED REFERENCE / G-PR / T2-PR1 / Status) and
    the T2-O4 block annotated in place (evidence corrected; the locked DECISION and
    the matrix SEAL are unchanged). Full recompute in docs/E5_VERIFY_CHECKLIST.md F5.

## b24 changes (Stage 8 Step 1: manual exit adoption, matrix SEALED)
Design: STAGE8_MATRIX.md (37 rows, sealed 2026-07-16). Summary:
1. SequenceState: manualTP/manualSL persisted (absent-key = 0.0,
   backward compat; self-test extended). 14th save site at adoption.
2. DetectManualExitEdits (pre-substitution, each pass): armed-ticket
   deltas classified - adopt (WARN w/ money impact if exposure-
   increasing, else INFO) / conflict = adopt none + WARN / post-BE
   looser SL refused / trailing skipped (ratchet path owns it).
   Removals never adopted - enforce loop reverts + WARN (both TP+SL).
3. Want-value substitution: owned manual overrides computed before
   ApplyProtectiveEngines; engines still tighten on top. Exceeded-
   close messages name manual vs computed. Re-anchor INFO gated off
   while manual SL owned.
4. Structural TP release (ReleaseManualTP): level add / level close /
   trail-arm, WARN names trigger. Manual SL: NO structural release
   (locked - risk statement + level budget).
5. ReconcileManualExits (end of Reconcile live path): ownership
   continues on agreement; death-window close releases TP only;
   dead-window edits adopted (M7-5); mid-propagation kill completed
   + WARN (M7-7); conflicts drop to computed + WARN (M7-6). Seeds
   lastApplied/armed; one-pass detection skip (Reconcile's verdicts
   propagate without re-classification).
6. Dashboard: TP/SL rows show " [MANUAL]" while owned.

## b25 fix (found live 2026-07-17, Jeff's log - S8-2 regression FAIL)
b24 detection read the EA's OWN stale write after a structural recompute
as a trader edit (cur == lastApplied != new want for one pass) and
adopted its own previous TP: adopt/release oscillation per level add,
TP never recalculating. SL variant latent and worse (no structural
release = stale anchor frozen permanently). Fix: candidate requires
delta from want AND from lastApplied (the discriminator policy A had,
dropped in the b24 rewrite). Matrix row M5-6 added; S8-2 hardened.

## b26 fix (found live 2026-07-17, Jeff's dashboard observation)
Manual substitution was enforcement-path only: dashboard TP/SL rows,
Proj at TP/SL, and LogStructure projected from raw computed while the
broker ran on the manual value (TP row showed computed value wearing
the [MANUAL] tag; projection frozen). Fix: same substitution at both
display call sites; zero money-path changes. Matrix M2-7, checklist
S8-25 added. Pre-existing (NOT b26, parked as fold-in candidate):
Proj at SL under BE projects from the computed anchor, not the BE
floor - predates Stage 8, raise for a display decision separately.

## b27 changes (found live 2026-07-17, BE + pending sessions)
1. D2 lock enforced at arm: manual SL cleared with INFO at BE trigger
   ("BE floor owns; tighter edit can re-own, M6-1") and at trail
   activation ("ratchet owns; tighter edit becomes floor"). b26 left
   manualSL set after arm - no money impact (floor logic superseded
   it) but dashboard showed [MANUAL] on an engine-owned SL and fed
   defect 2.
2. Exceeded-close labels derive from the value's ACTUAL source
   (manual / BE floor / trail ratchet / computed by comparison, not
   manualSL>0). b26 labeled a BE-floor backstop close "manual (trader
   risk cap)" - wrong provenance in a money log line.
3. LogBrokerExitGeometry() at init (both paths, incl CONFIG-BLOCKED):
   one-shot INFO stops/freeze levels + config guidance WARNs when BE
   (Trigger-Offset < broker min: stop born unplaceable, backstop
   closes at BE price but NOT broker-held/kill-proof) or Trail
   (Distance < broker min: chronic deferral) geometry cannot place.
   Jeff's request: broker constraints guide config, not surprise
   mid-trade. Plus WARN when AutoTrading toolbar is OFF at init.
4. P6 pending-reject WARN is retcode-aware. Found live: 10027
   (AutoTrading off, toolbar) printed the fixed "broker min distance"
   suffix and sent Jeff hunting a distance problem that pre-check had
   already passed (line 262-344 pts out). 10027/10026/10017 now name
   the real cause; 10015/10016 carry the distance context.
   (Also confirmed from code: NO auto-retry on pendings - the 3 rapid
   sends were 3 confirm clicks; success clears armed state so
   double-placement is not possible.)

## Session 2026-07-18 (weekend, BTCUST surface)
Locked: seal-evidence amendment - symbol-AGNOSTIC branches accept
BTCUST demo evidence (kill battery S8-23/S8-24, S8-12/13/14, 10027);
symbol-SENSITIVE items (money-impact arithmetic, M6-1, S8-17, SELL
lap) remain XAUUSD.s-only. Rationale: TRTM is multi-instrument by
design; persistence/reconcile paths have no symbol math. Rejected:
BTC-for-everything.
S8-14 manual conflict window: attempted x3, best separation 525ms
(adjacent passes) - NOT reproducible manually. Accepted per procedure;
conflict branch evidence = K4 (M7-6 reconcile path), now REQUIRED.
Sealed this session: S8-23 (terminal-restart half, K0), S8-24a (K1,
lock re-assert proves hard kill vs K0's clean release). Bonus: 6-flip
S8-9 chain + fat-finger 650008.00 adoption (58,585,827-pt WARN exact)
recorded as live evidence attached to the rev-2 locked rationale.
BTCUST empirical: stops/freeze 0 pts at init; spread ~1400-1418 pts;
tether tick-value factor ~0.9991 on all money projections; MaxSpread
80 (gold-tuned) forfeited L2 until raised (forfeit WARNs correct).

## b29 changes (Stage 9 Step 1: tester interactive mode, matrix SEALED)
Design: STAGE9_MATRIX.md (21 rows, 5 groups, sealed 2026-07-20).
Purpose: make the SHIPPING EA interactive in the MT5 visual tester
(chart events never fire there, build 5833) with ZERO live-chart
behavior change. NO money-path changes in this build.
Touch points (+55 lines, all one file; +27 was the code estimate,
overage is inline rationale comments, no extra logic):
1. TP-1 PanelButtonSet create-block: OBJPROP_ZORDER=10 on buttons
   (bg stays 0), unconditional (D1). Only live-visible delta; M4
   proves live clicks unaffected.
2. TP-2 PollTesterButtons(): MQL_TESTER-gated, polls 10 button STATEs
   every tick (D2, no throttle); latched button -> [TESTER] click
   line -> HandlePanelClick (reused verbatim, un-presses internally).
   Two-latched-same-tick dispatch in array order (M2-5).
3. TP-3 OnTick head: poll call placed ABOVE the g_configBlocked
   early-return so a click under config-block still reaches
   HandlePanelClick's own guard (M3-1). Verified 4144 before 4145.
4. TP-4 LogTesterModeOnce(): one-shot [TESTER] init INFO (D3),
   MQL_TESTER-gated, called from BOTH OnInit exit paths (config-
   blocked + normal) so the channel is announced either way.
UNCHANGED (explicit): HandlePanelClick body, OnChartEvent (live event
path byte-identical - regression anchor), all 10 click handlers, ALL
money paths (exits/recovery/adoption/reconcile/BE/trail), state
persistence + self-test (no new persisted field), PanelRefresh value-
update path, all inputs. MQL_TESTER is net-new in the file.
Hygiene: brace delta -1 (unchanged), CRLF clean (0 bare LF), ASCII-
only. Cannot compile MQL5 - compiler output is checklist gate zero.

## b28 fix (found live 2026-07-18, K2 kill test on BTCUST - FAIL)
K2 (S8-24b) FAIL on b27: death-window close released manual TP
correctly (M7-4 WARN), but ReconcileManualExits' M7-5 branch then
re-adopted the SURVIVING ticket's broker TP 64500.00 - the EA's own
pre-kill propagation - as a trader edit, because the release had
already cleared manualTP and the branch lacked the b25 discriminator.
Net: computed 64272.94 never re-asserted; the release WARN's
"re-asserted" claim was false. SL half PASSED (ownership continued).
Root cause: order-of-operations (release clears ownership, then
classification runs against the emptied persisted value). Fix:
capture releasedTP at the release site; M7-5 candidate must differ
from it; suppressed case logs one-shot M7-8 INFO. Nuance mirrors
M5-6: a genuine dead-edit to exactly the old value is reverted once.
Matrix row M7-8 (38 rows); S8-24b hardened. Live-path detection
untouched (b25 discriminator already correct there). Queued
observability items remain queued (fix-only build). FAIL evidence
retained: 23:44:59 log block 2026-07-18, b27.

## Stage 9 Step 1 - SEALED by Jeff 2026-07-20
Tester interactive mode on the SHIPPING EA. All 19 checklist items
PASS. Two environments: LIVE demo (regression) + MT5 visual tester
(GBPAUD.s M15, build 5833). Evidence audited to the cent.

LIVE regression (safety gate - proves zorder change is clean live):
- S9-1 PASS: live init shows NO [TESTER] line (gate holds, MQL_TESTER
  false live). S9-2 PASS: all buttons dispatch via OnChartEvent, NO
  [TESTER] poll line ever (verified absence). S9-3 PASS: object list
  = 0 objects (buttons still HIDDEN, no strays, screenshot). S9-4
  PASS: zorder survived ~3 min refresh churn, all buttons responsive
  first-click (M4-3 clean, no finding).

TESTER items:
- S9-5 PASS: one-shot [TESTER] init INFO, at init not per-tick (x2+
  launches). S9-6 PASS: same line fires from the CONFIG-BLOCKED init
  path too (TP-4 both call sites live).
- S9-7/S9-8 PASS: poll channel dispatches on shipping EA; ALL 10
  buttons have DIRECT [TESTER] poll lines (equivalence not needed) -
  B_BUY/SELL/CLOSE/PBUY/PSELL/PCONF/PCXL/CXLP/BE/TRAIL.
- S9-9 PASS: latch-fires-once, accepted on ~18-click accumulated
  evidence (no double-fire ever). S9-10 PASS by inspection+procedure:
  same-tick two-button contention not manually reproducible (3 tries,
  best 1 tester-sec; mirrors S8-14). Poll loop is for(i=0..9) over a
  static array, no inter-iteration state -> array-order dispatch is a
  structural guarantee. Adjacent-tick sequential (E4 arm-switch)
  directly evidenced.
- S9-11 PASS (the no-silent-path row): under config-block the poll
  reaches HandlePanelClick (loop sits ABOVE the OnTick config-blocked
  return, 4144<4145), refusal logged ONE-SHOT via AlreadyLogged, no
  order, no silent swallow. Repeat clicks still emit the poll line
  (channel never silent) while the refusal is suppressed (one-shot) -
  both observability axes satisfied. S9-12 PASS by composition: true
  mid-run input change is a TESTER LIMITATION (inputs locked per
  pass); block->clean transition proven by blocked-run clean latch
  behavior + clean-run dispatch + g_configBlocked reset at OnInit
  boundary (line 4009, code-confirmed).
- S9-13..S9-19 PASS: full lifecycle via poll. BUY/SELL arm+open
  (signs exact), CLOSE arm+confirm+flat (x2), pending PBUY place+
  confirm+CXLP cancel AND PSELL/PCXL placement-cancel, BE arm+trigger
  (floor = avg + 30 offset exact: 1.88457+30pts=1.88487), trail
  arm+ratchet+exit (activation -100 exact; steps 34pt/11pt >= min 10;
  exit on trailed SL 1.88297, attribution correct). Pending-confirm
  broker-min guard fired correctly (line 1pt from market < 25 min,
  named cause).

TESTER EMPIRICAL FACTS (ledger; terminal is truth):
- GBPAUD.s stops level = 25 pts (tester), confirms prior probe.
- Cross-pair first-trade symbol auto-sync (GBPUSD.s, AUDUSD.s load on
  first GBPAUD position): this is MetaTester's USD-valuation engine
  loading conversion legs, NOT a TRTM behavior (plain tester lines,
  no [TRTM] tag; TRTM only touches _Symbol via the wrapper). Would
  reproduce on b28. Verifiable: USD-quote symbol shows no pop-ups.
- Config-block refusal ("Buttons are config-blocked") is one-shot in
  tester too (AlreadyLogged cfgclick).
- Tester input limits: inputs locked per pass (no mid-run change);
  object drag dead (draggable pending line). WORKAROUND b33: Stage 9
  Step 2 adds tester-only +/- nudge buttons to move the pending line.
- MT5 visual tester has NO in-pass EA restart (observed 2026-07-21,
  Jeff-corrected): no remove/re-attach, no Properties/param-change
  re-init mid-pass. To re-init you must stop and restart the whole pass
  from the beginning. => restart-row tests (e.g. S18) run on a LIVE demo
  chart, where remove/re-add / recompile / param-change fire a real
  OnDeinit->OnInit. (OBSERVED, not assumed.)

## b29-QUEUED observability batch: NOW BUILT as Stage10-b30 (2026-07-21).
Own matrix/checklist (STAGE10_*). All 5 confirmed items (A1-A5) in the
build; A6 parked. Awaiting live+tester verification before seal.

## Stage 8 Step 1 - SEALED by Jeff 2026-07-20
Final market-hours session (XAUUSD.s, demo, logs audited to the cent):
- M6-1 PASS 07:16:42 - post-BE above-floor SL edit 3991.74 (floor
  3991.66, +8 pts) adopted INFO with level-budget note. BE trigger
  3992.36 fired @ 3992.59; floor = avg 3991.36 + 30 pts exact;
  deferred placement (93 pts < 100 min) then applied - acceptable
  per seal criteria.
- S8-17 PASS 16:01:01 - manual TP 4024.59 owned at trail arm ->
  "RELEASED - trailing armed" WARN (M5-3 call site), TP removed same
  pass, supersede INFO for owned SL 4009.46, activation SL
  4021.06 = 4022.56 - 150 exact.
- SELL lap PASS (three sequences 16:02-17:45):
  S8-10(S): tighter-classification SELL sign flip proven (4048.72,
    4040.91 each lower = tighter -> INFO; same branch as
    tighter-vs-computed). Loosen side corroborated: 4050.54 WARN
    $34.64 = 1732 pts x 0.02 exact (M3-2 SELL, gold arithmetic).
  S8-15(S): PASS twice (L2 add 16:17, L3 add 17:42) - release WARN
    names level, computed re-asserted, manual SL untouched in every
    exits-applied line (M5-1(S) + M3-4(S)).
  S8-6(S): PASS 17:44:54 - 3-level seq (0.02/0.02/0.03), TP edited
    on MIDDLE ticket 666655888 (L2), adoption INFO (36 pts closer =
    exposure-decreasing, correct), propagated to L1+L3 within 216ms
    one pass, all 3 carry 4015.70.
- Projection audits exact throughout: 2-level +12.00/-35.76;
  3-level +23.11/-53.19 (proj from manual SL when owned - display
  truth holding); computed TP 4015.34 = simple avg 4018.3433 - 300.
- Bonus evidence: M6-3 ratchet-floor adopt live BOTH directions
  (4021.26 BUY 16:01:12, 4024.36 SELL 16:29:15) - upgrades S8-21
  from equivalence to direct evidence.
- First trail-arm attempt 07:52 was NOT S8-17 evidence (L2 add at
  07:41 had already released the TP via M5-1; M5-3 site never ran) -
  rerun performed; recorded so equivalence is never claimed here.

## Accepted cosmetics (recorded, not churned)
- Benign duplicate "Exits applied" line after stops-level deferral
  retry (same value, no money impact). Seen 16:01:07/16:01:08 (BUY)
  and 16:29:06 (SELL). Display/log ordering quirk only.

## Parked additions 2026-07-20
- Computed-TP anchor: SIMPLE average of entries (code comment lines
  1094-1097 marks simple-vs-lot-weighted as a PENDING decision,
  "implemented to match spec until then"). First unequal-lot live
  evidence today: 0.02/0.02/0.03 -> simple avg 4018.3433 vs weighted
  4018.6414; simple sets TP beyond financial BE+300 when late lots
  are larger (errs profitable). Needs its own Gate 1 when raised -
  money-path change, do not fold in.

## Locked decisions log (additions this session)
2026-07-23 E4 O1 RUNG RE-ARM = UNRESTRICTED REFILL (Gate 1 LOCKED; matrix +
plan still required before any code). After a Tier 1 fire vacates a rung's
ADDRESS, that address refills by the ORDINARY recovery-ladder re-arm - the
same derived path as the level's first open (price = anchor + N*interval, lot
= ComputeLevelLot(N) under C3 preserved index). NO extra re-arm-travel
criteria, NO "armed" flag, NO per-rung last-closed state. Nothing new
triggers the refill (the normal recovery ladder recomputing from the
surviving top does) and nothing is stored - both price and lot stay DERIVED,
C3 invariant intact. FIRE-GROUP reminder (so the re-arm scope is not
misread): Tier 1 closes the anchor (oldest) + ALL currently-profitable
positions, so a 6-level basket can vacate e.g. L1(anchor)+L4/L5/L6, leaving
underwater survivors L2/L3 - not just top+bottom; every vacated address
re-arms by the same rule.
  DIRECTION REALITY (Jeff's clarification 2026-07-23, structural not
  probabilistic): only the HIGHER closed rungs re-arm; the LOWEST closed rung
  (the anchor) NEVER re-arms. The recovery ladder extends ONLY in the adverse
  direction (a SELL adds higher rungs as price rises), never below the current
  lowest survivor. The closed anchor sits at the FAVOURABLE extreme (lowest
  price for a SELL), so revisiting it needs price to move FOR the basket -
  which heads toward basket TP, not toward a recovery add. Concretely: a fire
  closes L1(anchor,bottom) + the profitable top band L4/L5/L6, leaving
  survivors L2/L3; recovery re-arms L4->L5->L6 above the top survivor as price
  moves adverse again, and L1's address is never revisited by an add.
  RATIONALE: every refill->close cycle is net-POSITIVE by construction - the
  threshold guarantees the group nets >= MinProfitPoints/lot (run A +30.16
  lot-pts; run B fire2 +29.72), so there is NO loss mechanism to gate against.
  Rate is already bounded: the bar-close entry gate caps refills at 1/M15 bar
  (<=96/day) and each refill still needs a qualifying tick clearing the
  threshold (observed: 2 fires in 4 days, run B). A re-arm-travel gate would
  defend against no loss while forcing per-rung STORED state that breaks C3's
  derived-only design and adds a fresh touch on the sealed ladder - cost
  against zero financial benefit. Jeff confirmed 2026-07-23.
  LADDER-CONSUMPTION cost ACCEPTED (bounded by fires; each fire spends the
  oldest; 9 fires empties a 9-rung ladder even if all 9 profit) - that IS the
  intended pressure-valve behavior. The residual "should deeper/later fires be
  worth MORE" question is handed to O2, not gated here.
  Rejected: require extra travel before a vacated rung re-arms. Rejected -
  defends against no loss (every cycle net-positive), requires per-rung stored
  state breaking C3, and duplicates the rate throttle the bar-close gate
  already provides.

2026-07-23 E4 O4 FAR-SIDE PRICE = DIRECTION-DERIVED, basis = PLATFORM INVARIANT
(Gate 1 LOCKED; matrix + plan still required before any code). The Tier 1
trigger far-price - the price the group's margin is measured against AND the
side the group closes at - is DERIVED FROM BASKET DIRECTION: SELL basket ->
Ask, BUY basket -> Bid. Never a hardcoded/fixed side.
  BASIS (Jeff 2026-07-23, first-principles - stronger than a single Shadow
  observation): a market close of a BUY is a SELL executed at BID; a close of a
  SELL is a BUY executed at ASK. Broker/platform INVARIANT, always true, and
  ALREADY the behavior of TRTM's SEALED TP + manual-exit close paths (buys have
  always exited at Bid across the whole sealed core). So the BUY side needs NO
  Shadow buy fire to justify it - buy-closes-at-Bid is a platform fact TRTM
  already relies on. Shadow's SELL-closes-at-Ask (observed 3x: run A + run B
  x2) corroborates the SELL side.
  DEFECT CLASS the rule guards (EA-CODE risk, NOT a platform risk): computing
  the trigger MARGIN against a FIXED side (e.g. SYMBOL_BID as "current price"
  regardless of direction). The CLOSE always executes on the correct broker
  side, so the danger is a MISMATCH - the EA tests the margin on the wrong
  side, so tested margin != realized margin by one spread (a BUY tested vs Ask
  fires ~1 spread optimistic; realized close at Bid is worse). TRTM must
  compute the trigger far-price on the SAME side the close will execute, so
  tested margin == realized margin.
  MATRIX: still BOTH laps (SELL + BUY) - NOT to prove buys close at Bid
  (platform-guaranteed) but to prove TRTM's CODE derives the far-price from
  direction and does not hardcode a side. The BUY lap is validated against the
  platform invariant + arithmetic, not against a Shadow reference.
  CONSEQUENCE for E7 R3: R3 ("get a BUY sequence") was listed ONLY to observe
  O4's buy side. O4 is now decided from the platform invariant, so R3 is NO
  LONGER NEEDED for O4 and nothing in E4 blocks on it (R3 retains only general
  buy-side corroboration value; de-prioritized).
  Rejected: any fixed Bid/Ask read - passes SELL-only evidence, breaks live on
  the first BUY basket, surfaces only on the untested side.

2026-07-23 E4 O3 POST-FIRE SUPPRESSION = NONE (no input, no hardcoded timer)
(Gate 1 LOCKED; matrix + plan still required before any code). TRTM does NOT
port Shadow's hardcoded 3s recovery-suppression window and does NOT expose it
as an input.
  RATIONALE: TRTM recovery entry is BAR-CLOSE gated (the same gate O1 relies
  on - 1 refill per M15 bar). A 3s window NEVER binds under bar-close entry:
  the fire lands mid-bar (Shadow log 14:57:40) and the next possible recovery
  entry is the next M15 bar close, minutes away, always >> 3s. Porting the
  timer would be dead code. Shadow itself ran InpRecoveryBarCloseEntry=true in
  both runs AND still hardcoded 3s - a generic defensive belt, redundant once
  entries are bar-gated.
  WHAT ACTUALLY NEEDS PROTECTING (implementation invariant, not a knob): the
  recovery-state refresh (Shadow's RefreshRecoveryState) must be ATOMIC with
  fire completion - synchronous, in the same handler, before any next
  bar-close evaluation - so the next bar-close already sees correct post-fire
  state (survivors, Level, LastPrice). No stale-state window then exists, so no
  timer is needed. A post-fire rung re-arming on the next bar close is exactly
  the O1 unrestricted-refill behavior already locked - desirable, not
  suppressed.
  Rejected: expose a suppression input (a knob that does nothing under
  bar-close entry - misleading). Rejected: port Shadow's hardcoded 3s (dead
  code under bar-close gating).
  PLAN-TIME RIDER (parked): this rests on recovery staying bar-close gated. If
  TRTM ever adds TICK-based recovery entry (relevant to E3 auto-entry),
  revisit with a minimal "no recovery entry on the same fire tick" guard, NOT
  a wall-clock timer. Out of scope for E4.

2026-07-23 E4 O5 GROUP-CLOSE ORDER + PARTIAL-FILL = PROFITABLES-FIRST /
ANCHOR-LAST + ABORT-ON-FAILURE (Gate 1 LOCKED; matrix + plan still required
before any code). CHOSEN - a deliberate safety divergence from Shadow's
OBSERVED order. Rule:
  1. Reuse the SEALED close-with-retry routine (manual-exit/TP path); do NOT
     invent a new close path.
  2. ORDER: close ALL profitable legs FIRST, the ANCHOR LAST (inverts Shadow's
     anchor-first). The anchor is the only loss leg; its loss is realized ONLY
     after the covering profit is already banked. Among profitables, descending
     ticket for determinism.
  3. Bounded retries per leg via the sealed routine, then treat the leg as
     failed.
  4. ABORT RULE: the anchor closes ONLY if every profitable leg is confirmed
     closed. If any profitable leg fails after retries -> STOP, do NOT touch
     the anchor; leave it open. Tier 1 re-evaluates next qualifying tick (group
     re-forms from what is open, threshold re-checked - self-correcting).
  INVARIANT PROOF (protects O2's "group never closes at a combined loss"): all
  profitables + anchor -> = tested group, >=0. Some profitables close then one
  fails -> abort anchor -> realized = pure profit subset, strictly >=0. All
  profitables close then anchor fails -> realized = pure profit, anchor stays,
  strictly >=0. Worst partial outcome is a SAFE DEFERRAL (harvested winners,
  did not shed the anchor this cycle), never a realized combined loss.
  OPTIONAL GUARD NAMED, NOT ADOPTED (Jeff 2026-07-23, my lean out): gating the
  final anchor close on banked-profit-so-far >= anchor cost-to-close would
  cover adverse anchor drift between banking profit and closing the anchor -
  negligible in practice (Shadow's fires landed whole-group on one sub-second
  tick), and the profitables-first order + abort rule already protect the
  invariant. Parked as a cheap future hardening if ever wanted.
  SHADOW EVIDENCE (run B 14:57:40 fire, pasted 2026-07-23, CONFIRMS the
  OBSERVED half and the GAP): Shadow closes ANCHOR FIRST (#2, the loss leg)
  then profitables DESCENDING TICKET (#11 then #10), ONE market order per leg
  (a buy to close each sell), all three filled on one sub-second tick
  (23:49:26.959->.965). NO retry, NO error handling, NO partial-fill path -
  the failure branch is never exercised, so Shadow's logs CANNOT define
  failure behavior. That is precisely why O5 is a TRTM CHOSEN rule. Shadow got
  away with the fragile anchor-first order only because no leg ever failed.
  Also re-confirms F3 (close deals #12/#13/#14 print "Confirmed initial deal
  #N. Position count is 0" - close-deals routed through the initial-entry
  branch; TRTM's transaction handler must not).
  Rejected: Shadow's anchor-first (realizes the loss before securing the
  profit - the exact failure the invariant forbids). Rejected: rollback/reopen
  a closed leg on failure (reopening is fresh entry risk - new price, slippage,
  re-derived lot/level). Rejected: all-or-nothing pre-check (cannot pre-verify
  a market order will fill; not implementable).

2026-07-23 E4 O2 THRESHOLD = FLAT MinProfitPoints, scaling PARKED (Gate 1
LOCKED; matrix + plan still required before any code). MinProfitPoints stays a
single flat constant - same value for the first fire and the ninth. NO
depth-scaling term (no 150 + K*(count-MinTrades)).
  RATIONALE: C1's anchor-cost escalation ALREADY provides implicit
  depth-scaling - a more-negative anchor demands a larger profitable tail to
  reach the same VWAP-margin, so later fires are structurally harder without a
  new knob (run B: fire1 surplus +30.16 lot-pts on a 0.01 anchor; fire2
  surplus FELL to +29.72 despite a LARGER profitable tail, because the 0.02
  anchor cost +63% more). Eventually cost-to-close exceeds any achievable tail
  and Tier 1 simply stops firing (run A basket 14:57: L1 27.1 -> L2 46.9 ->
  L3 59.2 -> L4 63.6 lot-pts). An explicit scaling term double-counts this and
  adds an UNVALIDATED tuning constant with zero reference evidence (Shadow ran
  flat 150 across both fires). Reversible: if live TRTM runs later show Tier 1
  firing too eagerly at depth, a scaling term is a clean follow-up.
  Rejected: depth-scaled threshold now - premature, redundant with the
  automatic anchor-cost self-limiting, unvalidated knob.

  TWO-GATE TRIGGER STRUCTURE clarified this session (Jeff's two points
  2026-07-23), both LOCKED, feeding the matrix:
    GATE A (depth): total OPEN POSITION COUNT >= MinTrades. NEW INPUT "Tier 1:
      Min Trades to Activate" (Shadow's MinTrades, was 4; TRTM default 4).
      Gates on the COUNT of currently-open positions, NOT the level index. In
      a fresh unbroken ladder these coincide (reach L4 = 4 open); under C3
      after a fire the index is preserved while the count drops, so they
      DIVERGE and the durable rule is COUNT-based. CONSEQUENCE (Jeff confirmed
      2026-07-23): a fire that drops open count below MinTrades makes Tier 1
      DORMANT until recovery rebuilds the count to >= MinTrades - a shallow
      basket is not under drawdown pressure and does not need the valve;
      Tier 1 re-activates once the ladder deepens again. Count is always the
      REMAINING open positions.
    GATE B (profit): the group (anchor + ALL currently-profitable positions)
      combined P/L must clear MinProfitPoints per lot (the VWAP-margin framing
      is the lot-size-independent form of the same test). This subsumes "is it
      positive?" - clearing a positive MinProfitPoints guarantees combined > 0.
    HARD MONEY-SAFETY INVARIANT (Jeff's Point 1, elevated): a Tier 1 group must
      NEVER close at a combined loss. The ANCHOR alone always realizes a loss;
      the GROUP (anchor + profitables) never does. Positivity is the GROUP
      combined, NOT each leg and NOT the whole basket. O5 (partial-fill) must
      protect this invariant if a close leg fails mid-group.
  PLAN-TIME RIDER (not an O2 decision): MinProfitPoints is in POINTS and
  symbol-relative. Shadow's 150 was GBPAUD.s (5-digit); on XAUUSD.s (_Point
  0.01) 150 pts = a $1.50 move - the DEFAULT value for gold must be chosen
  deliberately at plan time, independent of flat-vs-scaled.

2026-07-24 E4 O2 PLAN-TIME RIDER RESOLVED (Gate 3): InpTier1MinProfitPts
DEFAULT = 150 points. ONE input, in POINTS, symbol-relative, per-chart
overridable - the EA does NOT branch on symbol (same as the existing
InpRecoveryIntervalPts / InpAvgTPPts defaults).
  RATIONALE (Jeff 2026-07-24): TRTM's PRIMARY use is FOREX recovery-trade
  management; XAUUSD.s is only a fast TEST surface (volatility reaches levels
  faster). The shipped default therefore targets the primary use, not gold.
  150 is the forex-native number (Shadow's GBPAUD.s value) and is kept ON
  MERIT for forex, not as a coincidental gold point-count. A gold user
  overrides per chart.
  Rejected: 200 pts (parity with InpAvgTPPts, a GOLD-framed rec I proposed
  before the forex-primary framing was corrected) and 300 pts (one full
  recovery interval) - both were gold-centric and do not fit the forex
  primary use. Reversible per chart at any time (it is an input, not a
  constant).

2026-07-24 E4 H-6 SL RE-ANCHOR IMPLEMENTATION = CONFIRM EXISTING PATH +
FIRE-THEN-RETURN (Gate 3; Jeff confirmed 2026-07-24). NO new SL code. On a
Tier 1 fire, EvaluateTier1 returns from the tick (no recovery add that tick);
the NEXT tick CheckSequenceLiveness prunes the EA-closed anchor and
ComputeTargets recomputes minLvl = new lowest survivor, re-anchoring the SL
through the EXISTING path (EnforceExits:1511) - the same mechanism a manual L1
close already uses.
  RATIONALE: ComputeTargets already anchors SL to the lowest surviving level
  and skips missing tickets; the re-anchor is not new behavior. Fire-then-return
  is the only guard needed (H-5 atomicity - no higher rung added before the
  prune+re-anchor settles). Mid-fire the survivors hold their old (tighter,
  protective) broker-side SL; the basket is NEVER left unprotected. Preserves
  the "EnforceExits is the single SL writer" invariant.
  Rejected: explicit synchronous re-anchor inside EvaluateTier1 - adds a SECOND
  SL writer, touches the sealed exit path more heavily, and risks the async gap
  where the just-closed anchor is still PositionSelectByTicket-visible for a
  tick (wrong-anchor read). H-6 remains a VERIFY-time proof obligation (SL moves
  to new oldest, never references a closed ticket, never unprotected mid-fire,
  BUY+SELL laps), not a code rewrite.

2026-07-24 E4 M-1 WHOLE-BASKET STAND-DOWN (live finding -> matrix rev 2 amendment;
build E4-b36). Jeff confirmed 2026-07-24. When the Tier 1 group would close the
ENTIRE open basket (no underwater survivor remains), Tier 1 STANDS DOWN instead
of firing. Guard: grp size >= openCount (grp always contains the anchor, so this
means every non-anchor position is profitable).
  FINDING (live gold demo, 2026-07-24 16:02): a 4-level all-in-group fire closed
  the whole basket at group margin 152.8 pts, PRE-EMPTING the sequence's own
  AvgTP (200 pts, projected +19.98). Because group==basket, Tier 1's VWAP == the
  sequence VWAP, so with MinProfitPts(150) < AvgTPPts(200) Tier 1 always fires
  first and banks LESS than the sequence would unaided. Spec-compliant with G-1
  but not traced in the sealed matrix (which assumed partial valving on a deep
  underwater basket).
  DECISION (A) chosen over (B): (A) stand down whenever group==whole basket (no
  survivor); (B) stand down only when the anchor itself is profitable. (A) makes
  Tier 1 NEVER worse than the baseline sequence exit (the finding's core concern)
  and covers the anchor-sole-loser case (the likely live fire); (B) leaves that
  case still clipping the TP. Give-back objection answered: standing down hands
  the full close to the sequence's OWN AvgTP-exceeded market close (bank-at-market,
  give-back-averse, banks the higher +200) - deferral to a better guaranteed exit,
  not hoping.
  SCOPE: inert on every partial valve (grp < openCount) - all prior VERIFIED fires
  (GBPAUD SELL x4, gold BUY x5, GBPAUD fire1) had grp < openCount, so they are
  unchanged. Only the whole-basket case flips from fire to stand-down.
  Rejected: (B) anchor-profitable-only (partial fix); accept-as-is (leaves Tier 1
  strictly worse than Tier1-off on green baskets); scaling MinProfit vs AvgTP by
  guidance only (relies on the trader tuning, does not fix the interaction).
  VERIFY BEFORE RE-SEAL: reproduce the whole-basket case -> now logs "Tier 1
  stands down ... (M-1)" and the sequence AvgTP banks the full close; confirm a
  PARTIAL fire still fires byte-identical (regression vs the verified runs).

2026-07-24 E4-b36 SEALED by Jeff. Full evidence-audited verification complete
(see docs/E4_VERIFY_CHECKLIST.md). Matrix rev 2 (36 rows + M-1) SEALED. Every
money-path row recomputed to the cent: fire path BOTH directions (SELL GBPAUD.s
tester, BUY XAUUSD.s tester), re-arm (H-2/H-4/O-1/O-2), dormancy (D-1 observed),
H-6 SL re-anchor (SELL x4 exact; BUY reasoning + direction-signed), X-2/X-3 abort
(reasoning), K-1/K-2/K-3 restart (LIVE demo kill+reconcile), C-1/C-2/H-1, P1
no-fire byte-identity, M-1 whole-basket stand-down (observed: sequence AvgTP
banked +2500 vs Tier1 +500, validated (A) over (B) on the anchor-sole-loser case),
gate zero b36. Build E4-b36 sha256_16 7e14479c83d672a4 / 4483 lines. E4 (Drawdown
Reduction Tier 1) is CLOSED. Deploy to MT5 tree is Jeff's manual step.

2026-07-24 E5 T2-O0 TIER 2 = SEPARATE DEFAULT-OFF TIER (Gate 1 LOCKED; matrix +
plan still required before any code). E7 R1 reference run delivered this session
(docs/STM Drawdown Reduction Tier2 Logs.txt; analysis in
docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md), unblocking E5. Decision: Tier 2 is
adopted as its OWN mechanism, gated by a NEW input InpEnableTier2 (default FALSE,
mirroring InpEnableTier1), REUSING Tier 1's sealed close machinery (group select,
far-side derivation, close-with-retry, TP recompute, recovery refresh). Tier 2
differs from Tier 1 in ONE thing only: the TRIGGER METRIC - group P/L in MONEY
must clear ProfitPercent% of the account reference base, vs Tier 1's group VWAP
clearing MinProfitPoints per lot. Both tiers may be enabled independently.
  OBSERVED BASIS (single Tier 2 fire, 2026.07.02 15:30, recomputed to match the
  log): trigger line "Basket P&L: 31.40 | Required (1.0% of 3026.14): 30.26";
  1.0% x 3026.14 = 30.26 (base = ACCOUNT BALANCE post-realized, proven = 3000 +
  Tier 1's +26.14 realized, NOT equity). "Basket P&L" is the CLOSE-GROUP total
  (anchor #3 -85.68 AUD + profitables #21 +40.32 + #22 +91.65 = +46.29 AUD ->
  31.40 USD), NOT the whole underwater basket. Group rule, anchor-first Shadow
  order (TRTM inverts per O5), SELL->Ask far-side, F3 close-deal defect, and
  count-reindex (TRTM keeps C3) all IDENTICAL to Tier 1.
  RATIONALE: Tier 2 is not redundant - Tier 1's points bar is account-independent;
  Tier 2's 1%*balance bar FALLS as the account draws down, so it eases mid-
  drawdown (mildly pro-cyclical harvest Tier 1's metric cannot express). Separate
  default-off tier keeps E4's seal boundary intact (no re-touch of the sealed
  trigger code), matches Shadow's own structure, and is the cleanest unit to
  matrix/verify.
  Rejected: (unified trigger w/ metric selector) - re-touches just-sealed E4
  trigger code and blurs the seal boundary for less input surface; (decline/park
  Tier 2) - forfeits the account-relative harvest.
  OPEN (resolve next, one at a time): T2-O1 reference base (balance/equity/fixed);
  T2-O2 lock "close-group P/L" naming; T2-O3 percent semantics; T2-O4 Tier1/Tier2
  coexistence + same-tick precedence (UNOBSERVED - fired on different days);
  T2-O5 inherit E4 O5 close order; T2-O6 inherit E4 O4 far-side (BUY lap
  unobserved); T2-O7 cross-currency P/L valuation (NEW money path vs Tier 1;
  collapses to identity on USD-quote symbols like XAUUSD.s).

2026-07-24 E5 T2-O1 REFERENCE BASE = ACCOUNT BALANCE (Gate 1 LOCKED; matrix +
plan still required before any code). Tier 2's percent is taken of AccountBalance:
threshold = InpTier2ProfitPercent% x AccountInfoDouble(ACCOUNT_BALANCE). Matches
the OBSERVED Shadow base (3026.14 = realized balance, proven not equity).
  RATIONALE: balance is stable tick-to-tick (moves only when trades realize), so
  the bar is not perturbed by the very drawdown Tier 2 manages; it scales the
  harvest to account SIZE, giving a predictable account-proportional threshold.
  Rejected EQUITY (balance+floating): the bar shrinks as the basket deepens
  (fires more eagerly mid-drawdown) BUT is tick-volatile and can shrink toward
  zero in a very deep basket -> runaway harvesting on trivial group profit;
  unstable trigger. Rejected FIXED money amount: drops the percent/account-
  relative character, functionally Tier 1 in money units - adds nothing new.
  RIDER for T2-O7: the group P/L (Gate B left side) is in account currency, so
  the same-currency comparison is clean; cross-currency conversion is a valuation
  concern handled in T2-O7, not here.

2026-07-24 E5 T2-O2 MEASURED P/L = CLOSE-GROUP (Gate 1 LOCKED; matrix + plan
still required before any code). Gate B tests the P/L of the GROUP actually being
closed - oldest anchor + ALL currently-profitable positions, valued at the
far-side price - against the T2-O1 bar. Same group selection as Tier 1.
  OBSERVED: the log's "Basket P&L: 31.40" is this close-group total (anchor #3
  -85.68 AUD + prof #21 +40.32 + #22 +91.65 = +46.29 AUD -> 31.40 USD), NOT the
  whole 15-position basket (deeply negative floating at that tick). TRTM must NAME
  it close-group P/L, never "basket P/L" (Shadow's misleading label).
  RATIONALE: consistent with T2-O0 (reuse Tier 1's group-close machinery) and
  preserves the HARD invariant - a positive percent bar guarantees the group nets
  >= 0, so the group can never close at a combined loss (only the anchor realizes
  a loss, covered by the profitables).
  Rejected WHOLE-BASKET floating P/L: a different mechanism (global basket TP)
  that collides with the sequence's own AvgTP and the E4 M-1 whole-basket stand-
  down; not observed. Rejected PROFITABLES-ONLY: breaks parity with the group
  that actually closes and overstates the harvest vs the group net.

2026-07-24 E5 T2-O4 TIER PRECEDENCE = TIER 2 FIRST, FALL THROUGH TO TIER 1
(Gate 1 LOCKED; matrix + plan still required before any code). When both tiers
are enabled, each tick evaluates Tier 2 (percent) FIRST; if its gate passes,
fire + credit Tier 2. Else evaluate Tier 1 (points); if it passes, fire + credit
Tier 1. Both tiers select the IDENTICAL group and reuse the SAME fire-then-return
close, so exactly ONE fire per tick and the group that closes is identical
regardless of precedence - this is an ATTRIBUTION/logging choice, money-neutral.
E4 M-1 whole-basket stand-down applies to BOTH tiers (a whole-basket group defers
to the sequence AvgTP no matter which gate passed).
  EVIDENCE (both Shadow fires, recomputed - reproduces this exact rule): at the
  Tier 2 fire (07/02 15:30) Tier 1's gate was ALSO satisfied (group VWAP 1.93113,
  margin vs Ask 1.92931 = 181.6 pts >= 150) yet Shadow credited TIER 2 -> Tier 2
  has precedence. At the Tier 1 fire (06/30 14:16) Tier 2's gate FAILED (group
  ~26.6 USD < 1% x 3000 = 30.00) so it fell through and fired TIER 1. One
  both-pass observation, arithmetic unambiguous. Shadow = reference; TRTM matches
  its precedence deliberately (no money reason to diverge).
  CORRECTION 2026-07-25 (F5, E5 Gate 4 recompute): the EVIDENCE above is WRONG on the
  both-pass claim. The Tier-2-fire margin consistent with the logged 31.40 USD group
  P/L is 149.3 pts (VWAP 1.9308032 = 0.5985490/0.31, confirmed by the group-P/L
  identity 46.29/(0.31*1e5)), BELOW 150 - so Tier 1's gate was NOT met at the 07/02
  15:30 fire (matrix had mis-stated VWAP 1.93113 / margin 181.6, a /0.31 slip). That
  fire evidences ONLY that Tier 2 fired, NOT precedence. The DECISION (Tier-2-first)
  is UNCHANGED - it stands on merit + money-neutrality (T2-PR4). But there is NO
  reference both-pass observation: T2-PR1 must be verified LIVE via a constructed
  both-gates-pass tick. docs/E5_MATRIX.md (WORKED REFERENCE / G-PR / T2-PR1) carries
  the same correction; code correctly implements Tier-2-first (unaffected).
  Rejected TIER 1 FIRST (diverge): money-identical, but does not match the
  reference and there is no reason to flip attribution. Rejected fully-independent
  evaluators: risks a double-close attempt on the shared group without an explicit
  single-fire guard.

2026-07-24 E5 T2 GATE A = OWN INPUT InpTier2MinTrades, DEFAULT 4 (Gate 1 LOCKED;
matrix + plan still required before any code). Tier 2 eligibility requires open
position count >= InpTier2MinTrades (default 4, = Shadow InpPC2_MinTrades),
a SEPARATE input from InpTier1MinTrades. Same count-based semantics as Tier 1
Gate A: Tier 2 is DORMANT while open count < InpTier2MinTrades and re-activates
as recovery rebuilds the count; count is always REMAINING open positions (post
any fire).
  RATIONALE: separate input keeps the tiers independently tunable (T2-O0 separate-
  tier) and matches Shadow's separate PC2 param; the count gate confines Tier 2 to
  a basket deep enough to be under real drawdown pressure, same as Tier 1.
  Rejected SHARE InpTier1MinTrades: couples the tiers, contradicts separate-tier.
  Rejected NO count gate: could fire on a shallow basket not under drawdown
  pressure; diverges from Shadow.

2026-07-24 E5 T2-O5 + T2-O6 = INHERIT E4 CLOSE MECHANICS VERBATIM (Gate 1 LOCKED;
matrix + plan still required before any code). Tier 2 reuses Tier 1's sealed close
machinery unchanged:
  O5 CLOSE ORDER: profitables-first, anchor-last, abort-the-anchor on ANY
    profitable-leg failure after bounded retries, via the sealed close-with-retry
    routine (E4 O5). Realizes the anchor loss only after the covering profit is
    banked; worst partial outcome is a safe deferral, never a realized combined
    loss - preserves the T2-O2 >=0 group invariant.
  O6 FAR-SIDE/CLOSE PRICE: direction-derived (SELL basket -> Ask, BUY -> Bid;
    E4 O4 platform invariant). Trigger margin measured on the SAME side the close
    executes. BUY lap validated against the invariant + arithmetic (Tier 2 BUY
    fire UNOBSERVED, same as Tier 1).
  RATIONALE: money-safety rules TRTM already settled deliberately for Tier 1;
  reusing them (T2-O0) keeps ONE close path and one set of proven invariants.
  Rejected reopening the close order (e.g. Shadow's observed anchor-first for
  Tier 2): re-litigates a settled money-safety rule for no gain.

  --- E5 GATE 1 STATUS 2026-07-24: locked = T2-O0 (separate default-off tier
  InpEnableTier2), T2-O1 (base=balance), T2-O2 (measured=close-group), T2-O4
  (precedence Tier2-first/fall-through, shared group, 1 fire/tick, M-1 both),
  Gate A (InpTier2MinTrades=4 + count dormancy), T2-O5/O6 (inherit E4 close).
  Gate B = close-group P/L(money, acct ccy) >= InpTier2ProfitPercent% x balance.
  PLAN-TIME RIDERS (resolve at Gate 3 plan, like E4 O2's default): (a) T2-O3
  InpTier2ProfitPercent DEFAULT (Shadow 1.0%) - a percent, symbol-agnostic, but
  confirm the shipped default on merit; (b) T2-O7 cross-currency group-P/L
  valuation to account currency - collapses to identity on USD-quote symbols
  (XAUUSD.s), so TRTM's gold evidence surface will NOT exercise the conversion;
  the matrix needs a cross-currency reasoning row. GATE 2: docs/E5_MATRIX.md
  SEALED rev 1 by Jeff 2026-07-24 (30 rows, 12 groups; 23 NEW Tier-2 rows +
  INHERIT-E4 rows). GATE 3 plan docs/E5_PLAN_2026-07-24_gate3.md CONFIRMED by Jeff
  2026-07-24 (shared-dispatcher; TP-1..TP-7 incl. display-only DASHBOARD "DD Reduce"
  row). BUILT E5-b37 2026-07-24 (sha256_16 73dda148c79f1b27 / 4568 lines, +85 vs
  b36; CRLF+ASCII clean, brace delta -1 pre-existing baseline). EvaluateTier1 ->
  shared FormBasketGroup + FireGroupClose + EvaluateBasketClose dispatcher (Tier 2
  first). Matrix amended rev 2 (+G-DS/DS-1 dashboard). COMPILED clean + DEPLOYED
  (runtime == repo) + VERIFIED (all 34 rows) + SEALED by Jeff 2026-07-25 (seal entry below).

2026-07-24 E5 GATE 3 PLAN-TIME RIDERS RESOLVED (Jeff 2026-07-24; matrix already
sealed, plan + confirmation still required before any code):
  T2-O3 InpTier2ProfitPercent DEFAULT = 1.0% (matches Shadow InpPC2_ProfitPercent;
    percent-of-balance is symbol-AGNOSTIC so no forex/gold split; on merit a
    sensible round harvest bar, and the value the reference evidence was captured
    at). Rejected 0.5% (fires too eagerly, consumes ladder) and 2.0% (fires rarely).
  T2-O7 GROUP P/L VALUATION = SUM of members' POSITION_PROFIT (account currency,
    close-side valued, PRICE-ONLY - excludes swap/commission). Reproduces Shadow's
    31.40 and handles cross-currency + far-side by construction (no manual FX).
    GROUNDED IN TIER 1 CONSISTENCY, not Shadow-matching: the log CANNOT settle
    Shadow's swap handling (the reported "Basket P&L" back-solves the FX rate, so
    swap vs AUD/USD-drift is inseparable; ~1.7% gap between the 06/30 balance-
    implied rate 0.6667 and the 07/02 line-implied 0.6783 could be either). TRTM's
    sealed Tier 1 threshold is price-only (points distance), so price-only Tier 2
    keeps one basis + the >=0 invariant clean; swap remains a separate realized
    cost (C1 accepts the swap-heavy anchor). Rejected INCLUDE-SWAP (splits basis
    from Tier 1, can push a fired group below the bar) and MANUAL price+FX
    (reinvents POSITION_PROFIT, reintroduces the G-V2 cross-currency bug).

2026-07-25 E5-b37 SEALED by Jeff. Full evidence-audited verification complete (see
docs/E5_VERIFY_CHECKLIST.md). All 34 matrix rows (SEALED rev 2) recomputed to the cent /
confirmed. XAUUSD.s money paths (tester): SELL fire x5 + BUY fire x2 (group P/L = sum
POSITION_PROFIT; bar = InpTier2ProfitPercent% x live ACCOUNT_BALANCE - balance chain proven,
NOT equity), anchor oldest-transfer, profitables-first/anchor-last close, SELL@Ask / BUY@Bid
far-side, tick/mid-bar timing, lot-weighted survivor TP, SL re-anchor BUY x2 (+ a real
broker-SL hit that capped the basket), preserved-index re-arm, dormancy (5 fire->dormant->
rebuild cycles), must-nots, M-1 whole-basket stand-down (observed), Tier-2-off byte-inert
(R1), Tier-2-on recovery-unchanged (R2), no persisted field (R3 - self-test PASS), V1/V2/V3
gold identity. PRECEDENCE (T2-PR1..PR4): Tier-2-first credit+return + Tier-1 fall-through x4,
both live-recomputed. K1/K2 restart/kill: LIVE BTCUST demo (symbol-agnostic per the
2026-07-18 seal amendment) - unclean-kill lock re-assert + reconcile rebuilt the 2-level
basket from live positions, NO orphan Tier 2 state (Tier 2 persists nothing). DS-1 dashboard
4 states: Jeff visual-confirmed. Gate zero clean; runtime == repo 73dda148c79f1b27 / 4568.
E5 (Drawdown Reduction Tier 2) is CLOSED. Deploy done (Jeff's manual step); E5-b37
UNCOMMITTED (Jeff's call - E4-b36 committed-not-pushed, E1 pushed origin/main @ 864effe).
  STRUCTURAL INSIGHT (deepens F5): group money P/L = margin_pts x SUM(group lots). The Tier 1
  (points) and Tier 2 (%-money) metrics therefore cross the SAME group margin only at a single
  point (Sumlot = bar/T1), so on a SMOOTH retrace the lower-threshold gate fires first and both
  gates are essentially never "just met" on one tick - a literal both-gates-pass is JUMP-ONLY.
  This is the real reason F5's reference smooth both-pass was an arithmetic artifact. The
  Tier-2-first tie-break (when both pass) is CODE-GUARANTEED (dispatcher checks Tier 2 before
  Tier 1). Live PR evidence this session supersedes the (corrected) reference for T2-PR1.
  F5 remains annotated in docs/E5_MATRIX.md (WORKED REFERENCE / G-PR / T2-PR1 / Status), the
  T2-O4 block above, and the findings register - evidence-only; the DECISION is unchanged.
  Optional-only (NOT blocking, deferred): a literal forced both-gates-pass jump (fragile,
  data-dependent) and an XAUUSD.s live-demo K1/K2 touch (BTCUST already covers symbol-agnostic).

2026-07-23 E1 ANCHOR BASIS = LOT-WEIGHTED, ALL THREE PATHS (Gate 1
LOCKED; matrix + plan still required before any code). Decision: replace
the SIMPLE-average sequence anchor (g_curAvgEntry, TRTM.mq5 line 1091,
"locked structural") with the LOT-WEIGHTED AVERAGE of open entries
(sum(lot_i*entry_i)/sum(lot_i)), applied to EVERY path that reads the
anchor - NOT TP alone. SCOPE FENCE: E1 changes ONLY the exit/protection
anchor. It does NOT touch Recovery - not level lot sizing (ComputeLevelLot
line 1755, sealed closed-form, untouched) and not level spacing (the
anchor + N*interval ladder does not read g_curAvgEntry). Recovery stays
byte-identical. TERMINOLOGY: this lot-weighted average is the same formula
E4 later calls "VWAP"; E1 uses the plainer name to keep the two features
distinct. E1 is a basis swap on three existing paths; E4 (Tier 1 basket
close) is a separate feature that happens to read the same lot-weighted
average of its own close-group. The anchor feeds three money paths,
confirmed by grep of g_curAvgEntry: (1) avg-TP computed = anchor +
InpAvgTPPts (line 1106, levelCount>1 branch only); (2) BE stop = anchor +
InpBEOffsetPts [+ CostCoverPoints] (BEStopPrice line 1183, trigger test
line 1208); (3) trail activation + trigger = anchor + InpBEOffsetPts +
InpTrailDistPts (TrailActivationPrice line 1191, trigger line 1253). All
three move to lot-weighted together.
  SCOPE CORRECTION 2026-07-23 (found reading code before the matrix):
  there is a FOURTH averaging site the "three paths" wording missed -
  ComputeProjection (line 1848) recomputes sumPrice/counted independently
  (line 1871) to drive the DASHBOARD "Proj at TP/SL" row (line 3338) and
  the displayed avg-entry. Also the TP site (1106) recomputes
  sumPrice/counted INLINE, not via g_curAvgEntry. So E1 must convert
  every place the average is COMPUTED - g_curAvgEntry (1091), the TP
  inline (1106), AND ComputeProjection (1871) - or the panel would
  project/display a simple-mean average while the engine runs
  lot-weighted: the exact display-vs-engine drift b26/S8-25 fixed and
  locked. Jeff confirmed 2026-07-23: align EVERYTHING anchored to the
  average, dashboard included. Does NOT reopen Option A (still
  lot-weighted, all exit/protection paths); it extends the fence to the
  projection/display site so display never drifts from engine. Not a new
  money path - a display-consistency requirement.
  RATIONALE: lot-weighted is the financially correct basket break-even;
  simple average only coincides when all lots are equal. One anchor, one
  basis, everywhere it is read = internally consistent AND consistent
  with E4, whose Tier 1 trigger already computes from the same lot-
  weighted average of its close-group (leaving the E1 anchor simple would
  put two averaging bases in one money
  path - the section-7 consistency break the E1 amendment exists to
  close). MONEY EFFECT ACCEPTED (Jeff, eyes open): when later/deeper lots
  are larger (normal martingale), lot-weighting pulls the anchor toward
  them (BUY: higher), pushing TP, BE, and trail activation all FURTHER
  away, so BE arms slightly later and TP is slightly harder to reach than
  today. Simple average currently errs early/profitable; lot-weighted
  trades that small early-exit bias for correctness. Worked example (live
  0.02/0.02/0.03 BUY, entries 4018.20/4018.30/4018.53): simple avg
  4018.3433 vs lot-weighted 281.28671/0.07 = 4018.3843, +4.1 pts; avg-TP(+300)
  4021.3433->4021.3843, BE stop(+30) 4018.6433->4018.6843, all shift the
  same +4.1 pts.
    Rejected B (lot-weighted TP ONLY, BE/trail stay simple): creates a
    NEW internal split - TP on a different basis than BE/trail - and is
    still mismatched with E4. A fresh inconsistency to buy a smaller diff.
    Rejected C (keep simple everywhere): E4 then forces two bases in one
    money path (the flagged break); rejects the 2026-07-23 E1 amendment.
  MATRIX REQUIREMENTS carried forward: (a) MUST include an UNEQUAL-LOT
  sequence - under the sealed closed-form stall (base 0.01/mult 1.5 ->
  L3-L6 all 0.02) simple and weighted coincide across a stalled band, so
  a stall-only row proves nothing. (b) must-NOT-fire rows proving the
  equal-lot case is bit-identical to today (lot-weighted == simple mean
  when all lots equal). (c) all three paths (TP, BE trigger/stop, trail
  activation/trigger) exercised, both BUY and SELL laps (anchor is
  direction-signed at the consumer sites). E4 remains blocked until E1
  lands (E4 MUST NOT land first).

2026-07-16 Deferred-TP RE-EXAMINED AND CLOSED, zero code delta:
Choice 1 (bank at market when computed TP already exceeded) STANDS.
b20 race gate made broker-held-TP riding technically trustworthy but
does not change give-back risk; "TP is a MINIMUM acceptable exit"
principle reaffirmed. Alternatives rejected: ride old broker TP
(unbounded give-back, the exact R8 pain), hybrid buffer (complexity
for a guessed input). Jeff confirmed.
2026-07-16 Stage 8 design session, all locked (see STAGE8_MATRIX.md):
no policy selector; removals always reverted; asymmetric manual
lifetime (TP releases on structural events, SL persists); conflict
adopts nothing; engines own once armed; adoption persisted w/ death-
window reconcile rules. Policy A retired with b24.
2026-07-21 Stage 10 observability batch (see STAGE10_MATRIX.md):
D1 Guard-blocked file log = WARN, not INFO. Rejected INFO: splits log
   from the amber dashboard row and understates an operational-
   availability event (EA silently won't enter); the "protective ->
   INFO" rule is about market-risk direction, a different axis. Keying:
   one-shot per reason, re-announce on reason switch, re-arm on clear.
D2 A2 = BOTH touches (init sibling WARN + flag-aware 10027). Rejected
   init-only. SUPERSEDED by D6 (see below) on live evidence.
D6 (2026-07-21, supersedes D2's init-sibling half): DROP the init
   sibling; MQL_TRADE_ALLOWED is proven unreliable at OnInit (true with
   the F7 box off) though correct at TRADE time. Move the cause hint to
   a shared helper called from BOTH send paths (E7 market + P6 pending).
   D2's flag-aware-10027 half stands and is proven (S10-15 PASS); only
   the init-detection premise was wrong.
D3 Cover Guards A/B/C, not A alone. Rejected A-only: B/C share the
   identical dashboard-only block; fixing one leaves a known-identical
   silent path.
D4 A6 (manual-SL-refused throttle) PARKED. Rejected inclusion: no
   observed log spam; a throttle for a theorized repeat violates
   terminal-is-truth. Re-opens only on real repeat evidence.
D5 A3/A4/A5 verified as ONE folded regression row (Jeff). Pure log
   text/emission, money-neutral.
2026-07-21 MARTINGALE COMPOUNDING BASIS - CLOSED, zero code delta.
Jeff's live-raised recursive request WITHDRAWN by Jeff after reviewing
the numeric tradeoff (GATE1_martingale_basis.md). CLOSED-FORM (current)
STANDS as the meaning of the multiplier: level = base * mult^tier,
normalized per level (ComputeLevelLot line 1752/1776; normalizer 1798
round-to-nearest). Confirmed behavior on base 0.01 / mult 1.5 / step 2:
L3-L6 hold at 0.02 (0.0225 rounds down - the "stall"), first step-up at
L7 (0.03375 -> 0.03), then L9 0.05, etc. Jeff verified and accepts the
stall as the honest geometric curve.
  Rejected R-a (deterministic recursive on last-normalized lot): gives
  the climbing 1,1,2,2,3,3 ramp AND stays stateless/restart-safe, but is
  RISK-INCREASING - drifts above mult^n and accelerates (~+33% margin by
  tier2, more at depth). Jeff declined the added risk for no offsetting
  gain; the stall is cosmetic-expectation only, not a math error.
  Rejected R-b (recursive seeded from executed lot): also risk-
  increasing AND breaks statelessness (needs realized last lot ->
  persisted field, uninit-field trap, self-test + backward-compat
  change). No mid-sequence input-adaptation requirement exists to
  justify it.
  Scope untouched by this decision: plain RM_MARTINGALE, RM_MANUAL,
  incremental / deferred-incremental all remain as-is. No matrix, no
  build - nothing was changed.
  RE-OPEN CONDITION: only if a live requirement for a per-tier climbing
  ramp appears; then R-a is the implementation to cost, as a fresh
  Gate 1 with its own matrix and explicit risk-drift acknowledgement.

2026-07-21 STAGE 9 STEP 2 - tester pending-line adjust = NUDGE (Gate 1
locked; matrix pending). Problem: visual tester creates the pending
placement line at ask/bid but chart drag is dead there, so the line
cannot leave the market band and CONFIRM (pollable) always hits the
stops-level refusal - the pending flow is reachable but unusable in
tester. Decision: add two TESTER-ONLY polled buttons (B_PUP/B_PDN) that
shift PLINE OBJPROP_PRICE by +/- InpTesterNudgePts per click; the SEALED
confirm path (ComputeEntryLot, Guard C pre-screen, EntrySLRealizable/
Guard B, stops-level band, place) is read+validated UNCHANGED.
  Rejected OFFSET (declarative input placing the line at ref+/-offset):
  non-interactive (edit input + re-run to change price) and a fixed
  per-run offset is really a Stage 9 Step 3 auto-entry seed - building it
  here duplicates Step 3 and gives no interactive-flow value. Offset held
  in reserve for Step 3.
  Sub-decisions carried into the matrix (seal or correct there):
   - Buttons created + polled in TESTER ONLY (MQL_TESTER-gated), so the
     LIVE panel stays byte-identical (live already has native drag).
   - Step = input InpTesterNudgePts, default 50, clamp >=1.
   - NO band clamp on movement (REVERSED from the Gate 1 brief's clamp
     rec): the line may legitimately sit either side of market (buy-limit
     below / buy-stop above; order type inferred at confirm). Clamping at
     the band would block legitimate cross-market placement. Movement is
     free; CONFIRM remains the sole authority and already refuses+keeps
     the line for re-nudge. Each nudge logs the new line price (INFO;
     placement price, not a live money change).
  NO code yet - matrix must seal first (STAGE9_STEP2_MATRIX.md).

2026-07-22 CLAUDE CODE TRANSITION - compile/deploy boundary (see
docs/CLAUDE_CODE_TRANSITION_v2.md). Decision: compile AND deploy stay
MANUAL and MT5-side, Jeff's responsibility; NO automated compile gate in
the repo. Git is the SOURCE OF TRUTH for TRTM.mq5 - on any repo-vs-MT5
mismatch, Git wins. Quick-verify which build is loaded: the TRTM_BUILD
tag is shown on the chart panel and the Experts-log init line; compare to
STATE.md build:. sha256_16 (resume protocol) is the byte-level backstop.
  Rejected automated gate zero (compile_gate.py, built + verified this
  session then dropped): it shelled MetaEditor64.exe from the repo, which
  re-couples Claude Code to the MT5 toolchain - the exact thing the repo
  separation exists to avoid. Verified once that the b33 repo copy
  compiles clean (0 errors / 0 warnings) before dropping it.
  Verified gotchas (for anyone who ever revisits CLI compile): MetaEditor
  /log is UTF-16, and its process EXIT CODE is not pass/fail (returned 1
  on a clean 0/0 build) - parse the "Result:" line, never $?.

2026-07-25 E6 T3-O0 ADOPT TIER 3 = YES, DEFAULT-OFF (Gate 1 LOCKED; matrix +
plan still required before any code). Tier 3 (Drawdown Reduction Tier 3 -
PARTIAL-lot close) is adopted as a DISTINCT third trigger alongside sealed
Tier 1 (points) and Tier 2 (percent-of-balance), behind a new default-off
input InpEnableTier3 (same opt-in pattern as InpEnableTier1/Tier2). E6 now
opens its remaining Gate 1 sub-decisions T3-O1..O9 one at a time.
  EVIDENCE (E7 R2, docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md, two fires
  recomputed to the cent from docs/STM Drawdown Reduction Tier3 Logs.txt):
  Tier 3 SLICES the oldest anchor (closes ClosePercent of its lots, floored
  to lot step, anchor >= MinLots) and closes all profitables FULLY, then tests
  the CLOSING group's VWAP - {anchor SLICE being closed} + profitables, i.e.
  the anchor counted at its SLICE vol (the lots being closed), NOT its
  remainder - against MinProfitPoints (200). Structurally identical to Tier 1
  (which gates on {full anchor} + profitables); Tier 3 just substitutes the
  anchor's slice for its full volume, the remainder surviving untouched. This
  lets Tier 3 fire in the deep-drawdown regime
  Tier 1/Tier 2 are structurally locked out of: at FULL anchor both observed
  groups were at/below break-even (fire 1 06/25 +80.1 pts, ~+10 USD; fire 2
  07/02 -77.4 pts, a net LOSS), so T1 (needs 150) and T2 (needs ~+30 USD) both
  failed - only the sliced-anchor reframing cleared 200 (both fires ~+206 pts).
  So Tier 3 is a genuine, non-redundant deeper pressure valve, not a duplicate
  of T1/T2. It is POINTS-based like Tier 1, so it needs NO cross-currency FX
  path (unlike Tier 2's T2-O7).
  RATIONALE for adopt: the reference demonstrates a real capability gap the
  sealed tiers cannot cover (harvesting profit while a deep anchor loss keeps
  the full-basket gate underwater), and default-off keeps it strictly opt-in
  with zero behavior change to any existing chart until Jeff enables it.
  Rejected DECLINE/PARK: judged premature to forgo the capability given clean
  two-fire evidence; the cost (a new partial-lot primitive + a C3-ladder
  interaction) is real but is exactly what the remaining T3-O sub-decisions
  and the matrix exist to bound - not a reason to skip Gate 1.
  Rejected ADOPT-WITH-SCOPE-CAVEAT-FIRST: no scope constraint is foundational
  enough to precede the primitive (T3-O1) and gate (T3-O2) definitions; any
  such constraint (slice-only, drawdown-floor gating) is cleaner to lock as
  its own T3-O row once the mechanism is defined, not bolted onto O0.
  UNOBSERVED / carried into later T3-O rows (NOT decided here): the partial-
  close primitive itself (O1), MinLots eligibility + sub-MinLots anchor
  behavior (O3), slice rounding mode (O4 - floor observed, 0.015->0.01),
  sliced-anchor vs C3 preserved-index ladder (O5), 3-way T1/T2/T3 precedence
  (O6 - the tiers never competed in the run; T3 only fired when T1/T2 failed),
  close order + partial-fill on the slice leg (O7), BUY lap (O8 - all Shadow
  data SELL), post-fire TP + recovery refresh (O9). NO code, NO matrix yet.

2026-07-25 E6 T3-O2 FIRE CONDITION = FIXED-PERCENT SLICE + SLICED-ANCHOR VWAP
GATE (Gate 1 LOCKED; matrix + plan still required before any code). Tier 3's
trigger: (1) slice = ClosePercent of the OLDEST anchor's lots (anchor must be
>= MinLots to be eligible; rounding + minimum deferred to T3-O4); (2) form the
CLOSING group = {the anchor SLICE being closed, i.e. the anchor counted at its
slice vol NOT its remainder} + ALL currently-profitable positions; the
remaining anchor survives and is NOT in the gate group; (3) FIRE iff that
group's lot-weighted VWAP clears MinProfitPoints per lot in front of the
direction-derived far-side price (SELL->Ask, BUY->Bid). Structurally = Tier 1
(anchor slice substituted for full anchor); the gate is measured over the
ACTUALLY-CLOSED lots, same as Tier 1's group gate.
  ARITHMETIC PROOF the gate uses SLICE not remainder (fire 2, anchor #4 full
  0.03 / slice 0.01 / remaining 0.02, logged header VWAP 1.92888): slice 0.01
  -> (0.01*1.88917+0.13*1.93219+0.12*1.92861)/0.26 = 1.92888 MATCHES; remaining
  0.02 -> /0.27 = 1.92741 does NOT; full 0.03 -> /0.28 = 1.92605 does NOT. Fire
  1 (slice==remaining==0.01) cannot disambiguate; fire 2 forces slice.
MinProfitPoints is Tier 3's OWN threshold (Shadow ran 200; TRTM default set in
a later row). POINTS-based like Tier 1 => NO cross-currency valuation path
(Tier 2's T2-O7 does NOT recur).
  BASIS: recomputed exact on both Shadow fires (docs/ENHANCEMENT_INPUT_2026-
  07-25_tier3.md OBSERVED-1/6): sliced-anchor VWAP 1.90990 (fire 1) and 1.92888
  (fire 2), both ~+206 pts vs the 200 gate. The sliced framing is what lets
  Tier 3 fire where T1/T2 cannot (full-anchor +80.1 / -77.4 pts).
  Rejected THRESHOLD-SOLVED MINIMAL SLICE (close only the smallest slice that
  makes the group clear MinProfitPoints): more anchor-preserving in principle,
  but at TRTM's 0.01 lot step it COLLAPSES to the same 1-step slice (fire 2:
  max clearing slice <= 0.0104 -> 0.01, identical to fixed-percent-floored), so
  it buys nothing at TRTM's lot regime while adding non-reference math and extra
  matrix rows. Re-open only if TRTM ever trades large enough anchors that the
  two diverge materially.
  Rejected FULL-ANCHOR GATE + PARTIAL EXECUTION (gate like Tier 1 on the full
  anchor, execute a partial close): can NEVER fire when Tier 1 doesn't, so it
  forfeits the entire deep-drawdown capability that is Tier 3's whole reason to
  exist - both observed fires would not have fired. Recorded rejected.

2026-07-26 E6 T3-O3 MinLots = ANCHOR-ELIGIBILITY FLOOR; SUB-MinLots ANCHOR ->
TIER 3 STANDS DOWN (Gate 1 LOCKED; matrix + plan still required before any
code). The oldest anchor must have full volume >= MinLots (>= 2 lot steps) to
be Tier-3-eligible, so a >= 1-step slice always leaves >= 1 step alive (Tier 3
is a PARTIAL close by definition - it must never zero the anchor). When the
oldest anchor is BELOW MinLots (e.g. it is already at the 0.01 lot floor, or a
prior Tier 3 fire reduced it below MinLots), Tier 3 STANDS DOWN for that basket
- it does NOT slice, does NOT fall through to a full close - and the full-close
tiers (Tier 1 points / Tier 2 percent) cover that basket if THEY qualify.
  BASIS (Jeff 2026-07-26, and the reason all three tiers were enabled in the
  E7 R2 run): "Tier 3 could not fire if the anchor is already 0.01 - nothing to
  slice." A 0.01 anchor sliced by any amount is a FULL close, which is Tier 1's
  job, not Tier 3's. MinLots exists precisely to guarantee slice-ability with a
  surviving remainder. Shadow ran MinLots=0.02 (TRTM default set in a later
  row); at TRTM's 0.01 base lot MinLots=0.02 means "anchor must be at least the
  2nd rung's size", which the martingale ladder reaches quickly.
  EVIDENCE the stand-down is real, not theoretical: fire 1 left anchor #3 at
  0.01 (< MinLots 0.02); it was never sliced again - the next Tier 3 fire (fire
  2) sliced the NEW oldest eligible anchor #4 (0.03) after #3 had left the book.
  COUPLING to T3-O6 (precedence, still open): "stands down, Tier 1/2 cover it"
  presumes Tier 1/2 are ENABLED and may fire on the same basket - so the 3-way
  precedence/coexistence decision (O6) must state what happens to a
  sub-MinLots-anchor basket when Tier 1/2 are DISABLED (then no tier fires; the
  basket rides to its sequence TP - acceptable, but must be stated).
  Rejected SLICE-THEN-FULL-CLOSE FALLBACK (Tier 3 closes a sub-MinLots anchor
  FULLY itself): duplicates Tier 1's close mechanics inside Tier 3, blurs the
  tier boundary (Tier 3 = partial ONLY), and forces Tier 3 to own a full-anchor
  loss-realization path it was designed to avoid. If a full close of a tiny
  anchor is wanted, that is Tier 1's role - enable Tier 1. Re-open only if a
  Tier-3-standalone (Tier 1/2 off) config becomes a real requirement AND tiny
  anchors must still be harvested.

2026-07-26 E6 T3-O4 SLICE NORMALIZATION = FLOOR TO LOT STEP, CLAMPED PARTIAL
(Gate 1 LOCKED; matrix + plan still required before any code).
    slice = floor(anchorLot * ClosePercent / lotStep) * lotStep
    slice = max(1 lotStep, min(slice, anchorLot - 1 lotStep))
FLOOR (not round, not ceil); a lower clamp of 1 lot step so a small ClosePercent
still slices something; an upper clamp of anchorLot - 1 step so the slice is
ALWAYS partial (never zeroes the anchor - Tier 3 is partial by definition, a
full close is Tier 1's job). With T3-O3 (anchor >= MinLots >= 2 steps) the
clamps are always satisfiable.
  BASIS: matches Shadow exactly (fire 1: floor(0.02*0.5)=0.01; fire 2:
  floor(0.03*0.5=0.015)=0.01, NOT 0.02). Because the gate is measured over the
  CLOSED lots (T3-O2), a LARGER slice puts MORE anchor loss into the closing
  group and makes the gate HARDER: fire 2 under round-half-up (slice 0.02) gives
  group VWAP (0.02*1.88917+0.13*1.93219+0.12*1.92861)/0.27 = 1.92741, margin 59
  pts < 200 -> would NOT have fired. So FLOOR is simultaneously (a) the reference
  behavior, (b) the least loss realized per fire (gentler valve), and (c) the
  only rounding under which both observed fires actually clear the gate.
  NOTE the realized close fraction DIVERGES from nominal ClosePercent when floor
  bites (fire 2: 0.01/0.03 = 33%, not 50%); at TRTM's 0.01 base lot the floor
  makes the slice effectively 1 lot step for any anchor of 0.02-0.03, so
  ClosePercent only bites materially on larger anchors. Documented, not a defect.
  Rejected ROUND-HALF-UP and CEIL: realize more anchor loss per fire, diverge
  from Shadow, and (round-up) would have blocked a real observed fire.

2026-07-26 E6 T3-O5 SLICED ANCHOR = RESIDUAL SURVIVOR; C3 + E4 O1 INHERITED,
NOTHING STORED (Gate 1 LOCKED; matrix + plan still required before any code).
After a Tier 3 slice, the anchor remains a SINGLE open position at its
UNCHANGED entry price / ladder address, at reduced volume (full - slice). It is
treated as an ordinary smaller open position:
  - Rungs ABOVE the anchor keep their C3 preserved-index addresses (a rung is
    an ADDRESS with a DERIVED lot = ComputeLevelLot(N)); the profitables that
    Tier 3 closed re-arm by the sealed E4 O1 unrestricted-refill rule (recovery
    re-adds above the top survivor as price moves adverse). Tier 3 changes
    NOTHING about that path.
  - The anchor (the FAVOURABLE extreme) NEVER re-arms - inherit E4 O1's
    direction-reality: the ladder extends adverse-only, above the top survivor,
    never back down to the anchor. A sliced anchor therefore just stays smaller
    until basket TP / SL / a further slice (if still >= MinLots).
  - The residual volume is NOT a new persisted field. TRTM already LIVE-READS
    open position volumes on reconcile; the broker position's volume IS the
    state. C3's derived-only / nothing-stored invariant is preserved.
  - All money math reads the ACTUAL reduced volume: lot-weighted VWAP/TP (E1
    basis) correctly shifts when the anchor shrinks; the SL anchor price is the
    anchor's ENTRY, unchanged by slicing volume; ComputeLevelLot governs only
    the NEXT rung to ADD (by Level counter), never the anchor's current lot, so
    the SEALED martingale path is untouched.
  MATRIX REQUIREMENT: must-NOT-fire rows proving the sealed martingale / ladder
  / SL-anchor output is BIT-IDENTICAL to E5-b37 when Tier 3 is disabled or does
  not fire, plus a row proving a post-slice basket's VWAP/TP recompute reads the
  reduced anchor volume (fire 1 recompute: survivor VWAP 1.89921 over 0.34 with
  anchor at its remaining 0.01 - already confirmed in the E7 R2 input doc).
  Rejected RE-ARM ANCHOR TO FULL DERIVED LOT: contradicts sealed E4 O1 (anchor
  never re-arms; adverse-only extension). Rejected PERSIST RESIDUAL AS NEW STATE
  FIELD: breaks C3 derived-only, adds uninit-field / backward-compat / self-test
  burden, and is redundant because position volume is already live-read.

2026-07-26 E6 T3-O6 PRECEDENCE = T2 -> T1 -> T3, SINGLE-FIRE PER TICK (Gate 1
LOCKED; matrix + plan still required before any code). Extend E5's sealed
EvaluateBasketClose dispatcher (Tier 2 percent FIRST, then Tier 1 points) with
Tier 3 LAST: evaluate Tier 2, else Tier 1, else Tier 3; the FIRST tier that
qualifies fires and returns; NO other tier fires that tick (a later tick
re-evaluates the smaller basket). Tier 3 (partial) is the last-resort valve,
reached only when the FULL-close tiers do not qualify - the deep-drawdown case
it exists for.
  RATIONALE: T1/T2 are FULL closes (relieve the whole anchor + all profitables,
  banking profit on the entire group); T3 is PARTIAL (slices the anchor, leaves
  it alive). When both a full tier and T3 qualify on one tick, the full close
  relieves more exposure for the same guaranteed-positive harvest, so full is
  preferred - T3 last. Note T1 (150) and T3 (200) can each qualify independently
  (T3's slice-group margin > T1's full-group margin, but T3's threshold is
  higher), so both-qualify and only-one-qualify ticks all occur; last-place T3
  is correct in every case.
  UNOBSERVED: the tiers NEVER competed in the E7 R2 run (T3 fired only when
  T1/T2 failed at full anchor). MATRIX MUST carry a CONSTRUCTED tick where T1
  (full) AND T3 (slice) both qualify, proving the dispatcher fires T1 and skips
  T3; plus a T2+T3 both-qualify tick.
  Rejected T3-FIRST: a more-permissive partial pre-empts a qualifying full
  close, leaving more anchor exposure alive for less relief. Rejected MULTI-FIRE
  (>1 tier per tick): E5 is single-fire by design; overlapping groups on one
  tick risk double-acting on shared positions and break the per-fire tested
  arithmetic.
  SPUN OUT -> E8 (Jeff's idea 2026-07-26, ADOPTED as a separate item, NOT folded
  into E6): after a full T1/T2 close banks net +P, spend up to a fraction f of P
  to ALSO slice the NEW anchor (next-oldest, deepest remaining loser), combined
  tick staying net >= (1-f)*P >= 0. Distinct from the three self-funding tiers
  because it realizes a PURE loss on a loser funded by external harvest - a
  directional tail-risk lever that bets AGAINST the basket's own mean-reversion
  recovery thesis (nets neutral at the instant; buys reduced future tail
  variance + a VWAP nudge toward TP). Given the risk-changing character it gets
  its own Gate 1, not E6's reference-derived scope. See E8 backlog entry.

2026-07-26 E6 T3-O7 CLOSE ORDER = PROFITABLES-FIRST, ANCHOR-SLICE LAST (inherit
E4 O5) (Gate 1 LOCKED; matrix + plan still required before any code). The Tier 3
group closes in this order: (1) close every profitable member FULLY, descending
ticket; (2) slice the anchor LAST via the partial-close primitive. Failure rule:
if ANY profitable leg fails, ABORT the whole fire BEFORE the anchor is touched -
the loss leg never opens, so no half-closed group exists. If the anchor SLICE
itself fails or short-fills, the covering profit is ALREADY banked (net positive
secured), so accept + log, NO retry - the anchor simply stays at a larger volume,
which is safe (it is a survivor either way and re-qualifies on a later tick).
  BASIS: identical reasoning to sealed E4 O5 - realize the loss leg only after
  the covering profit is banked, so a mid-group failure can never leave the tick
  net-negative. Here the loss leg is a PARTIAL close, which only strengthens the
  case (the anchor remaining larger on a failed slice is harmless). DIVERGES
  from Shadow's OBSERVED anchor-slice-first order (E7 R2 OBSERVED-4), exactly as
  T1 diverged. Market-close slippage vs the gate-tick margin is accepted as in
  T1/T2.
  PRIMITIVE NOTE (feeds T3-O1): the anchor leg uses a PARTIAL close
  (CTrade::PositionClosePartial-class) of the slice volume; the profitables use
  the existing full-close path. Partial-close broker constraints (min partial
  lot, lot step) are an O1 detail; a broker rejection of the partial leg falls
  into the accept+log branch above.
  Rejected ANCHOR-SLICE-FIRST (Shadow): realizes the anchor loss before the
  cover is banked; a mid-group profitable failure leaves net-negative. Rejected
  SLICE-LAST-WITH-RETRY: adds retry logic T1 lacks for marginal benefit (a failed
  slice leaves a harmless larger survivor).

2026-07-26 E6 T3-O1 / T3-O8 / T3-O9 = INHERIT SEALED BEHAVIOR (Gate 1 LOCKED;
matrix + plan still required before any code). The three near-certain inherits,
confirmed by Jeff 2026-07-26. These COMPLETE E6 Gate 1 (T3-O0..O9 all locked).
  T3-O1 PARTIAL-CLOSE PRIMITIVE = native CTrade::PositionClosePartial(ticket,
  sliceVol) through the EXISTING sealed order-send wrapper + retcode handling.
  Slice volume already normalized by T3-O4. MT5 keeps the SAME ticket at reduced
  volume, so the anchor keeps its identity / ladder address (supports T3-O5
  live-read; no new persisted state). Broker min-partial-lot / lot-step rejection
  routes to T3-O7's accept+log branch. Rejected EMULATION (close full + re-open
  remainder): new ticket / new entry / lost identity (breaks T3-O5), double
  spread, worse re-entry price.
  T3-O8 FAR-SIDE = DIRECTION-DERIVED (inherit E4 O4): SELL closes at Ask
  (OBSERVED both fires: 1.90784, 1.92682), BUY at Bid (platform invariant). Matrix
  carries BOTH laps; the BUY lap is validated against the platform invariant +
  arithmetic (Tier 3 BUY fire is UNOBSERVED - all Shadow data SELL). Rejected
  SELL-ONLY: leaves the known direction-only defect class E4 O4 exists to prevent
  (a fixed Bid/Ask read passes SELL, breaks on the first live BUY basket).
  T3-O9 POST-FIRE = E1 LOT-WEIGHTED TP + C3 PRESERVED-INDEX (inherit): recompute
  sequence TP as the lot-weighted VWAP over survivors INCLUDING the reduced
  anchor at its remaining volume (OBSERVED exact, fire 1: avg 1.89921 / vol 0.34 /
  count 7, TP = VWAP - offset); REJECT Shadow's count-based re-index in favour of
  C3 preserved-index (Level from the highest surviving rung's address);
  RefreshRecoveryState ATOMIC with fire completion (E4 O3). Rejected SHADOW
  COUNT RE-INDEX: leaves the basket permanently lighter at the top, degrading TP
  (already rejected for T1/T2).

2026-07-26 E6 T3-GATE A = OWN INPUT InpTier3MinTrades, DEFAULT 4 (Gate 1 LOCKED;
matrix + plan already carry it). Flagged by Jeff 2026-07-26: Tier 3 must have its
own "Min Trades to Activate" input, SIMILAR TO Tier 1 (InpTier1MinTrades) and
Tier 2 (InpTier2MinTrades) - it had been carried in the input surface but never
locked as its own decision (the E5 log has an explicit "GateA" entry; E6's did
not). DECISION: Tier 3 has its OWN count-based Gate A input InpTier3MinTrades
(default 4, matching Shadow InpPC3_MinTrades and both other tiers); Tier 3 is
eligible only when openCount >= InpTier3MinTrades, independent of Tier 1/Tier 2's
own MinTrades. TIER-3 NUANCE (documented, not a divergence): a Tier 3 fire
reduces the open count only by the PROFITABLES closed - the anchor SURVIVES the
slice and stays counted - so the count falls more slowly per fire than a full-
close tier. Dormancy/re-activation rows G-D3 (T3-D1/D2) already reflect this.
  Rejected SHARE a single MinTrades across all three tiers: each tier is an
  independent valve with its own thresholds (Shadow ships PC1/PC2/PC3 MinTrades
  separately); a shared gate would couple their activation. Rejected NO Gate A
  (fire at any depth): loses the shallow-basket dormancy guard T1/T2 have.
  NO code/matrix change - InpTier3MinTrades (default 4) is already in
  docs/E6_MATRIX.md (input surface + G-T3/G-D3) and the Gate 3 plan (TP-1/TP-5a);
  this entry records the previously-implicit decision.

## E6 (Tier 3) GATE 1 COMPLETE - 2026-07-26
All ten sub-decisions + Gate A locked (T3-O0 adopt/default-off; O1 native
partial-close primitive; O2 fire condition = fixed-percent slice + SLICED-anchor-
VWAP gate; O3 MinLots eligibility + sub-MinLots stand-down; O4 slice = floor,
clamped partial; O5 sliced anchor = residual survivor, C3 + E4 O1 inherited,
nothing stored; O6 precedence T2->T1->T3 single-fire; O7 profitables-first /
slice-last / abort-before-slice; O8 direction-derived far side, both laps; O9 E1
VWAP TP + C3 index; GATE A = own InpTier3MinTrades default 4, mirroring T1/T2).
Jeff's profit-funded follow-on slice SPUN OUT to E8 (own Gate 1).
GATE 2: docs/E6_MATRIX.md SEALED rev 1 by Jeff 2026-07-26 (13 row-groups, 36
rows; both reference fires recomputed to the cent; slice-vs-remainder
disambiguated by FIRE 2; floor requirement proven; T2->T1->T3 precedence rows
UNOBSERVED -> verify LIVE; must-NOT-fire byte-identity + SL-not-re-anchored
rows). GATE 3: docs/E6_PLAN_2026-07-26_gate3.md DRAFTED 2026-07-26 (8 touch
points, all in src/TRTM.mq5; +70/95 lines est.). EXTENDS E5-b37's shared
dispatcher / FormBasketGroup / FireGroupClose - adds SliceLegAtMarket
(PositionClosePartial sibling, NO MarkEAClosed since the anchor survives),
ComputeSlicedAnchorVWAP (gate on the SLICE vol), an anchorSliceVol param on
FireGroupClose (default 0 => T1/T2 byte-identical), a 3rd dispatcher branch
(T2->T1->T3), 5 inputs, the DD-Reduce dashboard extension. THREE findings REMOVE
code: F-a SL-not-re-anchored is FREE (re-anchor keyed on anchor LEVEL, unchanged
by a slice); F-b survivor TP self-corrects (ComputeTargets reads live volume);
F-c F3 impossible (OnTradeTransaction is EMPTY - attribution poll-based). NO new
persisted field. PLAN CONFIRMED by Jeff 2026-07-26.
BUILD: E6-b38 IMPLEMENTED 2026-07-26 (repo src src/TRTM.mq5, f7766c859e4d3c7a /
4674, +106 lines). All 8 touch points done: TRTM_BUILD E6-b38; 5 Tier 3 inputs
(InpEnableTier3 default off, MinTrades 4, MinProfitPts 200, MinLots 0.02,
ClosePercent 50); ComputeSlicedAnchorVWAP (gate on slice vol); SliceLegAtMarket
(PositionClosePartial, NO MarkEAClosed); FireGroupClose +anchorSliceVol=0.0
(T1/T2 unchanged); Tier 3 dispatcher branch (T2->T1->T3); DD-Reduce dashboard
+T3; call-site + tag. Hygiene clean (0 bare LF, ASCII, brace -1 baseline, no new
global/persisted field).

GATE ZERO PASSED - 2026-07-26. Compiled in Jeff's terminal 12:34:12, **0 errors,
0 warnings** (metaeditor.log), on a source byte-identical to the repo manifest
(f7766c859e4d3c7a / 4674). TRTM.ex5 rebuilt 12:35:02; EA re-initialized as E6-b38
on XAUUSD.s + BTCUST with self-test PASS + Reconcile FLAT. An earlier compile of
the same source at 01:48:22 was also 0/0; Jeff's call was to re-witness gate zero
inside the session rather than accept the reconstructed log line, so the 12:34
compile is the one of record. DEPLOYED: runtime copy == repo, no deploy drift.

STATE CORRECTION - 2026-07-26 (bookkeeping, not a seal). This manifest previously
asserted E6-b38 was NOT compiled, NOT deployed, and UNCOMMITTED. All three were
false against disk + git at resume: the build had already been compiled (01:48:22),
deployed (runtime hash == repo), committed (8722fcc) and PUSHED (origin/main =
8722fcc, carrying E4-b36 and E5-b37 up with it) out-of-band between sessions. The
resume protocol did NOT trip a STOP, because the only STOP condition - repo src !=
f7766c859e4d3c7a / 4674 - held true throughout. Corrected here so "disk + git are
truth" is not contradicted by its own record. E6 remains UNSEALED at Gate 4.

BUILD-vs-PLAN DIVERGENCES (recorded, neither a money-path defect):
 (a) The build uses NormalizeDouble(sliceVol, 8) (TRTM.mq5:2415); the plan wrote
     NormalizeDouble(sliceVol, 2). The build is SAFER - 2 decimals would corrupt
     the slice on any symbol with a 0.001 lot step (0.005 -> 0.01). Identical on
     XAUUSD.s / GBPAUD.s (step 0.01), so money-neutral here and strictly better
     elsewhere. ACCEPTED as-is.
 (b) TP-6 dashboard built with direct string concatenation rather than the plan's
     parts[] array sketch. Functionally identical output. Cosmetic.
 (c) NIT, not yet fixed: the EvaluateBasketClose header comment (TRTM.mq5:2300-2308)
     still reads "Tier 2 FIRST, then Tier 1" / "Both share ONE group" - stale at
     three tiers. TP-7's call-site comment (4633) WAS updated. A comment-only edit
     re-bumps the manifest sha, so bundle it with the seal commit rather than
     dirtying a verified build.

## E6 (Tier 3) SEALED - 2026-07-26. GATE 4 CLOSED.
Jeff's explicit word, 2026-07-26. E6-b38 (f7766c859e4d3c7a / 4674) is the CURRENT
SEALED BUILD. Ten XAUUSD.s tester runs, nineteen Tier 3 fires, every money number
recomputed to the cent on two independent derivations.
KEY ROWS, all closed on LIVE evidence:
 - T3-6 gate-on-SLICE (the crux): Run C three-way at Ask 4202.38 - slice 0.01 ->
   4205.1978 (+281.8, FIRES); remainder 0.02 -> 4200.0360 (-234.4); full 0.03 ->
   4195.8127 (-656.7). Only the slice reproduces the logged VWAP, and BOTH alternatives
   are negative - a stronger demonstration than the Shadow reference gave.
 - T3-H3 SL byte-identical (the key divergence from T1/T2): Run E both laps, SELL
   4243.58 / BUY 4108.79 unchanged across every slice, ZERO "SL re-anchored" lines
   (E5's Tier 2 logged one per fire). The BUY stop was then HIT at 4108.77 - all eight
   legs including the twice-sliced anchor. A genuine broker-held stop fired.
 - T3-4 Gate B: blocked band RECOMPUTED from the entries (209.5 / 300.0 / 359.0 pts
   traversed with no fire) and the threshold predicts both fire prices to within one
   tick (4180.495 vs 4180.62; 4129.943 vs 4129.98).
 - T3-SL4 stand-down: absence across an 8-level (Run C) and 15-level (Run D1') rebuild.
 - T3-G2 invariant: held on all 19 fires, and INDEPENDENTLY confirmed against the
   ACCOUNT BALANCE in Run G (+56.84 realized -> balance 10056.84 -> Tier 2's bar 18.10).
   PositionClosePartial banks exactly what the sliced-VWAP math predicts.
DISPOSITIONS (not live evidence - recorded honestly):
 - T3-PR2 / T3-PR3 CODE-GUARANTEED. Both-qualify is JUMP-ONLY. Demonstrated across
   three constructions (F1 equal bars, F2 D2-derived, G1 T2-paired) with every
   counterfactual margin recomputed: the gap (sliced - full) moves with anchor volume
   and depth (134.2 / 289.4 / 915.8 observed), so the qualifying threshold pair differs
   at every candidate tick and each change rewrites the path it is trying to hit.
   Nearest approach: Run G 19:35:08, Tier 3 ELIGIBLE and 99.4 pts short while Tier 2
   fired. Same basis E5 used to seal T2-PR1, with better evidence.
 - T3-K1 / T3-K2 INHERITED, Run H NOT run (Jeff's call). Reconcile carries no Tier 3
   code, the "_lN_" level survives a partial close, nothing is persisted. RESIDUAL:
   never exercised against an actual sliced anchor across a restart - accepted; run
   opportunistically before live deployment.
 - T3-3 dose-response only (MinTrades 4/6/8 -> first fire at count 4/6/14, never below).
   A blocked-qualifying-tick recompute is structurally unobtainable: Tier 3 is last so a
   blocked tick logs nothing, and Tier 1 cannot witness it (locked out in Tier 3's regime
   by construction).
 - T3-DS1 display-only, code-verified, NOT visually confirmed. Non-blocking.

## LIVE INCIDENT 2026-07-27 - UNMANAGED RECOVERY POSITION ON VANTAGE (XAUUSD.sc)
NOT an E6 defect. The affected code (RegisterNewRecovery, RegisterButtonL1,
CancelOwnPendingOrders) is Stage 4/5 CORE, sealed long before E6; E6 touched none of it.
It is a latent assumption that has been present since Stage 4 and only surfaces on a
broker whose fills are ASYNCHRONOUS.
SYMPTOM (Jeff's live log, XAUUSD.sc, magic 725639, stops 20 / freeze 10):
  "L1 SELL OPENED via button: 0.01 lots @ 0.00 (deal 0)"
  "Recovery L2 OPENED: 0.02 lots SELL @ 0.00 (deal 0)"
  "RegisterNewRecovery: L2 order reported filled but position not found"
  "CTrade::OrderSend: cancel #459172826 [invalid request]" (10013)
DIAGNOSIS: price 0.00 + deal 0 => the server returned TRADE_RETCODE_PLACED - order
accepted, NOT yet executed, so no deal and no POSITION exist at that instant. Both send
sites (2170 recovery / 3274 button) accept PLACED as success and then IMMEDIATELY require
a position: RegisterNewRecovery scans PositionsTotal() for magic + "_lN_" and finds
nothing. The 10013 is the same race - CancelOwnPendingOrders walked OrdersTotal() and hit
the still-in-flight MARKET order, mistaking it for a pending.
WHY IT BECAME EXPOSURE, not just a noisy log: there is NO self-heal while a sequence is
live. CheckOwnPendingFillWhenFlat() is gated on levelCount == 0, and FindUntrackedOurL1()
skips lvl > 1 entirely. So an unregistered recovery level stays ORPHANED - no TP/SL, not
counted, invisible to liveness and to the basket-close tiers - until the sequence goes
flat or the EA restarts (RebuildLiveMap does pick it up by magic + comment).
COMPOUNDING RISK: g_state still held only L1, so ComputeRecoveryTrigger kept computing
from L1's entry and the trigger stayed satisfied - the EA would open ANOTHER 0.02 "L2" on
every subsequent M5 bar close. Duplicate stacking.
MITIGATION GIVEN: AutoTrading OFF to stop further opens, then re-attach the EA so
Reconcile/RebuildLiveMap rebuilds the sequence from live positions ("broker wins"), close
any duplicate _l2_ positions manually first.

## BROKER-COMPATIBILITY AUDIT 2026-07-27 (source grep, zero hits on all three)
  SetTypeFilling / ORDER_FILLING / SYMBOL_FILLING  -> 0 hits
  ACCOUNT_MARGIN_MODE / MARGIN_MODE_               -> 0 hits
  SYMBOL_TRADE_EXEMODE                             -> 0 hits
 ACTIVE  async fill (above).
 LATENT  NETTING ACCOUNTS. TRTM is structurally HEDGING-ONLY - the grid/martingale model
         needs multiple same-symbol same-direction positions. On a netting account L2
         MERGES into L1, PositionsTotal() shows one averaged position and the ladder /
         anchor model collapses SILENTLY. No guard exists. Vantage gave a hedging account
         so this is not biting now.
 LATENT  FILLING MODE. CTrade defaults to ORDER_FILLING_FOK and the EA never negotiates.
         Vantage accepted FOK on XAUUSD.sc (orders did fill), so not currently a problem;
         on an IOC/RETURN-only symbol it would be 10030 with no diagnostic.
 LATENT  COMMENT INTEGRITY - and this one intersects E6. Level tracking depends ENTIRELY
         on parsing "_lN_" from POSITION_COMMENT (10 call sites). Some brokers/bridges
         rewrite comments, notably ON PARTIAL CLOSES. If Vantage rewrites a SLICED
         anchor's comment then after a restart RebuildLiveMap logs "unparseable level
         comment - counted, level unknown" and assigns lvl = 0, which makes that position
         the ANCHOR under the lowest-level rule. That is exactly the T3-K1 scenario closed
         by INHERITANCE at the E6 seal. => RUN H IS NOW OVERDUE, and must be run on
         Vantage, not only on the Doo demo.

## b39 GATE 3 - DECISIONS TAKEN AT PLAN TIME (2026-07-29)
LOCKED DECISION E9-P1 (admission filter shape): ONE SHARED HELPER. Extract a single
  IsAdoptableOurPosition(ticket, &lvl) carrying RebuildLiveMap's exact admission filter,
  and route the watcher, RegisterNewRecovery's fast path and FindUntrackedOurL1 through
  it. WHY: W-1 says "identical filter to RebuildLiveMap (2471) - reuse, do not reinvent",
  and the three filters are NOT in fact identical today (see E9-P2). One admission truth.
  ACCEPTED COST: touches FindUntrackedOurL1 (Stage 5) and RegisterNewRecovery (Stage 4),
  both sealed - so R-1 must show the Doo Run A/C diffs are empty.
  REJECTED: standalone watcher filter leaving 1913/3141 untouched - smallest blast radius
  on sealed code, but keeps three copies of the filter and leaves the E9-P2 divergence
  live. Jeff's call 2026-07-29.

LOCKED DECISION E9-P2 (symbol comparator): NORMALIZED, matching RebuildLiveMap
  (NormalizeSymbol(POSITION_SYMBOL) == g_symbolNorm), NOT the raw != _Symbol used at 1919
  and 3146. FINDING BEHIND IT: NormalizeSymbol (354) strips separators and uppercases, so
  XAUUSD.sc / XAUUSD.s / XAUUSD all collapse to XAUUSD. The sealed startup path
  (RebuildLiveMap 2485) has therefore always been LOOSER than the two registration paths.
  Adopting the normalized comparator makes the watcher agree with Reconcile BY
  CONSTRUCTION. Divergence is nil on both evidence brokers - one gold chart per account,
  so normalized and raw select the same single position set, and Run A/C should diff empty.
  REJECTED: raw == _Symbol - trivially safe for R-1 and strictly narrower, but contradicts
  W-1's stated reuse target and would make startup and steady-state disagree PERMANENTLY
  about which positions are ours. Jeff's call 2026-07-29.

LOCKED DECISION E9-P3 (account switch): NO CODE IN b39; deferred to E9 with O3-O6.
  Jeff's question 2026-07-29 - what happens if the user switches MT5 account (Doo <->
  Vantage) rather than running both at once. ANSWER FROM CODE: DeriveMagic (375-384) hashes
  the NORMALIZED symbol ONLY - no account login, no server - and the state filename (4482)
  is state_<symbolNorm>_<magic>.json, so XAUUSD.s and XAUUSD.sc derive the SAME magic AND
  the SAME state file. On an account switch the new account re-inits onto the previous
  account's state file. It SELF-HEALS: Reconcile (2686) rebuilds the live map first and
  live-map-wins, PositionSelectByTicket fails on every foreign ticket, the live map comes
  back empty, the stale file is discarded at 2724-2736 and the EA lands FLAT.
  This is TRUE IN SEALED b38 TODAY - neither b39 nor E9-P2 creates it, and E9-P2 is
  PROTECTIVE here (the flat watcher then scans with the same comparator Reconcile just
  used, so a real our-magic tagged position on the new account is adopted rather than
  orphaned). Cross-broker position MIXING is impossible: one terminal shows one account.
  RESIDUAL, recorded as W-7: the stale-file inheritance is untested against a POPULATED
  file from a foreign account. Account-scoped identity (login/server in magic + filename)
  -> E9. Jeff's call 2026-07-29.

MATRIX AMENDMENT (Jeff's word 2026-07-29, Gate 2 was sealed - same status as the K-4
  addition): W-7 added to docs/B39_MATRIX.md as RECORD ONLY, group G-W. No code scope
  change. Verified opportunistically during Run H, which crosses the Doo -> Vantage
  account boundary anyway, so it costs no extra run.

LOCKED DECISION E9-P4 (Q-1, level 0 at STARTUP): OPTION (a) - RebuildLiveMap 2488-2494's
  lvl = 0 assignment is replaced by the same maxLvl+1 rule the adoption path uses, WARN
  kept. WHY: TP-2 alone would abolish level 0 on the ADOPTION paths only, leaving a restart
  into a comment-rewritten position still able to produce a level-0 anchor - L-3's exact
  hazard, on precisely the path Run H exercises (K-1 sliced anchor + K-4 partial-close
  comment integrity). The matrix calls L-3 "arguably the most valuable line in b39"; half-
  closing it was not worth the saving. ACCEPTED COST: touches the sealed Stage 1 rebuild
  that every init runs, so R-1's Doo regression must now include a RESTART. Risk low - the
  branch is unreachable unless a comment is genuinely unparseable, which neither evidence
  broker does today. NOTE: the map is built in ONE pass, so runningMax is the max over
  positions admitted SO FAR; an unparseable position can still land below a later-scanned
  higher level. Accepted - it can never be 0, so it can never seize the anchor from a real
  L1. REJECTED: (b) leave 2493 as-is - L-3 then only partially closed and unmarkable as
  PASS on the restart path. Jeff's call 2026-07-29.

LOCKED DECISION E9-P5 (counter-direction position under our magic): the watcher REFUSES it
  - LOG_ERROR, no adoption. Not contemplated by the sealed matrix; raised at plan time.
  WHY: RebuildLiveMap already treats mixed directions as an error (2509), and grafting a
  counter-direction leg would corrupt the VWAP anchor - the opposite of what b39 exists to
  do. A wrong-direction position is not a level of this sequence. REJECTED: adopt-and-warn
  (gives it exits, but at the cost of the anchor basis every sealed tier sits on).
  Jeff's call 2026-07-29.

## b39 GATE 3 CONFIRMED - 2026-07-29
docs/B39_PLAN_2026-07-29_gate3.md CONFIRMED by Jeff 2026-07-29. TEN touch points:
TP-1 IsAdoptableOurPosition (the one admission filter; magic gate lives here, W-3/N1);
TP-2 AdoptUntrackedLevel (the one entry into live g_state; no level 0, duplicates adopted
with WARN, counter-direction refused); TP-3 RegisterNewRecovery demoted to fast path
(ERROR 1939 -> INFO); TP-4 WatchUntrackedLevels (per-tick, live state); TP-5 flat rebuild
(orphan ERROR 3150 deleted - that branch IS the F-2 hole); TP-6 RegisterButtonL1 seedLvl
default arg; TP-7 order-book ORDER_TYPE split; TP-8 OnTick wiring before EnforceExits;
TP-9 stale EvaluateBasketClose comment 2300-2308; TP-10 RebuildLiveMap maxLvl+1 (Q-1=a).
NO NEW CODE NEEDED for A-4 (retcode gates 2170/3274 already reject non-DONE/PARTIAL/PLACED
before registration), A-5 (ComputeRecoveryTrigger derives nextLvl AND worst from g_state
alone, so adoption alone stops the M5 duplicate stacking) or R-4 (watcher silent when
everything is tracked). Verification must PROVE these, not assume them.
## b39 BUILT + GATE ZERO PASSED - 2026-07-29
b39 = 493302eccd8d3e0d / 4885 lines (+211 from b38's 4674). Compile 0 errors, 0 warnings.
All TEN touch points landed. Implementation notes worth keeping:
- TP-1 IsAdoptableOurPosition (2485) is the single admission truth; the MAGIC test lives
  there and nowhere else, so no b39 caller can reach a magic-0 position (W-3/N1 enforced
  structurally, not by convention). The three magic-0 ADOPTION scans (725, 784, 922) were
  audited and correctly left on the raw _Symbol comparator - they are the mirror-image
  path and are out of b39's scope.
- TP-2 AdoptUntrackedLevel (2504) is the single entry into a live g_state.
- TP-3 RegisterNewRecovery carries a sawLevel flag so "position not there yet" (async,
  INFO) is distinguished from "there and already tracked" (silent). Without it the fast
  path would emit a false "fill pending" line whenever it re-ran over a tracked ticket.
- TP-5 also fixed the BUTTON path's twin of the same defect at ExecuteMarketEntry (3477):
  it still logged ERROR on an async L1. That is matrix A-2, and it was missed on the first
  build pass - caught on the diff review, not by the compiler.
- FindUntrackedOurSeed originally ranked an unparseable tag with a TRTM_MAX_LEVELS+1
  sentinel. REJECTED AND REWRITTEN before compiling: ParseLevelFromComment returns
  whatever the comment holds, so a rewritten '_l99_' would have exceeded the sentinel and
  been silently reseeded to L1 - a level-identity bug. Now ranked on an explicit
  bestParsed flag; a parsed level is never compared against a sentinel.
- TP-10's runningMax is the max over positions admitted SO FAR (one-pass map), so an
  unparseable position can still land below a later-scanned higher level. Accepted and
  documented in-code: what matters is that it is never 0.
## b39 POST-BUILD AUDIT - REGRESSION FOUND AND FIXED (2026-07-29)
Jeff asked for confirmation that the functions were aligned and the bugs handled. The
audit that question forced found a REAL b39 REGRESSION against matrix F-3, which the
compiler could never have caught. Recorded in full because it is the second time the
first build pass was incomplete (the A-2 button path was the first).

DEFECT: the new flat-state L2+ seed branch STOLE THE ANCHOR FROM AN ADOPTABLE L1.
  CheckOwnPendingFillWhenFlat runs BEFORE TryAdopt in OnTick (4828-4831), and OnTick
  only calls TryAdopt while levelCount == 0. The b39 seed branch sets levelCount = 1,
  so on any flat tick where an adoptable magic-0 L1 AND an our-magic L2+ were both
  open, b39 seeded from L2 and TryAdopt never ran. Consequences: the magic-0 L1 sat
  UNMANAGED (the exact failure mode b39 exists to remove), the sequence anchored on L2,
  and baseLot was derived from a LADDER lot instead of the base lot. Reachable on a
  restart into a mixed mobile-L1 + EA-L2/L3 sequence with no state file - the very
  shape E9-N1 blesses. NOT reachable in b38: without the L2 branch the function fell
  through to TryAdopt and the L1 was adopted correctly.

LOCKED DECISION E9-P6 (fix, Jeff's call 2026-07-29): THE SEED YIELDS TO ADOPTION.
  New side-effect-free predicate AdoptionCandidateExists() mirrors BOTH TryAdopt
  branches (tagged magic-0 L1; MMT untagged fallback) with the same gates in the same
  order. When it returns true the seed branch stands down for the tick with a one-shot
  INFO: TryAdopt anchors on L1, and WatchUntrackedLevels adopts L2+ into that sequence
  on the SAME tick. The seed branch now fires only on a genuinely L1-less tick, which
  is the case F-2 is actually about.
  ACCEPTED COST: CheckOwnPendingFillWhenFlat now READS magic-0 positions (it still
  never adopts/closes/modifies one). Its header comment was corrected accordingly -
  the old text claimed our-magic-only and would have been a false statement on disk.
  MAINTENANCE HAZARD TO CARRY: AdoptionCandidateExists duplicates TryAdopt's admission
  logic and MUST be kept in step with it. Deliberately not refactored into one shared
  predicate in b39 - that would re-open TryAdopt, a sealed Stage 2 function with
  one-shot logging side effects, inside a hotfix. -> candidate for E9.
  REJECTED: (b) seed wins, L1 adopted later or never - simpler and needs no cross-magic
  read, but anchors on a ladder lot and the stale-tag gate would permanently lock out a
  legitimately adoptable L1 once the seeded sequence closed.

TP-11 (E9-P6): AdoptionCandidateExists() added above TryAdopt; the seed branch in
CheckOwnPendingFillWhenFlat gated on it; that function's header comment corrected.

## b39 GATE 4 - EVIDENCE LOG (opened 2026-07-29)
DEPLOYED 2026-07-29: MT5 runtime = repo = 12c69766c709bd0d / 4939, verified byte-identical.
EA re-initialized "=== TRTM b39 init ===" on XAUUSD.s (magic 715358), self-test PASS,
Reconcile FLAT.

RUN 1 - R-1/R-2 SYNC REGRESSION: **PASS**. tests/2026.07.29 123116.503.txt, Doo
XAUUSD.s M15 real ticks, deposit 3000 @ 1:500, all three tiers OFF - Run A's input set
exactly (tests/2026.07.26 125653.086.txt is the baseline). SELL ladder L1-L5.
  Compared line by line against Run A:
   - ladder depth L1-L5 .................... IDENTICAL
   - level lots 0.01/0.02/0.03/0.04/0.05 ... IDENTICAL
   - spacing 500 pts off the worst entry ... IDENTICAL
   - cumulative lots 0.03/0.06/0.10/0.15 ... IDENTICAL
   - projected at TP +75.00/+149.97/+250.01/+375.01 vs Run A's
     +75.01/+149.98/+250.02/+375.07 - agree to the cent given the different entry
   - AvgTP recomputed on every level add, propagated to every ticket ... IDENTICAL
   - exit: all five TP hit on one tick, sequence closed, flat marker ... IDENTICAL
  Entry time/price differ (07:45 @ 4176.77 vs 02:18 @ 4156.07) because the button click
  is manual - NOT a code difference; every derived number tracks the entry correctly.
  THE ONLY BEHAVIOURAL DELTA IS THE REGISTRATION LINE, which is TP-3 working:
     b38: "Recovery L2 registered: ticket 3"
     b39: "Recovery fast path: L2 REGISTERED ticket 3 0.02 lots @ 4181.78"
  Same tick, same ticket, same level; the new text adds volume + price (W-5).
  ZERO "Watcher:", ZERO "fill pending", ZERO "DUPLICATE", ZERO "unparseable" lines.
ROWS CLOSED BY RUN 1: R-1 (no regression on a sync broker), R-2 (money paths untouched -
no tier fired, ladder + AvgTP + projections all byte-consistent), R-3 (RunStateSelfTest
PASS), R-4 (watcher inert, no log noise on a healthy run), A-3 (sync fast path registers
immediately, exactly as b38).
NOTE - Run 1 did NOT exercise TP-10: Reconcile ran FLAT at init, so RebuildLiveMap's loop
body never executed. R-1 is NOT complete until a restart with live positions is run.

RUN 2 - R-1/R-2 TIER 3 VARIANT: **PASS**. tests/2026.07.29 124117.612.txt, same tester
setup as Run 1, Run C's three input deltas exactly (InpEntryLotSize=0.03,
InpAvgTPPts=5000, InpEnableTier3=true; baseline tests/2026.07.26 130728.662.txt).
SELL ladder L1-L6, TWO Tier 3 fires, anchor survived both.
  Ladder: lots 0.03/0.04/0.05/0.06/0.07/0.08 = baseLot 0.03 + 0.01x(N-1), incremental
  rule intact. Spacing 500 pts off the worst entry throughout.
  BOTH FIRES RECOMPUTED ON TWO INDEPENDENT DERIVATIONS (leg-by-leg AND the identity
  group P/L = marginPts x SUM(group lots); gold 1 pt on 1.00 lot = $1.00):
    FIRE 1 04:45 - anchor L1 4145.62 slice 0.01 of 0.03 + L6 4211.65 0.08, far 4201.01
      sliced VWAP  4204.31333 (logged 4204.31)   margin 330.3 pts (logged 330.3)
      identity +29.73  |  leg-by-leg +29.73 (anchor -55.39 + L6 +85.12)   AGREE
    FIRE 2 05:00 - anchor L1 now 0.02, slice 0.01 + L5 4200.82 0.07, far 4191.08
      sliced VWAP  4193.92000 (logged 4193.92)   margin 284.0 pts (logged 284.0)
      identity +22.72  |  leg-by-leg +22.72 (anchor -45.46 + L5 +68.18)   AGREE
  Both fires net POSITIVE while the anchor leg is a LOSS - the Tier 3 premise, working.
  Slice sizing correct: 0.03 x 50% = 0.015 floored to the 0.01 unit = 0.01 (remaining
  0.02); second fire slices the 0.02 anchor by 0.01 again (remaining 0.01).
  Anchor SURVIVED both fires; liveness pruned only the closed profitable leg; recovery
  then reopened L5/L6 at the same lots - level numbers reused after the prune, as sealed.
  ZERO Watcher / fill-pending / DUPLICATE / unparseable lines. ZERO WARN. ZERO ERROR in
  the whole run.
ROWS CLOSED/EXTENDED BY RUN 2: R-2 FULLY (E6 money path untouched -
ComputeSlicedAnchorVWAP, FormBasketGroup, FireGroupClose and the slice sizing all
reproduce the sealed E6 arithmetic exactly), R-1 extended (ladder/lots/AvgTP consistent
under a Tier-3-firing config), A-3 again, R-4 again.

RUN 3 - TP-10 RESTART WITH LIVE POSITIONS: **PASS**. tests/2026.07.29 145131.777.txt,
LIVE Doo XAUUSD.s demo chart (not the tester - tester inputs lock once a run starts and
a tester restart replays from the beginning, so it CANNOT produce a reconcile against
open positions; the live chart is the only route). BUY ladder L1-L3, EA removed and
re-attached with positions open.
  BEFORE restart: "Structure: 3 level(s), 0.06 lots | projected at TP +150.03"
  AFTER  restart: "Structure: 3 level(s), 0.06 lots | projected at TP +150.03"
                  "Reconcile complete: dir=BUY levels=3"
                  "Reconcile: flags restored (trailOverride=F beOverride=F
                   trailingActive=F beApplied=F)"
  The projection matching TO THE CENT is the decisive signal: it is derived from all
  three entries and volumes, so it can only match if every ticket, level and lot
  reconstructed identically.
  THIS IS THE RUN THAT FINALLY EXERCISED TP-10 - RebuildLiveMap's loop body ran over
  three real positions, parsed all three comments, assigned levels 1/2/3, and runningMax
  tracked correctly. Runs 1 and 2 both init'd FLAT, so the loop body never executed there.
  ABSENT AS REQUIRED: no "unparseable level comment"/"counted as L", no "Watcher:" line
  (the live map caught all three, leaving the watcher nothing to do), no "baseLot lost
  with state file" WARN (state file survived, so Reconcile's else-branch never ran), no
  level renumbering. ZERO WARN, ZERO ERROR across the restart.
  INCIDENTAL: InpMoneyMode was BALANCE RATIO on this run, not Fixed Lot ("Entry lot
  0.0157 normalized to 0.0100"). Does not invalidate the restart evidence and
  incidentally exercised the balance-ratio lot path with Guard A's round-down, which
  behaved correctly. Three clean open/close cycles preceded the test - incidental
  confirmation that the button path and liveness attribution are intact.
ROWS CLOSED BY RUN 3: TP-10 restart path (the R-1 gap Runs 1-2 could not reach); K-3 in
part (restart across a live sequence, no orphan); R-1 NOW COMPLETE.

=> THE SYNC-BROKER REGRESSION OBLIGATION (R-1/R-2/R-3/R-4) IS CLOSED ON EVIDENCE.
   E1/E4/E5/E6 are demonstrably unaffected by b39 on a synchronous-fill broker.

STILL OPEN: A-1/A-2/A-5 + W-1..W-6 (Vantage async reproduction - THE DEFECT b39 EXISTS
TO FIX, still entirely unverified), F-1..F-5 (flat-state rebuild), L-1..L-4, O-1..O-5,
K-1/K-2/K-4 (Run H on Vantage).

## EVIDENCE-BASE AMENDMENT - VANTAGE TEST ACCOUNT (2026-07-29)
Jeff created a VANTAGE STANDARD ECN **DEMO** account for b39 testing rather than risk the
live account. Correct call - b39 rewrites core registration and must not be first-run on
live money.
CONSEQUENCE THAT MUST BE HONOURED AT SEAL TIME: the 2026-07-27 incident occurred on the
VANTAGE CENT **LIVE** account (XAUUSD.sc), and TRADE_RETCODE_PLACED / price 0.00 / deal 0
is a property of THAT account's execution model (a bridge acknowledging before executing).
A Standard ECN DEMO is a different account type on a different server and commonly fills
SYNCHRONOUSLY. So:
  - If the demo reproduces the async fill -> A-1/A-2/A-5/W-1..W-6 close on real evidence.
  - If the demo fills SYNCHRONOUSLY (every level via "Recovery fast path", no "Watcher:"
    line) that is NOT a pass on the async rows. It is a THIRD sync-broker regression data
    point (useful - b39 correct on another broker) and the async rows STAY OPEN.
MUST-NOT: marking A-1 or any watcher row closed off a run in which the async condition
never occurred. Absence of the trigger is not evidence of the fix.

RUN 4 - VANTAGE STANDARD ECN DEMO: **SYNC FILL - ASYNC ROWS NOT CLOSED**.
tests/2026.07.29 222348.119.txt, live Vantage Standard ECN DEMO chart, symbol XAUUSD+.
The predicted outcome above occurred: the demo fills SYNCHRONOUSLY. Every level
registered via "Recovery fast path" on the send tick. NO "fill pending", NO "Watcher:"
line, no TRADE_RETCODE_PLACED. Three sequences run (SELL L1; BUY L1-L2; BUY L1-L3), all
clean, zero WARN, zero ERROR.
  => A-1, A-2, A-5, W-1..W-6 REMAIN ENTIRELY UNVERIFIED. The async condition did not
     occur, so this run says nothing about them.
  => Counts as a THIRD sync-broker regression data point: b39 correct on Doo XAUUSD.s,
     the Doo tester, and now Vantage XAUUSD+.
VALUABLE RESULT - FIRST LIVE EXERCISE OF E9-P2 (the normalized symbol comparator):
  symbol is "XAUUSD+" (raw), normalizing to "XAUUSD" - a suffix form NEITHER evidence
  broker had. All five registrations admitted correctly through IsAdoptableOurPosition's
  NORMALIZED comparator. Through b38 the registration paths compared RAW != _Symbol
  (which would also have worked here); b39 routes them through the normalized form, and
  this run proves that change admits correctly on a previously untested suffix. E9-P2 is
  no longer theory-only.
W-7 NARROWED BY EVIDENCE: magic here is 758105, derived from "XAUUSD"; Doo XAUUSD.s
  derives 715358 from "XAUUSDS". DIFFERENT normalized symbols -> different magics ->
  different state files. The account-switch collision W-7 describes requires both
  brokers' gold to normalize IDENTICALLY; XAUUSD+ and XAUUSD.s do NOT. Jeff's two
  accounts CANNOT collide. W-7 stays recorded for E9 but its reachability is now known
  to be narrower than drafted.
BROKER FACT ON RECORD: Vantage Standard ECN Demo XAUUSD+ stops level 20 pts, freeze 0
  (vs Doo XAUUSD.s 100 pts) - consistent with the matrix evidence-base note.

RUN 5 - VANTAGE CENT **LIVE** (XAUUSD.sc, magic 725639 set EXPLICITLY via InpMagicNumber
to avoid the W-7 state-file collision): **ASYNC RETCODE REPRODUCED; ASYNC MISS DID NOT**.
tests/2026.07.29 235916.412..txt. Jeff's call to run the defect's own account at minimum
size (0.01) with InpMaxRecoveryTrades=2 as a hard runaway cap, watched throughout.
  THE ASYNC SIGNATURE IS PRESENT ON ALL THREE SENDS - the 2026-07-27 shape exactly:
     "L1 BUY OPENED via button: 0.01 lots @ 0.00 (deal 0)"
     "Recovery L2 OPENED: 0.02 lots BUY @ 0.00 (deal 0)"
     "Recovery L3 OPENED: 0.03 lots BUY @ 0.00 (deal 0)"
  price 0.00 / deal 0 = TRADE_RETCODE_PLACED. This IS the asynchronous-fill broker.
  BUT ALL THREE REGISTERED VIA THE FAST PATH, each with a REAL entry price:
     L1 ticket 469006561 @ 4015.51 | L2 ticket 469012846 @ 4012.19 (fast path)
     L3 ticket 469022910 @ 4009.20 (fast path)
  MEANING: the broker acknowledges BEFORE executing, but executed within the same tick,
  so the position existed by the time the fast path scanned. That is why b38 "got lucky"
  on L1 on 2026-07-27. The async RETCODE is routine here; the async registration MISS is
  the rarer, worse case and did not occur in this run.
ROWS CLOSED BY RUN 5:
  A-3 / R-1 ON THE ASYNC BROKER - a PLACED send whose position lands in time registers
    via the fast path exactly as b38 did. No behaviour change on the common async case.
  A-5 (duplicate stacking) - L2 and L3 each opened ONCE. The trigger recomputed off each
    new worst entry (4015.51 -> 4012.19 -> 4009.20, 300 pts apart). On 2026-07-27 the EA
    opened a duplicate EVERY M5 BAR because L2 was never tracked. Closed on evidence.
  O-3 / O-4 - NO 10013, no "cancel ... [invalid request]", no spurious pendingLive, on
    the very account that produced that error. The ORDER_TYPE split works.
  K-3 / TP-10 again - init RECONCILED A LIVE 2-LEVEL SEQUENCE from a previous session
    ("levels=2", +75.00) on the async broker. RebuildLiveMap's loop clean, no WARN.
STILL OPEN AFTER RUN 5: A-1 and W-1..W-6. The watcher never fired because the fast path
  never missed. Closing them needs a fill slow enough that no position exists when the
  fast path looks - rarer than the PLACED retcode itself.
INCIDENTAL (not a b39 row, but useful): Jeff dragged the TP twice mid-sequence; b39
  adopted 4020.06 then 4019.42 and RELEASED correctly on the L3 add ("Manual TP 4019.42
  RELEASED - level add (L3)"). Sealed b24/b28 manual-ownership semantics survive b39's
  new registration path - that is TP-2 step 7 (ReleaseManualTP inside AdoptUntrackedLevel)
  exercised LIVE.
COSMETIC, PRE-EXISTING, NOT b39: close prices also return 0.00 on this broker
  ("Closed L1 ticket 468953350 @ 0.00").

## b39 SEAL DECISION - A-1/W-1..W-6 CLOSED ON INSPECTION, NOT EVIDENCE (Jeff, 2026-07-30)
DECISION: seal b39 WITH THIS CAVEAT RECORDED. The Cent account is LIVE with real money;
Jeff will not run further tests there to chase a timing tail. Run 5 already bought the
expensive evidence (async retcode reproduced, A-5/O-3/O-4 closed on that very account).
WHY THE WATCHER COULD NOT BE REPRODUCED: Run 5 established that on Vantage the PLACED
retcode is ROUTINE but the fill still lands within the tick, so the fast path never
misses. The registration MISS that caused the 2026-07-27 incident is a rarer TIMING TAIL,
not the everyday case. It cannot be summoned on demand on any available account:
  - Doo (tester + live): synchronous, no PLACED at all.
  - Vantage Standard ECN DEMO: synchronous.
  - Vantage Cent LIVE: PLACED routine, fill lands in time - miss did not occur in 3 sends.
WHAT IS AND IS NOT PROVEN:
  PROVEN - b39 does not break anything. 3 brokers, 3 symbol suffixes (.s / + / .sc),
    tester + live, restart with open positions, two Tier 3 fires recomputed to the cent.
    R-1/R-2/R-3/R-4, A-3, A-5, O-3, O-4, K-3, TP-10, E9-P2 all closed on EVIDENCE.
  NOT PROVEN - WatchUntrackedLevels has never adopted a position. A-1 and W-1..W-6 close
    on CODE INSPECTION only. What is inspected-but-unexercised is narrow: the DISPATCH
    from WatchUntrackedLevels. Its admission filter (IsAdoptableOurPosition) and its
    adoption body (AdoptUntrackedLevel) are BOTH exercised on every run - every single
    "Recovery fast path: L<n> REGISTERED" line in Runs 1-5 went through the same
    AdoptUntrackedLevel, and every registration on 3 brokers went through the same
    IsAdoptableOurPosition. The untested part is the per-tick loop that calls them.
RISK POSTURE ACCEPTED: b39 on the Cent account is strictly SAFER than b38 today. Worst
  case the watcher never fires and behaviour equals b38; best case it saves a position
  from going unmanaged. b38's behaviour in that scenario is KNOWN-BAD (2026-07-27).
PARKED, NOT ABANDONED - IF IT HAPPENS AGAIN: the journal now makes the miss visible and
  self-documenting. Look for this sequence on the Cent account:
     "Recovery L<n>: order accepted but no position yet (asynchronous fill)"   <- INFO
     "Watcher: L<n> REGISTERED ticket <t> <vol> lots @ <price>"                <- next tick
     "Exits applied to ticket <t>: TP <x> ..."
  If those three appear, A-1 and W-1..W-6 close on live evidence and this caveat is
  retired - update this entry and the checklist. If instead an orphan appears with NO
  watcher line, that is a b39 DEFECT and the log is the reproduction: capture it and
  reopen. Either way the evidence arrives for free during normal use.
NOT DONE (deliberately, no code written): the [TESTER]-gated forced-miss switch that
  would have exercised the watcher synthetically. Rejected as needing a new build (b40)
  plus Gate Zero for test-only code that proves the watcher works but NOT that a real
  broker triggers it. Remains available if certainty is ever wanted.
NOTE ON L-2/L-3/TP-10's WARN branch: unreachable on both evidence brokers without a
DELIBERATELY corrupted comment - decide before seal whether those rows close on evidence
or on code inspection.

## E9 / b39 - GATE 1 OPEN (2026-07-27)
LOCKED DECISION E9-S1 (scope): SPLIT. A narrow gated hotfix build b39 covering ONLY
  O1 (deferred registration on PLACED) + O2 (live-sequence orphan watcher) - the two that
  produce unmanaged positions - followed by a separate E9 for O3-O6 hardening. Full gate
  order applies to b39, just a small matrix and plan. Run H rides along on b39.
  REJECTED: (a) one E9 covering all six - cleaner record and the broker-negotiation pieces
  do interact, but it leaves the live exposure open until the whole thing lands;
  (b) O1+O2 only with no follow-on E9 - accepts netting/filling/exemode/comment risk
  permanently, defensible only if Vantage stays the sole additional broker.
  Jeff's call 2026-07-27.
DEFERRED TO E9 (not in b39): O3 filling-mode negotiation from SYMBOL_FILLING_MODE;
  O4 margin-mode guard (refuse/config-block on netting); O5 execution-mode awareness +
  init guidance in the LogBrokerExitGeometry idiom; O6 comment-integrity detection and
  fallback.
LOCKED DECISION E9-O1/O2 (registration model): WATCHER-PRIMARY, single mechanism. A
  live-sequence orphan watcher runs each tick and adopts ANY our-magic position carrying a
  _lN_ tag that is not currently tracked, at its comment level - the same admission filter
  RebuildLiveMap (2471) already uses and which has been sealed since Stage 1.
  RegisterNewRecovery is demoted to a FAST PATH: when it misses it logs INFO ("fill
  pending"), not ERROR, and the watcher completes registration on the next tick. NO new
  persisted state - consistent with E4/E5/E6 keeping everything derived per tick.
  WHY: O2 strictly subsumes O1's failure case. A watcher covers async fill AND a crash
  between send and register AND causes not yet seen, whereas deferred registration only
  covers the send path it was watching. In the 2026-07-27 incident a watcher would have
  adopted L2 on the next tick and NONE of the downstream damage (duplicate stacking,
  unmanaged position) would have occurred.
  ACCEPTED COST: up to one tick unmanaged before EnforceExits dresses the position.
  REJECTED: (a) register-on-send primary with a deferred queue keyed on the order ticket -
  more precise and can name the order that never filled, but needs new in-memory state, is
  a second path doing what the watcher does anyway, and still misses a crash between send
  and queueing; (b) BOTH - maximum coverage, but two mechanisms can race on one position
  so the matrix must prove they cannot double-register, which is real verification surface
  for a hotfix build. Jeff's call 2026-07-27.

LOCKED DECISION E9-O2b (unparseable tag): ADOPT AT maxLvl + 1, loud WARN naming the
  ticket. It gets TP/SL and is counted; being the HIGHEST level it can never seize the
  anchor. This ALSO replaces RebuildLiveMap's existing lvl = 0 path (2488), which is a
  live hazard today: FormBasketGroup picks the LOWEST level as anchor, so 0 wins and an
  unidentified position inherits both the SL anchoring (ComputeTargets) and Tier 3's slice
  target. Removing that is arguably the most valuable line in b39.
  SCOPE NARROWED BY EVIDENCE (Jeff, 2026-07-27): the ONLY way to get an our-magic position
  with an unreadable tag is the broker rewriting a comment WE wrote - the mobile/adoption
  path cannot produce one (see E9-N1 below). Jeff confirmed Vantage leaves comments INTACT
  on live XAUUSD.sc positions, so this case has no observed probability on his platform.
  That evidence changed the recommendation: open-time inference was recommended first
  (it correctly re-identifies a comment-stripped SLICED ANCHOR) but is added complexity in
  a hotfix for something now evidenced not to occur here.
  REJECTED: (a) open-time inference - deferred to E9-O6, still the right answer IF a
  broker is found that rewrites comments; (b) quarantine without adopting - matches the
  "notify never auto-close" idiom but leaves the position with NO TP and NO SL, which is
  the exact exposure b39 exists to remove. Jeff's call 2026-07-27.

NOTE E9-N1 (why the watcher cannot collide with ADOPTION - Jeff's question, 2026-07-27):
  The two paths are separated by the MAGIC NUMBER and it is enforced explicitly.
  Adoption handles magic-0 (external) positions - TryAdopt refuses ours outright
  ("if(POSITION_MAGIC == g_magic) continue"), and the untagged mobile fallback demands
  magic EXACTLY 0 ("if(POSITION_MAGIC != 0) continue"). The watcher's filter is the mirror
  image: magic == g_magic AND a parseable _lN_ tag. A mobile trade has NEITHER, so the
  watcher is blind to it. This is structural, not incidental: MT5 cannot modify
  POSITION_MAGIC, so an adopted L1 stays magic 0 for life and is restored by ticket from
  the state file in Reconcile, never by any scan. Mixed sequences (mobile L1 at magic 0 +
  EA-opened L2/L3 at our magic) work: the watcher considers only L2/L3.

LOCKED DECISION E9-O2d (order-book type split): CancelOwnPendingOrders and
  CountOwnPendingOrders must distinguish a GENUINE PENDING from an IN-FLIGHT MARKET order
  by ORDER_TYPE. Only BUY_LIMIT / BUY_STOP / SELL_LIMIT / SELL_STOP are pendings;
  ORDER_TYPE_BUY / SELL sitting in the book are fills in progress and must be left alone.
  WHY: the async fill caused THREE defects, all visible in Jeff's 2026-07-27 log, all with
  this one root. (1) the registration miss (O1/O2); (2) CancelOwnPendingOrders tried to
  OrderDelete the in-flight market order -> "cancel #459172826 [invalid request]" 10013;
  (3) CountOwnPendingOrders counts in-flight market orders as pendings, spuriously setting
  pendingLive - which HIDES the BUY/SELL buttons and trips the P7 "cancel the pending
  first" refusal. Minimal fix, removes an ERROR Jeff is seeing live. Jeff 2026-07-27.

LOCKED DECISION E9-O2e (order accepted but NEVER filled): NO TIMEOUT IN b39; escalation
  deferred to E9. The system degrades gracefully - if the order never becomes a position
  the level simply does not exist, the recovery trigger still computes from the old worst
  entry, and the signal re-fires on a later bar. If the first order fills very late the
  watcher adopts both and O2a tolerates the duplicate with a WARN. Not silent either: the
  send logs INFO and every adoption logs, so a send with no matching adoption is visible.
  Preserves the no-new-state property of watcher-primary and keeps b39 a hotfix.
  REJECTED: (a) track order tickets for a timeout - reopens the no-new-state decision and
  adds the second mechanism we rejected as O1; (b) infer from the order book via the O2d
  split - zero new state and composes well, but infers intent from the book rather than
  from what we sent, so it cannot tell our stuck order from a slow server clear. Both
  remain candidates for E9. Jeff's call 2026-07-27.

LOCKED DECISION E9-O2a duplicate-level collision: ADOPT BOTH and tolerate
  duplicate level numbers, with a loud WARN naming the tickets. Rationale: the positions
  EXIST and must be managed - refusing one recreates the exact orphan we are fixing; and
  the level is an ADDRESS for lot sizing and anchor ordering, not a unique key. Checked
  downstream: ComputeRecoveryTrigger takes maxLvl+1 (fine), the lot-weighted VWAP includes
  both (financially correct), ComputeLevelLot keys off baseLot (fine). EDGE TO RECORD: if
  duplicates ever occur at the LOWEST level, FormBasketGroup's "first lowest wins" makes
  the anchor arbitrary and "oldest" ambiguous - only reachable if L1 itself duplicates.
  REJECTED: refuse-the-second (leaves an unmanaged position); renumber-to-next-free (the
  comment would then disagree with the tracked level and a restart would undo it).

LOCKED DECISION E9-O2c (watcher scope): RUNS IN BOTH STATES, flat and live. While FLAT,
  finding our-magic _lN_ positions rebuilds a sequence from them - the same thing
  Reconcile already does at startup, reusing that sealed path rather than inventing a
  second one. SUPERSEDES CheckOwnPendingFillWhenFlat's L1-only scan.
  WHY: the flat state has the SAME orphan hole as the live state, and it is the one Jeff
  is closest to hitting. His L2 is untracked right now; if L1 closes first (it carries a
  manual TP at 4090.59) then liveness prunes L1, levelCount hits 0, state resets, and the
  0.02 L2 is left open with NO TP and NO SL - with the only trace being the one-shot
  orphan ERROR at 3147, which skips lvl > 1 and never manages it. Closing the hole in one
  direction only would leave that intact.
  ACCEPTED COST: an our-magic position left open from a previous session will now START a
  sequence rather than sit idle. Arguably correct - it is ours and should carry exits -
  but it sets adoptionTime to now and derives baseLot from what it finds.
  Adoption of magic-0 trades is untouched (E9-N1). Jeff's call 2026-07-27.

## b39 GATE 2 SEALED - 2026-07-27
docs/B39_MATRIX.md SEALED rev 1 by Jeff 2026-07-27. 7 groups, 29 rows
(A-1..5, W-1..6, L-1..4, F-1..5, O-1..5, R-1..4, K-1..4).
MUST-NOT rows: A-4, W-3, W-4, L-3, F-3, O-3, O-4.
CRITICAL rows: L-3 (level-0 anchor hazard - present in SEALED b38 TODAY, independent of
Vantage: RebuildLiveMap 2488 assigns lvl=0 on an unparseable comment and FormBasketGroup
picks the LOWEST level as anchor, so an unidentified position inherits both the SL
anchoring and Tier 3's slice target); R-1/R-2 (no regression on a synchronous-fill
broker - b39 touches core registration, which every sealed enhancement sits on, and the
E6 Run A / Run C logs are the diff baseline); A-5 (duplicate-stacking path closed);
F-2 (flat-state orphan hole).
NEW ROW ADDED AT DRAFT TIME - K-4: confirm Vantage preserves comments across a PARTIAL
CLOSE. Jeff verified they survive on OPEN positions (2026-07-27) but the partial-close
case is the one that matters for E6 and is still unverified. A rewrite there would make
L-2/L-3 active rather than defensive and would escalate E9-O6.
NEXT: Gate 3 - draft the b39 code plan from this sealed matrix. PRIORITISED FOR THE NEXT
SESSION (Jeff, 2026-07-27), ahead of E8.

## b39 GATE 1 COMPLETE - 2026-07-27
All sub-decisions locked: S1 (scope split), O1/O2 (watcher-primary registration),
O2a (duplicate levels: adopt both), O2b (unparseable tag: maxLvl+1, also fixes the
lvl=0 anchor hazard), O2c (watcher runs flat AND live, supersedes
CheckOwnPendingFillWhenFlat), O2d (order-book type split), O2e (no never-filled timeout).
Plus note N1 (magic separates the watcher from adoption).
NEXT: Gate 2 - draft the b39 matrix. Expected shape, small: async-fill registration
(recovery + button paths), watcher admission filter, duplicate levels, unparseable tag,
flat-state rebuild, order-type split, and MUST-NOT rows (never adopt magic-0; never
double-register; never let an unidentified position become the anchor; byte-identical
behaviour on a synchronous-fill broker so E1/E4/E5/E6 are unaffected).
b39 SCOPE ALSO INCLUDES: Run H (T3-K1/K2) on VANTAGE, not only the Doo demo - overdue per
the comment-integrity risk, and b39 changes the very code that rebuilds a sequence.
REGRESSION OBLIGATION: b39 touches core registration, which every sealed enhancement sits
on. The matrix must carry a row proving behaviour on a SYNCHRONOUS-fill broker
(DooTechnology XAUUSD.s) is unchanged - the E6 Run A/C logs are the baseline to diff.

## (superseded) GATE 4 IN PROGRESS log
GATE 4 IN PROGRESS: docs/E6_VERIFY_CHECKLIST.md DRAFTED 2026-07-26 (36 matrix rows
mapped; 8 live runs A-H specified). THREE RUNS GREEN so far, all XAUUSD.s tester,
every money number recomputed to the cent and cross-checked against the identity
group P/L = marginPts x SUM(group lots):
 - Run A (tests/2026.07.26 125653.086.txt) T3-R1 PASS: all tiers off, ZERO Tier lines,
   4 AvgTP recomputes + 4 projections exact. Calibration finding -> Run C settings.
 - Run C (tests/2026.07.26 130728.662.txt) base 0.03, Tier 3 only. TWO fires.
   T3-6 PROVEN LIVE: slice 0.01 -> 4205.1978 (+281.8 pts, fires); remainder 0.02 ->
   4200.0360 (-234.4); full 0.03 -> 4195.8127 (-656.7). Both alternatives NEGATIVE -
   stronger than the reference. Closed T3-1/5/6/SL1/SL2/SL3/SL4/SL5/A1/G1/G2/G3/X1/X2/
   P1/P2/H1/H2/H4/D1/D2/R2/M1.
 - Run E (SELL tests/2026.07.26 131938.427.txt, BUY tests/2026.07.26 132224.767.txt)
   InpStopLossPts=8000. FOUR more fires. T3-2 BUY lap PROVEN (Bid-side, O8 direction-
   derived - no reference existed). T3-H3 PROVEN BOTH LAPS: SELL SL 4243.58 / BUY SL
   4108.79 unchanged across every slice, ZERO "SL re-anchored" lines (contrast E5 Run 3,
   which logged one per Tier 2 fire) - confirms F-a, zero code. BONUS: the BUY lap's
   unchanged SL was HIT at 4108.77, all 8 legs including the twice-sliced anchor - a
   genuine broker-held stop fired, not merely an unchanged value.
 Tightest fire verified: BUY fire 2 cleared the 200-pt bar by 0.125 pts (200.125) and
 still reproduced to the cent. All eight fires satisfy the G2 invariant on BOTH
 derivations.
 TESTER CAVEAT: these runs used "calculate profit in pips". Harmless for Tier 3 (pure
 price arithmetic; POSITION_PROFIT used only for the membership SIGN test) but it makes
 Tier 2's Gate B meaningless - MUST be turned OFF before Run G (T3-PR3).
 REMAINING: T3-3/T3-4 (Run D), T3-PR2/PR3 precedence (Runs F/G, UNOBSERVED), T3-K1/K2
 (Run H), T3-X4 (opportunistic), T3-DS1 (Jeff visual). Reference audit result: E6_MATRIX rev 1 is
arithmetically CLEAN - both fires reproduce to the cent and were corroborated
against the RAW Shadow log lines 506-532 / 927-953, not re-derived from the
matrix's own intermediates (the method that caught F5 in E5). No F5-class error.
Three checklist findings worth carrying into the runs:
 - TEST-DESIGN BLOCKER: L1 is always the anchor while it lives, and L1 ==
   InpEntryLotSize (L(N>=2) = baseLot + (N-1) x InpIncrementStep). At the DEFAULT
   0.01 the anchor is below InpTier3MinLots 0.02 AND below 2 x unit, so Tier 3 can
   NEVER fire on a default-entry-lot ladder. Every fire run raises InpEntryLotSize
   (0.03 mirrors FIRE 2 and is the T3-6 crux). Same fact = Run D's T3-SL4 evidence.
 - ANCHOR DEPTH: the slice-vs-full margin gap scales with the anchor's depth
   relative to the profitables' margins. A 4-level ladder still clears Tier 1 on
   the FULL anchor, proving nothing. The regime needs ~8 levels at a 500-pt
   interval then a retrace greening only the top 2 - worked to the cent in the
   checklist's Run C target (slice 300.0 pts / remainder 152.4 / full 18.2).
 - STRUCTURAL RELATION: with the anchor as the group's worst leg, marginPts(slice)
   >= marginPts(full) ALWAYS. This is why Tier 3 fires where Tier 1 cannot, and it
   dictates the PR2/PR3 construction: make Tier 1 qualify by setting
   InpTier1MinProfitPts LOW (~50), never by raising Tier 3's bar (which can never
   produce a both-pass tick).
 - Slice sizing swept for float drift across ClosePercent x anchorVol (13 x 19
   combinations at unit 0.01): ZERO drift cases; the clamp holds
   unit <= slice <= anchorVol - unit throughout.
