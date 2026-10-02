# TRTM Handover - 2026-10-02 (b42 SEALED)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)

1. Run all four, compare to STATE.md's header (AUTHORITATIVE - not this file):
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16     EXPECT 9209dbe131c9d651  (b42)
   - wc -l src/TRTM.mq5                        EXPECT 5112            (b42)
   - sha256sum the LIVE MT5 runtime copy       EXPECT 9209dbe131c9d651
   Report "repo and runtime aligned at b42" in one line.
   NOTE on wc -l: PowerShell's Measure-Object -Line UNDERCOUNTS this file. Count LF bytes
   (or use git/wc). The sha256 is the byte-level backstop and settles disputes.
   (Prior identities: b41 = d2354c4c1269874e / 5063; b40 = 2e902e9032d820a9 / 4974.)

2. *** THE RUNTIME PATH CHANGED. READ THIS BEFORE HASHING ANYTHING. ***
   THE LIVE RUNTIME IS:
     Terminal/55DBD2FC8CD1E66E27FFA0EC4DDFAAEB/MQL5/Experts/FA_EA/TRTM.mq5
   Through 2026-10-02 CLAUDE.md section 0 named a DIFFERENT file as "the runtime copy":
     Terminal/D0E8209F77C8CF37AD8BF550E51FF075/MQL5/Experts/TRTM.mq5   <- STALE b41, Aug 19
   A third terminal (725B72F2...) holds an orphan .ex5 from Jul 30 with no source.
   CLAUDE.md section 0 is now CORRECTED and the protocol ALSO greps the runtime copy for
   "TEMPORARY DIAGNOSTIC" / "A-1 PROBE". If a 4TH terminal appears, ASK - never guess.

3. b42 is SEALED. E1, E4, E5, E6, b39, b40, b41 and b42 are ALL SEALED - do NOT re-open them.

## 2. WHAT b42 IS (one paragraph)

E9-Q3, retcode validity. CTrade's PositionClose / PositionClosePartial / PositionModify each
return false WITHOUT writing m_result when the position is not selectable (Trade.mqh 474,
608, 370 - all BEFORE their own ClearStructures()). ResultRetcode() then reports the PREVIOUS
order's retcode as if it were this call's. b42 gates all three sites: the EA tests the same
precondition CTrade will test, immediately before the call, and on failure logs "NO ORDER
SENT" and prints NO retcode. Plus a one-line ACCOUNT_MARGIN_MODE probe at init.
  +49 lines (5063 -> 5112). NO new input, NO new global, NO new persisted field, schema still 5.
  Exactly ONE deletion in the whole diff: the build tag.

THE DEFECT THAT CAUSED IT: 2026-09-22 09:25:18, a Tier 3 slice that NEVER SENT logged
"Partial close FAILED ... (retcode 10009: done)". 10009 is DONE - success. It was the retcode
of the preceding successful L8 close. Arithmetic proved the slice never happened:
0.56 - 0.08 - 0.09 = 0.39, and the log read 0.39, not the 0.37 a completed slice would leave.

THE ONE BEHAVIOURAL DELTA: a STALE 10036 can no longer fake a successful close. That return
value feeds FireGroupClose's X-2 abort, so before b42 a tier could proceed to the anchor
believing a profitable leg was banked. It can only turn a wrong TRUE into a correct FALSE.

## 3. GATE 4 DISPOSITION (all 18 rows)

LIVE EVIDENCE:
  A-1  2026-09-24, USDCADS 708972, via a temporary probe build, REVERTED byte-exact the same
       day. The line carried NO retcode token - that absence IS the row.
  A-2  2026-10-02, XAUUSDS 715358, ticket 887205930. A genuine 10027 rejection printed its own
       true retcode and description, x4. CTrade's own OrderSend line was interleaved, PROVING
       the send reached OrderSend rather than inferring it.
  D-3  Same run. fail #1->#2->#3->#4 monotonic, one increment per genuine rejection, recovery
       read EXACTLY 4. This was a Gate-3 working assumption; it is now evidenced.
  C-1/C-2/C-4  Gate Zero init lines, three separate accounts, HEDGING on all.
INSPECTION + FILTERED DIFF: A-3 A-4 A-5 A-6 B-1 B-2 B-3 C-3 D-1 D-2 D-4 D-5 D-6.
  B-2 is the only row Jeff elected to close on inspection rather than wait for. The 10036
  branches diff BYTE-IDENTICAL against committed b41, and a no-send provably returns at
  line 1539 before the CTrade call at 1541 - so the branch is reachable only by a real 10036.
  IF A FUTURE 10036 EVER LOGS ANYTHING OTHER THAN THE BENIGN-RACE INFO, B-2 REOPENS.

## 4. TWO THINGS THAT COST TIME - DO NOT RELEARN THEM

(a) A PROBE SURVIVED EIGHT DAYS IN A TERMINAL NOBODY WAS WATCHING.
    On 2026-10-02 13:09 an init logged all three A-1 PROBE lines under b42, eight days after
    the probe was "reverted". The REPO was clean the whole time and verifiably so. The probe
    lived in the FA_EA copy (section 1 item 2). Root cause: the documented runtime path was
    wrong, so every alignment check hashed a file nobody runs.
    THE THREE-LAYER PROBE GUARD DID NOT CATCH IT, and the 2026-09-24 claim that a probe
    "cannot be forgotten" was OVERSTATED and is withdrawn. The hook only fires on Claude's
    writes inside the repo; the banner and the protocol step both describe the repo; and the
    MT5 boundary correctly forbids Claude writing to the terminal tree, so Claude could not
    have cleaned it either. What caught it was the EA's own logging.
    DURABLE LESSON: a revert is only as wide as the set of copies you know about. Hash the
    file that RUNS and grep it for probe markers.

(b) THE LEVER FOR ANY RETCODE TEST IS A TP *DELETION*, NOT AN EDIT.
    Two attempts produced no failure ladder before the third worked:
      - AutoTrading off with a STEADY-STATE sequence logs NOTHING. EnforceExits is idempotent
        (1871): broker already holds the wanted values, so PositionModify is never called.
        That is D-4 working, and it is why b42 adds zero modify traffic.
      - EDITING the TP to a new non-zero value does not force a modify either: b24's Stage 8
        classifier ADOPTS it, so want == broker and idempotence short-circuits again.
      - Only a REMOVAL forces it: wantTP = (tp>0 && placeable) ? tp : curTP (1902), so
        curTP = 0 != wantTP. Removals are never adopted (1920).

## 5. CARRIED FORWARD

1. E9-Q2 - FALSE-FLAT RECONCILE. THE MOST SERIOUS OPEN ITEM, and it is a REAL defect with
   live evidence, not an inspection finding. 2026-09-18 23:54:59 reconcile declared the broker
   FLAT when it was not, called StateReset -> StateSave, and PERMANENTLY destroyed the
   adoptedL1 record for ticket 2940935091. That position then ran UNMANAGED (no TP, no SL, no
   recovery) from 09-18 until Jeff closed it manually on 09-23. The eight magic-owned levels
   self-healed via b39/F-2; the adopted L1 (magic 0) has NO such path. Mechanism: Reconcile
   trusts PositionsTotal() / PositionSelectByTicket UNCONDITIONALLY at init (2976 + 3001).
   E9-M4 understated this: the file was not LOST, it was OVERWRITTEN BY THE EA on a false read.
   NEEDS ITS OWN GATE 1. Recommended as the next build.
2. E9-Q4 - the slice-selection race. b42 NAMES the event; it does not explain why the anchor
   became unselectable, nor decide retry-vs-accept. Own Gate 1. WATCH ITEM: an elevated count
   of "NO ORDER SENT" lines would mean the race is more common than the single 09-22
   observation suggests - that is information Q4 needs.
3. E9-Q1 stale-quote guard (2026-08-19 incident, 73 minutes of a frozen quote read as truth).
   Own Gate 1, own matrix. Was top priority before the 09-22/09-18 findings jumped the queue.
4. E9 also holds: K-4 slice comment + O6, M4, M2, O3, O4, O5, O2e, W-7, P6.
5. STILL OPEN ON INSPECTION: L-1/L-2/L-4 (need a deliberately corrupted comment),
   F-1..F-5 (flat-state rebuild never triggered), T3-K2 sub-case (a), T3-DS1 dashboard visual.
6. E8 (profit-funded follow-on slice) unblocked since E6, own Gate 1 pending, never opened.
   E2 draggable exit lines, E3 auto-entry still in the backlog.
7. NOT COMMITTED: the b42 delivery is uncommitted in the working tree (src/TRTM.mq5, STATE.md,
   README.md, CLAUDE.md, .claude/hooks/check_hygiene.sh, plus docs/Q3_MATRIX.md and
   docs/Q3_PLAN_2026-09-24_gate3.md untracked). origin/main == HEAD == 5c2ca2f (b41).
   COMMITTING AND PUSHING ARE JEFF'S CALL - ask before doing either.
   NOTE: the ~18 "local-only commits" carried in earlier handovers were ALREADY PUSHED; that
   line was stale and is retired.

## 6. TEST-DESIGN RULES (unchanged, still binding)

- InpTier3MinTrades MUST stay >= 4. At 2 the profitable group IS the whole basket, M-1 stands
  down, and Tier 3 can never fire.
- InpEntryLotSize 0.05 for Tier 3 runs; at the 0.01 default Tier 3 cannot fire at all.
- InpEnableTrailing MUST be false for verification runs - it killed sequences twice.
- Restart-with-open-positions rows MUST be a LIVE chart, never the tester.
- After switching accounts in a running terminal, RESTART THE TERMINAL before trusting quotes.
- The MT5 Include tree is the authority on CTrade signatures. VERIFY an overload before
  planning against it - that is what K-4 cost.

## 7. ENVIRONMENT NOTES

- A second EA (TradingToolkit TK-B001) is attached to the XAUUSD.s chart. It does not share
  TRTM's magic so it cannot affect tracking, but it is the first other candidate if an
  unexplained position change appears there.
- AT SEAL TIME an open 0.01-lot BUY on XAUUSD.s (ticket 887205930) carried TP 4192.44 and
  NO STOP LOSS (InpStopLossPts = 0 on that chart). Named here deliberately rather than left
  implicit - it was a verification sequence, not a trading decision.
- SCALE OF DEPLOYMENT - LARGER THAN STATE.md IMPLIES. tests/2026.09.30 174332.508.txt shows
  EIGHT TRTM instances running b41 concurrently on 2026-09-30: XAUUSDS 715358, AUDNZDS 709170,
  USDCADS 708972, CADJPYS 716875, AUDUSDS 704902, AUDCHFS 723047, USDCHFS 766673,
  GBPAUDS 730053. Earlier notes discuss one or two instances at a time, which understates it.
  CONSEQUENCES WORTH HOLDING: (1) a defect's blast radius is eight symbols, not one - E9-Q2's
  false-flat reconcile could strand an adopted L1 on ANY of them; (2) the per-symbol instance
  lock and the per-symbol state files are carrying real concurrent load, not a test case;
  (3) when b42 is deployed, it must be deployed to ALL instances or the fleet runs mixed
  builds - and a mixed fleet makes any future log audit ambiguous about which build produced
  which line. NOT a defect, but a planning fact that was not previously written down.
- Broker geometry observed: stops level 50 pts on Doo XAUUSD.s, 25 pts on USDCAD.s / AUDNZD.s.
  DYNAMIC - never treat a sampled value as constant.

## 8. NEXT

Jeff's call. Ranked as of this seal:
  (a) E9-Q2 false-flat reconcile - a proven live defect that left a position unmanaged for
      five days. Strongest claim on the next build.
  (b) E9-Q4 slice race - now better instrumented by b42, and worth running b42 a while first
      to see how often "NO ORDER SENT" actually appears.
  (c) E9-Q1 stale-quote guard - own Gate 1, drafted reasoning already in STATE.md.
  (d) Commit + push the b42 delivery (Jeff's decision).
Gate order applies from the top for all of them: locked decisions -> sealed matrix ->
confirmed plan -> build -> evidence-audited verification -> seal on Jeff's explicit word.
