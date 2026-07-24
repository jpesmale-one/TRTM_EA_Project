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

## Current instance - pre-filled for the NEXT break (E4 SEALED; next item TBD)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md (expect build E4-b36, 7e14479c83d672a4, 4483 lines). Report
aligned in one line, or STOP on mismatch.

Then read docs/HANDOVER_2026-07-24_E4_b36_sealed.md and STATE.md. E4
(Drawdown Reduction Tier 1) is SEALED and CLOSED at E4-b36 (matrix rev 2,
37 rows). Do NOT re-open it.

Start the NEXT backlog item at Gate 1 (locked decisions). Backlog, none
started: E2 draggable exit lines; E3 auto-entry; E5/E6 (Tier 2 percent /
Tier 3 partial-lot) which need E7 R1/R2 reference runs FIRST; E7 is research
not a build. Tell me which item to open; then work its open sub-decisions
ONE at a time, most foundational first. No matrix before locked decisions;
no code before a confirmed plan.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. Do not touch the MT5 tree (deploy is my manual step);
recompute every money number before any PASS.

Note: E4-b36 committed locally, NOT pushed to origin (my call when to push).
E1 pushed (origin/main @ 864effe). Open findings: none blocking (F3 closed
= matrix X-5 verified; F4 design note). If the next item derives from the
Shadow reference EA, treat it as reference never spec (OBSERVED/CHOSEN tags
in docs/ENHANCEMENT_INPUT_*.md).
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
