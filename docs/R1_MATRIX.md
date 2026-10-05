# E9-R1 SCENARIO MATRIX — Drawdown Auto Close (boundary-SL enforcement)

STATUS: **SEALED rev 3 — rev 1 sealed by Jeff 2026-10-05. B-11 added the same day from a live
finding during the b45 build (a points/pips unit error in the fixture itself); B-12 and B-13 added
for the two b46 projection defects, found by precomputing expected values BEFORE Phase 2 ran.**
Live findings later become NEW rows (rev 2+), never silent fixes (CLAUDE.md §2).

Builds on locked decisions **E9-R1-D1** (per-symbol scope; percent of BALANCE; MIN of the two
positive limits; both-off refuses to arm), **D2** (enforced as an SL PRICE every leg adopts, not
an EA market close; InpStopLossPts concedes), **D3** (boundary derived from the FULL ANTICIPATED
GRID — placed at the level where the budget runs out), **D4** (re-derives on every STRUCTURAL
change), **D5** (pure re-derive — may move either way, including looser), **D6** (the DD boundary
owns the SL outright and overwrites a manual SL while DDClose is on).

Offset convention: **10 POINTS** on the safe side (= 1 pip on GBPJPY, XAUUSD.s, AUDNZD.s,
USDCAD.s alike). Points never pips — locked convention 2026-10-05.

Reference fixture used throughout (Jeff's verified GBPJPY screenshot, arithmetic confirmed in D3):
L1 lot 0.01, interval **370 POINTS** (= 37 pips on a 3-digit pair; the "37" in Jeff's external
pip-denominated tool is 370 in the EA's points-based input - see the 2026-10-05 correction in
STATE.md, found by recomputing this very fixture), Deferred Incremental, step 0.01, defer 2, MaxDDPercent 2,
MaxDDUSD 0, balance ~$1,522, USDJPY ~158.
Grid: L1 208.663/0.01 · L2 208.293/0.01 · L3 207.923/0.02 · L4 207.553/0.02 · L5 207.183/0.03
DD of L1..L4 at 207.183 = −4810.0 JPY = **−$30.44 = exactly 2%**. Boundary = 207.183 + 10 pts
= **207.193**.

---

## GROUP A — ARMING AND CONFIGURATION (the E9-R1 root cause was a silent no-op)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| A-1 | `InpEnableDDClose=false` | Feature fully inert. No boundary computed, no SL written, no DD line on dashboard. b24 manual-SL rule untouched. | **ABSENCE** of any DD log line |
| A-2 | `=true`, pct 2.0, usd 0 | Arms. Logs effective cap **$30.44** (2% of 1522) with the balance and percent that produced it | computed figures, never a bare "armed" |
| A-3 | `=true`, pct 0, usd 150 | Arms on the USD limit alone. Effective cap **$150.00** | log |
| A-4 | `=true`, pct 2.0, usd 20 | **MIN wins** → eff **$20.00** (USD tighter). Log must name BOTH candidates and which won | log |
| A-5 | `=true`, pct 1.0, usd 15.22 | TIE (both $15.22) → eff $15.22, no ordering ambiguity, single arm line | log |
| A-6 | **`=true`, pct 0, usd 0** | **MUST REFUSE TO ARM AND SAY SO LOUDLY** at init (ERROR, not INFO). This is the exact E9-R1 failure: enabled-but-no-cap must be the loudest case, never silent | ERROR line + dashboard warn |
| A-7 | `=true`, pct **negative** | Refuse to arm, log the offending value. A negative cap is meaningless | ERROR |
| A-8 | A-6 state, then trader sets pct>0 mid-sequence | Arms on the input change (D4 includes input edits), boundary derived and written | log + SL appears |
| A-9 | `=true` but `InpEnableRecovery=false` | Still arms. A single L1 with no ladder is a 1-level grid; the cap still applies | log, boundary from L1 alone |

## GROUP B — BOUNDARY DERIVATION FROM THE PROJECTED GRID (D3)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| B-1 | Reference fixture, L1 only open | Projects L1..L5, finds budget exhausted at L5, boundary = **207.193** (207.183 + 10 pts) | log the price AND the level count afforded |
| B-2 | Projected lots | Every projected lot comes from the **sealed `ComputeLevelLot(levelN)`** — 0.01/0.01/0.02/0.02/0.03, total 0.09 | matches screenshot exactly |
| B-3 | **MUST-NOT (highest build risk, D3)** | The projected L-n price **MUST equal the price the engine actually trades to**. Projection and `ComputeRecoveryTrigger` must share ONE interval helper — no second copy of the ladder maths | compare projected L2..L5 against the engine's live trigger as each level actually opens |
| B-4 | `InpMaxRecoveryTrades = 5` | Grid terminates at L5 by the input cap even if budget remains. Boundary = the capped grid's bottom | log names the terminator (cap vs budget) |
| B-5 | `InpMaxRecoveryTrades = 0` (unlimited) | **Budget is the terminator.** Hard iteration bound (propose 200) against pathological settings; if hit, log and refuse to arm rather than guess | log names which terminator fired |
| B-6 | Cap so small that L2 already exceeds it | Boundary lands just below **L1** — a 1-level grid. Must NOT return a price above entry (an instant stop-out) | log + sanity check |
| B-7 | Cap so large the grid would exceed broker volume max | `ComputeLevelLot` already clamps to `SYMBOL_VOLUME_MAX`; the projection must honour the CLAMPED lot, not the raw one | log the clamp |
| B-8 | Guard C (b16) | Projection may ASSUME non-decreasing lots — **verified, not assumed**: enforced at init (4808/4850), at the door (3389), and per level (2374) | inspection, recorded |
| B-9 | Martingale mode, mult 2.0 | Boundary derives correctly on a geometric ladder; budget exhausts far sooner than incremental | recompute by hand |
| B-10 | SELL sequence (dir = −1) | Boundary sits **ABOVE** entries; offset applied in the correct direction | sign correctness |
| **B-11** | **rev 2, added 2026-10-05 from a live finding during the b45 build.** `InpRecoveryIntervalPts` is in **POINTS**, and the reference fixture only reconciles at **370**, not 37 | The projected L2..L5 prices must match the screenshot (208.293 / 207.923 / 207.553 / 207.183) and the DD must total **$30.44**. At 37 the grid comes out 10× tight (L2 208.626) and the DD **$3.04** — wrong by exactly 10× in both price and money, the signature of a points/pips error. Gate 4 must **confirm the live GBPJPY instance reads 370** | recompute + read the live input |
| **B-12** | **rev 3, b46.** Budget runs out BETWEEN two projected levels | Boundary is **solved to the exact price** where DD equals the cap, not snapped to the next level. XAUUSD.s, cap $20, L1 0.01 @ 4000.00, interval 300, Incremental: DD walk $0 / $3 / $12 / $30, so the budget is spent inside the L3-L4 bracket. Must solve to **3992.00** (+10 pts = 3992.10) where the loss is **exactly $20.0000**. b45 snapped to 3991.00 and lost **$30** against a $20 cap | recompute + log |
| **B-13** | **rev 3, b46. MUST-NOT - the one that would have been invisible.** Projected leg entry prices | Each projected leg opens at the price of **its own** level, never the level above. On the GBPJPY fixture the DD at each level price must read **$0 / $2.34 / $7.03 / $16.39 / $30.44**. b45 opened every leg one level too high and read **$4.68 / $14.05 / $28.10 / $49.18** - nearly double - so the boundary sat too CLOSE to price and would have stopped the sequence out EARLY | compare the DD walk against the fixture |

## GROUP C — WRITING THE SL (D2, D6) AND BROKER CONSTRAINTS

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| C-1 | Boundary computed, 4 legs live | **Every** live leg gets the SAME SL price via `PositionModify` | 4 modify confirmations |
| C-2 | `InpStopLossPts = 300` AND DDClose on | **InpStopLossPts CONCEDES** (D2). The DD price wins. Log that it was overridden so it is never a mystery | log |
| C-3 | `InpStopLossPts = 0` (Jeff's usual) | DD boundary becomes the ONLY stop — load-bearing | log |
| C-4 | **Manual SL hand-set LOOSER than the boundary** | DD boundary overwrites it (D6). Cap enforced | log |
| C-5 | **Manual SL hand-set TIGHTER than the boundary** | D6 says the boundary wins, so the EA **LOOSENS the trader's stop**. Must happen AND **LOG LOUDLY** — a silent loosening is unacceptable even when locked. *Jeff accepted this; the row exists so it is visible on evidence, not discovered live* | WARN naming both prices |
| C-6 | Boundary inside broker `SYMBOL_TRADE_STOPS_LEVEL` | Reuse `BrokerStopsLevelPts()` (3533) + the b27 precedent. Clamp to the nearest legal price and log; must NOT spam failed modifies | log the clamp |
| C-7 | `PositionModify` returns false | b42's `TradeTargetLive()` gate applies — do NOT read `Result*()` on a no-send path (E9-Q3). Retry on the next structural change, never silently drop the cap | correct retcode or "not sent" |
| C-8 | Position already carries the exact boundary SL | **Idempotent** — no redundant `PositionModify`, no log spam | ABSENCE of repeat modifies |
| C-9 | DDClose turned OFF mid-sequence | Boundary SLs **remain** on the positions (removing a stop is the one unsafe direction). Log that the EA no longer manages them | log |

## GROUP D — RE-DERIVE ON STRUCTURAL CHANGE (D4, D5)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| D-1 | L2 opens | Re-derive; all legs rewritten to the new boundary | log before/after price |
| D-2 | **New tick, no structural change** | **MUST-NOT: no re-derive, no `PositionModify`, no log.** Re-derive is structural-only, never per-tick | ABSENCE over many ticks |
| D-3 | New bar, no structural change | MUST-NOT re-derive. (Bar-close entry gates LEVELS, not the boundary) | ABSENCE |
| D-4 | Leg manually closed mid-sequence | Re-derive from the **worst SURVIVING** entry (the engine's own anchor), honouring the no-retroactive rule | log |
| D-5 | **Tier 1 (E4) closes legs at a profit** | Re-derive with `realised` credited → `remainingBudget` GROWS → boundary may move **AWAY** from price (D5). Correct, not a bug | log realised P/L AND remaining budget |
| D-6 | **Tier 3 (E6) PARTIAL close** — lots change, ticket survives | Re-derive on the NEW lot total. The partial-slice case is the subtlest trigger | log the new lots |
| D-7 | Tier 2 (E5) fires | Re-derive. All three valve tiers are re-derive triggers | log |
| D-8 | Input edit mid-sequence (pct 2 → 3) | Re-derive on the new cap; boundary moves outward; log the new effective cap | log |
| D-9 | Realised loss already **exceeds** the cap (banked losses) | `remainingBudget <= 0` → boundary at/next to market = close now. Must NOT compute a nonsensical price or divide by zero | log + safe action |
| D-10 | Last leg closes, sequence flat | Boundary state cleared; no stale boundary leaks into the next sequence | ABSENCE on next L1 |

## GROUP E — RESTART AND STATE (mandatory for any stateful feature, Gate 2)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| E-1 | EA restart over a live sequence with boundary set | Boundary **re-derived** from reloaded state; the broker-held SLs already protect the legs meanwhile (the D2 advantage) | log at init |
| E-2 | Restart where the recomputed boundary differs from the one on the positions | Re-derive wins (D5) and rewrites; log both prices | log |
| E-3 | Adopted magic-0 L1 (the E9-Q2 class) | Boundary derived for adopted positions too, or explicitly declines with a reason — must NOT leave an adopted leg silently uncapped | log either way |
| E-4 | UNKNOWN-state record kept by b44's E9-Q2 gate | MUST-NOT write an SL to a ticket MT5 has not confirmed exists (`TradeTargetLive` gate) | ABSENCE |
| E-5 | State file written/reloaded | If the boundary is persisted, the schema version bumps per protocol; if derived-only, confirm nothing new is stored | inspection |

## GROUP F — OBSERVABILITY AND MUST-NOT REGRESSIONS

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| F-1 | Dashboard while armed | Shows the **boundary price** and the **level count it affords** (D3's Gate 2 note) | screenshot |
| F-2 | Dashboard, DDClose off | No DD row — no dead UI | screenshot |
| F-3 | Every log line on fire/re-derive | Carries computed money figures (cap, realised, remaining, price) — never a bare "DD close fired" (observability rule) | log |
| F-4 | **MUST-NOT: tier behaviour unchanged** | E4/E5/E6 dispatcher decisions identical to b44 with DDClose off | A/B against b44 |
| F-5 | **MUST-NOT: recovery ladder unchanged** | `ComputeRecoveryTrigger`/`EvaluateRecovery` place levels exactly as b44 does. The projection must be READ-ONLY with respect to engine state | A/B |
| F-6 | **MUST-NOT: b24 TP/SL asymmetry intact with DDClose OFF** | Manual SL still persists, manual TP still releases, exactly as b24 locks. D6 is scoped to DDClose ON only | A/B |
| F-7 | **MUST-NOT: no new per-tick cost** | Projection runs on structural change only; no measurable OnTick overhead | D-2 absence + inspection |
| F-8 | README | Beginner-audience section; the E9-R1 "you did not have a loss cap" warning REPLACED with the shipped behaviour | diff |

---

## OPEN ITEMS — RESOLVED AT SEAL (Jeff sealed rev 1 without redirecting them, so the stated
## recommendations carried. Each is now BINDING on Gate 3.)

1. **B-5 iteration bound = 200 levels.** With `InpMaxRecoveryTrades = 0` the budget is the
   terminator; 200 is a pathological-settings backstop. If hit, **refuse to arm and log** —
   never silently truncate, because a truncated grid places the boundary at a price the engine
   would trade straight through.
2. **Offset = CONSTANT 10 points, not a fourth input.** R1 already adds three inputs and the
   Stage 1 convention froze the dialog layout. 10 points = 1 pip on every symbol in use.
3. **C-5 stands as locked (D6).** The DD boundary overwrites a tighter manual SL, with a loud
   WARN naming both prices, so it is revisited on evidence rather than discovered live.
4. **Boundary is DERIVED-ONLY, never persisted.** No state-file schema bump, so b44's v5 schema
   is untouched. D4 re-derives at init anyway (row E-1) and the broker-held SL protects the legs
   across a restart (the D2 advantage) — persisting it would add a stale-value hazard for no gain.

## COVERAGE NOTE

54 rows across 6 groups (B-11 at rev 2; B-12 and B-13 at rev 3). 13 are MUST-NOT / absence-type rows (A-1, B-3, C-8, D-2, D-3, D-10,
E-4, F-2, F-4, F-5, F-6, F-7) — what must stay unchanged is tested, not assumed. Restart rows
are mandatory and present (Group E). Every locked decision D1–D6 has at least one row that
would fail if the decision were implemented backwards.
