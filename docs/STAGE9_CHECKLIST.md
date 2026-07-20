# Stage 9 Step 1 - VERIFICATION CHECKLIST (build Stage9-b29)
# Pass/fail per item, live log evidence required.
# Two environments: LIVE = demo chart (regression); TESTER = MT5
# visual Strategy Tester (the new capability). Matrix rows [bracketed].
# Compiler output is gate zero - a clean compile precedes all items.

## A. LIVE regression FIRST (nothing existing may move) [demo chart]
S9-1  Attach b29 to a live demo chart: init log shows NO "[TESTER]"
      line at all. Panel renders normally. [M1-1, M1-4]
S9-2  Click every button live (BUY/SELL/CLOSE/PBUY/PSELL/PCONF/PCXL/
      CXLP/BE/TRAIL): each dispatches via OnChartEvent exactly as b28.
      Full lifecycle arm->confirm->open->close works. NO "[TESTER]
      Panel click via poll" line ever appears. Verify that absence
      explicitly. [M1-2, M4-1]
S9-3  Object list (Ctrl+B / chart objects): buttons still HIDDEN from
      the list (OBJPROP_HIDDEN intact), no new objects, no visual
      change vs b28. Panel bg still behind buttons. [M4-2]
S9-4  Let the panel refresh many times (state changes, arm/disarm,
      sequence open): buttons stay clickable throughout - zorder
      survives PanelRefresh churn. If any button stops responding
      after a refresh, that is M4-3 FAIL -> finding. [M4-3]

## B. TESTER init + gate proxy [visual tester]
S9-5  Launch b29 in visual tester (any symbol/TF): init log shows the
      one-shot "[TESTER] Interactive mode active..." INFO exactly once,
      not repeated per tick. [M2-1]
S9-6  Config-blocked tester run (bad inputs on purpose): the [TESTER]
      init line STILL fires (announced from the config-blocked init
      path too). [M3-1 setup]

## C. TESTER dispatch (representative buttons - M2-3 grouped) [tester]
S9-7  B_BUY latch: poll dispatches once, "[TESTER] Panel click via
      poll: ...B_BUY" line, then BUY ARMED. Button un-presses. [M2-2]
S9-8  Representative spot-check across handler families: one entry
      (B_BUY done), one close (B_CLOSE), one pending (B_PBUY +
      B_PCONF), one toggle (B_BE). Each: [TESTER] line names the
      right button, correct handler runs, un-press clears. Remaining
      buttons (B_SELL/B_PSELL/B_PCXL/B_CXLP/B_TRAIL) pass by identical
      poll->HandlePanelClick branch (name is a string compare). [M2-3]
S9-9  Latch across >1 tick: hold understanding that STATE stays true
      until un-pressed - action fires ONCE on first poll read, no
      repeat on following ticks while the (now un-pressed) button
      sits. [M2-4]
S9-10 Two buttons latched in one tick (rapid double-click of two
      different buttons): both dispatch, in array order, two [TESTER]
      lines, no lost/cross dispatch. [M2-5]

## D. TESTER config-block behavior (no silent swallow) [tester]
S9-11 Config-blocked tester, click a button: poll reaches
      HandlePanelClick, the existing "Buttons are config-blocked -
      fix the inputs first" INFO fires, button un-presses. MUST-NOT:
      click silently swallowed. [M3-1]
S9-12 Clear the config block mid-run: buttons resume normal dispatch,
      no stuck latch carried over from the blocked period. [M3-2]

## E. TESTER full lifecycle on the SHIPPING EA [tester]
# NOT passable by pointing at TPROBE3 - different file. Re-run here.
# Audit every number to the cent, same as live.
S9-13 L1 BUY arm + confirm within 10s (GetTickCount64 window under
      tester speed). [M5-1]
S9-14 L1 SELL arm + confirm. [M5-2]
S9-15 CLOSE arm + confirm -> flat. [M5-3]
S9-16 Pending place + PCONF -> fill registers as L1. [M5-4]
S9-17 Pending place + PCXL (line removed) and CXLP (order canceled),
      correct log each. [M5-5]
S9-18 BE toggle + trigger: offset math exact (recompute). [M5-6]
S9-19 TRAIL toggle + activation + ratchet SL exit: numbers exact. [M5-7]

## Seal condition
SEALED by Jeff 2026-07-20. All 19 items PASS (live regression S9-1..4
+ tester S9-5..19). S9-9 accepted on accumulated evidence; S9-10 by
inspection+procedure (same-tick not manually reproducible, loop
array-order structural); S9-12 by composition (mid-run input change is
a tester limitation). Full disposition in STATE.md. Next: Step 2
(pending-line adjust in tester - drag dead) or the b29-queued
observability batch, Jeff's call. Each is its own build.
