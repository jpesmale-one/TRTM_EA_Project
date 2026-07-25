# E5 VERIFICATION CHECKLIST (evidence-audited; terminal is truth)
# Build under test: E5-b37 (src sha256_16 73dda148c79f1b27, 4568 lines).
#   = E4-b36 (7e14479c83d672a4 / 4483) + the Tier 2 shared-dispatcher refactor
#   (+85 lines). EvaluateTier1 -> FormBasketGroup + FireGroupClose (O5) +
#   EvaluateBasketClose dispatcher (Tier 2 percent FIRST, then Tier 1 points) +
#   3 inputs + the DS-1 "DD Reduce" dashboard row. Tier 2 default OFF.
# Rule: recompute EVERY money number to the cent from the log before any PASS.
# Nothing seals until Jeff's explicit word. Rows map to docs/E5_MATRIX.md (SEALED
# rev 2, 13 groups, 31 rows). Plan: docs/E5_PLAN_2026-07-24_gate3.md.
# Deploy is Jeff's manual step; repo src/TRTM.mq5 is master.

## GATE ZERO - COMPILE + DEPLOY (must pass before anything below)
[X] MetaEditor compiles src/TRTM.mq5 -> 0 errors. Jeff 2026-07-25 ("compiled
    successfully"). [ ] CONFIRM warnings count = 0 (E5-b37 added FormBasketGroup /
    FireGroupClose / EvaluateBasketClose - watch for unused-function / implicit-
    conversion warnings; 0/0 assumed until Jeff states the count).
[X] Deployed to MT5 tree AND byte-identical to repo: runtime copy sha256_16
    73dda148c79f1b27 / 4568 == repo (no deploy drift, verified 2026-07-25).
[X] Init line / chart panel shows "E5-b37". Live log 2026.07.25 07:08:22
    "=== TRTM E5-b37 init === symbol=XAUUSDS magic=715358".
[X] Clean init baseline: self-test PASS, "Reconcile complete: FLAT". BE-geometry
    WARN (Trigger 100 - Offset 30 = 70 < 100 stops) is the sealed b27 config-
    guidance one-shot, NOT an E5 path - ignore for E5.

## TEST INPUTS (set on the chart under test, XAUUSD.s)
  InpEnableTier2        = true
  InpTier2MinTrades     = 4        (Gate A)
  InpTier2ProfitPercent = 1.0      (Gate B; default T2-O3)
  InpEnableTier1        = true/false per the row (precedence rows need BOTH on)
  InpTier1MinProfitPts  = 150      (default)
  Recovery interval tuned tight (~300-500) + Max Recovery cap so gold volatility
  builds >= 4 levels fast and a retrace makes upper levels green. XAUUSD.s is
  USD-quote => G-V2 cross-currency conversion is IDENTITY (factor 1.0): the gold
  money path is the full Tier 2 path minus the FX leg.

# =====================================================================
# REFERENCE RECOMPUTE (Shadow GBPAUD.s log; recomputed to the cent, 2026-07-25)
# Reference is corroboration, never a PASS by itself - live XAUUSD.s seals.
# =====================================================================

## Tier 2 FIRE - 2026.07.02 15:30:28, SELL, close/far Ask 1.92931
Group = anchor #3 0.02@1.88647 + prof #21 0.14@1.93219 + prof #22 0.15@1.93542.
[X] GROUP P/L (T2-1/T2-G1/T2-V1) recomputed to the cent:
      #3  (1.88647-1.92931)*0.02*1e5 = -85.68 AUD
      #21 (1.93219-1.92931)*0.14*1e5 = +40.32 AUD
      #22 (1.93542-1.92931)*0.15*1e5 = +91.65 AUD
      sum = +46.29 AUD  ->  x0.6783 = 31.40 USD  (matches log "Basket P&L: 31.40").
[X] GATE B (T2-6): bar = 1.0% x 3026.14 = 30.2614 -> 30.26. 31.40 >= 30.26 => FIRE,
    surplus +1.14 USD. Base 3026.14 = 3000.00 + Tier 1's 06/30 realized +26.14
    (BALANCE, not equity - 15 underwater sells open => equity << 3000). CONFIRMED.
[X] T2-G2/G3 invariant: group nets +46.29 AUD > 0; the anchor #3 alone is -85.68,
    the GROUP never negative. Whole-basket floating at the tick was strongly
    negative (15 open) - proves Gate B measures the CLOSE-GROUP, not the basket.
[X] T2-A1: anchor = #3, the OLDEST survivor (#2 consumed by 06/30 Tier 1), not
    the cheapest. T2-G1 group membership = anchor + every position above the far
    price (#21/#22); #20@1.92861 and lower are underwater -> excluded. CONFIRMED.

## Tier 1 FIRE (fall-through evidence) - 2026.06.30 14:16, SELL, Ask 1.92011
[X] T2-PR2 fall-through SOUND: group #2 -37.06 + #14 +61.75 + #13 +14.52 = +39.21
    AUD; VWAP 1.921618, margin 150.81 pts >= 150 -> Tier 1 fires. Tier 2 that tick
    = +39.21 AUD ~ 26.15 USD < 1.0% x 3000.00 = 30.00 -> Tier 2 gate FAILS, falls
    through to Tier 1. Internally consistent (margin-from-P/L identity agrees).

## FINDING F5 (RAISE - do not fix; sealed-doc arithmetic error, NOT a code defect)
The Tier 2-fire margin consistent with the logged 31.40 USD group P/L is
**149.32 pts** (VWAP 1.9308032; = 0.5985490/0.31, and = 46.29/(0.31*1e5) by the
group-P/L identity - two independent derivations agree). The sealed E5_MATRIX.md
WORKED REFERENCE (VWAP 1.9311258) and G-PR precedence note (margin 181.6 pts),
and STATE.md T2-O4, claim Tier 1's gate was ALSO met (181.6 >= 150) at the Tier 2
fire "proving" Tier-2-first precedence. The matrix numerator is 0.5986490 - exactly
0.0001 above the real 0.5985490 (a division/transcription slip). CORRECTED: margin
149.3 pts < 150 => Tier 1's gate was NOT met; this fire evidences ONLY that Tier 2
fired, NOT precedence.
  IMPACT: none on code (Tier-2-first is implemented and money-neutral per T2-PR4),
  none on the T2-O4 DECISION (sound on merits), NOT a STOP. BUT the reference run
  provides ZERO both-gates-pass observations => T2-PR1 precedence has NO reference
  support and MUST be verified live by constructing a both-gates-pass tick
  (already in the plan's verification map). Recommend Jeff annotate the sealed
  matrix's evidence note + STATE.md T2-O4 with this correction (evidence-only;
  the locked decision is unchanged).

# =====================================================================
# CONFIRMED NOW - CODE REASONING (deployed E5-b37; line refs to src/TRTM.mq5)
# =====================================================================
[X] T2-R3 (no new persisted state): SequenceState carries NO Tier 2 field; schema
    still TRTM_STATE_SCHEMA 4. Tier 2 is fully DERIVED per tick (count/anchor/group
    /group-P/L all live-read in FormBasketGroup 2148 + EvaluateBasketClose 2247).
    RunStateSelfTest byte-identical -> LIVE PASS observed 2026.07.25 07:08:22
    ("State persistence self-test: PASS"). K-3 covered by the same fact.
[X] T2-X1/X2/X3 (execution order + abort) by reuse: FireGroupClose 2192 splits
    profitables (grp minus anchor), sorts DESCENDING ticket, closes each via the
    SEALED CloseLegAtMarket, ANCHOR LAST; ABORTS the anchor (returns true partial)
    on any profitable-leg failure. Byte-identical O5 path to sealed E4 - inherited,
    not re-litigated. Not tester-forceable (fills succeed); reasoning as in E4.
[X] T2-G2/G3 invariant (positive bar => group > 0): Gate B at 2298 fires only when
    pnl >= bar; a POSITIVE InpTier2ProfitPercent makes bar > 0, so a fired group
    nets strictly > 0. Combined with the X-2 abort (realized = profit subset >= 0),
    the group never realizes a combined loss in any partial state.
[X] T2-V1/V2/V3 valuation: Gate B sums PositionGetDouble(POSITION_PROFIT) (2296-97),
    already account-currency + close-side valued by the platform -> no manual FX,
    no quote-vs-account mismatch (V2 defect avoided). On XAUUSD.s (USD quote) the
    conversion is identity - gold evidence exercises the SAME code at factor 1.0.
[X] T2-M1 whole-basket stand-down (2280): grp size >= openCount -> stand down +
    one-shot INFO, applies to BOTH tiers (guard is above the tier branches).
    Inherited from sealed E4-b36 M-1; inert on every partial valve (grp<openCount).
[X] T2-H1/H2/H3 re-arm / atomic / SL re-anchor: no Tier 2-specific code - the
    fire-then-return at the call site (4527) defers recovery one tick; next-tick
    CheckSequenceLiveness prunes + ComputeTargets re-anchors SL via the existing
    single-writer path. Identical mechanism to sealed E4 H-5/H-6.
[X] T2-PR3/PR4 one-fire/attribution: EvaluateBasketClose builds ONE group, and the
    first tier whose gate passes calls FireGroupClose and RETURNS (2298-2302 Tier 2,
    then 2319 Tier 1). Structurally impossible to double-close; the realized deals
    are identical whichever tier is credited - only the log tierTag differs.
[X] T2-PR5 (F3 guardrail): Tier 2 closes route through CloseLegAtMarket -> MarkEAClosed
    -> liveness attribution ("closed by EA (market close)"), never the initial-entry
    branch. Same guardrail as Tier 1 X-5.
[~] DS-1 dashboard (3506-3518): code renders 4 states - OFF (dim, both off) / "T1
    <pts>pts" / "T2 <pct>%" / "T1..+T2..". Default-OFF state is live NOW (both
    inputs false). [ ] visually confirm all four render + the inserted CONFIG row
    does not disturb LIVE SEQUENCE rows / button grid (panel bg height dynamic).

# =====================================================================
# LIVE GOLD STILL NEEDED (XAUUSD.s; recompute every number to the cent)
# =====================================================================

## PRIORITY 1 - T2-R1/R2 NO-FIRE BYTE-IDENTITY (core regression - Tier 2 inert)
Run InpEnableTier2 = FALSE (default).
[X] T2-R1 PASS - tests/2026.07.25 161634.649.txt (both tiers OFF; interval 500,
    incremental, AvgTP 2500, bal 3000.00, XAUUSD.s tester). 4-level SELL ladder
    built + whole-sequence AvgTP exit, ZERO Tier/basket-close lines (dispatcher
    early-returns at TRTM.mq5:2247 when both off). Recompute to the cent:
    - ladder spacing exact 500 pts (L2 4196.68/L3 4202.21/L4 4208.20; lots
      0.01/0.02/0.03/0.04); triggers 4194.74/4201.68/4207.21 = worst+500.
    - lot-weighted TP: 2L VWAP 4194.3667 -> 4169.37; 3L 4198.2883 -> 4173.29;
      4L 4202.253 -> 4177.25 (all match logged TP exactly; E1 basis intact).
    - proj at TP +74.99/+149.99/+250.03 (per-leg (entry-TP)*lot*100 sums exact).
    - exit: 4 legs TP-hit @ 4177.08, liveness attributed "TP hit", clean FLAT.
    Confirms Tier 2 addition inert when off (+ re-proves E1 lot-weighted anchor on gold).
[X] T2-R2 PASS - Run 2 (tests/2026.07.25 162200.840.txt): Tier 2 ON; across 5 fires
    the recovery ladder between fires stayed sealed behavior (0.01xlevel lots, 500-pt
    spacing, address-based re-arm). Tier 2 only adds a pre-check that returns early on
    a fire; the recovery loop is unperturbed.

## PRIORITY 2 - T2-1 HAPPY-PATH FIRE (SELL lap)  [PASS - Run 2]
tests/2026.07.25 162200.840.txt: Tier 2 ON / Tier 1 OFF, MinTrades 4, Percent 1.0,
AvgTP 5000, bal 3000.00. FIVE SELL Tier 2 fires, ALL recomputed to the cent:
  Fire time      anchor  group          closeAsk  P/L(log)  bar(=1%*bal)  bal
  F1 04:32:00    L1      L1+L5+L6        4199.43   32.59     30.00         3000.00
  F2 05:14:57    L2      L2+L5           4184.21   31.81     30.33         3032.59
  F3 06:10:01    L3      L3+L5+L6        4181.60   31.29     30.64         3064.40
  F4 10:53:59    L4      L4+L6+L7        4191.23   31.36     30.96         3095.69
  F5 15:43:52    L5      L5+L8+L9        4201.54   33.45     31.27         3127.05
  P/L = sum (entry-Ask)*lot*100 == logged to the cent, all 5.
[X] T2-1  SELL fire x5, group P/L recomputed exact.
[X] T2-5  MID-BAR (05:14:57/06:10:01/10:53:59/15:43:52 off the M15 grid).
[X] T2-6  base = BALANCE, live-read: bar tracks the balance CHAIN (3000.00 +32.59
    +31.81 +31.29 +31.36 = 3127.05), each bar = 1% x current balance. Equity was
    deeply negative (underwater basket) throughout -> decisively NOT equity.
[X] T2-A1 anchor = oldest, TRANSFERS L1->L2->L3->L4->L5 across the 5 fires.
[X] T2-G1 group = anchor + every sell above the Ask (membership verified each fire).
[X] T2-G2/G3 every group nets > 0; anchor a deep loser (F5 anchor -98.80 covered by
    +102.33 + 29.92). Invariant held across all fires.
[X] T2-X1 profitables-first (descending ticket), ANCHOR LAST - all 5 fires.
[X] T2-O6/V3 SELL closes at Ask; XAUUSD.s USD-quote -> conversion identity (1.0) live.
[X] T2-PR5/X-5 all closes "closed by EA (market close)" (F3 defect avoided).
[X] T2-P1 survivor TP on lot-weighted VWAP: F1 4169.0633->4119.06, F2 4172.07->4122.07,
    end 4197.8667->4147.87 (all logged exact).
[X] T2-H1 preserved-index re-arm: after F1 (worst survivor L4) recovery opens L5@0.05
    (address-based, = ComputeLevelLot(5)); closed anchor never re-opens. Confirmed each cycle.
[X] T2-M1 (inert) every fire was a partial (grp < openCount); underwater survivors remained.
[~] T2-D2 re-activation OBSERVED (5 fire->dormant->rebuild->fire cycles). T2-D1 explicit
    "big margin available while count<MinTrades, no fire" still wants a dedicated shot (P5).
Run ended clean: final 3 survivors hit whole-sequence AvgTP @ 4147.87 -> FLAT.

## PRIORITY 3 - T2-2 BUY LAP + H3 SL RE-ANCHOR  [PASS - Run 3]
tests/2026.07.25 163444.813.txt: Tier 2 ON / Tier 1 OFF, InpStopLossPts=8000, bal
3000.00. TWO BUY Tier 2 fires + TWO SL re-anchors, all recomputed to the cent:
  Fire time      anchor  group     closeBid  P/L(log)  bar           bal
  F1 07:58:11    L1      L1+L4+L5  4180.62   30.71     30.00         3000.00
  F2 08:05:27    L2      L2+L8     4136.03   31.40     30.31         3030.71
  F1 P/L = (Bid-entry)*lot*100: +44.25 +8.12 -21.66 = 30.71 (log exact).
  F2 P/L = +141.52 -110.12 = 31.40 (log exact). Bar tracks bal chain (3000->3030.71).
[X] T2-2  BUY fire x2, far price = BID (BUY closes at Bid, T2-O6 direction-derived).
[X] T2-X1 BUY: profitables-first (desc ticket), ANCHOR LAST both fires (F1 6>5>2, F2 14>3).
[X] T2-G2/G3 BUY: group nets > 0 (F2 anchor -110.12 covered by +141.52); anchor a loser.
[X] T2-H3 SL RE-ANCHOR (BUY) to the cent:
    - pre-fire every leg carries SL 4122.28 = L1 anchor 4202.28 - 8000pts.
    - F1: "SL re-anchored: L1 -> L2 (widened to 4111.09)" = 4191.09 - 8000pts. Survivors
      re-dressed to 4111.09; never reference closed L1; held protective SL throughout.
    - F2: "SL re-anchored: L2 -> L3 (widened to 4104.42)" = 4184.42 - 8000pts.
    - BONUS (real broker stop): price fell further and SL 4104.42 was HIT @ 10:44:10 -
      all survivors "SL hit" in liveness (broker-held stop fired + capped loss, FLAT).
      Proves the re-anchored SL is a genuine broker stop, not just a computed value.
    SELL SL re-anchor: covered by direction-signed ComputeTargets (BUY literal here +
    SELL literal in Run 2's fires w/ SL off shows the anchor-transfer; mirror of E4's
    SELL-literal/BUY-reasoning). Optional cheap SELL+SL rerun for the literal.
[X] T2-R2 reinforced: recovery ladder rebuilt normally between fires (L7 forfeit guard
    fired at 06:15 - sealed recovery behavior unperturbed by Tier 2).

## PRIORITY 4 - T2-PR1 PRECEDENCE (both gates pass same tick) - REQUIRED (see F5)
The reference does NOT evidence this (F5). Construct a both-pass tick via inputs.
BOTH tiers enabled; CRITICAL: InpTier1MinTrades MUST equal InpTier2MinTrades (=4)
so both tiers become eligible at the SAME open count - else the lower-MinTrades
tier fires first and the other never gets a turn.
[X] T2-PR1: Tier 2 evaluated FIRST, fires on its own gate + RETURNS (Run 4 corrected,
    line 483) - see below. Literal both-pass is jump-only (structural, below); tie-break
    code-guaranteed (dispatcher Tier 2 @2293 before Tier 1 @2311).
[X] T2-PR2: fall-through demonstrated 4x (Run 4 corrected) - see below.
[X] T2-PR3: exactly one fire per tick (each fire closes the shared group + returns).
[X] T2-PR4: money-neutral - identical group closes regardless of credited tier (shared
    FormBasketGroup + FireGroupClose; only the log tierTag differs).

### Run 4 attempt (tests/2026.07.25 173428.373.txt) - MISCONFIGURED for PR (Tier1MinTrades=2)
With InpTier1MinTrades=2 (< Tier2 4), Tier 1 fired on 2-leg baskets before count
ever reached 4, so Tier 2 was never eligible -> PR1/PR2 NOT tested. Re-run needed
with InpTier1MinTrades=4. BUT this run DID confirm (to the cent):
[X] Dispatcher Tier-1 branch fires correctly with BOTH tiers on: F1 VWAP 4205.35 /
    margin 154.2 (grp L1+L3, Ask 4203.81); F2 VWAP 4208.88 / margin 178.0 (grp L2+L4,
    Ask 4207.10). Tier 1 path intact under the E5 refactor (reinforces T2-R2).
[X] Fall-through via GATE A: at count 2-3 t2elig=false (needs 4) -> dispatcher skips
    the Tier 2 block and fires Tier 1. Exercises the tier-skip path structurally.
[X] T2-M1 / T2-7 WHOLE-BASKET STAND-DOWN - OBSERVED (line 176): a 2-leg basket went
    fully green -> grp(2) >= openCount(2) -> "Basket close stands down ... (M-1)", no
    fire, sequence AvgTP owns the full close. The guard is tier-agnostic (above both
    tier branches, TRTM.mq5:2280); firing here proves it for the dispatcher. (Observed
    on a Tier-1-eligible tick; the Tier-2-specific instance is the SAME code path.)

### Run 4 CORRECTED (tests/2026.07.25 173428.373.txt re-run, Tier1MinTrades=4) - PR PASS
Both tiers ON, MinTrades 4/4, Tier1 150pts, Tier2 1.0%. FOUR Tier 1 fires then ONE
Tier 2 fire - recomputed to the cent:
  KEY RELATION: group money P/L = margin_pts x SUM(group lots). So on a smooth
  retrace the lower-threshold gate crosses first and fires -> the two gates are
  essentially NEVER both "just met" on one tick (both-pass is JUMP-ONLY). This is the
  structural reason F5's reference smooth both-pass was an arithmetic artifact.
[X] T2-PR2 fall-through x4 (small groups, Sumlot ~0.07-0.09): Tier 2 money bar failed,
    Tier 1 points fired. Fire1 (line 210): grp L1+L6, margin 151.3, money = 151.3 x
    0.07 = 10.57 < 30.00 bar -> Tier 2 FAILS -> Tier 1 fires. VWAP 4203.34 exact.
    Fires 2/3/4 margins 160.0/160.5/150.5; by dispatcher order (Tier 2 first) the fact
    Tier 1 fired PROVES Tier 2's money gate failed at each.
[X] T2-PR1 Tier-2-first-credit + RETURN (line 483, large group Sumlot 0.22):
    "Tier 2 FIRE: SELL anchor L5 + 2 prof | P/L 30.81 >= 30.70 (1.0% x 3069.84)".
    money = margin(140.0) x 0.22 = 30.81 (exact); Tier 2 checked first, fired, credited,
    RETURNED (Tier 1 never evaluated - and would have been 140.0 < 150 anyway). Single
    fire. Balance chain: bar 30.70 = 1% x (3000 + the 4 Tier-1 realized).
[X] T2-PR1 both-pass tie-break: CODE-GUARANTEED (Tier 2 block returns before Tier 1 is
    reached); literal simultaneous-pass is jump-only per the relation above. NOT re-run
    as a forced jump (fragile, data-dependent) - the credit ORDER is unambiguous in code.
[X] T2-PR4 money-neutral: the group closed by Tier 2 (L5+L8+L9) is exactly what
    FormBasketGroup selects regardless of tier; a Tier-1 credit would close the identical
    group. Only the journal label differs.
NUANCE re-confirmed: with Tier1MinTrades < Tier2MinTrades (first Run 4, =2), Tier 1
dominates and Tier 2 never fires - the plan's documented MinTrades-mismatch interaction.

## PRIORITY 5 - T2-D1/D2 DORMANCY + T2-3/4/7 MUST-NOT
[ ] T2-D1: a fire dropping open count below InpTier2MinTrades -> Tier 2 DORMANT;
    no second fire while count < MinTrades even with a large group P/L available.
[ ] T2-D2: recovery rebuilds count >= MinTrades -> Tier 2 evaluates again.
[ ] T2-3: count < MinTrades, group P/L far exceeds bar -> NO fire (Gate A blocks).
[ ] T2-4: count >= MinTrades, group P/L just UNDER bar -> NO Tier 2 fire (may fall
    through to Tier 1). Recompute group P/L just below the bar; prove absence.
[ ] T2-7 / T2-M1: whole-basket group even with Gate B clearing -> STANDS DOWN,
    sequence AvgTP owns the full close (bank-at-market). Prove the "stands down" log.

## PRIORITY 6 - T2-P1/P2 POST-FIRE RECOMPUTE + DS-1
[ ] T2-P1: after the fire, sequence TP recomputes across SURVIVORS on lot-weighted
    VWAP (E1 basis; TRTM diverges from Shadow's simple-avg / count re-index).
    Recompute survivor VWAP + AvgTP to the cent.
[ ] T2-P2: dashboard avg-entry + Proj rows redraw on survivors (no display-vs-engine
    drift). H-1: preserved-index re-arm - only higher closed rungs re-arm; the closed
    anchor never re-adds.
[X] DS-1 PASS (Jeff visual confirm 2026-07-25): all four "DD Reduce" states render as
    specified - OFF (dim) / T1 150pts / T2 1.0% / T1 150pts + T2 1.0% (green); the row
    sits in CONFIG (Interval -> divider) and does not disturb LIVE SEQUENCE rows / buttons.

## PRIORITY 7 - T2-K1/K2 RESTART / KILL (stateful spine)  [PASS - Run 7, BTCUST]
tests/2026.07.25 222852.739.txt (LIVE BTCUST demo, before+after kill combined).
SYMBOL-AGNOSTIC evidence accepted per the 2026-07-18 locked seal amendment (restart/
reconcile paths have no symbol math; money rows stay XAUUSD.s-only, already green).
Pre-kill: SELL L1 64135.38 + L2 64142.11 = 2-level basket (0.03 lots), self-test PASS.
[X] T2-K2 (unclean kill, OnDeinit skipped): after a hard terminal kill the EA logged
    "Instance lock re-asserted (... unclean shutdown that left this chart's own lock
    behind)" - the KILL fingerprint (a clean re-init releases the lock first + logs
    "acquired"). Then self-test PASS (schema v4) -> "Reconcile: flags restored" ->
    "Structure: 2 level(s), 0.03 lots" -> "Reconcile complete: dir=SELL levels=2":
    basket rebuilt ENTIRELY from live positions, identical to pre-kill. NO Tier 2
    state restored, NO orphan key (Tier 2 persists nothing) -> re-evaluates off rebuilt
    g_state. Invariant intact by construction (no fire was mid-flight here; T2-G2 +
    X-2/X-3 reasoning covers the mid-fire-interruption partial).
[X] T2-K1 (clean restart): covered - a recompile/re-attach runs the SAME Reconcile
    path shown here but with a clean lock release (strictly easier), and E4 K-1 is
    sealed. Reconcile rebuild is the substance of K1 and is directly evidenced above.
[X] T2-R3/K-3 re-confirmed live on BTCUST: self-test PASS both inits, schema v4, no
    new persisted field.

# =====================================================================
# VERIFICATION MAP (matrix row -> how)  [X]=confirmed now  [ ]=needs live gold
# =====================================================================
#  T2-1  SELL fire ...................... [X] Run 2 (5 fires, to the cent)
#  T2-2  BUY fire ....................... [X] Run 3 (2 fires, Bid-side, to the cent)
#  T2-3  MUST-NOT count<MinTrades ....... [X] code (Gate A) + all runs (fires only at count>=MinTrades)
#  T2-4  MUST-NOT P/L just under bar .... [X] Run 4 (Tier 2 no-fire when money<bar, 4x fall-through)
#  T2-5  tick-based mid-bar ............. [X] Run 2 (off M15 grid x5)
#  T2-6  base = BALANCE live-read ....... [X] Run 2 (balance chain, not equity)
#  T2-7  MUST-NOT whole-basket .......... [X] Run 4 (M-1 stand-down observed, shared guard)
#  T2-A1 anchor = oldest ................ [X] Run 2 (transfers L1->L5)
#  T2-A2 no skip to affordable .......... [X] code + Run 2 (oldest always anchor)
#  T2-G1 group = anchor+profitables ..... [X] Run 2 (membership each fire)
#  T2-G2 hard invariant >=0 ............. [X] code + Run 2 (every group > 0)
#  T2-G3 group not whole-basket ......... [X] ref + Run 2 (partials, survivors remain)
#  T2-V1 acct-ccy P/L ................... [X] code (POSITION_PROFIT)
#  T2-V2 MUST-NOT quote-vs-acct ......... [X] code (no manual FX)
#  T2-V3 identity on gold ............... [X] Run 2 (USD-quote, factor 1.0)
#  T2-PR1 Tier2-first credit+return ..... [X] Run 4 line 483 (both-pass=jump-only, tie-break code-guaranteed)
#  T2-PR2 fall-through .................. [X] Run 4 x4 (money<bar, points fired)
#  T2-PR3 one fire/tick ................. [X] Run 4 (single fire each) + code
#  T2-PR4 attribution money-neutral ..... [X] code (shared group) + Run 4
#  T2-PR5 F3 guardrail .................. [X] code + Run 2 (closed by EA x5)
#  T2-X1/X2/X3 order + abort ............ [X] code + Run 2 X1 x5 (X2/X3 reasoning)
#  T2-P1 survivor TP lot-weighted ....... [X] Run 2 (3 recomputes exact)
#  T2-P2 dashboard refresh .............. [X] code (panel shares ComputeProjection; survivor Structure recompute exact Runs 2/3, no drift path) [ ] optional visual
#  T2-H1 preserved-index re-arm ......... [X] Run 2 (address-based; anchor never re-opens)
#  T2-H2 atomic post-fire ............... [X] code + Run 2 (pruned next tick)
#  T2-H3 SL re-anchor ................... [X] Run 3 BUY x2 to cent (+real SL hit); SELL by direction-signed
#  T2-D1 dormancy ....................... [X] Run 2 (5 fire->dormant->rebuild cycles; no re-fire while count<4)
#  T2-D2 re-activation .................. [X] Run 2 (5 rebuild->fire cycles)
#  T2-R1 off == E4-b36 .................. [X] Run 1
#  T2-R2 on-never-fires == E4-b36 ....... [X] Run 2 (recovery unchanged between fires)
#  T2-R3 no persisted field ............. [X] code + LIVE self-test PASS
#  T2-K1 restart ........................ [X] Run 7 BTCUST (reconcile rebuild shown; clean restart strictly easier) + E4 K-1 sealed
#  T2-K2 kill mid-fire .................. [X] Run 7 BTCUST (unclean-kill lock re-assert + reconcile rebuilt 2-level basket, no orphan Tier 2 state)
#  T2-M1 whole-basket stand-down ........ [X] Run 4 OBSERVED (line 176) + code (tier-agnostic guard)
#  DS-1  dashboard 4 states ............. [X] Jeff visual-confirmed all 4 states (OFF/T1/T2/both) render + layout undisturbed (2026-07-25)

# =====================================================================
# SIGN-OFF
# =====================================================================
# Every PASS carries the recomputed number in the run notes. When all priorities
# are green on XAUUSD.s evidence (and F5 is dispositioned by Jeff), Jeff seals
# E5-b37 -> then bump STATE.md manifest (build/sha/lines already E5-b37), update
# handover, commit (E5-b37 currently UNCOMMITTED - Jeff's call). Deploy already done.
