# E4-b35 TESTER PLAN - cover the remaining rows in the strategy tester
# Build: E4-b35 (c286d11e1f79131c). Model: "Every tick based on real ticks".
# Recompute every money number to the cent from the log. Paste the FIRE block
# (Tier 1 FIRE + Closed + Liveness + Structure + SL re-anchored) for each fire.

## ALREADY GREEN (runs 1-2, GBPAUD.s)
Fire path (T-1,T-5,A-1,G-1,G-2,G-3,X-1,X-5,H-5,P-1), re-arm (H-2,H-4,O-1,O-2),
A-2 (4x), H-6 SELL (4x to the cent), C-1, T-6, K-3, gate zero. All SELL.

## RUN A - BUY LAP + GOLD EVIDENCE + H-6 BUY  (one run does three things)
Symbol XAUUSD.s (tester). A BUY ladder builds as price FALLS, so pick a gold
window that DROPS then BOUNCES (gold has clean down-then-up legs).
Inputs: InpEnableTier1=true, InpTier1MinTrades=4, InpTier1MinProfitPts=150,
        InpRecoveryIntervalPts=300, InpStopLossPts=1500 (SL ON), rest default.
Action: click BUY, let it build >=4 levels down, then the bounce fires it.
Covers:
  T-2   BUY fire: far = BID, margin = BID - VWAP (mirror of SELL). Recompute.
  X-1   BUY order still profitables-first desc ticket, anchor last.
  H-6   BUY SL re-anchor: new SL = new-anchor entry - 1500pt (SL BELOW anchor,
        direction-signed). Confirm it moves to the new lowest survivor.
  GOLD  money recompute on XAUUSD.s (_Point 0.01). NOTE 150pt = $1.50 -> fires
        readily on gold; that is the documented forex-default-on-gold case.
Capture: the FIRE block. I recompute VWAP, margin, combined P/L, SL.

## RUN B - NO-FIRE BYTE-IDENTITY (P1)  the regression that proves the lift-outs inert
Symbol GBPAUD.s. REUSE run-2 settings EXACTLY (interval 250, SL 5000, SELL,
same start) with ONE change: InpEnableTier1 = FALSE.
Covers:
  H-1   ComputeLevelLot lots identical to b34 (L1..Ln same as run 2's build).
  R-1/2/3  recovery entry prices + lots + flow identical to run 2 pre-fire.
  C-1/C-2  TP recomputes match run 2's pre-fire TP values exactly.
Pass = the ladder + TP lines match run 2 up to 06-24 14:02 (where fire1 was),
NO "Tier 1 FIRE" appears, and the sequence just runs to its own TP/SL/end.
Capture: the Recovery OPENED lines + a few Structure/TP lines to diff vs run 2.

## RUN C - DORMANCY + THRESHOLD GOVERNANCE (D-1/D-2, T-3, T-4)
Symbol GBPAUD.s. Make the basket SHALLOW so a fire drops count < MinTrades.
Inputs: InpEnableTier1=true, InpTier1MinTrades=4, InpTier1MinProfitPts=150,
        InpRecoveryIntervalPts=500 (WIDE -> few levels), SL 0 or 1500.
Sequence to watch for / prove:
  T-3   before the 4th level exists, a profitable tick does NOT fire (Gate A).
  FIRE  at ~4-5 levels; closes anchor + profitables = e.g. 3 legs -> 1-2 left.
  D-1   open count now < 4 -> Tier 1 DORMANT: no 2nd fire while shallow even if
        margin is available. Prove the ABSENCE across the shallow stretch.
  D-2   recovery rebuilds count back to >= 4 -> Tier 1 evaluates again (re-fires).
Then a T-4 sub-check (separate quick run OR same run, second pass):
  T-4   raise InpTier1MinProfitPts to a value the best retrace does NOT clear ->
        count >= 4 + profitables present but NO fire (Gate B blocks). Then lower
        back to 150 -> it fires. Shows the threshold alone governs.
Capture: the fire + the dormant stretch (no-fire lines) + the re-activation fire.

## OPTIONAL RUN D - XAUUSD.s SELL (defaults) if Run A was a BUY
A gold SELL fire at interval 300 rounds out the gold money evidence on the
sell side. Same capture. (Skip if Run A already gave a clean gold fire.)

## CANNOT be done in the tester (remaining for later)
  K-1/K-2  restart/kill mid-sequence  -> DEMO only (no in-pass restart).
  X-2/X-3  profitable-leg / anchor close FAILS -> abort  -> tester always fills;
           confirm by CODE REASONING (CloseLegAtMarket returns false path) - the
           logic is proven inert here, exercised only by a real broker reject.

## BEFORE FINAL SEAL (Jeff)
Tester covers the gold MONEY MATH, but CLAUDE.md wants a LIVE touch: one short
demo XAUUSD run to (a) see one live fire and (b) do the K-1/K-2 restart. Keep it
minimal - the per-row logic is already proven in the tester.
