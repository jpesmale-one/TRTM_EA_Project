# b45 / E9-R1 — GATE 4 TEST PROCEDURE (Drawdown Auto Close)

For: Jeff, running these by hand at the terminal.
Build under test: **b45**, `e5516ee1ce06dcde`, 5659 lines. Gate Zero PASSED 2026-10-05 15:50.
Matrix: `docs/R1_MATRIX.md` SEALED rev 2, 52 rows.

---

## BEFORE YOU START — two things

**1. Use a chart with NO live sequence.** Every test below starts flat. If a sequence is
running, finish it or use a different symbol.

**2. Check your GBPJPY recovery interval NOW** (matrix B-11). Open the GBPJPY chart's EA inputs
and read `InpRecoveryIntervalPts`:

- If it reads **370** — correct, 37 pips on a 3-digit pair. Nothing to do.
- If it reads **37** — your ladder is spacing levels **3.7 pips** apart, not 37. That is a
  live config issue, **not** a b45 bug, and it would also make every boundary test on GBPJPY
  read wrong. Fix it before Phase 3.

Tell me which it says; I need it for the record either way.

---

## HOW TO REPORT

After each phase, send me:
1. The log lines (copy from the Experts tab, or the day's file in `MQL5\Files\TRTM\`).
2. A **dashboard screenshot** for any phase marked **[SCREENSHOT]** — the DD Cap row exists
   only on screen, and `PanelDestroy()` erases it when you detach. Capture before removing the EA.

I audit each phase and recompute every money figure before calling anything PASS.

---

# PHASE 1 — CONFIGURATION GUARDS (flat, zero risk, no trades)

No position is opened in this phase. Nothing can lose money. It tests the defect that started
E9-R1: the silent no-op.

### 1A — the E9-R1 failure itself (rows A-6, F-1, F-2) **[SCREENSHOT]**

Chart: **XAUUSD.s** (or any flat chart).

| Input | Set to |
|---|---|
| `InpEnableDDClose` | **true** |
| `InpMaxDDPercent` | **0** |
| `InpMaxDDUSD` | **0** |

Apply (OK on the inputs dialog — this re-initialises the EA).

**Expect:**
- A **LOG_ERROR** containing: *"ENABLED but BOTH limits are 0 ... THE DRAWDOWN CAP IS NOT ARMED"*
- Dashboard row: **`DD Cap SL   NOT ARMED (no limit set)`** in amber
- **Entries still work** — the EA must NOT be config-blocked. The BUY/SELL buttons stay green.
  (This is deliberate: a bad DD cap must not freeze a sequence other rules still protect.)

**Fails if:** the message is INFO not ERROR, or there is no message at all, or the buttons go gray.

### 1B — negative limit (row A-7)

Set `InpMaxDDPercent = -1`, leave USD at 0. Apply.

**Expect:** LOG_ERROR naming the negative value, *"NOT ARMED"*. No crash, no block.

### 1C — percent only (rows A-2, F-1) **[SCREENSHOT]**

| Input | Set to |
|---|---|
| `InpMaxDDPercent` | **2** |
| `InpMaxDDUSD` | **0** |

**Expect:** `Drawdown Auto Close ARMED: effective cap $X (percent limit only: 2.00% of balance Y)`

**Check the arithmetic yourself:** X must equal Y × 0.02. Dashboard reads `$X cap (flat)` in green.

### 1D — USD only (row A-3)

`InpMaxDDPercent = 0`, `InpMaxDDUSD = 150`.

**Expect:** cap **$150.00**, *"USD limit only"*.

### 1E — both set, LOWER wins (row A-4) — **the one most worth checking**

`InpMaxDDPercent = 2`, `InpMaxDDUSD = 20`.

**Expect:** the log names **both** candidates and says the **LOWER (tighter) wins**. With any
balance above $1,000, the percent limit exceeds $20, so **effective cap = $20.00**.

**Fails if** it picks the percent, or only mentions one limit.

### 1F — tie (row A-5)

Set `InpMaxDDUSD` to exactly 2% of your balance (balance 1,000 → `20`).

**Expect:** one clean arm line, cap = that figure, no ambiguity or double-logging.

### 1G — feature off (row A-1, absence)

`InpEnableDDClose = false`. Apply.

**Expect: NOTHING.** No DD line in the log, **no DD Cap row on the dashboard**. Already passed
once at Gate Zero; confirm the row disappears after having been visible.

---

# PHASE 2 — BOUNDARY ON A LIVE SEQUENCE (real money — read this first)

**This phase opens a real position and lets the EA write a stop loss.** Use **demo**, or the
smallest lot your account allows. The boundary is a *stop*, so the risk is bounded by the cap
you set — but it is real.

**Recommended settings for a cheap, fast test:**

| Input | Set to | Why |
|---|---|---|
| `InpEnableDDClose` | true | |
| `InpMaxDDPercent` | 0 | use the USD limit — easier to verify by hand |
| `InpMaxDDUSD` | **20** | small, and the arithmetic is trivial to check |
| `InpEntryLotSize` | 0.01 | minimum exposure |
| `InpStopLossPts` | **300** | **deliberately set**, so C-2 can prove it concedes |
| `InpEnableRecovery` | true | the projection needs a ladder to project |
| `InpEnableTier1/2/3` | **false** for now | keep Phase 2 simple; tiers come in Phase 4 |

### 2A — open L1 and read the boundary (rows B-1, B-2, C-1, C-3, F-1, F-3) **[SCREENSHOT]**

Click **BUY**, then **CONFIRM**.

**Expect, in order:**
1. `L1 BUY OPENED via button: 0.01 lots @ <price>`
2. `EA L1 REGISTERED ...`
3. **`DD boundary re-derived after L1 opened: <price> - cap $20.00, realised $0.00, remaining $20.00, N level(s) afforded (E9-R1 D4).`**
4. `Exits applied to ticket ...: TP <x> SL <boundary>`

**What to check by hand:** the SL the EA writes must equal the boundary price in line 3 — not
your `InpStopLossPts` value. Dashboard shows `DD Cap SL  <price> ($20.00, N lvl)`.

### 2B — InpStopLossPts concedes (row C-2)

Already covered by 2A: you set `InpStopLossPts = 300`, so the *computed* SL would be 300 points
from entry. The applied SL must be the **DD boundary instead**.

**Expect** a log line stating the DD boundary **replaces** the computed SL, naming both prices.

### 2C — idempotence (row C-8, absence)

Let it run **2–3 minutes** with no intervention.

**Expect: NO repeated `PositionModify` lines, and no repeated DD boundary lines.** The boundary
re-derives on *structural* change only — ticks and new bars must produce nothing. This is rows
**D-2 and D-3** passing by absence, and it is the row that proves there is no per-tick cost.

### 2D — recovery level opens (rows D-1, B-3) — **the highest-value row in the matrix**

Wait for price to move against you by `InpRecoveryIntervalPts` so L2 opens. (On XAUUSD.s with
interval 300, that is a $3 move. If markets are quiet, skip to Phase 3 and come back.)

**Expect:**
1. `Recovery L2 OPENED ...`
2. `DD boundary re-derived after L2 opened: <new price> ...` — the boundary **moves**
3. All legs rewritten to the new boundary

**B-3 is what this really tests:** compare the `Recovery signal ... vs trigger <T>` line against
the level prices the earlier projection implied. They must agree — projection and engine share
one interval helper, and if they ever disagree the stop sits where the engine never trades.

### 2E — manual SL overwrite, the loud one (rows C-4, C-5)

With the sequence live, **drag the stop loss by hand** in MT5:

- **First, drag it FURTHER from price** (looser than the boundary) → expect the EA to pull it
  back to the boundary. Row C-4.
- **Then drag it CLOSER to price** (tighter than the boundary) → expect a **LOG_WARN** saying the
  DD boundary is **LOOSER** and replaces it, *"Your stop moves AWAY from price"*, naming both
  prices.

**This second case is the behaviour you locked in D6 and I flagged as the one that can cost
money.** It must happen, and it must be loud. If it happens *silently*, that is a FAIL.

### 2F — close out

Click **CLOSE SEQUENCE**, then **CONFIRM**.

**Expect:** all legs closed, `Sequence fully closed - back to FLAT`, and **no stale boundary**
on the next sequence (row D-10).

---

# PHASE 3 — RESTART (rows E-1, E-2, E-4)

With a **live sequence** carrying a boundary (repeat 2A if you closed it):

1. **Screenshot the dashboard** — note the boundary price.
2. Remove the EA from the chart.
3. Re-attach it.

**Expect at init:** `DD boundary re-derived after init (restart re-derive): <price> ...`

**The point of this row:** the broker held your stop the entire time the EA was off the chart.
That is the whole reason D2 chose a stop over an EA-side close. If the recomputed boundary
differs from the one on the positions, re-derive wins and rewrites — log both prices.

---

# PHASE 4 — DD REDUCTION TIERS (rows D-5, D-6, D-7) — the subtle one

Only attempt this once Phases 1–3 pass. It needs a deep sequence (4+ levels), so it may have to
wait for a real move.

Enable **Tier 3** (`InpEnableTier3 = true`, `InpTier3MinTrades = 4`) with DDClose on.

**When a tier fires, expect:**
- Tier 1/2 (full legs close) → `DD boundary re-derived after a level closed: ...` with
  **realised** credited and **remaining** grown. The boundary may move **AWAY** from price.
  **That is correct, not a bug** — budget was genuinely freed (your D5 decision).
- Tier 3 (partial slice, ticket survives) → `DD boundary re-derived after Tier 3 sliced L<n> by
  <vol> lot: ...`

**Row D-6 is the gap I found at Gate 3.** A Tier 3 slice passes through neither structural
chokepoint — the ticket lives, the level count is unchanged — so it needed its own hook. If that
line does **not** appear after a slice, the boundary is using pre-slice lots and the cap is
quietly **wider** than you set. Tell me immediately if it's missing.

---

# WHAT I VERIFY BY INSPECTION (you don't need to test these)

Rows **B-5** (200-level bound), **B-7** (volume clamp), **B-8** (Guard C, already verified in
three places), **B-9** (martingale), **E-5** (no schema bump), **F-4/F-5/F-6** (tier, ladder and
b24 behaviour unchanged with DDClose off). I'll dispose of these from the code and the b44
comparison, and record the reasoning.

---

# ORDER I RECOMMEND

**Phase 1 today** — seven sub-tests, flat, no risk, and it closes the original defect.
Then Phase 2 when you have a chart you're happy to trade on demo.
Phases 3 and 4 need a live sequence, so they follow naturally.

Send Phase 1's log plus the 1A, 1C and 1G screenshots and I'll audit before you risk anything.
