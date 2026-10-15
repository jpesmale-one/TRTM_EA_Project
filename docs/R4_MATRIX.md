# E9-R3 SCENARIO MATRIX — D20: the boundary takes the SL only when it is TIGHTER (b54)

STATUS: **GATE 2 DRAFT — 2026-10-15. NOT SEALED.** Awaiting Jeff's word.
Gate 1: **D20** (Jeff, 2026-10-15) supersedes **E9-R1-D6** (Jeff, 2026-10-05).

> **JEFF'S RULING, VERBATIM:** *"The user may adjust the SL tigher so I'd go with
> Tighter-of-the-two. But when the structure was changed then the EA should now refer the new SL
> to the AutoDD Close logic and disregard the Manual SL"*

**SCOPE CORRECTED AFTER THE 22:34 EVIDENCE.** D20 was first recorded as manual-SL-vs-boundary.
The log reads *"LOOSER than the **computed** SL 209.292"* — the **BE floor**, not a manual stop.
D6 overwrites **every** SL owner. D20 is therefore: **the boundary takes the SL only when it is
TIGHTER than the stop already in charge, whoever owns it.** That is a correction of Claude's
framing, not a new decision from Jeff — his ruling states which stop wins and never limited
itself to manual stops.

## THE EVIDENCE THIS MATRIX ANSWERS — all from tests/2026.10.15 220429.251.txt

| Time | What D6 did | Risk before | Risk after |
|---|---|---|---|
| 22:09:16 | overwrote a freshly ADOPTED manual SL 204.388 | $30.89 | $52.09 |
| 22:10:07 | overwrote the tighter manual SL 208.489 | **$4.90** | $52.09 |
| 22:31:15 | re-overwrote the **already-owned** 208.489 after an unrelated refusal | $4.90 | $52.11 |
| 22:34:46 | overwrote the **BE floor** 209.292 | **+$0.19 PROFIT** | **−$52.10** |

The cap was **$52.13** throughout. Every replaced stop was inside it. The BE case is a **$52.29
swing** and it also breaks sealed **M6-2** (*"the floor never lowers"*) by 8251 points.

## WHY D20 CANNOT UNDER-ENFORCE THE CAP — the proof, not an assurance

D20 only ever declines to **loosen**. Tightening is always permitted. So:
- BE floor tighter than the boundary → floor wins → the stop sits **in profit** → the cap is
  unreachable, not under-enforced.
- A level opens, the boundary **tightens** (more lots, same budget) → still compared, and if it
  is now tighter than the held stop it **wins**. D4 re-derivation is untouched.
- `InpStopLossPts > 0` computing a stop **farther** than the boundary → boundary is tighter →
  boundary wins. **D2 is preserved exactly**, with no special case.
- A manual stop looser than the boundary → **D16-C refuses it at the classifier**, before it ever
  becomes the held stop. Proven twice on b53 (A-2 at 200.379 and 199.878).

**The one direction that could breach the cap — a held stop looser than the boundary — is
exactly the direction D20 still lets the boundary win.**

---

## GROUP A — THE RESOLUTION (D20 proper)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| A-1 | **THE BE CASE** — BE floor tighter than the boundary | The **floor is KEPT**. The boundary does **not** replace it. Replays 22:34:46 and must invert its outcome | no `REPLACES it` WARN; `Exits applied` carries the floor |
| A-2 | **THE MANUAL CASE** — owned manual SL tighter than the boundary | The **manual stop is KEPT**. Replays 22:09/22:10/22:31 | the adopted price stays on the position across several passes |
| A-3 | **MUST-NOT: the boundary still wins when IT is tighter** | A boundary tighter than the held stop **REPLACES** it, with the existing INFO. This is the cap doing its job and must not regress | `ddtighten` INFO + the boundary is written |
| A-4 | **MUST-NOT: `InpStopLossPts` still concedes (D2)** | A computed stop farther than the boundary is still replaced by the boundary. D20 adds no exception for the input stop | boundary written, D2 WARN/INFO unchanged |
| A-5 | Trail ratchet tighter than the boundary | The **ratchet is KEPT**. Same code path as A-1; the trail owner was never separately handled by D6 either | no `REPLACES it`; the ratchet advances |
| A-6 | **MUST-NOT: the loosening WARN cannot fire for a kept stop** | The `Your stop moves AWAY from price` WARN must be **absent** whenever D20 keeps the tighter stop — saying it while not doing it would be a false claim | absence of that WARN |
| A-7 | Boundary and held stop **equal** (within tolerance) | No write, no log. The existing `tolSLOwn` compare already covers it; D20 must not add a log line to the common case | silence + no `Exits applied` |

---

## GROUP B — THE STRUCTURAL HALF (already built — these are REGRESSION rows)

Jeff's second sentence describes **sealed D16 behaviour**. `ReleaseManualExits` zeroes `manualSL`
at all five structural chokepoints, so after a release the boundary is the sole owner **by
construction**. These rows prove b54 did not disturb that.

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| B-1 | Level **opens** while a tighter manual SL is held | Manual SL **RELEASED**, boundary re-derived for the new structure and **applied**. Jeff's "disregard the Manual SL" | `RELEASED` + new boundary written |
| B-2 | Level **closes** while a tighter manual SL is held | Same at the liveness chokepoint | `RELEASED` + re-derive |
| B-3 | **MUST-NOT: BE floor is NOT released by a structural change** | D16 releases **manual** exits. The BE floor is an **engine** stop and `beApplied` persists — a level add must **not** drop it | `beApplied` still true; floor still held |
| B-4 | Tier 3 slice while a tighter stop is held | Release fires (C-7 hook, b52), boundary re-derives on the new lots | `RELEASED` + re-derive after the slice |
| B-5 | Restart while a tighter manual SL is held | `ReconcileManualExits` classifies it; ownership continues or releases per the sealed M7 rules | log at init |

---

## GROUP C — ARITHMETIC (audit to the cent)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| C-1 | Max loss at the **kept** stop | Recompute from live lots and tick value. Must be **≤ the cap**, which is what makes keeping it safe | recompute vs `EffectiveDDCap()` |
| C-2 | Max loss at a **kept BE floor** | Must be a **profit or zero loss**. The 22:34 case recomputed: +$0.19 at 209.292 | recompute, sign checked |
| C-3 | The **tighter-of-two** comparison is direction-correct | BUY: higher price is tighter. SELL: lower price is tighter. `ProtectiveSL`'s existing convention | one BUY and one SELL case |
| C-4 | D15 deadband threshold unchanged | The deadband still gates the **write** and its figure still recomputes as `travel × 0.5%` | log figure vs recomputation |

---

## GROUP D — SEALED INVARIANTS (must not move)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| D-1 | **MUST-NOT: D16-C still refuses a looser manual SL** | **THE LOAD-BEARING ROW.** Once D6's blanket overwrite is gone, D16-C is the **only** thing between a hand edit and a widened cap. Proven on b53 (A-2) and must not regress | `REFUSED` WARN at two prices |
| D-2 | **MUST-NOT: M6-2 holds — the floor never lowers** | A manual SL at/below the BE floor is still REFUSED. D20 **restores** this invariant, which D6 was breaking | `REFUSED - at/below BE floor` |
| D-3 | **MUST-NOT: D5 unchanged** | The EA's **own** re-derivation may still loosen the boundary after a profitable tier close. That is the boundary moving against **itself**, never against another owner, so it never reaches D20's comparison | tier-close event, boundary loosens, no refusal |
| D-4 | **MUST-NOT: D11 formula untouched** | `DDBoundaryPrice` is not edited. D20 changes **which of two prices wins**, never how either is computed | inspection + boundary recompute |
| D-5 | **MUST-NOT: single writer** | `EnforceExits` remains the only TP/SL writer — exactly one `PositionModify` call site | grep count = 1 |
| D-6 | **MUST-NOT: no new input, schema unchanged** | Input count stays **62**, schema stays **5** | counts + self-test PASS |
| D-7 | **MUST-NOT: D-9 cap-already-spent close survives** | `remaining <= 0` still closes the sequence at market. D20 is about stop **placement**, not about the spent-budget path | inspection |

---

## GROUP E — CARRIED FROM b53 (owed, not new)

| # | Condition | Required behaviour | Evidence |
|---|---|---|---|
| E-1 | **The row b53's C-3 could not reach** | Manual SL **tighter than the BE floor** while the cap is armed → **ADOPTED**, and the D18 message must name the **FLOOR**, not the boundary. b53's C-3 refused before the adopt branch, so `baseSLisBoundary` was never read | `ADOPTED` naming the floor |
| E-2 | b53 A-4 | `InpStopLossPts > 0` regression — baseline unchanged from b52 | A/B on the same edit |
| E-3 | b53 A-5 | Cap **off** + `InpStopLossPts = 0` stays the C-11/D16-E orphan case | absence of adopt/refuse |
| E-4 | b53 A-6 | Boundary unavailable (no tick value) → no classification, no crash | the `ddmpp` WARN only |

---

## COUNTS — reconciled ID by ID

**23 rows across 4 new groups** (A 7, B 5, C 4, D 7 = 23, reconciled ID by ID). Group E is 4
**carried** b53 rows, excluded from the 23.
**11** are MUST-NOT / absence-type: A-3, A-4, A-6, B-3, D-1, D-2, D-3, D-4, D-5, D-6, D-7.

## WHAT WOULD MAKE THIS FIX A FALSE PASS

Keeping the tighter stop and calling it done. **D-1 is the row that decides safety**: with D6's
blanket overwrite removed, D16-C is the sole barrier against a hand-widened cap. If D-1 ever
regresses, D20 converts a cosmetic defect into a real one. **A-3 is its twin** — the boundary
must still win when it is genuinely tighter, or the cap stops tightening as the grid deepens,
which is the whole point of D11.
