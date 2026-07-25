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

## Current instance - pre-filled for the NEXT break (E5 SEALED E5-b37; no item in-flight)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md. BOTH the repo src AND the MT5 runtime copy must now be build
E5-b37, 73dda148c79f1b27, 4568 lines (E5-b37 was compiled + deployed +
SEALED 2026-07-25, so runtime == repo). Report aligned in one line, or STOP
on a REPO-vs-manifest mismatch.

Then read docs/HANDOVER_2026-07-25_E5_b37_sealed.md and STATE.md. E1, E4,
and E5 are ALL SEALED/CLOSED (do NOT re-open). The core loop + Drawdown
Reduction Tier 1 (E4) and Tier 2 (E5) are done. Nothing is mid-pipeline.

Pick the NEXT enhancement-backlog item and open its Gate 1, working its open
sub-decisions ONE at a time, most foundational first (ask me which item if
unsure - one question, your rec). Remaining backlog:
  E2 - Stage 8 Step 2: draggable EXIT (SL/TP) lines LIVE (money-path UX).
  E3 - Stage 9 Step 3: auto-entry stub (MQL_TESTER-gated; optimization infra).
  E6 - Drawdown Reduction Tier 3 (partial-lot close) - needs an E7 R2
       reference run FIRST (ZERO observed behavior so far).
  E7 - reference-EA behavior capture (research, no gates: R2 Tier 3, R5 BE;
       R3 buy-seq de-prioritized).

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan; no matrix before locked
decisions. Do not touch the MT5 tree (deploy is my manual step); recompute
every money number before any PASS.

If the picked item derives from the reference EA (Shadow - E6/E7 do; E2/E3
do NOT): treat it as reference, never spec; each point is tagged OBSERVED or
CHOSEN in docs/ENHANCEMENT_INPUT_*.md.

Note: E5-b37 is UNCOMMITTED (I test before commit - my call); E4-b36
committed locally, NOT pushed; E1 pushed (origin/main @ 864effe). Open
findings: F5 (sealed-matrix reference-precedence arithmetic error - ANNOTATED
in E5_MATRIX + STATE.md T2-O4 + findings; evidence-only, decision unchanged,
resolved by live PR evidence this session); F3/F4 unchanged design notes.
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
