# TRTM Handover - 2026-10-03 (b44 SEALED)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)

1. Run all four, compare to STATE.md's header (AUTHORITATIVE - not this file):
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16     EXPECT 57bc3811df272e40  (b44)
   - wc -l src/TRTM.mq5                        EXPECT 5224            (b44)
   - sha256sum the LIVE MT5 runtime copy       EXPECT 57bc3811df272e40
   Report "repo and runtime aligned at b44" in one line.
   NOTE on wc -l: PowerShell's Measure-Object -Line UNDERCOUNTS this file. Count LF bytes.
   (Prior: b42 = 9209dbe131c9d651 / 5112; b41 = d2354c4c1269874e / 5063.)

2. THE LIVE RUNTIME PATH (corrected 2026-10-02, and it matters):
     Terminal/55DBD2FC8CD1E66E27FFA0EC4DDFAAEB/MQL5/Experts/FA_EA/TRTM.mq5
   The D0E8209F copy is STALE b41 and is NOT the runtime. ALSO grep the runtime copy for
   "TEMPORARY DIAGNOSTIC" / "A-1 PROBE" - a repo-only hash is blind to a probe left in a
   terminal tree, which is how one survived eight days in September.

3. THE MANIFEST SHA TRACKS THE WORKING FILE, NOT THE GIT BLOB. git normalises CRLF->LF on
   commit here, so `git show HEAD:src/TRTM.mq5 | sha256sum` will NEVER match. That is
   EXPECTED, not drift. Do not declare a STOP on it.

4. SEALED, do NOT re-open: E1, E4, E5, E6, b39, b40, b41, b42, b44.
   b43 is a WITHDRAWN INTERMEDIATE - Gate Zero passed, A-8 FAILED, never sealed, NEVER DEPLOY.

## 2. WHAT b44 IS

E9-Q2, directional record management. Jeff's own design, in his words:
    DELETION goes MT5 -> file.  A ticket leaves the record ONLY on affirmative evidence.
    RECONCILIATION goes file -> MT5.  The file proposes; MT5 confirms by ticket.
An ABSENCE can never delete anything.

THE DEFECT: on 2026-09-18 23:54:59 a Friday-rollover restart found the position cache
unpopulated. Reconcile read "broker is flat", called StateReset + StateSave, and PERMANENTLY
destroyed the adoptedL1 record for ticket 2940935091. Nothing had closed - all nine positions
reappeared on 09-21. The eight magic-owned levels self-healed via b39/F-2; the magic-0
adopted L1 has NO such path, so it ran with NO TP, NO SL and NO recovery for FIVE DAYS until
Jeff closed it by hand.

THE MECHANISM: HistorySelectByPosition is a DIFFERENT DATA SOURCE from PositionsTotal() and
they fail INDEPENDENTLY. An unpopulated position cache says NOTHING about history. History is
therefore the affirmative evidence that separates "this closed" from "I cannot see it yet" -
the distinction the EA collapsed. ClosingDealReason now returns -1 for "no closing deal
found", and TicketConfirmedClosed is the ONE place that judgement lives.

90-DAY EXPIRY: an UNKNOWN record older than 90 days is discarded, aged from the file's
existing lastSaved. No new per-ticket field, NO SCHEMA BUMP (schema stays 5) - a bump would
DISCARD the file and destroy the very record under repair, and with eight live instances that
would mean eight deploy windows.

## 3. GATE 4 DISPOSITION - ALL 25 ROWS

LIVE EVIDENCE (13): A-1 A-2 A-3 A-4 A-5 A-7 A-8 A-9 B-1 B-2 C-1 C-4 D-2
  A-1  a fabricated ticket (999999999, never existed) is classified UNKNOWN, the record is
       KEPT, nothing is written. The row the 09-18 incident failed.
  A-2  a REAL ticket (890591787) with a genuine closing deal IS deleted.
       A-1 + A-2 TOGETHER prove a DISCRIMINATOR, not blanket suppression. Neither alone does.
  A-5  the stale-tag gate anchor is still set on a genuine flat. CONFIRMED TWICE by different
       routes - B-1's expiry path and a real close. This was the ONE regression risk named at
       Gate 3: a zero lastCloseTime makes all three gates stand down and every tagged magic-0
       position become adoptable, stale ones included.
  A-8  the state file is BYTE-IDENTICAL across a full init + deinit cycle. THE ROW b43 FAILED.
INSPECTION + FILTERED DIFF (12): A-6 B-3 B-4 C-2 C-3 D-1 D-3 D-4 D-5 D-6 D-7 D-8

## 4. THE b43 FAILURE - THE MOST INSTRUCTIVE THING IN THIS CYCLE

b43's reconcile keep-path was CORRECT and A-1 passed on it. But it did `g_state = file`,
leaving levelCount = 1 holding a ticket just classified UNKNOWN. The EA then treated an
unconfirmed record as a LIVE SEQUENCE: OnDeinit's `if(levelCount > 0) StateSave()` REWROTE
the fixture, liveness churned on it every tick, and a level-0 entry reached anchor-eligible
state (b39's L-3 forbids exactly that - FormBasketGroup picks the LOWEST level as anchor).

JEFF CAUGHT IT FROM ONE WRONG CHARACTER: the log said "#0" where it should have said
"#999999999". The matrix row A-1 PASSED on that same run - the defect was DOWNSTREAM of what
A-1 asserts, so the matrix as written could not have caught it. That is the second time in
this cycle a log line Jeff questioned turned out to be the thread worth pulling (the first
was "retcode 10009: done" in September).

E9-Q2-D2 fixed it in ONE statement:
    g_state = file;   ->   StateReset(g_state); g_state.lastCloseTime = lastClose;
THE lastCloseTime CARRY IS LOAD-BEARING. g_state is a zero-initialised global, and a bare
StateReset would have left lastCloseTime = 0, standing the stale-tag gate down completely.
Without that one line, A-7 would have fixed one defect and opened another.

## 5. PROCESS FINDINGS WORTH KEEPING (each cost a cycle)

- A FIXTURE COPY CAN SILENTLY FAIL. The first b44 run read the OLD corrupt file and printed
  "#0" again. Diagnosed by TIMESTAMP, not guesswork: the live file carried adoptionTime
  1790931849 while the fixture carried 1790967639 - provably different files.
  THE EA MUST BE FULLY REMOVED (not re-initialised) before overwriting the state file, and
  THE COPY MUST BE VERIFIED ON DISK BEFORE THE RUN.
- READ/HASH THE STATE FILE BEFORE ANY DEINIT. The b43 run was invalidated because the
  deinit-save destroyed the evidence before it was captured.
- CLAUDE CAN READ THE MT5 TREE (only WRITING is denied by section 3a), so Claude hashes the
  files and Jeff only copies and attaches. Fewer steps, no transcription risk.
- A-7 IS ONLY OBSERVABLE ON THE DASHBOARD (Direction row FLAT vs BUY - L1). Capture it BEFORE
  detaching - PanelDestroy() removes the only evidence.

## 6. CARRIED FORWARD

1. DEPLOYMENT REACH - THE BIGGEST OPEN DECISION. EIGHT instances were running b41 on
   2026-09-30 (XAUUSDS, AUDNZDS, USDCADS, CADJPYS, AUDUSDS, AUDCHFS, USDCHFS, GBPAUDS).
   Only XAUUSDS runs b44. THE DEFECT b44 FIXES COST AN UNMANAGED POSITION ON AUDNZDS - the
   symbol that is NOT yet updated. A seal deploys nothing; rolling b44 to all eight is Jeff's
   call, and a mixed fleet makes future log audits ambiguous about which build produced which
   line.
2. E9-Q4 - the slice-selection race. b42 NAMES the event; it does not explain why the anchor
   became unselectable, nor decide retry-vs-accept. Own Gate 1. WATCH ITEM: the frequency of
   "NO ORDER SENT" lines in normal running is the information Q4 needs.
3. E9-Q1 - stale-quote guard (2026-08-19, 73 minutes of a frozen quote read as truth). Own
   Gate 1, own matrix. Was top priority before Q2/Q3 jumped the queue on live evidence.
4. E9-M4's TRUE FILE-LOSS CASE IS NOT CLOSED AND IS NOT CLOSABLE IN CODE. If the state file is
   DELETED or the data folder changes, a magic-0 adopted position has no magic, no reliable
   tag and no record. b44 closes the OVERWRITE case completely. Documented, not pretended away.
5. E9 also holds: K-4 + O6, M2, O3, O4 (unreachable - all accounts HEDGING), O5, O2e,
   W-7 (narrowed - Jeff's two accounts cannot collide), P6.
6. STILL OPEN ON INSPECTION: L-1/L-2/L-4, F-1..F-5, T3-K2 sub-case (a), T3-DS1.
7. E8 unblocked since E6, own Gate 1 pending. E2, E3 in the backlog.
8. NOT COMMITTED: b44 and all Q2 docs are uncommitted. origin/main == 36c3dc1 (b42 + the
   CRLF note). COMMITTING AND PUSHING ARE JEFF'S CALL.

## 7. TEST-DESIGN RULES (unchanged, still binding)

- InpTier3MinTrades MUST stay >= 4; InpEntryLotSize 0.05 for Tier 3 runs (at 0.01 Tier 3
  cannot fire at all); InpEnableTrailing MUST be false for verification runs.
- Restart-with-open-positions rows MUST be a LIVE chart, never the tester.
- After switching accounts in a running terminal, RESTART THE TERMINAL before trusting quotes.
- The MT5 Include tree is the authority on CTrade signatures. VERIFY before planning.
- THE LEVER FOR ANY RETCODE TEST IS A TP *DELETION*, NOT AN EDIT (b42 lesson): a steady state
  logs nothing (idempotence), and an EDIT is ADOPTED by b24's classifier. Only a removal
  forces a PositionModify.

## 8. ENVIRONMENT

- A second EA (TradingToolkit TK-B001) shares the XAUUSD.s chart. Different magic, so it
  cannot affect tracking - but it is the first other candidate for any unexplained change.
- InpStopLossPts is 0 on the XAUUSD.s chart: sequences there run with NO stop loss. Named
  deliberately. The 2026-10-03 A-2 test ran a 0.01-lot BUY uncapped for ~2 minutes.
- Broker geometry: stops level 50 pts on Doo XAUUSD.s, 25 pts on USDCAD.s / AUDNZD.s.
  DYNAMIC - never treat a sampled value as constant.

## 9. NEXT

Jeff's call. Ranked:
  (a) DEPLOY b44 TO THE REMAINING SEVEN INSTANCES - the fix is sealed and the symbol that
      suffered the original defect is still running the defective build.
  (b) Commit + push b44 and the Q2 docs.
  (c) E9-Q1 stale-quote guard - own Gate 1, reasoning already drafted in STATE.md.
  (d) E9-Q4 slice race - better instrumented by b42; worth running a while first.
Gate order applies from the top: locked decisions -> sealed matrix -> confirmed plan ->
build -> evidence-audited verification -> seal on Jeff's explicit word.
