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

## Current instance - pre-filled for the NEXT break (E6-b38 SEALED; E8 unblocked at Gate 1)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md (expect build E6-b38, f7766c859e4d3c7a, 4674 lines). Repo and
runtime are ALIGNED and SEALED - report "repo and runtime aligned at E6-b38,
sealed" in one line. A mismatch on EITHER side is a real STOP.

Then read docs/HANDOVER_2026-07-26_E6_b38_sealed.md and STATE.md. E1, E4, E5
and E6 are ALL SEALED (do NOT re-open). The three drawdown-reduction valves
now stack: T2 percent -> T1 points -> T3 partial slice, one fire per tick,
all default OFF. E6 sealed 2026-07-26 on ten XAUUSD.s tester runs / 19 Tier 3
fires, every money number recomputed to the cent on two derivations.

Open E8's Gate 1 (profit-funded follow-on slice - my idea, spun out of E6's
T3-O6). It was gated on E6 landing; E6 has landed. Work its open sub-decisions
ONE at a time, starting with the most foundational. E8 is a DIRECTIONAL
TAIL-RISK lever (it realizes a loss against the recovery thesis), so the risk
framing is the first thing to lock, not the mechanics. Do NOT start a matrix
before the decisions are locked.

E8 derives from the same reference EA (Shadow) as E6 - treat it as reference,
never spec; each point is tagged OBSERVED or CHOSEN in
docs/ENHANCEMENT_INPUT_*.md.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan; no matrix before locked
decisions. Do not touch the MT5 tree (deploy is my manual step); recompute
every money number before any PASS.

Carried forward from the E6 seal (none block it, all in handover section 5):
(1) STALE COMMENT - EvaluateBasketClose header TRTM.mq5:2300-2308 still says
"Tier 2 FIRST, then Tier 1" / "Both share ONE group"; three tiers now. Left
unfixed deliberately - a comment-only edit re-bumps the manifest sha and would
break the seal's build identity. Bundle with the NEXT build.
(2) RUN H (T3-K1/K2) was NOT run - closed by inheritance on my call. Never
exercised against an ACTUAL sliced anchor across a restart/kill, the one state
E4/E5 could not produce. Run it before any live deployment; a defect would
surface as a mis-rebuilt level or lost baseLot on the first restart after a
Tier 3 fire.
(3) T3-DS1 dashboard never visually confirmed (display-only, no money path).

Note: E6-b38 code is COMMITTED + PUSHED (8722fcc, origin/main), but the E6
VERIFICATION DOCS (docs/E6_VERIFY_CHECKLIST.md, the sealed handover, STATE.md's
seal entries) and the ten tests/2026.07.26 *.txt logs are UNCOMMITTED - my call
whether to commit. E8 is the only parked item that E6 unblocked; E2 draggable
exit lines and E3 auto-entry remain in the backlog. Open findings: F3
(impossible in TRTM - empty OnTradeTransaction), F4 (design note), F5 (E5
evidence-only, resolved).
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
