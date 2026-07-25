# ENHANCEMENT BACKLOG INPUT (E5 / Tier 2) - 2026-07-24

STATUS: Gate 1 INPUT ONLY. Nothing here is locked. No code, no matrix.
This is the E7 R1 reference-capture deliverable (Tier 2 run) feeding E5
(Drawdown Reduction Tier 2 - percent-based). Merge target when opened:
STATE.md "Enhancement backlog" E5 line + a locked-decisions block.
STATE.md was NOT modified by this analysis - fingerprint at read time:
sha256_16 78d68972b7fb85cf, 1041 lines, build E4-b36.
src/TRTM.mq5 at read time: 7e14479c83d672a4, 4483 lines (aligned, runtime==repo).

Source: ONE MT5 strategy-tester run of Shadow Trade Manager PRO v3.21
(third-party EA, reverse-engineered from logs only - no source access).
File: docs/STM Drawdown Reduction Tier2 Logs.txt (937 lines). GBPAUD.s M15,
DooTechnology-Demo, test window 2026.06.22 -> 2026.07.03, build 5833,
initial deposit 3000.00 USD, leverage 1:500. Run recorded 2026.07.24 17:33.
Config had BOTH tiers enabled: InpEnablePartialClose1=true (MinTrades 4,
MinProfitPoints 150) AND InpEnablePartialClose2=true (MinTrades 4,
ProfitPercent 1.0). InpEnablePartialClose3=false. Auto-Adjust raised the
recovery interval 200 -> 350 pts for GBPAUD.s. Recovery bar-close entry ON.

RUN OUTCOME - read before citing: the run ended 2026.07.02 23:59:58 with
12 SELL positions still open, force-closed by the tester ("position closed
due end of test", all at 1.92884), final balance 1981.59 from 3000.00.
That -1018.41 is a forced mark-to-market of a live drawdown sequence at an
arbitrary cutoff, NOT a strategy result and must not be cited as one. What
the run DOES give: one Tier 1 fire (06/30) and one Tier 2 fire (07/02),
both on the SAME single deep SELL sequence (magic 100001).

IMPORTANT: Shadow is a REFERENCE, not a spec. Items are marked OBSERVED
(evidenced in the log, arithmetic recomputed here) or OPEN (a TRTM Gate 1
sub-decision, deliberately NOT resolved in this input doc). Do not let an
OPEN item be mistaken later for verified reference behavior.

---

## HEADLINE FINDING

Tier 2 is Tier 1 with ONE thing swapped: the TRIGGER METRIC. Everything
else - group selection (oldest anchor + ALL currently-profitable
positions), the count gate, far-side/close-side price derivation, the
close mechanics, post-fire TP recompute, and recovery-state refresh - is
BYTE-for-byte the same behavior Shadow showed for Tier 1.

  Tier 1 trigger (E4, SEALED): group VWAP clears MinProfitPoints PER LOT
                               (points; account- and lot-independent).
  Tier 2 trigger (E5, this doc): group P&L in MONEY clears
                               ProfitPercent% of ACCOUNT BALANCE
                               (money; account-size DEPENDENT).

So E5 is, in the main, "Tier 1's close machinery fired by a
percent-of-balance money threshold instead of a per-lot points threshold."
The only genuinely NEW money-path concern Tier 1 never had is cross-currency
P&L valuation (see OBSERVED-7 and T2-O7).

---

## THE FIRE (single Tier 2 event) - log lines 816-870

Header, log line 816-817 (verbatim):
    === DRAWDOWN REDUCTION TIER 2 TRIGGERED ===
    Basket P&L: 31.40 | Required (1.0% of 3026.14): 30.26

Timestamp 2026.07.02 15:30:28. Basket had 15 open SELL positions
(#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#18,#19,#20,#21,#22). Closed 3, left 12.

### OBSERVED-1 - Trigger is a MONEY-vs-percent-of-BALANCE test.
Required = ProfitPercent% x reference-base = 1.0% x 3026.14 = 30.2614 -> 30.26.
RECOMPUTED, matches the log exactly.

### OBSERVED-2 - Reference base = ACCOUNT BALANCE (post-realized), NOT equity.
The base 3026.14 = initial 3000.00 + Tier 1's realized profit. Proof by
recomputing the earlier Tier 1 fire (06/30 14:16, close-side Ask 1.92011):
  #2  anchor sell 0.01 @1.88305: (1.88305-1.92011)*0.01*100000 = -37.06 AUD
  #14 prof.  sell 0.13 @1.92486: (1.92486-1.92011)*0.13*100000 = +61.75 AUD
  #13 prof.  sell 0.12 @1.92132: (1.92132-1.92011)*0.12*100000 = +14.52 AUD
  Tier 1 group = +39.21 AUD  ->  x AUD/USD(~0.667) ~= +26.14 USD
  Balance = 3000.00 + 26.14 = 3026.14  == the exact base in the Tier 2 line.
This proves the denominator is BALANCE (realized), not EQUITY. It CANNOT be
equity: at the fire moment 15 underwater sells were open, so equity was far
below 3000. Using balance is a real design lever - see T2-O1.

### OBSERVED-3 - "Basket P&L: 31.40" is the CLOSING GROUP's P&L, not the whole basket.
The whole 15-position basket was deeply underwater at that tick; its
floating P&L was strongly negative. 31.40 is POSITIVE, so it is NOT the
whole basket. Recompute the group (anchor #3 + profitables #21,#22),
close-side = far side = Ask 1.92931 (SELL basket):
  #3  anchor sell 0.02 @1.88647: (1.88647-1.92931)*0.02*100000 = -85.68 AUD
  #21 prof.  sell 0.14 @1.93219: (1.93219-1.92931)*0.14*100000 = +40.32 AUD
  #22 prof.  sell 0.15 @1.93542: (1.93542-1.92931)*0.15*100000 = +91.65 AUD
  GROUP = +46.29 AUD  ->  x AUD/USD  = 31.40 USD  =>  implied AUD/USD 0.6783
  (31.40 / 46.29 = 0.6783; period-plausible for GBPAUD ~1.93 with GBPUSD/
  AUDUSD both loaded for valuation).
So the reported number IS the group total (anchor loss + profitables),
matching Tier 1's "group can never close at a combined loss" invariant.
Shadow's label "Basket P&L" is MISLEADING - it means the close-group, not
the account basket. TRTM must name this correctly (T2-O2).
Surplus over threshold at fire: 31.40 - 30.26 = +1.14 USD (thin margin).

### OBSERVED-4 - Group selection = oldest anchor + ALL currently-profitable. SAME as Tier 1.
Anchor = #3, the lowest-level survivor (oldest; #2 was consumed by the
06/30 Tier 1 fire). Profitables = #21 (@1.93219) and #22 (@1.93542) - the
two highest-priced sells, both above the 1.92931 close, i.e. in profit.
Identical group rule to Tier 1. The count gate InpPC2_MinTrades=4 passed
trivially (15 open); the exact boundary was NOT independently exercised.

### OBSERVED-5 - Close order = ANCHOR FIRST, then profitables DESCENDING ticket.
Deals in order: #23 closes anchor #3, #24 closes #22, #25 closes #21. All
three filled on one sub-second tick (18:00:38.422 -> .428), one market buy
per leg, NO retry / NO error handling / NO partial-fill path exercised.
This is Shadow's fragile anchor-first order - the SAME order TRTM already
REJECTED for Tier 1 (E4 O5 chose profitables-first / anchor-last / abort-
on-failure so the loss leg is realized only after the covering profit is
banked). Same reasoning applies verbatim to Tier 2 (T2-O5).

### OBSERVED-6 - Far-side/close-side price = direction-derived (SELL -> Ask). SAME as Tier 1.
Close-side 1.92931 = Ask. Matches E4 O4 (buy closes at Bid, sell at Ask;
platform invariant). BUY lap is UNOBSERVED (this fire, like every Shadow
fire captured, was a SELL basket).

### OBSERVED-7 - Tier 2's threshold requires CROSS-CURRENCY P&L valuation. NEW vs Tier 1.
The group P&L is computed in the quote currency (AUD) then converted to the
account currency (USD) before the percent test (that is why AUDUSD.s is
loaded). Tier 1's per-lot POINTS metric needed no conversion. So Tier 2
introduces a money-path dependency on a live FX conversion (tick value /
AccountCurrency) that Tier 1 does not have. Flagged for T2-O7 - on XAUUSD.s
(TRTM's evidence symbol) the quote currency is USD so this collapses, but
the code path must be correct for cross-currency instruments.

### OBSERVED-8 - Post-fire behavior = SAME as Tier 1.
After the 3 closes: recompute sequence avg TP over the 12 survivors
(Avg Entry 1.91337, Vol 0.99, Count 12 -> Avg TP 1.91137), then
RefreshRecoveryState -> Level=11, LastPrice 1.92861, ticket #20. That is
Shadow's COUNT-based re-index (12 survivors -> Level 11), which TRTM already
REJECTED for Tier 1 in favour of C3 preserved-address indexing. No new
decision - E4 C3 already governs this and applies identically to Tier 2.

### OBSERVED-9 - Two log deltas vs Tier 1 (cosmetic / already-decided).
(a) Tier 2 completion line ("=== TIER 2 COMPLETE: 3 positions closed. ===")
    does NOT carry Tier 1's "Recovery suppressed for 3s" note. OBSERVED
    absence only; MOOT for TRTM since E4 O3 already chose NO suppression
    window under bar-close entry.
(b) F3 defect RECURS: the three close deals #23/#24/#25 each log
    "Confirmed initial deal #N. Position count is 0." - close deals routed
    through the initial-entry branch. TRTM guardrail (E4 matrix X-5,
    MarkEAClosed/liveness attribution) already covers this class.

---

## WHAT TIER 2 ADDS OVER TIER 1 (why it is not redundant)

Tier 1's per-lot POINTS threshold is account-size-INDEPENDENT: it harvests
the same points regardless of balance. Tier 2's percent-of-BALANCE money
threshold is account-size-RELATIVE, and because the base is balance (which
FALLS during a losing streak), the money bar 1%*balance falls too - so
Tier 2 gets EASIER to satisfy as the account draws down. That is a
genuinely different, mildly pro-cyclical harvest trigger, not a duplicate
of Tier 1. Whether TRTM wants that second trigger is a Gate 1 call (T2-O0).

---

## OPEN SUB-DECISIONS FOR E5 GATE 1 (resolve ONE at a time, most foundational first)

T2-O0 ADOPT? Is Tier 2 adopted as a DISTINCT second trigger alongside
  sealed Tier 1 (default-off input, like InpEnableTier1), or is Tier 1
  deemed sufficient and E5 declined/parked? Most foundational - gates all
  the rest.
T2-O1 REFERENCE BASE: balance (OBSERVED) vs equity vs fixed money amount.
  Defines what the trigger means. Equity almost never fires mid-drawdown;
  balance fires pro-cyclically. Single biggest divergence lever.
T2-O2 MEASURED P&L: the CLOSE-GROUP (anchor + profitables; OBSERVED, and
  the only value consistent with the >=0 invariant) - lock the naming so it
  is never read as whole-basket floating.
T2-O3 PERCENT SEMANTICS: percent OF the T2-O1 base, in account currency.
  Account-size dependent by construction - confirm that is intended for
  TRTM's multi-account use, or normalize.
T2-O4 COEXISTENCE / PRECEDENCE with Tier 1: both enabled here but fired on
  different days - interaction UNOBSERVED. On a tick where BOTH gates
  qualify: which evaluates first, do they share one anchor/group, can they
  double-fire the same tick? Must be decided, not observed.
T2-O5 CLOSE ORDER + PARTIAL FILL: inherit E4 O5 (profitables-first /
  anchor-last / abort-on-failure), rejecting Shadow's observed anchor-first.
  Near-certain inherit; confirm.
T2-O6 FAR-SIDE DERIVATION, BOTH LAPS: inherit E4 O4 (direction-derived);
  BUY lap validated against the platform invariant, not a Shadow read
  (Tier 2 BUY fire is UNOBSERVED).
T2-O7 CROSS-CURRENCY VALUATION: the money threshold needs quote->account
  conversion (OBSERVED-7). New money path vs Tier 1. Decide the conversion
  source and how it is tested (collapses to identity on USD-quote symbols
  like XAUUSD.s).

Nothing above is locked. E5 opens at Gate 1 with T2-O0, one question per
message, concrete numbers, recommendation each, rejected alternatives
recorded in STATE.md's locked-decisions log - same protocol as E4.
