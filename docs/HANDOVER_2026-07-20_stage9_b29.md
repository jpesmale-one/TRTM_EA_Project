# TRTM Handover - 2026-07-20 (Stage9-b29; Stage 9 Step 1 SEALED -
# tester interactive mode on the shipping EA). Follow CLAUDE.md +
# staged-delivery-protocol skill strictly; this file + STATE.md truth.

## 1. RESUME PROTOCOL (first actions, in order)
1. Jeff uploads: TRTM.mq5, STATE.md, and the relevant stage files.
2. Run: sha256sum TRTM.mq5 | cut -c1-16  AND  wc -l
   EXPECT: 7def6cd918f94a15 / 4197 lines (build Stage9-b29).
   Match = say "aligned" in one line. Mismatch = STOP, ask which copy
   runs in MT5. Never rebuild from memory or sandbox.
3. NOTE: docs are LF; TRTM.mq5 is CRLF+ASCII (verify after edits;
   naive brace count baseline is -1, compare DELTA only).
4. Read section 3. Do not re-plan sealed work.

## 2. WHERE THE PROJECT STANDS
- Stages 1-7 SEALED. Stage 8 Step 1 (manual exit adoption) SEALED
  2026-07-20 on b28. Stage 9 Step 1 (tester interactive mode) SEALED
  2026-07-20 on b29.
- b29 shipped this session: productionized the TPROBE3 tester delta
  into the SHIPPING EA. Button ZORDER 10 (unconditional) + MQL_TESTER-
  gated OnTick polling of the 10 panel buttons -> HandlePanelClick +
  one-shot [TESTER] init INFO + per-dispatch [TESTER] line. NO money-
  path changes. +55 lines (code ~+27, rest inline rationale).
- All 19 Stage 9 checklist items PASS. Live regression S9-1..4 = the
  safety gate (proved zorder change does not disturb live charts):
  no [TESTER] line live, all buttons dispatch via events, object list
  empty, zorder survives refresh. Tester S9-5..19: all 10 buttons
  dispatch via poll, full lifecycle (entry/close/pending/BE/trail)
  runs on the shipping EA in the visual tester.

## 3. NEXT SESSION - PENDING DECISION (Gate 1, present options)
Two candidates, each its OWN build with matrix + checklist:
A. b29-QUEUED observability batch (wording/logging only, ZERO money
   paths). Items (from prior handover, still valid):
   - Geometry INFO: dynamic-stops note (20-100 intraday XAUUSD.s);
     "none reported" wording when stops level = 0.
   - AutoTrading: also check MQL_TRADE_ALLOWED, distinct message.
   - Guard A entries-blocked: one-shot FILE-log WARN (dashboard-only
     today; bit Jeff via MT5 Inputs Reset trap). NOTE: now has a clean
     TESTER surface - Guard A fired in tester at balance-ratio
     0.0075<0.01 min this session.
   - Signal-basis naming ("M15 close <=" vs "ask <=").
   - Lock re-assert msg: name unclean-shutdown-survivor case.
   - Candidate (discuss): one-shot-per-value throttle on M6-2 WARN.
B. Stage 9 Step 2: pending-line adjustment in tester (object drag is
   DEAD in tester - confirmed again this session). Options from
   TESTER_FINDINGS: nudge buttons (+/-N pts, recommended) vs input
   offset. Then Step 3 (auto-entry stub for non-visual optimizer
   sweeps, MQL_TESTER-gated) - REQUIRED before parameter optimization.
Recommendation last session was A-then-B ordering; A is the smaller
build and closes a silent path (Guard A file-log). Ask Jeff.

## 4. EMPIRICAL FACTS LEDGER (terminal is truth; do not relearn)
NEW this session (tester):
- GBPAUD.s stops level = 25 pts in tester (confirms probe).
- Cross-pair first-trade symbol auto-sync (GBPUSD.s/AUDUSD.s load on
  first GBPAUD position) = MetaTester USD-valuation engine loading
  conversion legs, NOT TRTM. Plain tester lines (no [TRTM] tag).
  Reproduces on b28. A USD-quote symbol would show no pop-ups.
- Tester input change is LOCKED per pass (no true mid-run change).
- Object drag DEAD in tester (Step 2 must use nudge/offset).
- Config-block button refusal is one-shot in tester (AlreadyLogged).
- MQL_TESTER gate resolves true only under Strategy Tester (proven:
  [TESTER] init line present in tester, absent on live chart).
CARRIED (still true):
- Doo Prime XAUUSD.s stops level DYNAMIC 20-100 pts intraday.
- Task Manager Processes "End task" = GRACEFUL (invalid for kill
  tests); Details "End process"/taskkill /F = real kill.
- MT5 Inputs "Reset" restores ALL defaults (Guard A trap); .set preset.

## 5. FILE MANIFEST (current truth set)
- TRTM.mq5              Stage9-b29  7def6cd918f94a15  4197 lines
- STATE.md              b29 header; b29 change section; Stage 8 Step 1
                        + Stage 9 Step 1 SEALED sections
- STAGE9_MATRIX.md      21 rows, SEALED + verification-complete
- STAGE9_CHECKLIST.md   19 items, all PASS, SEALED
- STAGE8_MATRIX.md      38 rows (Stage 8 Step 1, sealed prior)
- STAGE8_CHECKLIST.md   Stage 8 Step 1, sealed prior
- TESTER_FINDINGS_2026-07-19.md  channel map + Stage 9 Gate 1 sheet
- TRTM_TesterProbe.mq5  TPROBE3 (diagnostic fork - NOT delivery chain;
                        now SUPERSEDED for interactivity by b29, keep
                        for future channel forensics only)
- ButtonProbe.mq5       channel mapper (keep for forensics)
- ECOSYSTEM_BACKLOG.md  never re-import into TRTM

## 6. PARKED (TRTM-only)
- Stage 9 Step 2 (tester pending-line adjust) + Step 3 (auto-entry
  stub) - see section 3B.
- Stage 8 Step 2: draggable exit lines LIVE (+ drag-clamp). Tester
  behavior: drag dead there, so Step 2 must state tester behavior
  explicitly (nudge/offset, same as Stage 9 Step 2).
- Computed-TP anchor: SIMPLE average of entries (code comment
  ~lines 1094-1097 marks simple-vs-lot-weighted as a PENDING Gate 1
  decision). First unequal-lot live evidence 2026-07-20 (0.02/0.02/
  0.03). Money-path change - own Gate 1 when raised, do not fold in.
- Proj at SL under BE projects from computed anchor, not BE floor
  (pre-Stage-8 display question).
- Liveness misattribution: EA-issued market closes logged "closed
  externally" in some path (K-runs showed correct attribution;
  verify which path misattributes before assuming).
- One-shot INFO when untagged candidates exist but Manage Mobile
  Trades off; manual multiplier clamp WARN verification.
- Per-symbol auto-calibration of intervals - future Gate 1.

## 7. ACCEPTED COSMETICS (recorded, not churned)
- Benign duplicate "Exits applied" line after stops-level deferral
  retry (same value, no money impact). Stage 8 evidence.

## 8. WORKING AGREEMENTS (Jeff's protocol - binding)
Plan -> matrix -> code -> numbered checklist -> seal, in order, gate
by gate, sealed only by Jeff's explicit confirmation. One question per
message. Surgical edits, never rewrites. No silent paths. Terminal is
truth; recompute every money number before PASS; absence items need
explicit absence checks. STATE.md ships with EVERY build; bump
TRTM_BUILD every delivery. Master rebuilt from Jeff's upload each
session. `input` reserved in MQL5. Money-behavior changes need
explicit confirmation however small. Push back with reasoning.
NOTE: Jeff now runs sessions in Claude Code with CLAUDE.md +
staged-delivery-protocol skill installed; the protocol travels there.
