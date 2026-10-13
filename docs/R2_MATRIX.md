# E9-R2 SCENARIO MATRIX — boundary stability (R2-A) + manual-exit lifecycle (R2-B)

STATUS: **SEALED rev 1 — sealed by Jeff 2026-10-13.** Live findings later become NEW rows (rev 2+), never silent fixes (CLAUDE.md §2).
Target build: **b52**, one build carrying both defects (Jeff's call: *"we may address these issues
1 by 1 but let's put them on the same version as it was observed simultaneously"*).

Builds on locked decisions **E9-R2-D15** (deadband sized as a percentage of the remaining budget,
converted to points at the live lots) and **E9-R2-D16** (manual exits adopted → honoured →
released on structural change → re-adopted; symmetric for TP and SL; **D16-C** manual SL tighter
only; **D16-D** the EA's own re-derivation may loosen; **D16-E** orphaned stop is left in place and
announced).

> **D16 REVERSES SEALED b24 BEHAVIOUR.** b24 locked manual SL as *persisting* across structure
> changes. D16 makes TP and SL symmetric. This matrix must therefore verify the NEW behaviour **and
> prove the old rationale is not silently violated** — rows F-1..F-4.

---

## THE INSTRUMENT RULE FOR THIS MATRIX — read before running anything

**Every money-formula row is verified on a CROSS-QUOTED instrument** (GBPJPY.s, USDCAD.s,
AUDCAD.s or GBPCHF.s), **not XAUUSD.s**.

That is the whole lesson of E9-R2. Every E9-R1 row was verified on gold, whose
`SYMBOL_TRADE_TICK_VALUE` is **constant** on a USD account. D-2/D-3 passed *by absence* over 17
real minutes — a true result that was **symbol-specific without saying so**. The defect needed an
instrument where a broker-supplied value drifts, and the matrix contained none.

**Standing rule for all future matrices:** when a money formula reads a broker-supplied value, the
matrix needs a row for an instrument where that value is **not constant**.

---

## GROUP A — THE DEADBAND ITSELF (D15)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| A-1 | Threshold arithmetic, GBPJPY L1 phase | `thresholdPts = (remaining × 0.005)/(mpp × liveLots)`. At remaining $47.11, mpp 0.6305, lots 0.02 → **18.7 pts**. Recompute from the log's own cap and lots | log the threshold alongside the boundary |
| A-2 | **THE REPLAY — the row that defines success** | On a sequence comparable to ticket 2994752430, the observed 18-pt drift must produce **ONE** SL write, not ~1100 | count `Exits applied` per ticket over ≥2h |
| A-3 | Threshold tightens with depth | L1 0.02 lots → 18.7 pts; L2 0.04 lots → **9.3 pts**. The deadband narrows as the grid deepens, same direction D11 moves the boundary | two thresholds logged, recomputed |
| A-4 | Drift **exceeding** the threshold | A genuine >0.5%-of-cap boundary move **DOES** write. The deadband suppresses noise, never a real move | log the old/new boundary and the delta |
| A-5 | **MUST-NOT: cap slip bounded** | Realised loss at the held stop never exceeds cap + 0.5%. On a $47.11 cap that is **$0.24** | recompute loss at the stop actually held |
| A-6 | XAUUSD regression (constant tick value) | Gold must behave **exactly as b51 did** — D-2/D-3 still pass by absence. The deadband must not change a symbol that never drifted | A/B against a b51 gold run |
| A-7 | **MUST-NOT: no new SL owner** | The deadband gates the **write**, not the value. `DDBoundaryPrice` output is unchanged; D11's formula is untouched | filtered diff + recompute |
| A-8 | Structural change **inside** the deadband | A level opens and the new boundary is within the threshold → the boundary is still **re-derived and announced** (D4), the SL simply is not rewritten | announcement present, no modify |
| A-9 | First write of a sequence | With no SL yet on the position, the first boundary is written **unconditionally** — a deadband against "nothing" must not suppress initial placement | SL appears on L1 |
| A-10 | Deadband vs the broker min-distance gate | A held stop inside `SYMBOL_TRADE_STOPS_LEVEL` still defers through the sealed path; the deadband must not bypass or duplicate that gate | log, no failed modifies |

---

## GROUP B — ADOPTION CLASSIFIES PRE-EXISTING EXITS (D16 step 1, the R2-B root fix)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| B-1 | **THE GBPJPY CASE** — adopt a position carrying a trader TP | TP recorded as `manualTP` **at adoption**, ticket marked armed, `lastAppliedTP` seeded. Compare: b51 recorded it **nowhere** | log the classification at the adoption line |
| B-2 | Adopt a position carrying a trader SL | Same, SL side — **subject to D16-C** (see C-3) | log |
| B-3 | Adopt a position carrying **both** | Both classified **independently**. *The GBPJPY position had a trader TP (210.132) and an EA-derived SL (205.722) — different owners on one ticket, so they must not be classified as a unit* | log both |
| B-4 | Adopt a position carrying **neither** (0/0) | Nothing classified; computed values applied. **b51 behaviour unchanged** — this is the common case and must not regress | log |
| B-5 | **MUST-NOT: the 10-hour misattribution cannot recur** | After B-1, a later structural change must **NOT** produce `Manual TP … ADOPTED` for a value that was present at adoption | **ABSENCE** across the whole sequence |
| B-6 | Adopted value equals the computed target | A pre-existing TP that happens to match the computed value is **not** manual ownership — nothing to own | no spurious adoption |
| B-7 | Untagged (MMT) adoption path | Classification applies to the untagged fallback too, not only the tagged path | log |
| B-8 | **MUST-NOT: `lastApplied` seeding cannot defeat b25** | Seeding at adoption must not make a genuine later trader edit invisible to the b25 discriminator | a real edit after adoption is still detected |

---

## GROUP C — THE RELEASE LIFECYCLE (D16 steps 2–4)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| C-1 | Level **opens** → release both | Manual TP **and** SL released; computed AvgTP and the boundary/computed SL take over | `RELEASED` ×2, then the new values written |
| C-2 | Level **closes** → release both | Same at the liveness chokepoint | log |
| C-3 | **D16-C: manual SL looser than the boundary** | **REFUSED**, loud WARN naming both prices. Honouring it would breach the declared cap — *the cap is sacred* | WARN + boundary holds |
| C-4 | **D16-C: manual SL tighter than the boundary** | **ADOPTED** and honoured until the next structural change | log + the stop is written |
| C-5 | **D16-D: tier close loosens the boundary** | The EA's **own** re-derivation may loosen. Verified against the sealed D-5 event: loss at boundary −$206.62, realised **+$8.24**, total **−$198.38** vs a $200 cap — **inside** | log realised + remaining; recompute total exposure |
| C-6 | Re-adoption after release | Trader edits again post-release → adopted again → released at the **next** level. The cycle repeats | two full cycles in one sequence |
| C-7 | **Tier 3 slice — the hook that does not exist** | A slice fires `AnnounceDDBoundary` but **no** `ReleaseManualTP`. Lots change, so the manual exit is stale and must release. **New hook required** | `RELEASED` after a slice |
| C-8 | **ORDERING: release must not be re-adopted on the same tick** | *This is the b51 failure mechanism.* Releases fire in `WatchUntrackedLevels`/`CheckSequenceLiveness` **before** `EnforceExits`, where `DetectManualExitEdits` re-adopts the stale broker value. The fix must survive this ordering | **ABSENCE** of adopt-after-release in one tick |
| C-9 | **ORDERING: `EvaluateBasketClose` runs AFTER `EnforceExits`** | A tier release therefore cannot be seen until the next tick. Must not leave a one-tick window where the stale manual value is re-applied | log across the fire tick and the next |
| C-10 | Trail-arm release | Existing b24 trail-arm release still fires, now for **both** exits | log |
| C-11 | **D16-E: orphan — no engine claims the stop** | `InpStopLossPts = 0` and DD off → release, **leave the stop**, announce it. Never strip a working stop | WARN + the SL still on the position |
| C-12 | Death-window release (restart) | `ReconcileManualExits`' existing release path extended to the SL side | log at init |

---

## GROUP D — GUARDS RETAINED (every one sealed; D16 must not weaken any)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| D-1 | Post-BE looser SL | Still **REFUSED** (M6-2: the floor never lowers) | WARN |
| D-2 | Conflicting values across tickets in one pass | Still adopts **NONE**, reverts all (M4-1) | WARN |
| D-3 | Removal (→ 0) | Still **never** adopted (D3/M1) | WARN + revert |
| D-4 | Widening manual SL (DD off) | Still adopted **with** the money-figure WARN | WARN with the recomputed figure |
| D-5 | Trailing active | Trail ratchet still owns the SL; manual TP re-add still removed | unchanged from b51 |

---

## GROUP E — INTERACTION AND REGRESSION

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| E-1 | D15 + D16 together | The deadband decides **whether** to write; D16 decides **what**. They compose with no interaction | one sequence exercising both |
| E-2 | **MUST-NOT: single-writer invariant** | `EnforceExits` remains the only TP/SL writer. Neither change adds a writer | inspection + filtered diff |
| E-3 | **MUST-NOT: E9-R1 rows still pass** | The 35 closed R1 rows are unaffected. Spot-check the money-path ones on gold | A/B against b51 |
| E-4 | **MUST-NOT: schema unchanged** | No new persisted field; schema stays **5**. A bump **discards** the state file | self-test PASS + inspection |
| E-5 | Restart over a classified sequence | Manual ownership classified at adoption survives a restart via the existing persisted fields | log at init |
| E-6 | **MUST-NOT: no new input** | Both thresholds are constants (`DD_RESTEP_PCT`). Stage 1's dialog layout stays frozen | input count 62 before and after |

---

## GROUP F — THE b24 REVERSAL, VERIFIED HONESTLY

These rows exist because D16 **overturns a sealed decision**. They check the reversal is complete
and that b24's original concern is addressed rather than ignored.

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| F-1 | b24's rationale was "the trader's risk statement" | After release, the stop is governed by an **engine**, never left ungoverned — except the announced D16-E orphan case | log shows the successor owner by name |
| F-2 | **MUST-NOT: a release never widens risk silently** | If the successor stop is **looser** than the released manual SL, that must be stated with the money delta | WARN naming both prices and the figure |
| F-3 | Comment/doc integrity | The `SequenceState.manualSL` field comment and `ReleaseManualTP`'s header both still claim SL **persists**. Both must be corrected, or the code contradicts its own documentation | diff |
| F-4 | README | The manual-exit section describes the **new** symmetric lifecycle | diff |

---

## SUMMARY

**45 rows across 6 groups** (A 10, B 8, C 12, D 5, E 6, F 4 — reconciled ID by ID).
**16** are MUST-NOT / absence-type: A-5, A-6, A-7, B-4, B-5, B-8, C-8, C-9, D-1, D-2, D-3, E-2,
E-3, E-4, E-6, F-2.

**The three rows that matter most**, by the evidence that produced this matrix:

- **A-2** — the replay. ~1100 writes must become 1. Everything else in Group A supports this.
- **C-8** — the ordering trap. This is the *actual* b51 failure mechanism: the release fired and
  was immediately defeated by `DetectManualExitEdits` on the same tick.
- **C-5 / D16-D** — the distinction Jeff raised unprompted. Manual edits may only tighten; the
  EA's own re-derivation may loosen, because a tier close genuinely frees budget. Already verified
  arithmetically against the sealed D-5 event; this row confirms it live.

**Known gap, stated up front:** C-7 requires a **new** `ReleaseManualTP` hook in `SliceLegAtMarket`
— the slice currently announces the boundary but releases nothing. That is a code addition, not
just a behaviour change, and it is the same shape as the D-6 gap found at Gate 3 of E9-R1.
