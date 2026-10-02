# E9-Q2 MATRIX - **SEALED rev 2 by Jeff 2026-10-03**
# *** ALL 25 ROWS DISPOSED. b44 SEALED BY JEFF 2026-10-03. GATE 6 CLOSED. ***
#   LIVE EVIDENCE (13): A-1 A-2 A-3 A-4 A-5 A-7 A-8 A-9 B-1 B-2 C-1 C-4 D-2
#   INSPECTION + FILTERED DIFF (12): A-6 B-3 B-4 C-2 C-3 D-1 D-3 D-4 D-5 D-6 D-7 D-8
#   A-1 kept on absence; A-2 deleted on evidence - TOGETHER they prove a DISCRIMINATOR
#   rather than blanket suppression. A-5 was confirmed TWICE by different routes (B-1's
#   expiry path and a genuine close), which was the one regression risk named at Gate 3.
#   b43 is a WITHDRAWN INTERMEDIATE: Gate Zero passed, A-8 FAILED, never sealed, never
#   to be deployed. Its failure is what produced rows A-7/A-8/A-9 in this rev.
# rev 2 ADDS A-7, A-8, A-9 after a GATE 4 FAIL on 2026-10-03 (found by Jeff on the first
# fixture run). The seal was re-opened deliberately: CLAUDE.md section 2 requires a live
# finding to become ROWS, never a silent fix. Gate 1 decision E9-Q2-D2 implements them.
# rev 1 rows are UNCHANGED - nothing was reworded, only added.
#
# E9-Q2 MATRIX - SEALED rev 1 by Jeff 2026-10-02
# Gate 2 CLOSED. No row may be added, removed or reworded without Jeff re-opening the seal.
# A Gate 3 code plan may now be drafted FROM this matrix.
# QQ1 is RESOLVED in-matrix (fabricated-ticket fixtures) - no item sealed unanswered.
#
# E9-Q2 MATRIX - Gate 2 (drafted 2026-10-02)
# Defect: the EA deletes a position record on an ABSENCE of evidence rather than on
# affirmative evidence of closure. It cost a live unmanaged position for five days.
# Gate 1 decision this matrix implements: E9-Q2-D1 (directional record management inside
# the existing state file; 90-day UNKNOWN expiry aged from lastSaved; schema STAYS 5).
# STATUS: SEALED 2026-10-02 (see header). Gate 3 plan may be drafted from these rows.

## THE RULE THIS BUILD ENCODES (Jeff's design, in his words)

  DELETION goes MT5 -> file.  A ticket leaves the record ONLY when MT5 affirmatively
                              states it is gone.
  RECONCILIATION goes file -> MT5.  The file PROPOSES a ticket; MT5 CONFIRMS it.

An ABSENCE can never delete anything. That is the entire fix.

## WHAT WAS PROVEN BEFORE THIS MATRIX WAS DRAFTED

OBSERVED 2026-09-18 23:54:59 (AUDNZDS 709170), deinit reason 9, Friday rollover restart.
In ONE second, in this order:
  "Reconcile: recorded adopted L1 ticket 2940935091 no longer exists - closed while EA was
   offline"
  "Reconcile: file claims 9 level(s) but broker is flat - sequence closed while EA was
   offline"
  "Reconcile complete: FLAT"
ALL NINE POSITIONS WERE INVISIBLE SIMULTANEOUSLY - not only the magic-0 L1 but the eight
magic-owned levels too (RebuildLiveMap returned 0, which is WHY the flat branch ran). The
terminal's position list was simply not populated yet. NOTHING had closed: on 2026-09-21 all
nine reappear, the eight magic levels self-heal via b39/F-2, and ticket 2940935091 shows up
as "UNMANAGED MANUAL TRADE". It ran with NO TP, NO SL and NO recovery from 09-18 until Jeff
closed it by hand on 09-23. FIVE DAYS.
WHY ONLY THE ADOPTED L1 WAS LOST FOREVER: the magic-owned levels have a self-heal path
(b39/F-2 orphan rebuild). A magic-0 adopted L1 has NONE - RebuildLiveMap cannot see it, so
the state file was its ONLY record, and StateReset + StateSave destroyed that record IN THE
SAME INIT.

## THE KEY TECHNICAL FACT THE FIX RESTS ON

HistorySelectByPosition is a DIFFERENT DATA SOURCE from PositionsTotal() /
PositionSelectByTicket, and they FAIL INDEPENDENTLY. An unpopulated position cache says
NOTHING about trade history. History is therefore the affirmative evidence that separates
"this closed" from "I cannot see it yet" - the distinction the EA collapsed on 09-18.

## CRITICAL FINDING MADE WHILE SCOPING - READ BEFORE THE ROWS

THE DEFECT IS IN TWO PLACES, NOT ONE. An earlier claim this session that "one line is the
whole bug" was WRONG and is withdrawn.
  3060 Reconcile flat branch - StateReset + StateSave when live.levelCount == 0 at init.
       This is where it COST a position.
  969  CheckSequenceLiveness - when ClosingDealReason returns 0 it logs "closed externally
       (manual/unknown)" and REMOVES THE TICKET ANYWAY. Same absence-means-closed inference.
  CONSEQUENCE: fixing 3060 alone is DEFEATED WITHIN ONE TICK - reconcile would keep an
  UNKNOWN record at init and liveness would prune it on the next tick.

ClosingDealReason ALREADY distinguishes the cases internally and then COLLAPSES them:
  line 927-928  HistorySelectByPosition FAILED        -> return 0   (NO EVIDENCE)
  line 941      default: a closing deal EXISTS, reason manual/other -> return 0  (CLOSED)
  line 944      history selected, NO DEAL_ENTRY_OUT found -> return 0   (NO EVIDENCE)
Two of those three mean UNKNOWN; one means genuinely closed. Giving the helper a distinct
return for "no closing deal found" puts the affirmative/absence judgement in the ONE place
that reads history, instead of duplicating it at two callers - the E9-P6 lesson applied.
IT HAS EXACTLY ONE CALLER TODAY (962), which is what makes the helper change low risk.

## SCOPE STATEMENT

IN SCOPE
  1. ClosingDealReason (924): a distinct return value for "no closing deal found", so
     UNKNOWN is separable from CLOSED-manual.
  2. Reconcile flat branch (3060): on UNKNOWN, do NOT StateReset + StateSave. Keep the
     record, log it, let OnTick settle it.
  3. CheckSequenceLiveness (969): on UNKNOWN, do NOT prune the ticket. Keep it, log it.
  4. The 90-DAY UNKNOWN EXPIRY, aged from the file's existing lastSaved field.

OUT OF SCOPE (named so the boundary is explicit)
  - NO schema bump. Schema STAYS AT 5. A bump makes StateLoad DISCARD the file (610),
    destroying the adoptedL1 record - THE EXACT DEFECT UNDER REPAIR - and with EIGHT live
    instances that would mean eight flat-sequence deploy windows. Locked at Gate 1.
  - NO new state file, NO new persisted field, NO new input.
  - E9-M4's true file-LOSS case. If the file is DELETED or the data folder changes, a
    magic-0 position has no magic, no reliable tag and no record: UNRECOVERABLE IN CODE.
    To be DOCUMENTED in the README and STATE.md, never pretended away.
  - The b39/F-2 orphan rebuild, the adoption scan, the stale-tag gate: untouched.
  - K-4 / O6 (slice blanks the anchor comment). It is WHY the comment cannot be the
    identity (see the C rejection at Gate 1) but it is not fixed here.
  - E9-Q1, Q4, and every other parked E9 item.

## GROUP A - THE UNKNOWN CLASSIFICATION (the fix itself)

A-1  A recorded ticket that is NOT selectable AND has NO closing deal in history is
     classified UNKNOWN: the record is KEPT, nothing is written, and a WARN names the ticket.
     THIS IS THE ROW THE 2026-09-18 INCIDENT FAILED, at both 3060 and 969.

A-2  A recorded ticket that is NOT selectable AND HAS a closing deal IS deleted, and the log
     still names the reason (TP / SL / stop-out / manual). Evidence: the existing b20
     attribution lines are unchanged in text and disposition.
     THIS ROW PROVES THE FIX IS A DISCRIMINATOR, NOT "NEVER DELETE ANYTHING".

A-3  A recorded ticket that IS selectable is restored to the sequence exactly as today.
     Evidence: a normal restart over a live sequence logs the same lines as b42.

A-4  MUST-NOT: reconcile no longer writes a FLAT MARKER while the file claims levels and the
     broker merely reads empty. Evidence: the 09-18 scenario re-run (or forced) shows the
     record SURVIVING the init, and the state file still containing the tickets afterwards.

A-5  MUST-NOT: a GENUINE flat still produces a flat marker. When every recorded ticket has a
     closing deal, the sequence closes normally and lastCloseTime is set as the stale-tag
     gate anchor. Evidence: a sequence closed by TP on the broker, then a restart - expect
     "Reconcile complete: FLAT" and a correct flat marker.
     WITHOUT THIS ROW THE FIX WOULD BREAK THE STALE-TAG GATE.

A-6  The classification lives in ONE place (ClosingDealReason) and both callers consume it.
     Evidence: code inspection - no second copy of the affirmative/absence judgement.

A-7  MUST-NOT: an UNKNOWN record is NEVER LOADED INTO g_state. "Keep the record" means
     PRESERVE THE FILE UNTOUCHED - it does NOT mean resurrect the record as a live sequence.
     After an UNKNOWN keep, g_state.levelCount == 0 and the EA reports itself FLAT.
     Evidence: the A-1 fixture init, plus the dashboard/log showing FLAT rather than a
     1-level sequence.
     WHY (2026-10-03): `g_state = file` left levelCount = 1 holding a ticket the EA had just
     classified UNKNOWN, so the EA treated an unconfirmed record as live - every OnTick
     engine ran against it and liveness re-evaluated it every tick.

A-8  MUST-NOT: OnDeinit WRITES NOTHING after an UNKNOWN keep. OnDeinit runs
     `if(g_state.levelCount > 0) StateSave(g_state);` - with g_state flat that guard is
     false, but the plan must VERIFY it rather than assume, because that guard is exactly
     what corrupted the fixture.
     Evidence: the state file is BYTE-IDENTICAL before and after a full init + deinit cycle
     on the A-1 fixture (sha256 both sides).
     *** THIS IS THE ROW THE 2026-10-03 RUN FAILED. *** The first instance's deinit logged
     "state saved (sequence alive)" and rewrote the fixture to tickets:[0], levels:[0].

A-9  MUST-NOT: no LEVEL-0 entry ever reaches g_state - b39's L-3 rule still holds.
     Evidence: no "L0 ticket" line in any log.
     WHY THIS IS NOT COSMETIC: FormBasketGroup picks the LOWEST level as the anchor with no
     magic check, so a level-0 entry would SEIZE THE TIER 3 ANCHOR and inherit both the SL
     anchoring and the slice target. L-3 exists precisely to make level 0 unassignable. The
     2026-10-03 log shows "Liveness: L0 ticket 0", i.e. the corruption had already reached
     anchor-eligible state.

## GROUP B - THE 90-DAY UNKNOWN EXPIRY

B-1  An UNKNOWN record older than 90 days (TimeCurrent() - lastSaved > 90d) IS deleted, with
     a WARN naming the ticket and the age. Evidence: a hand-aged state file (lastSaved set
     back 91 days) on a flat chart; expect the delete + WARN exactly once.

B-2  An UNKNOWN record YOUNGER than 90 days is KEPT. Evidence: the same fixture at 89 days;
     expect the keep + the standing WARN, no delete.

B-3  MUST-NOT: a record holding a LIVE sequence never ages out, because lastSaved refreshes
     on every write. Evidence: a live multi-level sequence run across several saves - the
     age never approaches the bound.
     ACCEPTED AND DELIBERATE (Gate 1): an UNKNOWN ticket sitting ALONGSIDE live siblings
     therefore never expires, because the siblings keep the file fresh. Jeff and I agree this
     is DESIRABLE - that case deserves a standing WARN, not silent deletion.

B-4  The 90 days is a CONSTANT, not an input (no new input is in scope). Evidence: code
     inspection - a #define alongside the other TRTM_ constants.

## GROUP C - OBSERVABILITY (this build exists because the EA lied once)

C-1  The UNKNOWN WARN says what it does NOT know, and never asserts a cause. It must NOT say
     "closed while EA was offline" or "closed externally" - those are the false-cause strings
     this build removes. Evidence: the literal text, read in the log.

C-2  The UNKNOWN WARN is one-shot per ticket per init, not per tick. A kept UNKNOWN record is
     re-evaluated every tick by liveness, so an unthrottled WARN would flood the log.
     Evidence: a forced UNKNOWN held across many ticks produces ONE line per init.

C-3  The 90-day delete is logged at WARN with the ticket and the age, never silently.
     Evidence: B-1's line.

C-4  MUST-NOT: a normal, healthy run gains NO new log lines. Evidence: a clean live sequence
     under the new build logs the same lines as b42 (the UNKNOWN path is unreachable when
     every ticket is selectable).

## GROUP D - REGRESSION (what must stay exactly as sealed)

D-1  MUST-NOT: the three SAFE StateReset sites are NOT touched - 744 AdoptPosition,
     991 CheckSequenceLiveness's genuine all-closed reset, 3463 RegisterButtonL1.
     Evidence: filtered diff shows zero changes at those sites.

D-2  MUST-NOT: the b20 closing-deal ATTRIBUTION is unchanged - TP hit / SL hit / STOP-OUT /
     closed-by-EA all keep their existing text and log level. Only the no-evidence branch
     changes. Evidence: filtered diff + a live TP close.

D-3  MUST-NOT: b39/F-2's orphan rebuild still fires for magic-owned levels found while flat.
     It is the self-heal path that saved the eight levels on 09-21 and it must survive.
     Evidence: code inspection + the standing 09-21 log as the behavioural baseline.

D-4  MUST-NOT: the stale-tag gate still works. lastCloseTime must still be set on a genuine
     close (A-5), or a stale tagged L1 becomes adoptable again. Evidence: inspection of
     every lastCloseTime write plus A-5's run.

D-5  MUST-NOT: the 20 existing call sites that skip an unselectable tracked ticket continue
     to skip it harmlessly. A KEPT-but-unselectable record must be inert to ComputeTargets,
     FormBasketGroup, EnforceExits and the projections. VERIFIED AT SCOPING: 20 sites
     already guard with `if(!PositionSelectByTicket(...)) continue;`, so the design is
     compatible with existing code rather than requiring changes across it.
     Evidence: inspection of those guards; no edits to any of them.

D-6  MUST-NOT: state schema stays at 5; StateToJson / StateLoad field lists are unchanged.
     Evidence: filtered diff + the self-test still passing unmodified.

D-7  MUST-NOT: ReconcileManualExits (2834) and the b41 lastAppliedTP/SL discriminator are
     untouched. Evidence: filtered diff.

D-8  MUST-NOT: file hygiene holds - CRLF, ASCII-only, brace/paren/bracket delta accounted.
     Evidence: the check_hygiene hook at write + the STATE.md hygiene line.

## SEAL CONDITION

Gate 2 seals when Jeff confirms the rows. A-1 is the row that reproduces the defect and
needs forced or live evidence. B-1/B-2 need a hand-aged state file. A-5 needs a genuine
broker close. Everything else closes on inspection + filtered diff.

QQ1 RESOLVED 2026-10-02 - Jeff chose (b), FABRICATE THE SCENARIO. A-1, B-1 and B-2 all
close on ONE fixture file, edited three ways. No probe build, NO CODE CHANGE, nothing
temporary in the source - this avoids the probe-build hazard entirely.

THE FIXTURE. A state file whose only ticket is 999999999 - a number that NEVER EXISTED. So
PositionSelectByTicket FAILS (not a real position) and HistorySelectByPosition FINDS NOTHING
(never traded). That IS the UNKNOWN classification, reached without needing an unpopulated
position cache. adoptedL1 is set TRUE deliberately: that makes it the WORST case, the magic-0
adopted L1 with no b39/F-2 self-heal path - the exact shape of the position lost on 09-18.
VALIDATED against the live file: key order identical, schema 5, symbol XAUUSDS, magic 715358
so StateLoad's identity check (630) passes.

  A-1  lastSaved 1790931849 (2026-10-02, 0d)   -> expect KEEP + one-shot UNKNOWN WARN
  B-2  lastSaved 1783242249 (2026-07-05, 89d)  -> expect KEEP + WARN (under the bound)
  B-1  lastSaved 1783069449 (2026-07-03, 91d)  -> expect DELETE + WARN naming ticket and age
  (90d = 7776000 s. All three derived from the live file's own lastSaved, not invented.)

Files staged for Jeff at scratchpad/q2_fixtures/: A1_fresh_unknown.json, B2_89days_keep.json,
B1_91days_delete.json. Each is copied over
  MQL5\Files\TRTM\state_XAUUSDS_715358.json
on a FLAT XAUUSDS chart, then the EA re-initialised. XAUUSDS is flat as of 2026-10-02
(levelCount 0), so no live sequence is disturbed. Reversible by deleting the file - the EA
writes a fresh flat marker on the next init.
CLAUDE MUST NOT PLACE THESE FILES: the MT5 tree is deny per CLAUDE.md section 3a. Copying is
Jeff's manual step, exactly like a deploy.
PRECONDITION: the fixture is only meaningful AFTER the fix is built. Run against b42 it would
reproduce the DEFECT (b42 still deletes on an absence) - which is itself a useful before/after
if Jeff wants the contrast on the record.

SUPERSEDED, KEPT FOR THE RECORD - the original QQ1 and its rejected options:
OPEN QUESTION FOR JEFF (QQ1): A-1 needs a ticket that is unselectable AND has no closing
deal - the 09-18 condition, which we cannot summon (it needed an unpopulated position cache
at init). Options:
  (a) accept code inspection + the 09-18 log as the evidence for A-1;
  (b) force it with a state file hand-edited to contain a FABRICATED ticket number that
      never existed - it will be unselectable with no history, which is exactly UNKNOWN.
      No probe build needed, no live position touched, and it is reversible by deleting the
      fixture file.
  (c) wait for a natural recurrence.
RECOMMENDATION: (b). It needs NO code change at all - only a test fixture - so it avoids
the probe-build hazard entirely, and a fabricated ticket is a perfectly faithful UNKNOWN.
NOTE: (b) requires writing into the MT5 Files\TRTM state directory, which is Jeff's manual
step - Claude must not touch the MT5 tree (CLAUDE.md section 3a).
