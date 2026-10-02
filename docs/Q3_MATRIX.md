# E9-Q3 MATRIX - **SEALED rev 1 by Jeff 2026-09-24**
# *** ALL ROWS DISPOSED. b42 SEALED BY JEFF 2026-10-02. GATE 6 CLOSED. ***
#   LIVE EVIDENCE : A-1 (2026-09-24 probe), A-2 + D-3 (2026-10-02), C-1/C-2/C-4 (Gate Zero).
#   INSPECTION    : A-3 A-4 A-5 A-6 B-1 B-2 B-3 C-3 D-1 D-2 D-4 D-5 D-6.
#   B-2 was inspection-closed on Jeff's call - the 10036 branches diff BYTE-IDENTICAL
#   against b41 and a no-send provably returns before the CTrade call, so the branch is
#   reachable only by a real 10036. No b42 run has yet OBSERVED one; if a future 10036
#   logs anything other than the benign-race INFO, B-2 REOPENS. Full reasoning in STATE.md.
#   D-3 was a Gate-3 working assumption and is now EVIDENCED: fail #1..#4 monotonic, one
#   increment per genuine rejection, recovery read exactly 4.
# Gate 2 CLOSED. No row may be added, removed or reworded without Jeff re-opening the seal.
# A Gate 3 code plan may now be drafted FROM this matrix.
# SEALED WITH TWO ITEMS UNANSWERED - carried into the Gate 3 plan as working assumptions,
# overturnable at Gate 3 WITHOUT reopening this seal:
#   D-3  a no-send does NOT increment g_modifyFails (matrix recommendation adopted).
#   QQ1  A-1 evidence via a temporary probe build, then reverted (option (b) adopted).
#        DONE 2026-09-24: probe built (13aa1a504ce1d59b/5125), RUN on USDCADS 708972 at
#        10:12:46.711, A-1 PASSED, reverted byte-exact to 9209dbe131c9d651/5112.
#        Disposition and the full evidence are in STATE.md. A-1 IS CLOSED - do not
#        re-run the probe. This annotation records an OUTCOME; no row was reworded,
#        so the rev-1 seal stands.
#
# E9-Q3 MATRIX - Gate 2 (drafted 2026-09-24)
# Defect: g_trade.Result*() is read after CTrade returned false WITHOUT having reached
# OrderSend, so the EA reports the PREVIOUS order's retcode as this call's outcome.
# Gate 1 decision this matrix implements: E9-Q3-D1 (Option B + init margin-mode probe).
# STATUS: SEALED 2026-09-24 (see header). Gate 3 plan may be drafted from these rows.

## WHAT WAS PROVEN BEFORE THIS MATRIX WAS DRAFTED

OBSERVED 2026-09-22 09:25:18 (AUDNZDS 709170):
  "[ERROR] Partial close FAILED on ticket 2942227144 (retcode 10009: done at 0.00000)"
  10009 IS TRADE_RETCODE_DONE. The line is self-contradictory: an ERROR reporting success.

VERIFIED AGAINST THE MT5 INCLUDE TREE (Trade.mqh) - NOT ASSUMED. This is the K-4 lesson
applied: K-4 cost a build because a Gate 3 plan asserted a CTrade overload existed without
reading it. Every claim below was read out of Trade.mqh in this session.

  CTrade::PositionClosePartial(ulong,double,ulong)            Trade.mqh 599
    599  if(IsStopped())              return(false);   <- WRITES m_result (10027)
    605  if(!IsHedging())             return(false);   <- NO WRITE
    608  if(!PositionSelectByTicket)  return(false);   <- NO WRITE
    612  ClearStructures();                            <- m_result zeroed ONLY HERE
    614  if(!FillingCheck(symbol))    return(false);   <- WRITES m_result (10030/10011)
    640  return(OrderSend(m_request,m_result));

  THE TWO PATHS ABOVE ClearStructures() LEAVE m_result HOLDING THE PREVIOUS ORDER'S RESULT.
  The previous order at 09:25:18 was the successful full close of L8 2961928246.
  THAT is the 10009. It is not this call's retcode; it is the last one's.

## THE BUG THIS MATRIX MUST NOT LET THROUGH AGAIN

ARITHMETIC PROOF THE SLICE NEVER SENT (recomputed, not taken from the log):
  pre-fire  "Structure: 8 level(s), 0.56 lots"
  slice executed => 0.56 - 0.08 - 0.09 - 0.02 = 0.37
  slice NOT sent => 0.56 - 0.08 - 0.09        = 0.39
  post-fire "Structure: 6 level(s), 0.39 lots"  -> 0.39. ANCHOR STAYED FULL AT 0.05.

WHICH EARLY RETURN FIRED - eliminated by the observed retcode:
  IsStopped              writes 10027           RULED OUT
  FillingCheck           writes 10030/10011     RULED OUT
  !IsHedging             no write               DISPROVEN: eight distinct SELL tickets
                                                coexist on AUDNZDS at different entries
                                                (09-21 00:00:00) plus magic-0 2940935091.
                                                Netting merges same-symbol positions into
                                                one. THE ACCOUNT IS HEDGING.
  !PositionSelectByTicket no write              THE ONLY SURVIVOR.

=> PositionSelectByTicket(2942227144) returned FALSE INSIDE CTrade, ONE LINE AFTER the O7
   caller at TRTM.mq5 2421 called PositionSelectByTicket(anchorTk) and got TRUE.
   The terminal's position cache changed its answer between two adjacent calls.

## SCOPE STATEMENT

IN SCOPE
  1. The three call sites where CTrade can return false WITHOUT writing m_result, so the
     EA must establish the precondition itself before trusting ResultRetcode():
       1511 CloseLegAtMarket   PositionClose         (!PositionSelectByTicket)
       1565 SliceLegAtMarket   PositionClosePartial  (!IsHedging, !PositionSelectByTicket)
       1893 exits loop         PositionModify        (!PositionSelectByTicket)
  2. An init-time ACCOUNT_MARGIN_MODE probe: read once, log once. A PROBE, NOT A GUARD.

OUT OF SCOPE (named so the boundary is explicit)
  - 3650 L1 button (PositionOpen) and 3753 pending orders (BuyLimit/SellStop/...). VERIFIED
    CLEAN: PositionOpen calls ClearStructures() at Trade.mqh 310 BEFORE any failure path,
    and the pending family writes INVALID_VOLUME itself then delegates to OrderOpen which
    clears first. THE ENTRY PATHS WERE NEVER LYING. No rows, no edits.
  - E9-Q4 (why the anchor became unselectable; retry-vs-accept policy). Q3 NAMES the event
    correctly; it does not change what the EA DOES about it. Separate Gate 1.
  - E9-O4 netting GUARD behaviour. The probe only reports the mode. O4 stays parked.
  - E9-Q2 false-flat reconcile. Separate defect, separate Gate 1, separate build.
  - E9-Q1 stale-quote guard. Same family, separate build.
  - Any change to WHICH cases the EA refuses. Q3 changes reason text and the reachability
    of the 10036 branches. It does not change money behaviour.

## CRITICAL FINDING MADE WHILE DRAFTING - READ BEFORE THE ROWS

THE EXITS LOOP ALREADY SELECTS, AND THAT IS NOT SUFFICIENT.
TRTM.mq5 1862 does `if(!PositionSelectByTicket(ticket)) continue;` at the TOP of the loop
body. But between that select and the PositionModify at 1893 the code runs PositionGetDouble
(1864-1865), tolerance comparisons, HasAppliedExits, and up to two Log() calls. CTrade then
re-selects internally at Trade.mqh 370. THE EA'S SELECT IS STALE BY THE TIME CTRADE CHECKS.
The window is small, but it is THE SAME WINDOW that defeated the slice at 2421->1565, where
the caller's select and CTrade's select were only one function call apart.
=> A row must prove the check is positioned so that no un-rechecked work sits between it
   and the call. "We already select somewhere above" is NOT the fix.

WHY THE 10036 BRANCHES ARE THE REAL PRIZE (both 1512 and 1567):
  if((int)g_trade.ResultRetcode() == 10036) { log INFO "benign race"; return true; }
A STALE 10036 left in m_result by an EARLIER genuine race makes a REAL close failure
RETURN TRUE - the EA believes a position closed when it has not. For CloseLegAtMarket that
return value feeds FireGroupClose's X-2 abort logic (2407): a false "closed" would let the
tier proceed to the anchor believing a profitable leg was banked. THIS IS A CLAUDE.md
SECTION 7 SILENT PATH. It has not been observed firing. It is reachable today.

## GROUP A - THE PRECONDITION GATE (the fix itself)

A-1  A close/slice/modify attempted on a ticket that is NOT selectable logs "no order sent"
     and NEVER prints a retcode. Evidence: the log line names the unselectable ticket and
     contains no retcode token at all.
     THIS IS THE ROW THE 09-22 INCIDENT FAILED. It is the reason Q3 exists.

A-2  When the precondition HOLDS and the call genuinely fails, the retcode IS printed and
     IS this call's own. Evidence: a real broker rejection (e.g. market closed 10018, as
     seen 09-21 00:00:00 on this very account) still logs its true retcode and description.
     THIS ROW PROVES B IS NOT D - valid retcodes are preserved, not discarded.

A-3  The precondition check sits IMMEDIATELY before the CTrade call with no intervening
     work that could invalidate it (see the critical finding above). Evidence: code
     inspection of all three sites - the select and the call are adjacent statements.

A-4  MUST-NOT: the set of cases in which the EA REFUSES to act is UNCHANGED. Every path
     that returned false/continue before still returns false/continue; every path that
     proceeded still proceeds. Evidence: filtered diff showing no change to any condition
     governing whether an order is SENT - only to what is logged when it is not.

A-5  MUST-NOT: SliceLegAtMarket still does NOT MarkEAClosed (the sealed E6 T3-O1 contract -
     the position SURVIVES a partial close, so flagging it would misattribute a later
     broker TP/SL close of the full anchor). Evidence: code inspection; the MarkEAClosed
     asymmetry between CloseLegAtMarket (marks) and SliceLegAtMarket (does not) is intact.

A-6  MUST-NOT: CloseLegAtMarket still calls MarkEAClosed on success and NOT on the 10036
     benign-race path (b9-2 / b20 sealed behaviour - 10036 means the BROKER exit closed it,
     so liveness attributes it via ClosingDealReason). Evidence: code inspection.

## GROUP B - THE 10036 SILENT PATH

B-1  A 10036 benign-race return is only believed when the precondition HELD, i.e. when
     CTrade actually reached OrderSend and wrote that 10036 itself. Evidence: code
     inspection that the 10036 test is unreachable on a no-send path at BOTH 1512 and 1567.

B-2  MUST-NOT: a GENUINE 10036 race still returns true and logs INFO, at both sites. The
     race is real and benign (b20) - Q3 must not turn it into an ERROR. Evidence: the
     existing INFO line unchanged in text and disposition.
     THIS ROW PROVES THE FIX IS A DISCRIMINATOR, NOT A SUPPRESSION.

B-3  MUST-NOT: CloseLegAtMarket's return value still drives FireGroupClose's X-2 abort
     exactly as sealed - a genuine failure returns false and the tier aborts with the
     anchor untouched. Evidence: code inspection of 2407-2413 (unchanged) plus the
     contract that a no-send now returns FALSE there, not a stale-10036 TRUE.

## GROUP C - THE MARGIN-MODE PROBE

C-1  Init logs the account margin mode in plain words (hedging / netting / exchange).
     Evidence: the init block shows one new line naming the mode.

C-2  On THIS account (AUDNZDS 709170) the probe reports HEDGING, confirming the deduction
     made from the coexisting-tickets evidence rather than leaving it inferred.
     Evidence: the init line on the live terminal.

C-3  MUST-NOT: the probe changes NO behaviour. It does not block, warn-escalate, refuse, or
     alter any trading decision. A netting reading would be REPORTED, not acted upon - that
     is E9-O4's job and O4 is parked. Evidence: code inspection - the value is logged and
     not stored in any variable that any decision reads.

C-4  MUST-NOT: the probe does not re-read on every tick/init cycle or add per-tick cost.
     Evidence: it runs once in OnInit alongside the existing broker-geometry line.

## GROUP D - REGRESSION (what must stay exactly as sealed)

D-1  MUST-NOT: the L1 button entry path (3650, PositionOpen) is NOT edited. VERIFIED CLEAN
     against Trade.mqh 303-337. Evidence: filtered diff shows zero changes at that site.

D-2  MUST-NOT: the pending-order path (3753) and its b27 retcode-specific hint ladder are
     NOT edited. That ladder exists because a fixed wrong hint cost a real investigation;
     it is correct today because those calls always carry a valid retcode. Evidence:
     filtered diff shows zero changes at that site.

D-3  MUST-NOT: the PositionModify failure backoff is unchanged - g_modifyFails increments,
     g_nextModifyTry = TimeCurrent()+5, and the >=10 consecutive Alert still fires.
     A no-send must be logged WITHOUT corrupting that counter's meaning: the matrix must
     state explicitly whether a no-send counts as a fail. RECOMMENDATION FOR THE PLAN: a
     no-send is NOT a broker failure and must NOT increment g_modifyFails, otherwise a
     transient cache blip walks the EA toward a spurious "check terminal/broker!" Alert.
     Evidence: code inspection + the counter's behaviour across a forced no-send.

D-4  MUST-NOT: exits idempotence (1871) still short-circuits when broker values already
     match, so Q3 adds no new PositionModify traffic. Evidence: a steady-state sequence
     logs no new "Exits applied" lines under b42 than under b41.

D-5  MUST-NOT: Tier 3 slice ARITHMETIC is untouched - sliced-VWAP, margin, ClosePercent,
     MinLots, the unit<=slice<=anchorVol-unit clamp. Q3 touches the SEND path only.
     Evidence: filtered diff confined to the wrapper bodies; a live fire recomputed on both
     derivations to 8 decimals per the E6 standard.

D-6  MUST-NOT: file hygiene holds - CRLF, ASCII-only, brace/paren/bracket delta accounted.
     Evidence: the check_hygiene hook at write + the STATE.md hygiene line.

## SEAL CONDITION

Gate 2 seals when Jeff confirms the rows. Group A and B close on a mix of code inspection
and a live run; C-1/C-2 close on the init line; C-3/C-4 and all of D close on inspection +
filtered diff. A-1 is the row that reproduces the defect and is the one that MUST have live
or forced evidence - a no-send that logs correctly and prints no retcode.

OPEN QUESTION FOR JEFF (QQ1): A-1's evidence needs a ticket that is selectable to the
caller and not to CTrade - the 09-22 race, which we cannot summon on demand. Options:
  (a) accept code inspection + the 09-22 log as the evidence for A-1;
  (b) force it with a temporary probe build that calls the wrapper on a closed ticket, then
      revert (the 2026-08-19 quote-probe pattern, which earned its cost);
  (c) wait for it to recur naturally on the live account.
RECOMMENDATION: (b). The 08-19 probe killed three false theories and was reverted to a
byte-identical build with an empty git diff - the pattern is proven and cheap. (a) leaves
the one row that matters closed on inspection alone; (c) has no bound.
