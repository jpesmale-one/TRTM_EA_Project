# TRTM SYNC MANIFEST - update with EVERY build delivery
# Resume protocol: upload TRTM.mq5 + STATE.md together. First action on
# resume: recompute the hash and compare. Match = aligned in one command,
# no diff, no reconstruction from conversation memory.

build: Stage9-b29
file: TRTM.mq5
sha256_16: 7def6cd918f94a15
lines: 4197
date: 2026-07-20

## Environment note
ALL charts are DEMO; multi-symbol attachments are test surface.
Checklist EVIDENCE comes from XAUUSD.s only.
Broker facts: Doo Prime XAUUSD.s stops level = 100 pts.
DEPLOY NOTE (b24): no policy selector - manual exit adoption is live
behavior on EVERY chart b24 is attached to. Flagged and accepted.

## Verified (demo, logs audited)
Stages 1-7 SEALED (S7 sealed 2026-07-16 on b23; kill tests on b21).
Stage 8 Step 1 SEALED by Jeff 2026-07-20 on b28 (see seal section).
Stage 8 Step 2 (draggable lines) is the only parked Stage 8 item.

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
  object drag dead (draggable pending line = Step 2).

## b29-QUEUED observability batch: STILL QUEUED (separate build, own
matrix/checklist). Now unblocked. Guard A file-log WARN item has a
clean tester surface (Guard A fired live in tester at balance-ratio
0.0075<0.01 min).

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
