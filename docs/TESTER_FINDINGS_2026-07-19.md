# TRTM Strategy Tester Findings - 2026-07-19 (probe session)
# Empirical record + Stage 9 Gate 1 sheet. Probes are diagnostic forks,
# NOT the delivery chain. Master remains Stage8-b28 14f30dcc66197082.

## Empirical channel map (MT5 build 5833, visual tester, ButtonProbe)
1. CHARTEVENT_* : NONE delivered to EAs in the tester. Not object
   clicks, not mouse (even when CHART_EVENT_MOUSE_MOVE enabled), not
   bare chart clicks. OnChartEvent is dead there. (TPROBE2: zero
   telemetry across all click types while RUNNING - pause was ruled
   out as the variable.)
2. OBJ_BUTTON OBJPROP_STATE : DOES toggle on click (terminal-side
   hit-testing works) and is pollable from OnTick. This is the ONLY
   live interaction channel. (ButtonProbe channel B.)
3. Hit-testing priority: TRTM buttons under the panel background
   rectangle did NOT toggle until OBJPROP_ZORDER was raised above the
   bg (TPROBE2 video: no stuck-pressed button = no toggle without
   zorder; TPROBE3 with zorder: toggles + dispatch working).
4. Object DRAG does not work in the tester even for a line created
   SELECTABLE+SELECTED (live-verified flags). No mouse channel = no
   drag. Pending line placement needs an alternate adjustment path.
5. Shadow Trade Manager's tester interactivity is therefore polling
   too; its "OnChartEvent:" journal lines are its own prints.
6. Full TRTM lifecycle PROVEN interactive on historical data
   (TPROBE3 run, GBPAUD.s M15 2026.06.22): L1 BUY/SELL arm+confirm,
   close arm+confirm, pending place/confirm/cancel, BE toggle +
   trigger (offset math exact), trail toggle + activation + ratchet
   SL exit, liveness attribution, flat marker. 10s confirm window
   runs on GetTickCount64 (wall clock) - unaffected by tester speed.

## TPROBE3 delta that made it work (candidate production changes)
- PanelButtonSet: OBJPROP_ZORDER = 10 on buttons (bg stays 0).
- OnTick head, gated MQL_TESTER: poll all 10 button names for
  OBJPROP_STATE==true -> HandlePanelClick(name) (which un-presses).
- (TPROBE1's hidden-toggle proved unnecessary - hit-testing works on
  hidden objects once zorder is right; production keeps HIDDEN=true
  unconditionally.)

## Stage 9 proposal (Gate 1 pending, do NOT build until Step 1 seals)
Step 1 - Tester interactive mode: productionize the TPROBE3 delta.
  Decisions needed: zorder unconditional vs tester-gated; polling
  cadence (every tick vs throttled); log wording.
Step 2 - Pending-line adjustment in tester (drag unavailable):
  Option A: tester-only nudge buttons (+/-N pts) shown while a
    placement line exists; polling channel proven. Recommended.
  Option B: tester-only input offset (line created at price+offset,
    confirm as-is). Trivial fallback, no mid-run adjustment.
Step 3 - Auto-entry stub for NON-visual runs (optimizer sweeps):
  input-selected L1 BUY/SELL/pending at test start, MQL_TESTER-gated.
  Required for parameter optimization (no clicking in non-visual).
Matrix must include: all gates unreachable outside tester; live-chart
regression (buttons still work via events, still hidden from object
list); polling never double-dispatches with the event path.

## Session artifacts
- ButtonProbe.mq5 (channel mapper, keep for future tester forensics)
- TRTM_TesterProbe.mq5 @ TPROBE3 fb6ff56d852cd5b6 (working fork -
  usable for tester experiments TODAY, never attach to live)
