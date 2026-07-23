# ENHANCEMENT BACKLOG INPUT - 2026-07-23

STATUS: Gate 1 INPUT ONLY. Nothing here is locked. No code, no matrix.
Merge target: STATE.md "Enhancement backlog" section (E1 amended; E4-E7 new).
STATE.md was NOT modified by this session - fingerprint at read time:
sha256_16 96f106ee0677f54d, 509 lines, build Stage9s2-b33.

Source of all observed behavior below: two MT5 strategy-tester runs of
Shadow Trade Manager PRO v3.21 (third-party EA, reverse-engineered from
logs only - no source access). GBPAUD.s M15, DooTechnology-Demo,
2026.06.22 - 2026.06.26, build 5833. Runs recorded 2026-07-22 22:36
(run A) and 23:39 (run B). Run B was carried to the end of the test
period and contains TWO Tier 1 fires; run A was cut short after one.
Where both cover the same event they reproduce identically.

RUN B OUTCOME - read carefully before citing it: the run ended with
8 positions still open, force-closed by the tester ("position closed
due end of test", all at 1.90948) and a final balance of 2833.42 from
3000.00. That -166.58 is a forced mark-to-market of a live drawdown
sequence at an arbitrary cutoff, NOT a strategy result. The run has no
P/L verdict and must not be cited as one. What it does show: two
profitable Tier 1 fires, and the sequence still 0.48 lots deep and open
four days in, with the basket TP (1.90134) never reached. Tier 1 is a
drawdown pressure valve, not a mechanism that resolves a sequence.

IMPORTANT: Shadow is a REFERENCE, not a spec. Items below are marked
OBSERVED (evidenced in the logs, arithmetic recomputed) or CHOSEN
(Jeff's design decision for TRTM, deliberately diverging or filling a
gap Shadow's logs never exercised). Do not let a CHOSEN item be
mistaken later for verified reference behavior.

---

## E1 (AMENDED) - BE/TP anchor: SIMPLE avg -> LOT-WEIGHTED

Existing E1 recorded the choice as open. Jeff's direction 2026-07-23:
adopt LOT-WEIGHTED. Still requires its own Gate 1 -> matrix -> plan;
this only records the intended direction and the new coupling.

Existing evidence (STATE.md "Parked additions 2026-07-20", unchanged):
code comment lines 1094-1097 mark simple-vs-lot-weighted as PENDING;
live 0.02/0.02/0.03 sequence gave simple avg 4018.3433 vs weighted
4018.6414. Simple sets TP beyond financial BE+300 when late lots are
larger (errs profitable).

NEW COUPLING (this is the reason E1 can no longer be decided alone):
E4 (Tier 1, below) computes its trigger from a LOT-WEIGHTED VWAP.
Landing E4 while the sequence TP/BE stays simple-average puts two
different averaging bases in the same money path. Consistency break
under CLAUDE.md section 7. Therefore:

  E1 and E4 are ONE Gate 1, or E1 lands FIRST and E4 follows.
  E4 must not land before E1.

Scope note for whoever plans this: lot-weighted is the financially
correct basket break-even. Simple average is not - it only coincides
when all lots are equal. Under the SEALED closed-form martingale
(base * mult^tier, normalized) equal lots occur across the stall band
(e.g. base 0.01 / mult 1.5 -> L3-L6 all 0.02), so many live sequences
will show NO difference between the two bases. Divergence appears only
where the curve steps. This makes regression evidence easy to get
wrong: a matrix row that only exercises a stalled band proves nothing.
Any E1 matrix MUST include an unequal-lot sequence.

---

## E4 (NEW) - Drawdown Reduction Tier 1 ("Enable Point-Based Basket Close")

One-line: when the basket is deep, close the oldest position together
with every currently-profitable position, but only if that group's
combined P/L clears a per-lot profit threshold.

Depends on: E1 (lot-weighted). Blocks: nothing.
Money-path. Full Gate 1 -> matrix -> plan required.

### E4.1 OBSERVED behavior (Shadow, both runs, arithmetic recomputed)

Trigger conditions, all required:
- Open position count >= MinTrades (input; was 4 in both runs)
- Group formed = anchor + ALL currently-profitable positions
- Group lot-weighted VWAP is >= MinProfitPoints in front of the
  far-side market price (input; was 150 pts in both runs)

Far side = the side the basket would actually close at. Sells close at
Ask. (Buys would close at Bid - NOT observed, no buy sequence in either
run.)

Evaluation is TICK-based, not bar-gated. Both fires landed mid-bar
(14:57:39 run A, 14:57:40 run B) while every recovery entry in both
runs landed exactly on M15 boundaries.

On fire: close every group member at market, one order each, anchor
first then profitables in descending ticket order. Then recompute the
sequence TP across survivors and refresh ladder state.

Run A arithmetic (positions #2 0.01@1.88151, #11 0.10@1.91309,
#10 0.09@1.90975; close Ask 1.90850):
  group vol   = 0.01+0.10+0.09 = 0.20            (log: 0.20 OK)
  group VWAP  = 0.3820016 / 0.20 = 1.910008      (log: 1.91001 OK)
  margin      = 1.910008 - 1.90850 = 150.8 pts   (>= 150 OK)

Run B arithmetic (#2 entry differs: 1.88135; close Ask 1.90848):
  group VWAP  = 0.3819998 / 0.20 = 1.909999      (log: 1.91000 OK)
  margin      = 1.909999 - 1.90848 = 152.0 pts   (>= 150 OK)

Run B SECOND fire, 2026.06.25 15:48:48 (#3 0.02@1.88502 anchor,
#16 0.09@1.91286, #15 0.08@1.90957; close Ask 1.90698):
  group vol   = 0.02+0.09+0.08 = 0.19            (log: 0.19 OK)
  group VWAP  = 0.3626234 / 0.19 = 1.9085442     (log: 1.90854 OK)
  margin      = 1.9085442 - 1.90698 = 156.4 pts  (>= 150 OK)
  per-leg     = -43.92 +52.92 +20.72 = +29.72 lot-pts
                = 0.19 x 156.4. Exact.

Ask-side confirmed THREE times across two runs. All three fires cleared
the threshold by under 6.5 points - the signature of a threshold
crossed on the first qualifying tick. Bid-side would have fired ~33 pts
earlier (Bid 1.90817 run A) and therefore on an earlier tick. Bid is
ruled out.

ANCHOR COST ESCALATION - now MEASURED, not projected (run B, two fires):
  fire 1 anchor #2: 0.01 lot, -26.99 lot-pts
  fire 2 anchor #3: 0.02 lot, -43.92 lot-pts   (+63%)
  surplus over threshold FELL 30.16 -> 29.72 lot-pts despite fire 2
  having a LARGER profitable tail.
This is the squeeze C1 accepts. It is evidenced, not theoretical.

THRESHOLD RESTATED (the useful form for implementation):
  MinProfitPoints is a COMBINED-P/L test, volume-normalized.
  Run A: 0.20 lots x 150.8 pts = 30.16 lot-points.
  Per-leg: #2 -26.99, #11 +45.90, #10 +11.25 => +30.16. Identical.
So the rule is "the group must net at least MinProfitPoints per lot".
The VWAP framing is the same test expressed lot-size-independently.
CONSEQUENCE: the group can never close at a combined loss. The anchor
realizes a loss; the group does not.

### E4.2 CHOSEN for TRTM (Jeff, 2026-07-23) - NOT inherited from Shadow

C1. ANCHOR = OLDEST position, strictly. When the oldest closes, the
    anchor becomes the next-oldest. No "skip to an affordable anchor".
    Rationale: swaps accrue per position per night, so the oldest is
    always the most expensive to keep alive, and the primary goal
    remains reaching basket TP/BE - Tier 1 failing to fire on an
    expensive anchor is acceptable, not a defect.
    Rejected: "oldest that still clears MinProfitPoints" (skip-ahead).
    Rejected because it leaves the oldest, most swap-expensive
    positions alive longest, and makes the next-to-close unpredictable.
    Cost accepted: cost-to-close rises with each fire (run A basket at
    14:57: #2 27.1 lot-pts, #3 46.9, #4 59.2, #5 63.6), so Tier 1
    fires progressively less often as the ladder is consumed.
    EVIDENCE NOTE (corrected 2026-07-23 after run B's second fire):
    Shadow's logs CANNOT confirm its own anchor rule, and NO ordinary
    run ever will. In an unbroken additive ladder the oldest position
    is ALWAYS also the deepest underwater and the smallest lot - the
    three properties coincide structurally, not coincidentally. Fire 1
    picked #2 (oldest/deepest/smallest); fire 2 picked #3 (oldest/
    deepest/smallest of the survivors). Two observations, still three
    indistinguishable candidate rules.
    What IS confirmed: Shadow's selection sequence (#2 then #3) matches
    C1's "oldest, transferring to next-oldest" across both fires. The
    BEHAVIOR agrees; the RULE behind it is unproven. C1 remains a TRTM
    choice, now with corroborating (not determinative) evidence.
    Edge case named, not blocking: on a V-shaped/whipsaw path the
    oldest can be the SHALLOWEST loser. The rationale that always
    holds is "oldest = most swap-expensive", not "oldest = deepest".

C2. At least one profitable position is NOT mandatory. The threshold
    test alone governs. (Shadow never fired with zero profitables, so
    this is unevidenced either way - a TRTM choice.)

C3. PRESERVED LADDER INDEX (diverges from Shadow - see E4.3).

C4. 3-second post-fire recovery suppression: Shadow's is hardcoded
    (not present in its input list). TRTM should decide whether to
    expose it. Unresolved - see E4.4 O3.

### E4.3 Auto-heal: OBSERVED (Shadow) vs CHOSEN (TRTM)

Shadow RE-INDEXES BY COUNT. Run B evidence:
  Pre-fire: 10 positions, Level=9, top rung 0.10 @ 1.91309 (#11)
  Fire closes #2, #11, #10 -> 7 survive
  RefreshRecoveryState -> Level=6, LastPrice=1.90620, LastLot=0.08 (#9)
  Re-entry 20:30:00 -> Level=7, lot 0.08 @ 1.90957
Check: 1.90620 + 350 (auto-adjusted interval) = 1.90970 theoretical;
filled 1.90957, 13 pts below - normal bar-close overshoot. Confirms
Jeff's read: the "heal" is the ORDINARY recovery ladder recomputing
from the surviving top. Nothing is stored or remembered.
But the LOT is level-7's lot (0.08), not the 0.09 that rung originally
carried. Basket now holds two 0.08s (#9 and #15). The 0.09 and 0.10
rungs are permanently gone even though price returned to them.

CONCRETE DIVERGENCE CASE (run B, after the SECOND fire - use this for
the E4.3 matrix, it is real logged data, not a constructed example):
  fire 2 closes #3/#15/#16 -> 6 survive
  RefreshRecoveryState -> Level=5, LastPrice=1.90620, LastLot=0.08 (#9)
  16:30:00 re-entry -> Level=6, lot 0.07 @ 1.90969
  17:00:00 re-entry -> Level=7, lot 0.08 @ 1.91334
Shadow has now issued level-6 and level-7 lots TWICE each within one
sequence, at different prices. Final basket holds 0.07, 0.08, 0.08 plus
#9's 0.08 - four positions carrying two distinct lot values across four
distinct prices. The ladder has lost any stable price-to-lot mapping.
Under preserved index (C3) the 16:30 entry at 1.90969 would instead be
the level-8 rung and carry level-8's lot. THIS is where the two models
visibly disagree, and it is the row the matrix must exercise.

TRTM CHOSEN (C3): PRESERVE THE INDEX. A rung is an ADDRESS, not a
counter position. Level N always means (price derived from anchor +
N*interval, lot = closed-form ComputeLevelLot(N)). Price revisits that
level -> that level refills at that lot. Still nothing stored: both
price and lot are DERIVED, exactly as today.
    Rationale: refilling at the correct lot restores the basket's
    weight distribution, so the lot-weighted VWAP (and therefore the
    basket TP under amended E1) returns to where the sequence earned
    it. Shadow's re-index leaves the basket permanently lighter at the
    top, pushing TP marginally further away, compounding across heals.
    Rejected: count-based re-index (Shadow's). Rejected because it
    silently discards ladder rungs and degrades the TP line.

    IMPLEMENTATION WARNING: this touches the SEALED martingale path
    (ComputeLevelLot, lines 1752/1776; normalizer 1798) and the level
    counter. The matrix MUST carry must-NOT-fire rows proving
    closed-form output is bit-identical for the no-heal case.

    INTERACTION WITH THE SEALED CLOSED-FORM STALL: under base 0.01 /
    mult 1.5, L3-L6 all normalize to 0.02. Across a stalled band,
    preserved-index and count-re-index produce the SAME lot, so they
    are indistinguishable. Divergence appears only where the curve
    steps. Matrix rows must be sited at a step, not inside a stall,
    or the row proves nothing.

### E4.4 OPEN sub-decisions (must be resolved in E4's Gate 1)

O1. RUNG RE-ARM after a Tier 1 close. Preserved index (C3) allows the
    same rung to refill and be closed repeatedly on a whipsaw. Each
    cycle is net-POSITIVE by construction (the threshold guarantees
    it), so this is not a loss leak. The cost is ladder CONSUMPTION:
    every fire spends one old position, and the ladder is finite.
    Nine fires empties it even if all nine profited.
    Jeff's position 2026-07-23: closing at combined-negative is the
    thing to prevent, and the threshold already prevents it.
    Still to decide: whether a closed rung needs extra travel before
    re-arming, or whether unrestricted refill is the intended
    pressure-valve behavior.
    NOTE - the three existing entry gates do NOT cover this. Spread
    filter checks spread; slippage filter checks fill quality; bar-
    close checks the clock. All three are stateless w.r.t. rung
    history. Bar-close does bound the RATE (max one refill per bar)
    and filters intrabar noise - that is real throttling and may be
    sufficient. It does not bound the COUNT.

O2. THRESHOLD SCALING WITH DEPTH. MinProfitPoints is currently a flat
    constant - 150 for the first fire and the ninth. Under C1 the
    anchor gets more expensive every fire, so later fires are already
    harder to trigger; the question is whether they should also be
    required to be WORTH more. A knob, not a bug. Decide or park.

O3. Is the post-fire recovery suppression window an input or hardcoded
    (see C4)? Shadow hardcodes 3s. TRTM decides.

O4. BUY-side far-price. Sells close at Ask (observed THREE times: run
    A fire 1, run B fires 1 and 2). Buys must close at Bid. Not
    observed - no buy sequence exists in either run at all. The
    matrix must carry a SELL lap AND a BUY lap; the close-side price
    must be DIRECTION-DERIVED, never a fixed Bid or Ask read. This is
    a known common defect class (reading SYMBOL_BID as "current price"
    regardless of direction) and only surfaces on one direction.

O5. Group close ordering and partial-fill handling. Shadow closes
    anchor-first then profitables descending, each a separate market
    order, no retry observed. If any leg fails mid-group TRTM is left
    with a partially-closed group whose combined P/L no longer matches
    what was tested. Unaddressed by Shadow's logs. Needs a rule.

---

## E5 (NEW) - Drawdown Reduction Tier 2 ("percent-based")

Shadow input InpPC2_ProfitPercent, InpPC2_MinTrades. DISABLED in both
runs (InpEnablePartialClose2=false). ZERO observed behavior. Recorded
as a known sibling feature only. Requires its own reference run before
it can be specified at all.

## E6 (NEW) - Drawdown Reduction Tier 3 ("partial-lot close")

Shadow inputs InpPC3_MinTrades, InpPC3_MinLots, InpPC3_MinProfitPoints,
InpPC3_ClosePercent. DISABLED in both runs. ZERO observed behavior. The
input names imply closing a PERCENTAGE of a position's lots rather than
whole positions - a different mechanism from E4. Requires its own
reference run.

## E7 (NEW) - Reference-EA behavior capture (research task, not a build)

Rerun Shadow with the disabled features ON to obtain the evidence E5/E6
need, and to close E4's unobserved branches. Specific runs wanted:
  R1. InpEnablePartialClose2=true (Tier 2 behavior, zero data today)
  R2. InpEnablePartialClose3=true (Tier 3 behavior, zero data today)
  R3. A BUY sequence (all data today is SELL-only; needed for O4)
  R5. BE reference run: price favourable to the basket AND
      InpEnablePartialClose1=false, so Tier 1 cannot harvest the
      positions before BE arms (see F4). Only needed if Shadow's BE
      is ever wanted as a reference - TRTM's own BE is already sealed.
  R4. WITHDRAWN 2026-07-23 as originally written. The premise was that
      a different run could separate oldest / deepest / smallest-lot.
      It cannot: in an unbroken additive ladder those three properties
      coincide by construction, in every run, at every fire. Verified
      against run B's two fires (#2 then #3, all three properties
      matching both times).
      To disambiguate at all would require an ARTIFICIAL basket - e.g.
      a manually opened out-of-order position, or a sequence broken by
      partial manual closes - which is no longer a faithful reference
      run. Not worth building. C1 is a TRTM choice and does not depend
      on the answer; the question is now formally parked as
      undeterminable-by-observation.
NOT a TRTM build. No gates. Pure evidence gathering.

---

## Findings against STATE.md (raise with Jeff; NOT applied here)

F1. STATE.md line 42, E1 wording: "SIMPLE avg (live) vs lot-weighted"
    presents the choice as open. Jeff directed LOT-WEIGHTED on
    2026-07-23. E1 should be reworded to record the intended direction
    while keeping the Gate 1 requirement. Not edited here - E1's text
    underpins the parked-additions evidence block at lines 398-405.

F2. The pre-existing FINDING at lines 148-155 (stale "stops level =
    100 pts" constant in the Environment note vs the DYNAMIC 20-100
    pts ledger fact) is STILL PENDING Jeff's wording confirmation.
    Unrelated to this session; flagged so it does not get lost.

F3. Shadow log cosmetic (reference EA defect, informational only):
    its three Tier 1 CLOSING deals each print "Confirmed initial deal
    #N. Position count is 0", misclassifying close-deals as initial
    entries and reporting a count of 0 while 7 positions remained
    open. Worth knowing as a defect class TRTM's own transaction
    handler should avoid - close deals must not route through the
    initial-entry branch.

F4. Shadow's break-even engine remains UNOBSERVED across the FULL
    four-day run. Run B set InpEnableBreakEven=true and no BE line, no
    SL modification, and no armed message appears anywhere in the log
    from 00:25 on 06.22 to test end on 06.25; every position modify in
    the entire run carries sl: 0.00000, including the eight force-
    closed at test end. Reason is demonstrated, not assumed: price ran
    persistently AGAINST the basket, and on the two occasions positions
    did move into profit, Tier 1 closed them (14:57 06.24, 15:48 06.25)
    before any could hold the 200-point trigger. Note this is a
    structural interaction worth carrying into TRTM's own design
    thinking: an aggressive Tier 1 can systematically harvest exactly
    the positions a BE engine would otherwise arm on. If Shadow's BE is
    ever wanted as a reference it needs a run where price moves in the
    basket's favour AND Tier 1 is disabled - add both conditions to E7.
