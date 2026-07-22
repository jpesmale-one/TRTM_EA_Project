# TRTM Handover - 2026-07-21 (Stage9s2-b33; Stage 9 Step 2 tester
# pending-line NUDGE - SEALED). Follow CLAUDE.md + staged-delivery +
# session-continuity skills. This file + STATE.md are truth.

## 1. RESUME PROTOCOL (first actions, in order)
1. Jeff uploads: TRTM.mq5, STATE.md, and relevant stage files.
2. Run: sha256sum TRTM.mq5 | cut -c1-16  AND  wc -l
   EXPECT: b732b80fddf75fda / 4296 lines (build Stage9s2-b33).
   Match = say "aligned" in one line. Mismatch = STOP, ask which copy
   runs in MT5. Never rebuild from memory or sandbox.
3. TRTM.mq5 is CRLF+ASCII (verify after edits; naive brace baseline is
   -1: compare DELTA only. b33 count is 409 { / 410 }). EOF has NO
   trailing newline (last byte is '+') - match it if you rewrite.
4. Read section 3. Do not re-plan sealed work.

## 2. WHERE THE PROJECT STANDS
- Stages 1-7 SEALED. Stage 8 Step 1 SEALED (b28). Stage 9 Step 1
  SEALED (b29). Stage 10 observability SEALED (b32). Stage 9 STEP 2
  (tester pending-line nudge) SEALED 2026-07-21 at b33 - this session.
- Two Gate 1 decisions locked this session (both in STATE.md):
  * Martingale compounding basis: CLOSED-FORM kept, recursive request
    WITHDRAWN by Jeff. Zero code. R-a/R-b rejected w/ rationale.
  * Stage 9 Step 2 mechanism: NUDGE (rejected OFFSET).
- One build: b33 (Stage 9 Step 2). Zero money paths.

## 3. NEXT SESSION - queued items (Jeff picks order)
No pending Gate 1 forced. Candidates:
- BE ANCHOR simple-vs-lot-weighted (money-path, own Gate 1). Fresh
  evidence this session: S1 BE logged SIMPLE avg 4183.07 (vs weighted
  4192.20) on lots 0.01/0.02/0.03/0.04/0.05. This is the parked anchor
  item - unchanged from b32, confirmed still live. Decide if/when.
- Stage 9 Step 3: auto-entry stub (MQL_TESTER-gated). REQUIRED before
  parameter optimization. OFFSET (rejected for Step 2) is the seed
  mechanism to reuse here.
- Stage 8 Step 2: draggable EXIT (SL/TP) lines LIVE - NOT built (only
  the pending PLACEMENT line exists today; confirmed by code read this
  session). Full money-path feature: Gate 1 -> matrix -> plan.
- Stage 8 gold-hours items: M6-1 (post-BE SL adoption above floor),
  S8-17 (trail-arm TP release), SELL lap (direction symmetry).
- STATE.md env-note reword (stops "=100" -> dynamic). Small, flagged.
- Transfer to Claude Code for subsequent builds (handover files ready).

## 4. STAGE 9 STEP 2 SCOREBOARD (audited; seal evidence)
Build b33: input InpTesterNudgePts (clamp >=1) + NudgePendingLine()
(moves ONLY PLINE OBJPROP_PRICE) + 2 TESTER-ONLY buttons B_PUP/B_PDN on
the CONFIRM row + poll array 10->12. Live panel byte-identical.
- PASS (audited, cent-exact): S1 (full lifecycle: SELL entry 0.01
  @4159.95 -> 5 recovery levels -> BE simple-avg 4183.07, BE SL 4182.77
  -> all 5 SL-close @4182.77, realized +141.50; every Structure
  projection L1-L5 and both guards recomputed exact), S3, S4, S5, S6,
  S8 (step-0 clamp to 1), S9, S10, S11 (band refusal 14 pts, line kept),
  S12 (buy-limit places at nudged price), S16, S18 (live restart, line
  gone, reason-5 deinit).
- EQUIVALENCE: S13/S14 (Guard B/C) - ConfirmPendingOrder + guards +
  ClampEntryVolume byte-identical b32==b33; confirm reads nudged price.
- INSPECTION: S15 (guard unreachable via UI), S17 (pendingLive collapse
  observed), S19 (no persisted field; 292 persistence lines identical,
  schema=4), S20 (no live buttons per S2).
- Trail sub-leg of S1: NOT market-exercised (BE stop closed first);
  CARRY-FORWARD - trail engine byte-identical to sealed b32.
No FAILs. No new parked items.

## 5. EMPIRICAL FACTS LEDGER (terminal is truth; do not relearn)
NEW this session:
- MT5 VISUAL TESTER HAS NO IN-PASS EA RESTART (Jeff-corrected, OBSERVED).
  No remove/re-attach, no Properties/param-change re-init mid-pass. Must
  stop + restart the whole pass. => restart-row tests run on a LIVE demo
  chart (real OnDeinit->OnInit). S18 was run live for this reason.
- Gold XAUUSD.s point scale: _Point 0.01, contract x100 (0.01 lot = $1
  per $1 move). 50-pt nudge = 0.50 price. Confirmed vs GBPAUD.s (5-digit,
  50 pts = 0.00050) - nudge math is per-symbol _Point, verified both.
- BE anchor on this build uses SIMPLE mean of entries (S1: 4183.07),
  NOT lot-weighted (4192.20). Known/parked, re-confirmed live.
CARRIED (still true): Doo Prime XAUUSD.s stops DYNAMIC ~100 pts; Task
Mgr Processes "End task" graceful (invalid for kill); Inputs "Reset"
restores ALL defaults (.set preset); tester chart events dead, poll
OBJ_BUTTON STATE; MQL_TRADE_ALLOWED reads true at OnInit; OnDeinit
releases lock unconditionally.

## 6. FILE MANIFEST (current truth set)
- TRTM.mq5                    Stage9s2-b33  b732b80fddf75fda  4296 lines
- STATE.md                    b33 header; b33 change section SEALED;
                              2 Gate1 decisions logged; empirical facts
                              updated; parked list current
- STAGE9_STEP2_MATRIX.md      20 rows (N1-N4); SEALED + verification note
- STAGE9_STEP2_CHECKLIST.md   S1-S20; SEAL disposition
- STAGE9_STEP2_CODEPLAN.md    8 touch points; delivered
- GATE1_martingale_basis.md   decision brief (CLOSED, closed-form kept)
- GATE1_tester_pending_adjust.md  decision brief (NUDGE chosen)
- README_stage9_step2_section.md  paste into repo README (not done in-session)
- STAGE10_* / STAGE9_* / STAGE8_*  sealed prior
- ECOSYSTEM_BACKLOG.md        never re-import into TRTM

## 7. TODO for Jeff (carry into repo)
- Paste README_stage9_step2_section.md into the project README.
- Confirm build-tag scheme: this session used "Stage9s2-b33" (Stage 9
  Step 2, build 33) since work returned to Stage 9 after Stage 10.

## 8. WORKING AGREEMENTS (binding; from CLAUDE.md)
Gate order: locked decisions -> sealed matrix (money paths) -> confirmed
plan -> surgical build -> evidence-audited verification -> seal on Jeff's
explicit word. One question per message. No silent paths. Terminal is
truth; recompute every money number before PASS; absence items need
explicit absence checks. STATE.md ships with EVERY build; bump
TRTM_BUILD every delivery. Master rebuilt from Jeff's upload each session.
`input` reserved in MQL5. Money-behavior changes need explicit
confirmation however small. Chat concise (what-it-is / choice+rec /
question); traces + rationale go in artifact files.
