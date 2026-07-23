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

## Current instance - pre-filled for the NEXT break (E4 Gate 3)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md (expect build E1-b34, aef5dc989609dc45, 4307 lines). Report
aligned in one line, or STOP on mismatch. (No build since E1-b34 - E4 is
still pre-code.)

Then read docs/HANDOVER_2026-07-24_E4_gate2.md and STATE.md. E4 Gate 1
(O1-O5) is locked and Gate 2 (docs/E4_MATRIX.md, rev 1, 36 rows) is SEALED;
Gate 3 (confirmed code plan) is next.

Resume E4 at Gate 3. The matrix is sealed - do NOT re-plan or re-open sealed
rows or locked decisions. Produce the surgical code plan: touch points,
insertion order, each step mapped to its matrix row(s). Expect it SMALL -
reuse CloseSequenceAtMarket for the group close (O5); the re-arm is already
address-based (ComputeRecoveryTrigger max+1, ComputeLevelLot by level) so
C3/H-2 is a confirm not a rewrite. The ONE careful piece is H-6: the SL must
re-anchor to the new lowest survivor when Tier 1 closes the oldest (the SL
anchor). Also resolve the gold default for InpTier1MinProfitPts (plan-time,
O2 rider). One question per message.

This item is reverse-engineered from a reference EA (Shadow) - treat it as
reference, never spec; each point is tagged OBSERVED or CHOSEN in
docs/ENHANCEMENT_INPUT_2026-07-23_tier1.md.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan. Do not touch the MT5 tree
(deploy is my manual step); recompute every money number before any PASS.

Note: E1 is pushed (origin/main @ 864effe); this session's Gate 1/2 docs are
committed locally (ahead of origin, not pushed). Open findings: F3 (guardrail
= matrix X-5), F4 (design note).
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
