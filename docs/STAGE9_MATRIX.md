# Stage 9 Step 1 - Tester Interactive Mode - SCENARIO MATRIX (rev 1)
# Base build: Stage8-b28 (14f30dcc66197082). Productionize the TPROBE3
# delta so the SHIPPING TRTM.mq5 is interactive in the MT5 visual
# tester, with zero live-chart behavior change.
#
# SCOPE (Step 1 ONLY): button ZORDER + MQL_TESTER-gated OnTick polling
# of the 10 panel buttons -> HandlePanelClick, plus tester-mode
# observability. OUT of scope: pending-line adjustment in tester
# (drag dead) = Step 2; auto-entry stub for non-visual optimizer runs
# = Step 3. Both queued, not covered here.
#
# ENVIRONMENT (empirical, from TESTER_FINDINGS_2026-07-19):
#  - MT5 build 5833 visual tester delivers NO CHARTEVENT_* to EAs.
#    OnChartEvent is dead there. OBJ_BUTTON OBJPROP_STATE toggles on
#    click and is pollable from OnTick. This is the ONLY input channel.
#  - Button STATE LATCHES true on click until code un-presses it;
#    a fast click is not lost between ticks.
#  - Hit-testing needs buttons above the panel bg: ZORDER 10 (bg 0).
#  - Object drag is dead in tester (=> Step 2 problem, not here).
#  - Tester ticks drive OnTick; GetTickCount64 wall-clock unaffected
#    by tester speed (10s confirm window proven in TPROBE3).
#  - Proven interactive fork: TPROBE3 (fb6ff56d852cd5b6), GBPAUD.s
#    M15 2026.06.22 - full lifecycle worked. NOT the delivery chain.
#
# LOCKED DECISIONS (Gate 1, 2026-07-20, this stage):
#  D1 ZORDER 10 on buttons set UNCONDITIONALLY in PanelButtonSet
#     create-block (bg stays 0). Rejected: tester-gated zorder
#     (permanent fork in shared UI code for near-zero verification
#     saving; live regression row is needed either way; 8 stages of
#     buttons worked at zorder 0, so raising to 10 is not expected to
#     change live click behavior - and the M4 row proves it).
#  D2 Poll EVERY TICK (MQL_TESTER-gated OnTick head), matching
#     TPROBE3's proven per-tick timing. Rejected: throttle via
#     GetTickCount64 (solves a perf problem that does not exist on 10
#     integer reads; adds timing state + a latch-read miss window;
#     departs from the proven artifact).
#  D3 Tester-mode observability SPLIT (no-silent-paths at the channel
#     boundary): one-shot INFO at tester init naming the channel, and
#     ONE [TESTER] dispatch-confirmation line per polled click.
#     Downstream lifecycle logs stay BYTE-IDENTICAL to live (so
#     audits transfer unchanged); only the dispatch boundary is
#     marked. Rejected: fully silent dispatch (no double-dispatch
#     detector, violates observability rule); per-line [TESTER] tag
#     smeared across all downstream logs (pollutes audit evidence).
#     Wording:
#       init : "[TESTER] Interactive mode active - OnTick polling 10
#               panel buttons (chart events do not fire in tester,
#               build-confirmed)"
#       click: "[TESTER] Panel click via poll: <BUTTON> (event
#               channel inactive)"
#
# NOTE: MQL_TESTER is NET-NEW in this file (grep-confirmed absent on
# b28). The gate is UNPROVEN code, not an existing guard - M1 exists
# to prove it holds in both directions.
#
# The 10 panel buttons (poll set): B_BUY B_SELL B_CLOSE B_PBUY
# B_PSELL B_PCONF B_PCXL B_CXLP B_BE B_TRAIL.

## Group M1 - gate isolation (MUST-NOT; the safety spine)
M1-1  LIVE chart, any/all buttons clicked          -> dispatch happens via OnChartEvent ONLY. Poll loop MUST be unreachable: no [TESTER] init line at live init, no [TESTER] click line ever. Verify ABSENCE explicitly in a live journal.
M1-2  LIVE chart, full existing panel behavior      -> every button dispatches exactly as b28 (events). Zero behavior delta. (regression anchor for M4.)
M1-3  TESTER, single click                          -> dispatched EXACTLY once. MUST-NOT double-dispatch (no event path in tester, but assert the poll fires the action once per latch, not once per tick while latched). One action, one un-press.
M1-4  gate value at runtime                          -> MQL_TESTER true only under Strategy Tester; false on live/demo attach. The [TESTER] init line is the observable proxy - present in tester, absent live (M1-1).

## Group M2 - tester dispatch, positive (each channel works)
M2-1  TESTER init                                   -> one-shot [TESTER] init INFO fires once, at init only, not repeated per tick.
M2-2  TESTER, B_BUY latches                         -> poll reads STATE==true -> HandlePanelClick(B_BUY) -> HandleEntryClick(1); [TESTER] click line names B_BUY; button un-pressed after.
M2-3  TESTER, each of the other 9 buttons           -> same poll->dispatch->un-press; [TESTER] click line names the correct button; correct handler runs. (Enumerated spot-check, not one row each in evidence - see checklist.)
M2-4  TESTER, latch persists across >1 tick before poll reads it -> action fires ONCE on first read, un-press clears latch, no repeat on subsequent ticks. (Latch/un-press race.)
M2-5  TESTER, two DIFFERENT buttons latched same tick (rapid) -> both dispatched deterministically in poll order, each un-pressed, two [TESTER] lines. No lost click, no cross-dispatch.

## Group M3 - config-blocked in tester (no silent swallow)
M3-1  TESTER, g_configBlocked true, button clicked  -> poll MUST still reach HandlePanelClick (loop sits ABOVE the OnTick config-blocked early-return). HandlePanelClick's own guard logs the "config-blocked - fix inputs" INFO and un-presses. MUST-NOT: poll swallowed silently by the OnTick return.
M3-2  TESTER, config-blocked cleared mid-run         -> buttons resume normal dispatch; no stuck latch from the blocked period.

## Group M4 - live regression (ZORDER 10 changed a live property)
M4-1  LIVE, ZORDER 10 on buttons                    -> every button still receives its click (hit-testing unchanged); full lifecycle arm->confirm->open->close still works via events. MUST match b28.
M4-2  LIVE, object list / chart                      -> buttons still HIDDEN from the object list (OBJPROP_HIDDEN=true intact); bg still behind; no visual change; no new objects.
M4-3  LIVE, panel repaint (PanelRefresh churn)       -> zorder persists across refresh; PanelButtonSet re-entry does not reset zorder wrongly (set is inside create-block - MUST confirm zorder survives the value-update path that runs every refresh). If zorder must be re-asserted each refresh, that is a finding -> new row.

## Group M5 - full tester lifecycle (the payoff, on the SHIPPING EA)
M5-1  TESTER, L1 BUY arm + confirm within 10s        -> opens; GetTickCount64 window correct under tester speed.
M5-2  TESTER, L1 SELL arm + confirm                  -> opens.
M5-3  TESTER, CLOSE arm + confirm                    -> sequence closes flat.
M5-4  TESTER, pending place + PCONF                  -> pending set; fill registers as L1 (existing CheckOwnPendingFillWhenFlat path).
M5-5  TESTER, pending place + PCXL (line) / CXLP (order) -> placement line removed / pending canceled; correct log each.
M5-6  TESTER, BE toggle + trigger                    -> BE arms, offset math exact (re-audit numbers in tester just as live).
M5-7  TESTER, TRAIL toggle + activation + ratchet     -> trail arms, SL trails, ratchet exit. Numbers audited.
# M5 is EQUIVALENCE-BACKED by TPROBE3 but MUST be re-run on the
# production EA - the probe is a different file; equivalence across
# files is not equivalence across a code branch.

## Out of scope (Step 1)
Pending-line adjustment in tester (Step 2: nudge buttons vs input
offset). Auto-entry stub for non-visual optimizer sweeps (Step 3).
Live draggable exit lines (Stage 8 Step 2, parked).

## Status
SEALED by Jeff 2026-07-20. 5 groups, 21 rows. M2-3 grouped
(representative buttons + identical-branch equivalence). Kill/restart
rows N/A - Step 1 adds no persisted state (polling stateless, zorder
display-only); confirmed at seal. M4-3 retained as finding-capable.
VERIFICATION COMPLETE 2026-07-20: all rows evidenced via checklist
S9-1..S9-19 (all PASS). M4-3 came back CLEAN (zorder survived refresh
churn, no finding). M5 re-run on shipping EA (not equivalence to
TPROBE3). Next: b29-queued observability batch, or Stage 9 Step 2
(pending-line adjust in tester - drag dead).
