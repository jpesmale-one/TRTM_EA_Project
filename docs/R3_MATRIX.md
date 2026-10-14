# E9-R2-C SCENARIO MATRIX — the manual-SL classifier baseline (b53)

STATUS: **SEALED rev 1 — sealed by Jeff 2026-10-14.** Live findings later become NEW rows
(rev 2+), never silent fixes (CLAUDE.md §2).
Gate 1 decisions this verifies: **D17** (baseline = the DD boundary when `InpStopLossPts = 0`
and the cap is armed), **D18** (the widen warning tells the truth in both worlds), **D19**
(one boundary call per detector pass).

THE DEFECT, RE-CONFIRMED IN LIVE SOURCE BEFORE GATE 1 WAS LOCKED:
`src/TRTM.mq5:1882` sets `baseSL = (manualSL > 0) ? manualSL : compSL`; `:1910` gates ALL SL
detection behind `baseSL > 0.0`. With `InpStopLossPts = 0`, `ComputeTargets` sets `sl = 0.0` and
its only assignment is behind `if(InpStopLossPts > 0)` (**verified**, not assumed), so `compSL`
is 0.0, `manualSL` is 0.0, and the gate **short-circuits before examining the edit**. The TP gate
at `:1904` is structurally identical and survives only because `compTP` is non-zero.

> **WHY THIS MATRIX IS SMALL AND WHY THAT IS CORRECT.** D17 changes ONE EXPRESSION. The risk is
> not in the expression — it is in what the new baseline does to the branches DOWNSTREAM that
> were written assuming `baseSL` is a computed SL. Those are rows C-1..C-4 below. Every other row
> exists to prove the fix did not disturb something already sealed.

---

## GROUP A — THE FIX ITSELF (D17)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| A-1 | **THE JEFF CASE** — manual SL dragged TIGHTER, `InpStopLossPts = 0`, cap armed | The edit is **CLASSIFIED**: `Manual SL … ADOPTED`. This is the exact action that produced silence on 2026-10-14 | `ADOPTED` line + the stop is written and held |
| A-2 | Manual SL dragged LOOSER, same config | **REFUSED** by D16-C naming both prices and the cap. *Refusal is a PASS — the defect was neither adopting nor refusing* | `REFUSED` WARN |
| A-3 | **MUST-NOT: silence is impossible** | For any non-zero broker SL differing from the boundary, EXACTLY ONE of `ADOPTED`/`REFUSED` appears. **The absence of BOTH is the defect signature** | absence check on a run with SL edits |
| A-4 | `InpStopLossPts > 0`, cap armed | `compSL` is non-zero, so the baseline is UNCHANGED from b52. **Identical behaviour** — D17 must not touch this path | A/B against b52 on the same edit |
| A-5 | **MUST-NOT: cap off + `InpStopLossPts = 0` stays the ORPHAN case** | `baseSL` stays 0.0, nothing is classified, and the **C-11/D16-E** decision (announce, leave the stop, do not manage it) is untouched. D17 is scoped to `InpEnableDDClose` for exactly this reason | inspection + absence of any adopt/refuse |
| A-6 | Boundary unavailable (tick value missing) | `DDBoundaryPrice` returns 0.0 → baseline falls back to 0.0 → **no classification, and no crash**. Degrades to today's behaviour, never worse | the existing `ddmpp` WARN, no adopt/refuse |

---

## GROUP B — ARITHMETIC (audit to the cent)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| B-1 | The adopted stop's money distance | Recompute max loss at the adopted SL from live lots and tick value. Must be **≤ the declared cap**, since D16-C refused anything looser | recompute vs `EffectiveDDCap()` |
| B-2 | **D18's new INFO figure** | "tighter than the boundary by N points" — N recomputed from the two prices and `_Point`, exact | log N vs recomputation |
| B-3 | Baseline identity under D19 | The consolidated single call must yield the **same** boundary the enforcer uses on that pass. One value, no drift | the `ADOPTED` baseline price vs the `Exits applied` SL basis |

---

## GROUP C — THE DOWNSTREAM BRANCHES (the real risk surface)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| C-1 | **D18: the widen WARN is unreachable in the new config** | With `baseSL` = the boundary, D16-C refuses every looser candidate, so `dir*(baseSL-candSL) > tol` at `:1983` **can never be true**. The new INFO fires instead | the INFO present, the widen WARN absent |
| C-2 | **MUST-NOT: the widen WARN still fires where it should** | On the `InpStopLossPts > 0` path a genuine loosening still produces the money-figure WARN. D18 must not kill a live branch | WARN with the recomputed figure |
| C-3 | **BE floor composes with the new baseline** | `:1884` applies `ProtectiveSL(baseSL, BEStopPrice(), dir)` **on top of** the boundary baseline. VERIFIED: `ProtectiveSL` returns the TIGHTER of the two, so the floor still wins where it is tighter — **no code change needed, but it must be shown** | post-BE edit; b52 D-1 still refuses |
| C-4 | **MUST-NOT: `trailingActive` still suppresses detection** | Both gates carry `!g_state.trailingActive`. D17 changes the baseline, never the guard | absence of adopt/refuse while trailing |
| C-5 | Conflicting SL edits across tickets, new baseline | M4-1 still adopts **NONE** and reverts all, now quoting the boundary as the baseline | conflict WARN naming the boundary |
| C-6 | Removal (→ 0) under the new baseline | `curSL > tol` fails, so removal is **still never adopted** (D3/M1 intact) | WARN + revert |

---

## GROUP D — SEALED INVARIANTS (must not move)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| D-1 | **MUST-NOT: no new input** | Input count stays **62** (verified at b52). D17/D18/D19 add no dialog field | input count before/after |
| D-2 | **MUST-NOT: schema unchanged** | Stays **5**. A bump DISCARDS the state file and loses manual-SL ownership | self-test PASS + `#define` inspection |
| D-3 | **MUST-NOT: single-writer invariant** | `EnforceExits` remains the only TP/SL writer. D19 removes a read, never adds a write | inspection |
| D-4 | **MUST-NOT: `DDBoundaryPrice` stays pure** | D19 depends on purity. Body (4244–4322) has ONE side effect: an `AlreadyLogged`-guarded WARN, idempotent. Must stay that way | inspection of the body |
| D-5 | **MUST-NOT: the b25 discriminator survives** | `g_lastAppliedSL` still vetoes the EA's own stale write. D17 changes `baseSL`, not that clause | no self-adoption across a structural recompute |
| D-6 | **MUST-NOT: b2 fresh-position rule survives** | `HasAppliedExits` still skips 0/0 tickets. Option (c) was rejected precisely to keep this guard | absence on a fresh level |

---

## GROUP E — THE b52 ROWS THIS FIX UNBLOCKS

These are **b52 matrix rows**, not new ones. They are listed because they are unreachable while
E9-R2-C stands — the edit never reaches the classifier, so there is nothing to adopt or refuse.
They carry into b53's Gate 4 and are verified in the same pass.

| b52 row | What it needs | Unblocked by |
|---|---|---|
| **C-3** | manual SL looser than the boundary → REFUSED | A-2 |
| **C-4** | manual SL tighter than the boundary → ADOPTED | A-1 |
| **D-1** | post-BE looser SL still refused | C-3 |
| **D-3** | removal never adopted | C-6 |
| **D-4** | widening manual SL (DD off) with the money WARN | A-5 + C-2 |
| **C-13** | the row added at rev 2 that named this defect | A-3 |

---

## GROUP F — THE RIDE-ALONG DEBTS

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| F-1 | `TFShort()` removed | 5 lines, **zero callers — verified**: one occurrence in the whole file, its own definition at `:4658` | grep count 0 + compile |
| F-2 | EA header carries E9-R1 **and** E9-R2 | Deferred at b51 and again at b52. Third time it ships | header diff |
| F-3 | **WITHDRAWN at Gate 3 — ALREADY SATISFIED IN b52** | Verified in source, not from notes: the `SequenceState.manualSL` comment at `:249` states the b24 "PERSISTS" rule is **RETIRED**, and `ReleaseManualExits`’ header at `:1315` records the supersession. Every other `persist` hit is historical narration, not a live claim. **b52 closed this; the row was drafted against a stale note.** No b53 work | grep `persist` + read `:249` and `:1315` |

---

## COUNTS — reconciled ID by ID

**24 rows across 5 new groups** (A 6, B 3, C 6, D 6, F 3 = 24). Group E is 6 **carried** b52 rows,
not new, so it is excluded from the 24.
**AMENDED AT GATE 3 (2026-10-14): F-3 WITHDRAWN** — verifying it against source showed b52 had
already done it. **23 rows are actionable in b53**; F-3 stays listed, struck, so the record shows
it was checked rather than dropped. Counts re-reconciled ID by ID after the withdrawal.
**11** are MUST-NOT / absence-type: A-3, A-5, C-1, C-2, C-4, D-1, D-2, D-3, D-4, D-5, D-6
(C-1 is an unreachability claim, verified by absence of the WARN).

## WHAT WOULD MAKE THIS FIX A FALSE PASS
Adopting a tighter SL and calling it done. **A-3 is the row that matters**: the defect was not a
wrong decision, it was **no decision at all**. A run that produces neither `ADOPTED` nor `REFUSED`
on a real SL edit is a FAIL even if every other row passes. The same reasoning that located the
defect has to be the thing that proves it gone.
