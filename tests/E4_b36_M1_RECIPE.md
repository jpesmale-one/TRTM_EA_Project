# E4-b36 M-1 VERIFY RECIPE (whole-basket stand-down)
# Build: E4-b36 (src sha256_16 7e14479c83d672a4, 4483 lines) = b35 + M-1 guard.
# Goal: prove M-1 stands Tier 1 down when the group = the WHOLE basket, and that
# a PARTIAL fire still fires. One tester run can show BOTH.

## STEP 0 - GATE ZERO
[ ] Recompile src/TRTM.mq5 in MetaEditor -> 0 errors / 0 warnings.
[ ] Deploy to the MT5 tree; init line / panel shows "E4-b36".
    (If any compile error: STOP, paste it - the guard is one if-block, easy fix.)

## STEP 1 - THE M-1 RUN (tester, XAUUSD.s, real ticks, visual mode)
The trigger is a SHALLOW, tightly-packed ladder that a retrace can clear ENTIRELY
(all levels profitable => group == whole basket => M-1). The cap keeps it shallow.
Inputs:
  InpEnableTier1        = true
  InpTier1MinTrades     = 4
  InpTier1MinProfitPts  = 500      # < AvgTP so Tier1 WOULD pre-empt (that's the point)
  InpRecoveryIntervalPts= 500      # ~$5 spacing -> 5 levels span ~$25, a $25 retrace clears all
  InpMaxRecoveryTrades  = 4        # cap: max 5 levels (L1-L5) -> shallow
  InpInitialTPPts       = 3000
  InpAvgTPPts           = 2500     # sequence TP target (Tier1's 500 sits well below it)
  InpStopLossPts        = 0
Action: click SELL (or BUY), pick a window with a clear ROUND TRIP (SELL: price
rises to build ~4-5 levels, then falls back BELOW the oldest/L1; BUY: mirror).
Let it run the full range.

## STEP 2 - WHAT PROVES M-1  (two things, ideally in the one run)
[ ] PARTIAL fire (regression): on a SMALL retrace only the top level(s) profit ->
    "Tier 1 FIRE: ... group N leg(s)" with N < open count. Proves the guard is
    INERT on real valves (b35 behavior intact). Grab one.
[ ] M-1 STAND-DOWN: on a DEEP retrace the WHOLE ladder goes profitable ->
    instead of a fire you see:
        "Tier 1 stands down: group would close the whole basket
         (no underwater survivor to valve) - sequence AvgTP/BE/trail owns
         the full close (M-1)"
    and the full close then comes from the SEQUENCE, not Tier 1 - i.e. a later
    "Closing sequence at market: ... TP ... exceeded" banks the whole basket at
    the AvgTP (or it rides on). MUST-NOT: a "Tier 1 FIRE" with N == open count.

## STEP 3 - THE DECISIVE CHECK
On b35 that same whole-basket tick FIRED (live: margin 152.8 >= 150). On b36 the
identical condition must LOG THE STAND-DOWN instead. That single flip - fire ->
stand-down on a whole-basket group - is M-1 verified.

## IF THE TESTER WINDOW WON'T CLEAR THE WHOLE LADDER
The whole-basket case needs price to move back past the ANCHOR (the hardest
level). If a given window only gives partial bounces:
  - tighten InpRecoveryIntervalPts (300) so the ladder is even more packed, or
  - pick a rangier window (a clear up-then-down for SELL), or
  - FALLBACK: the LIVE demo already produced a whole-basket FIRE on b35
    (2026-07-24 16:02). Re-deploy b36 on the same live chart; the next time a
    basket goes fully green you'll get the M-1 stand-down instead of a fire.

## WHAT THIS CLOSES
[ ] M-1 (matrix rev 2) verified -> Tier 1 never worse than the baseline exit.
[ ] Regression: partial fires unchanged from b35 (all prior evidence carries).
After this: full evidence package -> Jeff's SEAL. Then commit (b36 + 4 E4 docs)
and manual deploy. Nothing else is outstanding.
