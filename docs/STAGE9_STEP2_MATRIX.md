# Stage 9 Step 2 - Tester pending-line NUDGE - SCENARIO MATRIX (rev 1)
# Base build: Stage10-b32 (0423704065ebd089 / 4236 lines).
# Target build: Stage9-Step2-bNN (label TBC by Jeff).
#
# SCOPE: add a tester-only input mechanism to move the existing pending
# placement line (PLINE) so the SEALED pending-confirm flow becomes
# exercisable in the visual tester. The confirm path itself is UNCHANGED:
# ConfirmPendingOrder() still reads ObjectGetDouble(PLINE, OBJPROP_PRICE)
# and runs ComputeEntryLot -> EntryLotRecoveryConsistent (Guard C) ->
# EntrySLRealizable (Guard B) -> broker stops-level band -> place. This
# batch adds movement + 2 buttons + INFO logs. ZERO money-logic change.
#
# LOCKED DECISIONS (Gate 1, 2026-07-21 - see STATE.md):
#  G1  Mechanism = NUDGE (rejected OFFSET: non-interactive + overlaps
#      Step 3 auto-entry).
#  G2  Buttons B_PUP/B_PDN created AND polled in TESTER ONLY
#      (MQL_TESTER-gated). Live panel stays byte-identical.
#  G3  Step = InpTesterNudgePts (default 50, clamp >=1).
#  G4  NO band clamp on movement; free either side of market. CONFIRM is
#      the sole authority (already refuses + keeps line for re-nudge).
#      Each nudge logs new line price (INFO).
#
# STATE ADDED: none persisted. The only mutable state is PLINE's own
# OBJPROP_PRICE (an object property, already non-persisted - the line is
# destroyed on restart, StartPlacementLine log says so). No new struct
# field => MQL5 uninit-field trap N/A, no state self-test change.
#
# EXACT button geometry + creation site live in the code plan, not here.

## Group N1 - Nudge movement mechanics [tester, pending line live]
N1-1  B_PBUY poll creates PLINE at ask; click B_PUP once            -> line price = ask + InpTesterNudgePts*_Point; ONE INFO logs the new price. (positive)
N1-2  Click B_PDN once from N1-1                                    -> line price decreases by one step; back to prior price; INFO logs it.
N1-3  Click B_PUP 3x                                                -> line moves 3 steps up total; THREE INFO lines (one per click), each the running price. No skipped/merged clicks (latch dispatch, M2-5 style).
N1-4  B_PUP and B_PDN both latched in ONE tick                      -> dispatch in poll-array order (up then down net zero, or defined order); each logs; no lost click, no crash. (mirrors existing two-in-one-tick rule)
N1-5  InpTesterNudgePts = 0 or negative at init                    -> clamped to >=1 at read; init INFO/WARN notes the clamp; nudge still moves >=1 pt. MUST-NOT: a 0-pt no-move click that logs "moved" (false movement).
N1-6  Nudge a SELL placement line (B_PSELL) up and down            -> same behavior; direction of the line's inferred order is NOT decided by nudge (still inferred at confirm from line vs fill side, P2). Verify nudge does not touch g_pendDir.

## Group N2 - Nudge -> confirm integration (the payoff) [tester]
N2-1  Nudge the line WELL above market, then B_PCONF               -> confirm reads the nudged price; passes the stops-level band; ComputeEntryLot/Guard C/Guard B run exactly as live; pending order placed at the nudged price. Every money number (lot, price, SL realizability) recomputed = a live confirm of the same line price.
N2-2  Nudge the line INTO the stops-level band, then B_PCONF       -> confirm REFUSES with the existing band WARN naming pts-from-market; line KEPT for re-nudge (P6 behavior byte-identical). MUST-NOT: nudge suppresses or alters the refusal.
N2-3  Nudge to make a buy-LIMIT (line below market) then confirm   -> order type inferred at confirm unchanged; places/refuses per existing logic. Confirms G4 free-movement is required (a band clamp would have blocked this).
N2-4  Guard B unrealizable at the nudged price, confirm            -> EntrySLRealizable refuses with its existing message vs the LINE price; line kept. Money validation path unchanged.
N2-5  Guard C (L1 vs fixed recovery) fails, confirm                -> EntryLotRecoveryConsistent refuses as today; nudge irrelevant to the lot path. Verify unchanged.

## Group N3 - MUST-NOT / gating / edges
N3-1  MUST-NOT (LIVE, not tester): B_PUP/B_PDN are NOT created and NOT polled. Live panel object set + geometry byte-identical to b32. Verify absence of both buttons live.
N3-2  MUST-NOT: money paths. ConfirmPendingOrder / ComputeEntryLot / Guard B / Guard C / stops-band strings + numbers byte-identical to b32. Nudge only writes OBJPROP_PRICE + logs. grep-confirm no new send/modify/close.
N3-3  Nudge with NO placement line present (g_pendDir==0 / PLINE absent) -> no-op; ONE INFO "no pending line to nudge"; no crash, no object created. (availability log, not silent)
N3-4  MUST-NOT: nudge does not alter g_pendDir, does not create/destroy the line, does not trigger confirm or cancel. Only OBJPROP_PRICE changes.
N3-5  Pending order already exists (CountOwnPendingOrders>0), user nudges -> nudge still only moves the (new, unconfirmed) line if one exists; confirm still enforces one-pending-max (P7) unchanged. Verify P7 path untouched.

## Group N4 - Restart / kill / dispatch (the safety spine)
N4-1  RESTART (re-attach/recompile) in tester with a nudged line   -> line is destroyed (already non-persisted); no orphan PLINE, no stale price, no phantom nudge state. Re-create fresh via B_PBUY/PSELL. Verify no leftover object/state.
N4-2  KILL: N/A money state - no persisted field added (only OBJPROP_PRICE, non-persisted). Confirm state file schema/self-test byte-identical to b32 (no new key).
N4-3  Poll array grows 10 -> 12; existing 10 buttons dispatch order + behavior unchanged. Verify the 10 sealed Stage 9 rows still hold (regression), new 2 appended at the end.
N4-4  MUST-NOT: nudge buttons do NOT fire on the LIVE chart-event path (they don't exist live per N3-1); OnChartEvent CLICK handling for the existing panel unchanged.

## Out of scope
Stage 9 Step 3 (auto-entry stub) - separate. Stage 8 Step 2 (live
draggable EXIT lines) - separate, unbuilt. OFFSET mechanism - rejected
(Gate 1), reserved for Step 3.

## Status
SEALED by Jeff 2026-07-21. rev 1. Must-NOT rows: N1-5, N2-2, N3-1,
N3-2, N3-4, N4-2, N4-4. Restart/kill: N4-1, N4-2. No code until sealed.

## VERIFICATION COMPLETE + SEALED at Stage9s2-b33 (2026-07-21)
All 20 rows evidenced. N-rows -> S-items 1:1 (see checklist). Live-audited
except N2-4/N2-5 (Guard B/C) by equivalence (byte-identical confirm+guards)
and N3-3/N4-4/N3-1-tail by inspection/absence. Zero money-path change
proven: trade-primitive count 8=8; ConfirmPendingOrder, EntrySLRealizable,
EntryLotRecoveryConsistent, ClampEntryVolume, HandleToggleClick,
RunStateSelfTest all byte-identical to b32. No FAILs.
