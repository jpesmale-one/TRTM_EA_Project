# TRTM SYNC MANIFEST - update with EVERY build delivery
# Resume protocol (repo-based; see CLAUDE.md section 0). First action on
# resume: git status + sha256_16 + wc -l of src/TRTM.mq5 AND the MT5
# runtime copy, all compared to this manifest. Match = aligned in one
# line. Disk + git are truth, never conversation or auto memory.

build: E1-b34
file: TRTM.mq5
sha256_16: aef5dc989609dc45
lines: 4307
date: 2026-07-23

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
E5 (NEW 2026-07-23) Drawdown Reduction Tier 2 - percent-based (Shadow
   InpPC2_ProfitPercent/InpPC2_MinTrades). DISABLED in both reference
   runs - ZERO observed behavior. Recorded as a known sibling only;
   requires its own reference run (E7 R1) before it can be specified.
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
   today SELL-only; needed for O4); R5 a BE reference run (price
   favourable to basket AND Tier 1 disabled so it cannot harvest
   positions before BE arms - see F4; only if Shadow's BE is ever wanted
   as a reference, TRTM's own BE is sealed). R4 WITHDRAWN 2026-07-23: a
   different run cannot separate oldest/deepest/smallest-lot (they
   coincide by construction in every additive ladder; verified against
   run B's two fires); disambiguation would need an artificial basket,
   no longer a faithful reference. Formally parked as
   undeterminable-by-observation; C1 does not depend on the answer.

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
