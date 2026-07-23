# TRTM - Trade Risk and Trade Manager

An MQL5 Expert Advisor for MetaTrader 5 that manages the *risk and exit
side* of manual trading. You decide when to enter; TRTM manages the
position from there - recovery levels, take-profit, stop-loss,
break-even, and trailing - with an on-chart button panel.

**Current build:** `Stage9s2-b33` · state schema v4 · primary instrument
XAUUSD.s (Doo Prime demo).

> **This is not a signal EA.** TRTM does not decide *whether* to trade.
> It never opens a position on its own except recovery levels inside a
> sequence you started. Every first entry is your click.

---

## Table of contents
1. [What it does](#1-what-it-does)
2. [Install & first run](#2-install--first-run)
3. [The panel](#3-the-panel)
4. [Core concepts](#4-core-concepts)
5. [Settings reference](#5-settings-reference)
6. [Stage guide](#6-stage-guide)
7. [Safety, logs & state](#7-safety-logs--state)
8. [Troubleshooting](#8-troubleshooting)
9. [Development protocol](#9-development-protocol)

---

## 1. What it does

You click **BUY** or **SELL** on the panel. TRTM opens the position
(this is level 1, "L1"), attaches your take-profit and stop-loss, and
watches it.

If the trade moves against you by a set distance, TRTM can open
**recovery levels** - additional positions in the same direction, at a
lot size you control. It then manages the whole group as one sequence:
a shared take-profit computed from the average entry, an optional
break-even stop once you're in profit, and an optional trailing stop.

When the sequence closes, everything resets and TRTM goes back to flat,
waiting for your next click.

**In one line:** you pick the entry, TRTM runs the risk management.

---

## 2. Install & first run

1. Copy `TRTM.mq5` into `MQL5\Experts\` (via MetaEditor: File → Open
   Data Folder → `MQL5\Experts`).
2. In MetaEditor, press **F7** to compile. You should get 0 errors.
3. In MT5, drag **TRTM** onto a chart (XAUUSD.s recommended).
4. In the dialog, open the **Common** tab and tick **Allow Algo
   Trading**. Also make sure the **AutoTrading** button in the MT5
   toolbar is green.
5. Check the **Inputs** tab (see [section 5](#5-settings-reference)),
   then click **OK**.

You should see the panel appear and, in the **Experts** tab, lines like:

```
=== TRTM Stage9s2-b33 init === symbol=XAUUSDS ...
Instance lock acquired (no existing lock)
State persistence self-test: PASS
Reconcile complete: FLAT
Init complete - Stage9s2-b33 (adoption, exits, recovery active)
```

If you see those, it's running.

> **Save your settings.** MT5's **Reset** button in the Inputs dialog
> restores *every* input to its default - including your risk settings.
> Save a `.set` preset per symbol (Inputs tab → **Save**) and load that
> instead of retyping.

---

## 3. The panel

Buttons appear on the chart depending on what's happening. You never
see all of them at once.

**When flat (no position):**

| Button | What it does |
|---|---|
| **BUY** / **SELL** | Arms a market entry. Click again within 10s to confirm. |
| **PEND BUY** / **PEND SELL** | Draws a horizontal placement line. Drag it to your price, then confirm. |

**While placing a pending order:**

| Button | What it does |
|---|---|
| **CONFIRM …** | Places the order at the line's price. The label shows the type it will use (BLIMIT / BSTOP / SLIMIT / SSTOP). |
| **CANCEL** | Removes the line, sends nothing. |
| **+ / −** | *Strategy Tester only.* Moves the line by the nudge step (see [Stage 9](#stage-9--strategy-tester-support)). |

**When a sequence is live:**

| Button | What it does |
|---|---|
| **CLOSE** | Closes the whole sequence at market. |
| **BE** | Toggles break-even for *this sequence only*. |
| **TRAIL** | Toggles trailing for *this sequence only*. |
| **CANCEL PENDING** | Cancels an unfilled pending order. |

**Two-click confirmation.** Market entries arm first and execute on the
second click, so a stray click can't open a trade. The arm expires
after 10 seconds.

**BE and TRAIL are per-sequence overrides.** Clicking them when no
sequence is running does nothing except log a reminder - change the
input default instead.

---

## 4. Core concepts

**Sequence.** One trade group: your L1 entry plus any recovery levels,
managed and closed together.

**Levels (L1, L2, L3 …).** L1 is your entry. L2+ are recovery levels
TRTM opens if price moves against the sequence by
`InpRecoveryIntervalPts` from the worst entry so far.

**Average entry (lot-weighted).** With multiple levels open, the shared
take-profit is computed from the **lot-weighted** average of the entry
prices - each level's price counts in proportion to its lot size, not
equally. This is the true break-even of the basket: a bigger lot pulls
the average toward its price, exactly as it pulls your real profit/loss.
Every level gets the same TP, so the whole group exits together.

> Why lot-weighted, not a plain average? If your levels use different
> lot sizes (any Incremental, Martingale, or Manual setup), a plain
> average of prices is *not* where the basket actually breaks even - it
> only matches when every lot is the same size. Lot-weighting places the
> TP so that at target you bank exactly `InpAvgTPPts` per lot across the
> whole group. When all lots are equal the two are identical, so nothing
> changes for equal-lot sequences.

**Break-even (BE).** Once the sequence is ahead by `InpBETriggerPts`,
TRTM moves all stops to the lot-weighted average entry, offset by
`InpBEOffsetPts` on the profit side - locking in a small gain instead
of risking a round-trip back to loss. The trailing stop's activation
point is measured from the same lot-weighted average.

**Trailing stop.** After BE, the stop can follow price at
`InpTrailDistPts`, either a fixed distance or the previous candle's
high/low.

**Deferred exits.** Brokers refuse stops placed too close to market
(the "stops level", ~100 points on XAUUSD.s and *not* a fixed number).
When a TP or SL would be inside that band, TRTM holds it and applies it
as soon as it's legal - it doesn't silently drop it.

---

## 5. Settings reference

### Money Management - L1 Entry
| Input | Meaning |
|---|---|
| `InpMoneyMode` | How the L1 lot is sized: **Fixed Lot**, **Balance Ratio**, or **Percent Risk**. |
| `InpEntryLotSize` | The lot, when using Fixed Lot. |
| `InpBalancePerLot` | Balance required per 0.01 lot, when using Balance Ratio. |
| `InpRiskPercent` | Percent of balance risked, when using Percent Risk. **Requires a stop-loss** - with SL = 0 the entry buttons are disabled by design. |
| `InpMagicNumber` | 0 derives one from the symbol. Change only to run two instances. |

### Recovery
| Input | Meaning |
|---|---|
| `InpEnableRecovery` | Master switch for recovery levels. |
| `InpRecoveryMultMode` | How each level is sized: Incremental, Fixed, Martingale, Deferred Incremental, Deferred Martingale, or Manual. |
| `InpIncrementStep` | Lot added per level (Incremental). |
| `InpFixedRecoveryLot` | Same lot every level (Fixed). |
| `InpMartingaleMult` | Growth ratio (Martingale). See the note below. |
| `InpDeferredStep` | Levels per step-up, for the Deferred modes. |
| `InpManualMultipliers` | Comma-separated multipliers, e.g. `1,2,5,8,12` (Manual). |
| `InpRecoveryIntervalPts` | Distance against you before the next level opens. |
| `InpBarCloseEntry` | On: the trigger must be met at bar close. Off: acts on tick. |
| `InpRecoveryTF` | Timeframe used for that bar close. |
| `InpMaxRecoveryTrades` | Cap on levels. 0 = unlimited. |

> **How the martingale multiplier works.** Each level is computed from
> the **base lot**: `base × mult^tier`. Because lots are rounded to the
> broker's 0.01 step, the *realized* ramp can hold flat for a couple of
> levels before stepping up (e.g. 0.01, 0.01, 0.02, 0.02, 0.02, 0.02,
> 0.03 …). That's the honest geometric curve, not a bug - the
> alternative (multiplying the last *traded* lot) drifts steadily above
> the ratio you set and quietly increases your margin requirement.
> This was reviewed and kept deliberately.

> **Recovery increases exposure.** Every level adds lots to a position
> that is already losing. Use `InpMaxRecoveryTrades` and the drawdown
> guards, and size L1 with the *deepest* case in mind, not the first.

### Exits
| Input | Meaning |
|---|---|
| `InpInitialTPPts` | TP for L1 before any recovery. 0 = off. |
| `InpAvgTPPts` | TP target from the lot-weighted average entry once recovery starts. 0 = off. |
| `InpStopLossPts` | Stop-loss, anchored to the lowest level (not the average). 0 = off. |
| `InpEnableBE` | Break-even on by default (the **BE** button overrides per sequence). |
| `InpBETriggerPts` | Profit from lot-weighted average entry needed to arm BE. |
| `InpBEOffsetPts` | Where the BE stop sits, on the profit side of the lot-weighted average. |
| `InpBEAutoAdjust` | Widen BE to cover swaps/fees. |
| `InpEnableTrailing` | Trailing on by default (the **TRAIL** button overrides). |
| `InpTrailDistPts` | Trailing distance. |
| `InpTrailMode` | Fixed Distance or Previous Candle High/Low. |
| `InpMinTrailStepPts` | Minimum improvement before the SL is modified again. |
| `InpTrailBarClose` / `InpTrailTF` | Trail only at bar close, on this timeframe. |

> **BE and the broker minimum.** If `BETrigger − BEOffset` is smaller
> than the broker's stops level, every BE stop is born unplaceable and
> gets deferred - TRTM still closes at the BE price via its backstop,
> but the stop is not held by the broker (so it isn't protected if your
> terminal dies). TRTM warns about this at init. For a broker-held BE
> stop: `Trigger ≥ Offset + stops level` plus a little spread margin.

### Filters & Safety
| Input | Meaning |
|---|---|
| `InpSpreadFilter` / `InpMaxSpreadPts` | Block *recovery* entries when spread is too wide. |
| `InpDeviationFilter` / `InpMaxDeviationPts` | Max slippage allowed on recovery entries. |
| `InpEnableDDClose` | Master switch for drawdown auto-close. |
| `InpMaxDDPercent` / `InpMaxDDUSD` | Close everything past this drawdown. 0 = off. |

### Tester & System
| Input | Meaning |
|---|---|
| `InpTesterNudgePts` | Points moved per **+ / −** click in the Strategy Tester. Values below 1 are clamped to 1. |
| `InpLogToFile` | Write a daily log file under `MQL5\Files\TRTM\`. |
| `InpRunSelfTest` | Verify state save/load on init. Leave on. |
| `InpLogRetentionDays` | Auto-delete TRTM's own logs older than N days. 0 = keep. |

---

## 6. Stage guide

TRTM was built in stages; each is verified and sealed before the next.

**Stage 1 - Foundation.** Logging, daily log files, state persistence
with a self-test, and an instance lock so two copies can't fight over
the same symbol.

**Stage 2 - Adoption.** TRTM can take over trades it didn't open. Its
own trades carry a magic number; `InpManageMobileTrades` lets it also
adopt untagged manual trades (e.g. ones you placed from your phone).

**Stage 3 - Exits.** Take-profit and stop-loss, including the deferred
handling described above.

**Stage 4 - Recovery.** Recovery levels and the six sizing modes.

**Stage 5 - Money management.** The three L1 sizing modes, plus startup
guards that refuse an unworkable configuration (see below).

**Stage 6 - Break-even & trailing.** The BE engine, the trailing
engine, and the per-sequence override buttons.

**Stage 7 - Filters & safety.** Spread and deviation filters, drawdown
auto-close, restart hardening.

**Stage 8 - Manual interaction.** Manual exit adoption and the pending
placement line.

### Stage 9 - Strategy Tester support
The MT5 visual tester does not deliver chart events to an EA, so the
panel buttons don't respond to clicks the normal way. TRTM detects
tester mode and *polls* the buttons every tick instead, so the panel
works there too.

**Adjusting the pending line in the tester (Step 2).** In the tester
you also can't drag chart objects - so the placement line was stuck at
market price and CONFIRM always refused it as too close. Two small
buttons, **+** and **−**, now sit on the CONFIRM row *in the tester
only*. Each click moves the line by `InpTesterNudgePts` (default 50).
Walk the line where you want it, then CONFIRM as usual.

Things worth knowing:
- These buttons exist **only** in the tester. Your live panel is
  unchanged - keep using the mouse there.
- The line can go either side of market on purpose (above = stop order,
  below = limit order). The order type is decided at CONFIRM.
- Nudging only moves the line. It never places or cancels anything, and
  CONFIRM still runs every safety check against the line's price.
- Each nudge logs the new price.
- Set `InpTesterNudgePts` to 0 and it clamps to 1, so a click always
  moves at least one point.

**Stage 10 - Observability.** Every guard, block, and refusal writes to
the log, not just the dashboard - so a silent "nothing happened" is
always explainable after the fact.

### Startup guards
Before enabling the entry buttons, TRTM checks that your configuration
can actually work, and says so plainly if it can't:

- **Guard A** - the computed L1 lot is below the broker minimum.
- **Guard B** - the stop-loss can't be placed as configured.
- **Guard C** - the L1 lot is larger than the fixed recovery lot, which
  would make recovery levels smaller than the entry.

A blocked guard is announced once in the log, re-announced if the
reason changes, and re-armed once you fix it.

---

## 7. Safety, logs & state

**State file.** TRTM keeps its sequence state in
`MQL5\Files\TRTM\state_<SYMBOL>_<MAGIC>.json`. If the terminal
restarts, it reloads and reconciles against what's actually open at the
broker - it does not assume.

**Restart-safe.** A heartbeat repairs the instance lock if MT5 exits
uncleanly (a hard crash doesn't run the EA's shutdown code). The
pending placement line is deliberately *not* persisted - after a
restart you draw it again.

**Logs.** `Experts` tab plus a daily file in `MQL5\Files\TRTM\`. Money
events log the actual computed figures - lots, points, currency - so
you can audit any decision after the fact.

**Two-click entry, per-sequence overrides, and deferred exits** all
exist to make the EA's behaviour predictable rather than clever.

---

## 8. Troubleshooting

**"AutoTrading disabled" / order rejected with 10027.** Two different
causes share that code. If the toolbar **AutoTrading** button is off,
that's global. If the toolbar is on, it's this EA's own checkbox:
right-click the chart → Expert Advisors → Properties → **Common** tab →
**Allow Algo Trading**. TRTM's log names which one it actually was.

**Entry buttons are disabled.** Either a startup guard is blocking (see
above - the log says which) or you're on Percent Risk with
`InpStopLossPts = 0`, which can't size a lot. Set a stop-loss.

**A TP or SL "didn't apply".** Check the log for a deferred message.
The broker refuses stops inside its stops level; TRTM applies them as
soon as they're legal.

**Settings reverted on their own.** You probably hit **Reset** in the
Inputs dialog, which restores *all* defaults. Reload your `.set`.

**Nothing happens when I click in the Strategy Tester.** Buttons are
polled on tick there, so the tester must be *running*, not paused.

**I can't restart the EA mid-test.** You can't - the MT5 visual tester
has no in-pass restart. Stop the pass and start it again, or test
restart behaviour on a live demo chart.

---

## 9. Development protocol

TRTM is built under a strict gate protocol - see `CLAUDE.md`.

1. **Locked decisions** - anything touching money behaviour is decided
   first, in writing, with the rejected alternatives and why.
2. **Sealed scenario matrix** - every condition combination, including
   the ones that must *not* fire, plus restart/kill rows.
3. **Confirmed code plan** - numbered touch points and an explicit list
   of what stays unchanged.
4. **Surgical build** - no rewrites, one build per delivery, build tag
   bumped every time.
5. **Evidence-audited verification** - every money figure recomputed
   from the live log to the cent. Terminal output outranks the code,
   the plan, and anyone's expectation.
6. **Seal** - only on explicit confirmation.

Current state, locked decisions, and observed broker behaviour live in
`STATE.md`. Never reconstruct project state from memory - verify the
file hash and line count against `STATE.md` first.

---

## Disclaimer

TRTM is trading software provided as-is, for use on your own account
and at your own risk. Recovery/martingale-style position management can
increase losses quickly. Test on a demo account until you understand
exactly how each setting behaves, and never run a configuration you
haven't watched through a full losing sequence.
