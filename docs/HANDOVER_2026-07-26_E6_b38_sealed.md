# TRTM Handover - 2026-07-26 (E6 Tier 3 SEALED at E6-b38)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md header:
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT f7766c859e4d3c7a
   - wc -l src/TRTM.mq5                      EXPECT 4674
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   REPO and RUNTIME are now ALIGNED at E6-b38 (f7766c859e4d3c7a / 4674). Report
   "repo and runtime aligned at E6-b38, sealed". Any mismatch on EITHER is a STOP.
2. E1, E4, E5, E6 are all SEALED. Do NOT re-open them.

## 2. WHERE THE PROJECT STANDS
- CORE + E1 SEALED. E4 (Tier 1, points) SEALED at E4-b36. E5 (Tier 2, percent-of-
  balance) SEALED at E5-b37. E6 (Tier 3, partial-lot anchor slice) SEALED at E6-b38
  on 2026-07-26 - gate zero 0/0, deployed, Gate 4 closed on ten tester runs.
- E6-b38 is COMMITTED (8722fcc) and PUSHED (origin/main). NOTE: the commit predates
  the seal - the verification docs (E6_VERIFY_CHECKLIST.md, this handover, the STATE.md
  seal entries) are UNCOMMITTED as of writing. Committing them is Jeff's call.
- The three drawdown-reduction valves now stack: T2 (percent) -> T1 (points) ->
  T3 (partial slice), dispatched in that order, one fire per tick. All three have been
  observed firing live. All default OFF.

## 3. WHAT E6 IS
Tier 1's group close, except the OLDEST anchor contributes only a SLICE (ClosePercent
of its lots, FLOORED to the lot unit, anchor >= MinLots) to BOTH the close AND the gate.
Profitables close FULLY; the anchor SURVIVES at reduced volume; the gate is the
SLICED-anchor group VWAP clearing MinProfitPoints. It fires in the deep-drawdown regime
the full-anchor tiers cannot reach, because removing most of the anchor's loss from the
group lifts the margin.
  Inputs: InpEnableTier3 (false), InpTier3MinTrades (4), InpTier3MinProfitPts (200),
          InpTier3MinLots (0.02), InpTier3ClosePercent (50.0)
  KEY DIVERGENCE from T1/T2: Tier 3 does NOT re-anchor the SL, because the anchor
  survives and its LEVEL never changes. Zero code - a property of the design (F-a).

## 4. SEAL EVIDENCE (docs/E6_VERIFY_CHECKLIST.md is the full record)
Ten tester runs, XAUUSD.s real ticks 2026.06.22-07.10, deposit 10000 @ 1:500.
Nineteen Tier 3 fires + 3 Tier 1 + 1 Tier 2. EVERY money number recomputed to the cent
on TWO independent derivations - leg-by-leg AND the identity
  group P/L (USD) = marginPts x SUM(group lots)     [gold: 1 pt on 1.00 lot = $1.00]
They never disagreed once, across all 23 fires.
36 matrix rows: 32 LIVE, 2 code-guaranteed, 2 inherited.
Highlights:
 - T3-6 (the crux) proven three ways at one tick: slice +281.8 FIRES, remainder -234.4,
   full -656.7. Only the slice reproduces the logged VWAP.
 - T3-H3 proven on both laps AND the unchanged stop was subsequently HIT (BUY 4108.77,
   eight legs incl. the twice-sliced anchor) - a real broker-held stop, not just a value.
 - T3-G2 confirmed against the ACCOUNT BALANCE (Run G: +56.84 realized -> 10056.84 ->
   Tier 2's bar 18.10), an channel independent of the leg math.
 - E6_MATRIX rev 1 audited against the RAW Shadow log: arithmetically CLEAN, no
   F5-class error (E5's method, applied and passed).

## 5. OPEN ITEMS CARRIED FORWARD (none block the seal)
1. STALE COMMENT - EvaluateBasketClose header (TRTM.mq5:2300-2308) still reads "Tier 2
   FIRST, then Tier 1" / "Both share ONE group". Three tiers now. TP-7's call-site
   comment (4633) WAS updated. NOT fixed at seal time on purpose: a comment-only edit
   re-bumps the manifest sha and would break this build's identity. Bundle with the
   next build.
2. RUN H (T3-K1/K2) against an ACTUAL sliced anchor. Closed by inheritance at Jeff's
   call; the reconcile path has no Tier 3 code and nothing is persisted, but a
   partially-closed position surviving a restart is the one state E4/E5 could not have
   produced. RECOMMEND running before live deployment. A defect here would surface as a
   mis-rebuilt level or lost baseLot on the first restart after a Tier 3 fire.
3. T3-DS1 visual confirm of the "DD Reduce" row across its 8 states (widest string 31
   chars vs PNL_W 340). Display-only, no state, no money path.
4. NormalizeDouble(sliceVol, 8) vs the plan's 2 - ACCEPTED as-is (safer on 0.001-step
   symbols; identical on XAUUSD.s).

## 6. TEST-DESIGN KNOWLEDGE WORTH KEEPING (cost real runs to learn)
- L1 IS ALWAYS THE ANCHOR while it lives, and L1 == InpEntryLotSize. At the default 0.01
  the anchor is below InpTier3MinLots 0.02, so **Tier 3 can never fire on a default-
  entry-lot ladder**. Every fire run must raise InpEntryLotSize (0.03 gives slice 0.01 /
  remainder 0.02, the three-way disambiguation).
  Lot rule generally: L(N>=2) = baseLot + (N-1) x InpIncrementStep.
- BAR-CLOSE OVERSHOOT: the trigger is a MINIMUM. On M15 the close can land 850-2500 pts
  past a 500-pt trigger, so effective spacing is ~3x the configured interval. Tick-basis
  (InpBarCloseEntry=false) builds far deeper far faster - 14 levels in 58 minutes.
- BUY reaches more depth than SELL on this data window (8-15 levels vs ~6).
- "calculate profit in pips" (tester Settings) MUST be off for any Tier 2 work - its
  Gate B compares POSITION_PROFIT in account currency to a percent-of-balance bar. It is
  harmless for Tier 3 (pure price arithmetic; POSITION_PROFIT used only for the
  membership SIGN test). Tell: the log prints the mode and DROPS the currency
  ("10000" vs "10000.00 USD").
- STRUCTURAL RELATION, the single most useful fact: marginPts(slice) >= marginPts(full)
  ALWAYS, when the anchor is the group's worst leg. Consequences: (a) it is WHY Tier 3
  fires where T1/T2 cannot; (b) Tier 3's gate always opens FIRST, so it pre-empts unless
  its bar is raised above the gap; (c) both-qualify ticks are JUMP-ONLY and live on
  SHALLOW-anchor ladders where the full margin is still positive.
- A BLOCKED Tier 3 tick LOGS NOTHING (Tier 3 is last; nothing follows it), and Tier 1
  cannot witness it (locked out in Tier 3's regime by construction). But the sliced VWAP
  is an EXACT function of the entries and the Bid, so blocked-state margins CAN be
  recomputed from the log without tick data - that is how T3-4 was closed.

## 7. NEXT
E8 (profit-funded follow-on slice - Jeff's idea) is PARKED with its own Gate 1 and was
gated on E6 landing. E6 has landed, so E8 is now unblocked. Gate order applies from the
top: locked decisions -> sealed matrix -> confirmed plan -> build -> verification -> seal.
Other backlog: E2 draggable exit lines, E3 auto-entry.
Open findings: F3 (impossible in TRTM - empty OnTradeTransaction), F4 (design note),
F5 (E5 evidence-only, resolved).
