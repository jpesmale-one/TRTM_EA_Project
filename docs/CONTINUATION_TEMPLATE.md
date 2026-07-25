# TRTM - Session continuation prompt template

Standard way to resume TRTM after a session break. At each break (when the
handover is written), fill the `{{PLACEHOLDERS}}` below from STATE.md's
header + the handover you just wrote, then paste the filled block as the
FIRST message of the next session.

Keep the fixed scaffolding (resume protocol, gate order, MT5 boundary)
verbatim - it protects against cold-start drift. Only the `{{...}}` change.

---

## Template (copy, fill the placeholders, paste)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md (expect build {{BUILD}}, {{SHA256_16}}, {{LINES}} lines).
Report aligned in one line, or STOP on mismatch.

Then read {{HANDOVER_FILE}} and STATE.md. {{STATUS_LINE}}

{{RESUME_TASK}}

{{REFERENCE_EA_CAVEAT}}

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan; no matrix before locked
decisions. Do not touch the MT5 tree (deploy is my manual step); recompute
every money number before any PASS.

{{OPEN_NOTES}}
```

---

## Placeholder key (where each value comes from)

| Placeholder | Fill from |
|---|---|
| `{{BUILD}}` / `{{SHA256_16}}` / `{{LINES}}` | STATE.md header (`build:` / `sha256_16:` / `lines:`). |
| `{{HANDOVER_FILE}}` | The handover just written, e.g. `docs/HANDOVER_YYYY-MM-DD_<item>_<build>.md`. |
| `{{STATUS_LINE}}` | One line on where things stand, e.g. "E1 sealed; E4 is now unblocked." |
| `{{RESUME_TASK}}` | The concrete next action. Two shapes: **(a) new item** - "Open {{ITEM}}'s Gate 1. Work its open sub-decisions ONE at a time, starting with the most foundational." **(b) resume mid-pipeline** - "Resume {{ITEM}} at Gate {{N}} ({{WHERE}}, e.g. matrix rows Mx-My unsealed / checklist at S-x). Do not re-plan sealed rows." |
| `{{REFERENCE_EA_CAVEAT}}` | Include ONLY if the item derives from a reference EA: "This item is reverse-engineered from a reference EA (Shadow) - treat it as reference, never spec; each point is tagged OBSERVED or CHOSEN in docs/ENHANCEMENT_INPUT_*.md." Otherwise delete the line. |
| `{{OPEN_NOTES}}` | Carry-forwards: unpushed commits, open findings (F-numbers), empirical re-checks flagged in the handover. Delete if none. |

---

## Current instance - pre-filled for the NEXT break (E6-b38 BUILT, pre-compile; mid-pipeline at Gate 3->4)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md. The REPO src must be build E6-b38, f7766c859e4d3c7a, 4674
lines. The MT5 RUNTIME COPY is EXPECTED to still be E5-b37
(73dda148c79f1b27 / 4568): E6-b38 is BUILT but NOT compiled and NOT
deployed. Report "repo aligned at E6-b38; runtime lags at E5-b37 (compile+
deploy pending)" - that is EXPECTED, not a STOP. Only a REPO-vs-manifest
mismatch (repo src != f7766c859e4d3c7a / 4674) is a real STOP.

Then read docs/HANDOVER_2026-07-26_E6_b38_built.md and STATE.md. E1, E4,
E5 are SEALED (do NOT re-open). E6 (Drawdown Reduction Tier 3 - partial-lot
anchor slice) is MID-PIPELINE: Gate 1 LOCKED (T3-O0..O9 + Gate A), matrix
SEALED (docs/E6_MATRIX.md rev 1), plan CONFIRMED
(docs/E6_PLAN_2026-07-26_gate3.md), BUILT E6-b38. Do NOT re-plan sealed rows.

Resume E6 at the GATE 3->4 boundary. My call: compile + deploy + live-test
all happen THIS session. Order: (1) I compile in my terminal (gate zero, 0/0
expected) - if errors, fix src/TRTM.mq5, re-run hygiene, re-bump the manifest;
(2) you draft docs/E6_VERIFY_CHECKLIST.md from the sealed matrix (mirror
E5_VERIFY_CHECKLIST.md) and recompute EVERY money number to the cent; (3) I
deploy, we run Gate 4 on live XAUUSD.s; (4) seal on my explicit word. Key
verify rows: T3-1/T3-2 SELL+BUY fire (slice, sliced-VWAP, margin to the cent);
T3-6 gate-on-SLICE (0.03 anchor -> slice 0.01, full-anchor would fail); T3-SL4
sub-MinLots stand-down; T3-SL5 floor; T3-H3 SL byte-identical across a slice;
T3-PR2/PR3 CONSTRUCTED both-qualify ticks (full tier pre-empts Tier 3 -
UNOBSERVED, verify live); T3-R1/R2/R3 off/never-fire/no-persist.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan; no matrix before locked
decisions. Do not touch the MT5 tree (deploy is my manual step); recompute
every money number before any PASS.

E6 (Tier 3) is reverse-engineered from a reference EA (Shadow) - treat it as
reference, never spec; each point is tagged OBSERVED or CHOSEN in
docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md. The T2->T1->T3 both-qualify
precedence is UNOBSERVED (the tiers never competed) - verify LIVE.

Note: E6-b38 is UNCOMMITTED (I test before commit - my call); E5-b37 committed
locally (d094c65), E4-b36 committed, NONE pushed; E1 pushed (origin/main @
864effe). E8 (profit-funded follow-on slice - my idea) is PARKED with its own
Gate 1, depends on E6. Open findings: F3 (impossible in TRTM - empty
OnTradeTransaction), F4 (design note), F5 (E5 evidence-only, resolved).
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
