# b41 MATRIX - **SEALED rev 1 by Jeff 2026-08-19**
# Gate 2 CLOSED. No row may be added, removed or reworded without Jeff re-opening the seal.
# A Gate 3 code plan may now be drafted FROM this matrix.
#
# b41 MATRIX - Gate 2 (drafted 2026-08-18, sealed 2026-08-19)
# Two defects, one build: K-4 (slice order wipes the position comment) and
# E9-M1 (reconcile adopts the EA's own computed TP as a trader edit).
# Gate 1 decisions this matrix implements: b41-S1, K4-D1, K4-D2, E9M1-D1, E9M1-D2.
# STATUS: DRAFT - not sealed. Jeff seals Gate 2 before any Gate 3 plan is written.

## SCOPE STATEMENT

IN SCOPE
  1. K-4: SliceLegAtMarket sends its partial close WITHOUT a comment, so MT5 overwrites the
     surviving anchor's position comment with an empty string. Fix per K4-D1/K4-D2.
  2. E9-M1: ReconcileManualExits adopts the EA's OWN last-applied computed TP as a manual
     edit after a restart. Fix per E9M1-D1.

OUT OF SCOPE (named so the boundary is explicit)
  - First-adoption ordering on a structural tick. CLOSED by E9M1-D2, accept current
    behaviour. No row here.
  - Retroactive repair of comments already blanked by b40. Not attempted; b39's O2b guard
    covers those and is Run-H-proven.
  - E9-O6 comment-integrity DETECTION. K-4 stops TRTM corrupting its own comments; it does
    not add detection of externally corrupted ones. Still E9.
  - L-1/L-2/L-4 (deliberately corrupted comment). Unchanged, still inspection-only.

## CRITICAL REFRAMING FOUND WHILE DRAFTING - READ BEFORE THE ROWS

E9-M1 IS NOT "reconcile has no guard". THE GUARD EXISTS AND IS SEALED (b28, M7-8, 2744-2757):
`releasedTP` remembers a manual TP released during the death window precisely so the M7-5
branch cannot re-adopt the EA's own pre-kill propagation as a trader edit. The code comment
calls it "the reconcile-path analogue of the b25/M5-6 discriminator".
WHY IT DID NOT FIRE IN RUN H: `releasedTP` only arms when `g_state.manualTP > 0.0` - i.e.
when a MANUAL TP was owned before the kill. In Run H manualTP was 0; the 4401.17 the EA had
applied was purely COMPUTED. So releasedTP stayed 0 and M7-5 adopted freely.
=> E9-M1 IS THE SAME DEFECT CLASS AS M7-8, ONE CASE WIDER: the EA's own stale write goes
   unrecognised when the value was COMPUTED rather than MANUAL.
CONSEQUENCE FOR THE FIX: persisting lastAppliedTP/SL (E9M1-D1) generalises M7-8's
discriminator to the computed case. This is an EXTENSION of a sealed, working idiom, not a
new mechanism - which lowers the risk of the change and should be stated in the plan.
CONSEQUENCE FOR THIS MATRIX: rows must prove the new guard does not BREAK M7-8's existing
behaviour, since both now discriminate on the same branch.

## GROUP A - K-4: THE SLICE ORDER CARRIES THE TAG

A-1  A Tier 3 slice leaves the surviving anchor's POSITION comment INTACT and parseable.
     Evidence: after a fire, PositionGetString(POSITION_COMMENT) on the sliced anchor
     returns the same _lN_ tag it carried before. Read via the Trade tab AND proven by the
     absence of the O2b WARN on the next restart.
     THIS IS THE ROW RUN H FAILED. It is the reason b41 exists.

A-2  The tag written by the slice is BYTE-IDENTICAL to the tag the open path writes for the
     same level+direction. Evidence: BuildLevelTag is the single source (K4-D2), plus a
     live comparison - open L2, slice L1, confirm both comments follow the same
     "<normsym>_l<N>_<buy|sell>" form with the same normalised symbol casing.

A-3  MUST-NOT: ParseTag (671) is NOT modified. Evidence: filtered diff shows zero changes
     in ParseTag and in RebuildLiveMap's parse call site.

A-4  MUST-NOT: newly-opened recovery levels carry a comment BYTE-IDENTICAL to b40's.
     K4-D2 edits the SEALED Stage 4 open path (three inline lines -> one helper call), so
     this is the regression obligation for that edit. Evidence: a live multi-level sequence
     under b41 whose L2..LN comments match the b40 baseline strings exactly (the Run H log
     and its account history are the baseline: xauusd_l2_buy .. xauusd_l8_buy).

A-5  A DOUBLE slice of the same anchor still leaves a parseable tag. Run H fire 2 re-sliced
     an already-sliced anchor (0.05 -> 0.03 -> 0.02), so this case is real, not theoretical.
     Evidence: two fires on one sequence, comment intact after both.

A-6  b39's O2b fallback still works when a comment is genuinely unparseable. K-4 must not
     make the guard unreachable or untested. Evidence: code inspection that the O2b branch
     is untouched, PLUS the standing Run H evidence for its behaviour. (Deliberately NOT
     closed on a new live run - producing a genuinely corrupt comment needs the L-1..L-4
     deliberate-corruption setup, which is out of scope.)

A-7  The slice's ORDER comment (as opposed to the position comment) is a side effect, not a
     contract. Recorded so a future reader does not treat the account-history string as
     load-bearing: history showed xauusd_l1_buy for the sliced ticket even while the
     POSITION comment was empty (Run H). Money paths read the position, never history.

A-8  Slice failure paths unchanged: the 10036 benign race still returns true and logs INFO;
     a genuine failure still logs ERROR and returns false to the O7 accept+log caller.
     Adding a comment parameter must not alter either. Evidence: code inspection + Gate Zero.

## GROUP B - E9-M1: RECONCILE STOPS ADOPTING THE EA'S OWN VALUE

B-1  After a restart over a sequence whose TP the EA itself last applied, reconcile does
     NOT log "TP edited ... while EA was offline ... adopted as manual (M7-5)".
     THIS IS THE ROW RUN H FAILED (16:42:58, adopted its own 16:35:50 write of 4401.17).
     Evidence: the exact Run H scenario re-run under b41 - fire Tier 3, restart, confirm
     the computed target re-asserts and manualTP stays 0 in the state file.

B-2  MUST-NOT: a GENUINE trader edit made while the EA is offline is STILL adopted (M7-5
     must survive). Evidence: restart with a hand-edited TP that matches nothing the EA
     ever wrote; expect the M7-5 adoption line and manualTP set in state.
     THIS IS THE ROW THAT PROVES THE FIX IS A DISCRIMINATOR, NOT A BLANKET SUPPRESSION.

B-3  MUST-NOT: M7-8's existing death-window discriminator still behaves exactly as sealed.
     Both guards now sit on the same branch, so the new one must not shadow or duplicate
     it. Evidence: code inspection of the branch order + the M7-8 case exercised (close a
     level while the EA is down, with a manual TP owned pre-kill).

B-4  Manual TP ownership CONTINUING across a restart still works ("manual TP %s ownership
     continues across restart (broker agrees)"). Evidence: restart with an adopted manual
     TP the broker still carries.

B-5  M7-6 conflict handling unchanged: conflicting broker TPs after restart still drop
     manual ownership and re-assert computed.

B-6  The SL side of the same code is NOT regressed. E9M1-D1 persists lastAppliedSL too, and
     the SL branch has its own sealed cases (M7-7 stale-propagation, the BE floor test).
     Evidence: a restart with a manual SL owned; expect the existing SL lines unchanged.

B-7  lastAppliedTP/SL are seeded at load and updated at the SAME site that updates the
     runtime globals today (1869), so persisted and runtime values cannot diverge.
     Evidence: code inspection - exactly one assignment site per field.

B-8  Trailing-active case unchanged: the TP classification block is skipped while trailing
     (no TP exists), and g_lastAppliedTP is forced to 0 past activation (1871). Persisting
     must not resurrect a stale TP after a trail-arm.

## GROUP C - STATE SCHEMA - Q1 LOCKED 2026-08-19 AS SHAPE (i)

LOCKED DECISION b41-C1 (schema shape, Jeff's call 2026-08-19): SHAPE (i) - BUMP
TRTM_STATE_SCHEMA 4 -> 5, ACCEPT THE DISCARD OF A b40 FILE, DEPLOY ON A FLAT SEQUENCE.

THE FACT THAT DECIDED IT - THE EXPOSURE WINDOW IS ONE OnInit CALL, NOT AN ONGOING RISK:
  StateSave runs at the END OF Reconcile (2980), on EVERY init, live or flat. So under (i)
  the sequence is: StateLoad discards the schema-4 file -> Reconcile rebuilds from the
  broker -> StateSave writes schema 5, all within the SAME init, milliseconds apart. After
  that first init the file on disk is schema 5 and EVERY subsequent restart - crash, power
  loss, MT5 auto-update, chart change, terminal restart - loads normally.
  => THE CRASH SCENARIO DOES NOT DISTINGUISH (i) FROM (ii). Only a crash landing INSIDE
     that single init would, which is not a real risk. The entire difference between the
     shapes reduces to ONE controllable event: the first init after b41 is deployed.
  (An earlier draft of this analysis claimed the window ran "until the first b41 state
   write" and implied an ongoing exposure across restarts. That was wrong - the save site
   at 2980 closes it within the same init. Recorded so the reasoning is not re-derived.)

WHAT IS LOST IF b41 IS DEPLOYED OVER A LIVE SEQUENCE (the one event above):
  Recoverable from the broker by Reconcile - direction, tickets, levels, levelCount,
  baseLot, and manualTP (re-classified through the M7-5 path).
  NOT RECOVERABLE - the file is the only source:
    - trailOverride, beOverride, trailingActive, beApplied (per-sequence button state)
    - manualSL (reconcile can adopt an SL but cannot know it was the trader's)
    - adoptedL1 (a magic-0 adopted L1 does NOT carry our magic, so RebuildLiveMap cannot
      see it - Reconcile restores it FROM THE FILE ONLY, 2887-2911). This is the most
      serious of the three: the position would go UNMANAGED.
  DEPLOY ON FLAT ELIMINATES ALL THREE.

REJECTED (ii) BUMP + teach StateLoad to accept 4 as readable legacy:
  Buys protection for a SINGLE init that Jeff already controls, and pays for it with a
  permanent silent-PARTIAL-LOAD pattern on the gate that EVERY state read passes through.
  Specific failure modes that decided against it:
    - The persistence SELF-TEST (3013) writes and reads a schema-5 file, so it exercises
      only the NEW path. A subtly wrong legacy branch would leave the self-test GREEN while
      the gate is broken - the one automated check does not cover the case the edit exists
      for.
    - It invites unsafe extension. A future 5 -> 6 bump where a field's MEANING changes
      (rather than a field being added) could be "fixed" by extending the accepted list to
      {4,5,6} without checking semantics - loading an old value into a field that now means
      something different, silently, on a money path. (i) cannot do this: mismatch always
      means discard.
    - Rollback is asymmetric anyway. b41 would read 4 and 5, but b40 reads ONLY 4, so
      rolling back to b40 discards the schema-5 file and loses the same fields (ii) was
      bought to protect. (i) never claims otherwise; (ii) creates a false expectation of
      symmetry.
    - It does not close the adoptedL1 hole. Legacy-reading protects the b40->b41 transition
      only; adoptedL1 is still unrecoverable whenever the file is lost for ANY other reason
      (corruption, deletion, fresh terminal, different data folder). See E9-M4 below.
REJECTED (iii) DO NOT bump, add keys at schema 4:
  The schema field stops meaning anything - two different formats would share version 4,
  contradicting the contract stated in the code at 152 ("bump on breaking state format
  change"). Saves nothing over (ii) and forfeits the versioning invariant.

CONDITIONS ATTACHED TO THIS DECISION (both are matrix obligations, not advice):
  1. C-4 is STRENGTHENED - the discard WARN must NAME what was lost.
  2. The deploy note for b41 must state DEPLOY ON A FLAT SEQUENCE.

C-1  MUST-NOT: no state transition silently loses an ACTIVE override flag, a live manualSL,
     or adoptedL1. Under the locked shape (i) these CAN be lost on the first init after
     deploy, so this row is satisfied by (a) the strengthened C-4 warning and (b) the
     deploy-on-flat procedure - NOT by code. Stated plainly so the record is honest: this
     row is closed by procedure, not by construction.
C-2  A b41-written state file round-trips: save, reload, self-test PASS, all fields intact
     including lastAppliedTP and lastAppliedSL.
C-3  The state persistence SELF-TEST still passes at init (it has passed on every run since
     Stage 1 and is the first line of the resume protocol).
C-4  STRENGTHENED PER b41-C1: encountering a b40 (schema 4) file logs a WARN that NAMES the
     consequence - not the current generic "discarding file". It must say that override
     flags, manual SL ownership and any adopted-L1 record are being dropped, and that this
     is expected exactly once on the b41 upgrade. Evidence: deliberately place a schema-4
     file and confirm the WARN text at init.
C-5  A schema-3 file, a garbage file, and a file with a MISSING schema key are all still
     REJECTED. The bump must not weaken the gate in either direction. Evidence: inspection
     (the equality test is unchanged in form, only the constant moves) + the self-test.

## GROUP D - REGRESSION (b41 touches sealed money-path code)

D-1  MUST-NOT: Tier 3 fire arithmetic is unchanged. b41 touches SliceLegAtMarket, which is
     inside the E6 money path. Evidence: a fire under b41 recomputed on BOTH derivations
     (leg-by-leg AND marginPts x sum lots) agreeing to the cent, per the E6 standard.
     Baseline: Run H's two fires (206.6 pts and 217.0 pts) are the diff reference.

D-2  MUST-NOT: no change to lot sizing, ladder spacing, AvgTP, BE, or trailing. b41 has no
     business touching any of them. Evidence: filtered diff + a no-tier regression run.

D-3  MUST-NOT: NO NEW INPUT. Neither fix needs one.

D-4  Recovery open path behaviour is unchanged beyond the helper extraction (see A-4).

D-5  Gate Zero: 0 errors, 0 warnings. Hygiene: 0 bare LF, ASCII-only, brace/paren/bracket
     deltas all 0 against the b40 baseline.

## VERIFICATION SHAPE - ONE RUN COVERS BOTH FIXES

This is the reason b41-S1 bundled them. ONE live sequence closes A-1..A-5 and B-1:
  1. Attach b41 on a FLAT sequence (also satisfies C-1 under shape (i)).
  2. Open L1, let the ladder build to 4+ levels (Run H's config: entry 0.05, MinTrades 4,
     interval 150, RecoveryTF M1 - PROVEN to produce a fire).
  3. Tier 3 fires -> read the sliced anchor's comment      -> A-1, A-2
  4. Let it fire a second time if the market allows        -> A-5
  5. Remove EA -> re-attach                                -> B-1 (no M7-5 adoption),
                                                              A-1 again (no O2b WARN)
  6. Hand-edit a TP, remove EA, re-attach                  -> B-2 (genuine edit still adopted)
CONSTRAINT CARRIED FROM RUN H: the restart legs MUST be on a LIVE CHART. Tester inputs lock
once a run starts and a tester restart replays from the beginning, so the tester cannot
produce a reconcile against open positions.
ACCOUNT: the Vantage demo (25948001) is proven to produce this shape.

## QUESTIONS - ALL ANSWERED 2026-08-19, MATRIX READY TO SEAL

Q1  GROUP C shape. ANSWERED: shape (i). See LOCKED DECISION b41-C1 in Group C for the full
    reasoning, the rejected alternatives, and the two conditions attached.
Q2  Does A-6 close on inspection, or must b41 deliberately corrupt a comment to exercise
    O2b live? ANSWERED: INSPECTION. Producing a genuinely corrupt comment requires the
    L-1..L-4 deliberate-corruption setup, which is explicitly out of scope for b41.
    O2b's behaviour is already proven on live evidence by Run H (2026-08-18), where a
    blank comment produced "counted as L1" with a WARN and did NOT become the anchor.
    A-6 therefore closes on: code inspection that the O2b branch is untouched + the
    standing Run H evidence. Recorded as inspection-closed, NOT rounded up to evidence.
Q3  Does B-3 (M7-8 not shadowed by the new guard) close on inspection? ANSWERED:
    INSPECTION, with an explicit obligation on the Gate 3 plan: the plan MUST show the
    branch order at 2816 and state how the new lastApplied discriminator composes with the
    existing releasedTP one - which fires first, and why they cannot both claim the same
    value. b28 sealed M7-8 on live evidence; b41 must not re-litigate that, only avoid
    disturbing it.

## SEAL STATUS - **SEALED rev 1 by Jeff, 2026-08-19**
All questions answered. 26 rows (A-1..A-8, B-1..B-8, C-1..C-5, D-1..D-5).
MUST-NOT rows: A-3, A-4, B-2, B-3, C-1, D-1, D-2, D-3.
Rows closing on INSPECTION rather than evidence, stated up front so no seal quietly
rounds them up: A-6 (O2b untouched), B-3 (M7-8 not shadowed), C-5 (gate not weakened),
A-8 (slice failure paths), D-2/D-3 (filtered diff).
THE TWO ROWS THAT DEFINE THE BUILD: A-1 and B-1 - both are rows RUN H FAILED.
GATE 2 IS CLOSED. NEXT: Gate 3 - draft the b41 code plan from this sealed matrix.

## OBLIGATIONS THIS SEAL PLACES ON THE GATE 3 PLAN
  1. (from Q3/B-3) SHOW the branch order at 2816 and state how the new lastApplied
     discriminator composes with M7-8's existing releasedTP discriminator - which fires
     first, and why they cannot both claim the same value. b28 sealed M7-8 on live
     evidence; b41 must not disturb it.
  2. (from b41-C1) The deploy note must state DEPLOY ON A FLAT SEQUENCE, and C-4's WARN
     text must NAME what a discard drops (override flags, manualSL, adoptedL1).
  3. (from K4-D2) The recovery-open path edit must be shown to be behaviour-identical by a
     FILTERED DIFF, the way b40's comment-only claim was proven - the emitted tag string
     for a newly opened level must be byte-identical to b40's.
  4. State the touch-point count and the expected line delta up front, per the b39/E6
     precedent, so Gate Zero has something to check against.
