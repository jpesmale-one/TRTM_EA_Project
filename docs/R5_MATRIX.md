# E9-R3-B SCENARIO MATRIX — one projected-stop derivation (b56)

STATUS: **SEALED rev 1 — sealed by Jeff 2026-10-16.** Live findings later become NEW rows
(rev 2+), never silent fixes (CLAUDE.md §2).
Gate 1: **Option A approved by Jeff 2026-10-16** — extract ONE pure helper,
`ProjectedStopPrice()`, mirroring `EnforceExits`' ladder, consumed by all three callers.

> **THE RULE, ONE SENTENCE:** *a projection must price the stop the enforce pass would actually
> write* — not "the boundary", not "the manual value", but the OUTCOME of the same ladder.

## THE TWO DEFECTS THIS CLOSES

**E9-R3-B (Jeff, 2026-10-16, dashboard screenshot).** Panel showed `SL 210.479` (BE floor, +30
pts, in profit) and `Proj at SL -52.16` on the same frame. Recomputed: the true figure is
**+$0.19**; −52.16 is the loss at the **boundary** 202.206. Two sites do an *unconditional*
boundary overwrite — `LogStructure` `:2752` and `PanelRefresh` `:5129` — and the log proves the
engine-side twin is live too: *"projected at TP +3.80 | at SL -52.16"*.
**Root cause is a comment D20 made false.** `:5129` reads *"display what the broker actually
holds (D2/D6)"*. Under D6 the boundary ALWAYS won, so it always WAS the held stop. D20 made it
win only when tighter; the line still overwrites unconditionally.

**THE BE-FLOOR GAP (found by surveying for the fix, CONFIRMED BY INSPECTION).** Neither display
ladder applies the BE floor at all. `BEStopPrice` appears **zero** times in both
(`:5085`–`:5135` and `:2730`–`:2760`); the floor merges at exactly ONE line, `:1635` inside
`ApplyProtectiveEngines`, which only `EnforceExits` calls. **This predates D20 and b48/D9.** It
stayed invisible because the unconditional boundary overwrite masked it whenever the cap was
armed — a wrong value concealing an older wrong value.

> **WHY THE CURRENT LIVE RUN CANNOT PROVE THE BE GAP.** With the cap ARMED, `:5129` runs last and
> wins, so BOTH defects point at the same wrong number. Separating them needs
> `InpEnableDDClose = false` with BE armed. The gap is **inspection-proven, not log-proven**, and
> row A-4 below owes that evidence before b56 claims it.

---

## GROUP A — THE HELPER AND WHAT IT MUST RETURN

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| A-1 | **THE JEFF CASE** — BE floor tighter than an armed boundary | `Proj at SL` prices the **floor**. On his sequence: **+$0.19**, not −52.16 | panel + recompute |
| A-2 | Boundary tighter than every other owner | `Proj at SL` prices the **boundary**. b48/D9's original fix must NOT regress — understating a loss is the wrong way to err | recompute vs the applied SL |
| A-3 | Owned manual SL, cap armed, manual tighter | Prices the **manual stop** (D20 keeps it) | log + recompute |
| A-4 | **THE OWED ROW: BE armed, `InpEnableDDClose = false`** | Prices the **BE floor**. Inspection-proven today; this row needs a LIVE log, because the cap-armed path masks it | panel with the cap OFF |
| A-5 | Trailing active | Prices the **live broker ratchet**, as the sealed `:5108` branch already does | unchanged from b55 |
| A-6 | **MUST-NOT: the helper is PURE** | No writes, no state change, no logging. Three callers invoke it per refresh/structure-log; a side effect would fire three times | body scan, as done for `DDBoundaryPrice` |
| A-7 | **MUST-NOT: the engine does not consume it** | `EnforceExits` keeps its own in-line ladder — it must MUTATE `sl` for the write path, where the helper only REPORTS. Collapsing both into one call is a money-path change and is **out of scope** | inspection |

---

## GROUP B — THE THREE CALLERS AGREE

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| B-1 | Panel and engine log agree | `Proj at SL` (panel) and `at SL` (`LogStructure`) show the **same** figure on the same state. They disagreed before: both wrong, but independently derived | screenshot + log line, same moment |
| B-2 | Both agree with what is **written** | The projected price equals the SL in the next `Exits applied` line | two log lines compared |
| B-3 | **MUST-NOT: no fourth copy** | After b56 exactly ONE derivation of the projected stop exists. The b45/B-3 precedent — *"a second, drifting copy of this maths"* was R1's named biggest risk | grep count of the ladder |

---

## GROUP C — ARITHMETIC (audit to the cent)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| C-1 | Sign is right | A stop in PROFIT projects a **positive** number. The whole defect was a −$52 at a +$0.19 stop | sign checked explicitly |
| C-2 | Multi-level projection | With 2+ legs the figure uses live lots and each leg's own entry, per `ComputeProjection` | recompute per leg |
| C-3 | `Proj at TP` untouched | b56 changes the SL side only. The TP figure must be **byte-identical** to b55 | A/B on the same state |

---

## GROUP D — SEALED INVARIANTS

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| D-1 | **MUST-NOT: no money-path change** | D20, D15, D16-C, M6-2 and the D-9 close are untouched. b56 is a REPORTING build | inspection + A-1 still passes |
| D-2 | **MUST-NOT: single writer** | One `PositionModify` site; the helper writes nothing | grep count = 1 |
| D-3 | **MUST-NOT: schema 5, inputs 62** | No persisted field, no dialog change | counts + self-test |
| D-4 | **MUST-NOT: b48/D9's lesson survives** | The projection must never UNDERSTATE the loss at the stop. A-2 is the regression that proves it | recompute |
| D-5 | Flat sequence | Projection rows read `-`, no helper call, no crash | panel while flat |

---

## COUNTS — reconciled ID by ID

**18 rows across 4 groups** (A 7, B 3, C 3, D 5 = 18).
**7** are MUST-NOT / absence-type: A-6, A-7, B-3, D-1, D-2, D-3, D-4.

## WHAT WOULD MAKE THIS FIX A FALSE PASS
Fixing the panel and leaving `LogStructure` — or vice versa. **B-1 is the row that decides it**:
the two displays must agree *with each other* AND with the applied SL (B-2). Before b56 they
agreed only by accident, because both were wrong in the same direction. Agreement alone is not
correctness; **B-2 is what ties either of them to reality.**
