# TRTM Handover - 2026-07-19 FINAL (Stage8-b28; kill battery complete;
# tester feasibility proven). Written for the next session's model:
# follow CLAUDE.md protocol strictly; this file + STATE.md are truth.

## 1. RESUME PROTOCOL (first actions, in order)
1. Jeff uploads: TRTM.mq5, STATE.md, STAGE8_CHECKLIST.md, this file.
   (STAGE8_MATRIX.md, TESTER_FINDINGS_2026-07-19.md as needed.)
2. Run: sha256sum TRTM.mq5 | cut -c1-16  AND  wc -l
   EXPECT: 14f30dcc66197082 / 4142 lines (build Stage8-b28).
   Match = say "aligned" in one line. Mismatch = STOP, ask which copy
   runs in MT5. Never rebuild from memory or sandbox.
3. NOTE: docs are LF; TRTM.mq5 is CRLF+ASCII (verify after edits;
   naive brace count baseline is -1, compare DELTA only).
4. Read section 3 (next actions). Do not re-plan sealed work.

## 2. WHERE THE PROJECT STANDS
- Stages 1-7 SEALED. Stage 8 Step 1 (manual exit adoption): matrix
  38 rows sealed; checklist COMPLETE except 3 market-hours items.
- Weekend (BTCUST per locked seal-evidence amendment): S8-12, S8-13,
  S8-14-by-K4, S8-23 both halves, S8-24 K0-K5 ALL PASS, 10027 msg.
- One real bug found+fixed this weekend: K2 FAIL on b27 -> b28 fix
  (reconcile M7-5 branch re-adopted the EA's own released TP; b25
  discriminator mirrored into reconcile; matrix row M7-8; K2 PASS +
  K3 positive control PASS on b28). FAIL evidence in STATE.md.
- Tester feasibility PROVEN (see TESTER_FINDINGS_2026-07-19.md):
  full interactive lifecycle works in visual tester via OBJPROP_STATE
  polling + button ZORDER. Chart events NEVER fire in tester (build
  5833). Object drag dead in tester (pending line can't be dragged).
  Working fork: TRTM_TesterProbe.mq5 @ TPROBE3 (fb6ff56d852cd5b6) -
  Jeff may use it for tester runs; NEVER attach to a live chart;
  NOT part of the delivery chain.

## 3. NEXT SESSION - IN THIS ORDER
A. Seal Stage 8 Step 1 on XAUUSD.s (market hours, ~1 focused session):
   1. M6-1: fresh seq, BE override ON, own an SL (any tighter edit).
      Let BE trigger (supersede INFO prints, [MANUAL] drops). Within
      ~30-60s commit a pre-staged SL edit a few pts ABOVE
      trigger+offset in the Modify dialog. PASS = adoption INFO
      (M6-1); deferred placement is fine, adoption is the evidence.
      Also below-floor edit -> refusal WARN already sealed (M6-2 x2).
   2. S8-17: own a TP (any edit), flip TRAIL ON, let it arm.
      PASS = "Manual TP RELEASED - trailing armed" WARN (+ supersede
      INFO if SL owned). Post-arm: S8-21 already sealed by equivalence.
   3. SELL lap: one SELL sequence: S8-6(S) middle-ticket TP edit
      propagates to all within one pass; S8-10(S) tighter SL INFO;
      S8-15(S) level-add TP release + manual SL untouched.
   4. AUDIT EVERY NUMBER TO THE CENT before PASS (gold: no tether
      factor; BTCUST money figures carry ~0.9991).
   5. Then: mark Stage 8 Step 1 SEALED in STATE.md, update Pending.
B. PENDING DECISION (Jeff did not decide - present options A/B):
   Merge tester capability now-ish vs after b29 batch. Option A:
   merge after seal as part of orderly sequence. Option B was "merge
   immediately with micro-gates". Since seal will be done, this
   collapses to: proceed to b29 observability batch first, or Stage 9
   step 1 first. Ask Jeff. Either way each is its OWN build with
   matrix/checklist per protocol.
C. b29 QUEUED (observability/wording only, zero money paths):
   - Geometry INFO: dynamic-stops note (20-100 observed intraday
     XAUUSD.s); "none reported" wording when stops level = 0.
   - AutoTrading: also check MQL_TRADE_ALLOWED, distinct message.
   - Guard A entries-blocked: one-shot file-log WARN (dashboard-only
     today; bit Jeff once via MT5 Inputs Reset trap).
   - Next row: name signal basis ("M15 close <=" vs "ask <=") - the
     touch-style display misled during BTC testing.
   - Lock re-assert msg: name unclean-shutdown-survivor case.
   - Candidate (discuss): one-shot-per-value throttle on M6-2 WARN.
D. Stage 9 (tester support) - Gate 1 sheet in TESTER_FINDINGS file:
   Step 1 productionize TPROBE3 delta (ZORDER 10 on buttons; gated
   OnTick polling of 10 button names -> HandlePanelClick; REVERT the
   TPROBE1 hidden-toggle - unnecessary, keep HIDDEN=true).
   Decisions: zorder unconditional vs gated; poll cadence; wording.
   Step 2 pending-line adjust in tester (drag dead): nudge buttons
   (recommended) vs input offset.
   Step 3 auto-entry stub (MQL_TESTER-gated input: L1 BUY/SELL/
   pending at test start) - REQUIRED for optimizer sweeps.
   Matrix must prove: gates unreachable live; live buttons regress
   clean (events still work, object list still clean); no double
   dispatch (polling + events).

## 4. EMPIRICAL FACTS LEDGER (terminal is truth; do not relearn)
- Doo Prime XAUUSD.s stops level DYNAMIC 20-100 pts intraday.
  BTCUST reports 0/0 (treat as sampled). GBPAUD.s tester: 25.
- BTCUST: spread ~1400-1418 pts; tick-value factor ~0.9991 (tether)
  on every money figure; MaxSpread 80 forfeits all recovery there
  (raised to 3000 for tests); SL 1000pts is INSIDE spread.
- Recovery signal = bar close on InpRecoveryTF + fill-side guard
  (effective distance = interval + spread) + spread filter, each
  with its own forfeit WARN - all observed correct.
- MT5 build 5833 visual tester: NO chart events to EAs at all;
  OBJ_BUTTON state toggling + polling is the ONLY input channel;
  ZORDER needed over panel bg; object drag dead; timers + wall-clock
  (GetTickCount64) fine - 10s confirm window unaffected by speed.
- Task Manager Processes "End task" = GRACEFUL (invalid for kill
  tests); Details "End process" / taskkill /F = real kill. K0 vs K1
  lock lines discriminate ("no existing lock" vs "re-asserted").
- MT5 Inputs "Reset" restores ALL defaults (Guard A trap); Jeff
  keeps a .set preset. Config mystery => ask for inputs screenshot.
- Practice item (workflow, not code): per-symbol .set presets.

## 5. FILE MANIFEST (current truth set)
- TRTM.mq5            Stage8-b28  14f30dcc66197082  4142 lines
- STATE.md            b28 header; weekend session + b28 fix sections;
                      locked log incl. seal-evidence amendment
- STAGE8_MATRIX.md    38 rows (M7-8 added 2026-07-18)
- STAGE8_CHECKLIST.md b28; S8-24b hardened (M7-8 absence assertion)
- TESTER_FINDINGS_2026-07-19.md  channel map + Stage 9 Gate 1 sheet
- TRTM_TesterProbe.mq5  TPROBE3 fb6ff56d852cd5b6 (diagnostic fork)
- ButtonProbe.mq5       channel mapper (keep for forensics)
- ECOSYSTEM_BACKLOG.md  unchanged; never re-import into TRTM

## 6. PARKED (TRTM-only)
- Stage 8 Step 2: draggable exit lines (+ drag-clamp decision).
  NOTE tester finding: drag is live-only; Step 2 design should state
  its tester behavior explicitly (likely: unavailable there).
- Proj at SL under BE projects from computed anchor, not BE floor
  (pre-Stage-8 display question - needs a display decision).
- Liveness misattribution: EA-issued market closes logged as
  "closed externally" in some path (pending list item; note K-runs
  showed correct attribution "closed by EA (market close)" - verify
  which path misattributes before assuming).
- One-shot INFO when untagged candidates exist but Manage Mobile
  Trades is off; manual multiplier clamp WARN verification.
- Per-symbol auto-calibration of intervals (Shadow-TM-style
  "Auto-Adjust") - future Gate 1, do not fold in.
- Tester scenario driver (scripted commands) - superseded largely by
  Stage 9; revisit only if interactive+stub prove insufficient.

## 7. WORKING AGREEMENTS (Jeff's protocol - binding)
Plan -> matrix -> code -> numbered checklist -> seal, in order, gate
by gate, sealed only by Jeff's explicit confirmation. One question
per message. Surgical edits, never rewrites. No silent paths - every
skip/guard/block logs. Terminal is truth; recompute every money
number before PASS; absence items need explicit absence checks.
STATE.md ships with EVERY build; bump TRTM_BUILD every delivery.
Master rebuilt from Jeff's upload each session. `input` is reserved
in MQL5. Money-behavior changes need explicit confirmation however
small. Push back with reasoning; drop ideas when shown conflicts.
