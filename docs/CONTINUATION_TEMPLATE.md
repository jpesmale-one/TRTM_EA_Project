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

## Current instance - pre-filled for the NEXT break (b39 SEALED with caveat; Run H next)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md (expect build b40, 2e902e9032d820a9, 4974 lines). Repo and
runtime are ALIGNED and DEPLOYED - report "repo and runtime aligned at b40"
in one line. A mismatch on EITHER side is a real STOP.

Then read docs/HANDOVER_2026-07-30_b39_sealed.md and STATE.md. E1, E4, E5, E6
and b39 are ALL SEALED (do NOT re-open). b40 changed COMMENTS ONLY - proven by
a filtered diff showing exactly one non-comment line changed (the build tag) -
so every b39 evidence row carries forward unchanged. The three drawdown-
reduction valves stack T2 percent -> T1 points -> T3 partial slice, one fire
per tick, all default OFF.

b39 (async-fill registration hotfix) is SEALED WITH ONE EXPLICIT CAVEAT, and
you must not lose it: A-1 and W-1..W-6 closed on CODE INSPECTION, NOT evidence.
WatchUntrackedLevels has NEVER adopted a position in any run. On Vantage the
TRADE_RETCODE_PLACED signature is ROUTINE (reproduced live) but the fill lands
within the tick, so the fast path never missed. The registration MISS is a
TIMING TAIL, not reproducible on demand, and the Cent account is LIVE MONEY -
we are not chasing it there. It is PARKED, not abandoned: if it recurs the
journal is the reproduction. "order accepted but no position yet" ->
"Watcher: L<n> REGISTERED" -> "Exits applied" closes the rows on live evidence
and RETIRES the caveat; an orphan with NO watcher line is a b39 DEFECT -
capture the log and reopen. Do NOT quietly mark those rows verified.

TOP PRIORITY THIS SESSION is RUN H, unless I say otherwise. Run H is T3-K1/K2
against an ACTUAL SLICED ANCHOR, ON VANTAGE - overdue since the E6 seal (closed
by INHERITANCE there, never exercised) and now doubly so because b39 REWROTE
the sequence-rebuild code it exercises. It also carries K-4: confirm empirically
whether Vantage preserves position comments across a PARTIAL CLOSE. A rewrite
there would make L-2/L-3 ACTIVE rather than defensive and escalate E9-O6.
Note the constraint learned the hard way: tester inputs LOCK once a run starts
and a tester restart REPLAYS from the beginning, so any restart-with-open-
positions row MUST be run on a LIVE chart (remove EA -> re-attach), not the
tester.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan; no matrix before locked
decisions. Do not touch the MT5 tree (deploy is my manual step); recompute
every money number before any PASS.

Also carried forward:
(1) NOT PUSHED - origin/main is at 8722fcc; SIX commits are local-only
(oldest first): 37daf7e E6-b38 seal, 09a0d77 b39 Gate 1+2, aed4b26 b39 seal
+ evidence, 68009ed b39 handover + continuation, d22cb44 b40 docs build,
704761d handover realign. Verify with `git log --oneline 8722fcc..HEAD`.
Pushing is my call, ask before doing it.
(2) MAINTENANCE HAZARD from b39: AdoptionCandidateExists duplicates TryAdopt's
admission logic and MUST be kept in step. Deliberately not unified inside a
hotfix (it would re-open sealed Stage 2 code with one-shot logging side
effects). -> E9.
(3) STILL OPEN ON INSPECTION besides the watcher: L-1..L-4 (unreachable without
a DELIBERATELY corrupted comment - decide before any future seal whether those
close on evidence or inspection) and F-1..F-5 (flat-state rebuild never
triggered in any run).
(4) T3-DS1 dashboard never visually confirmed (display-only, no money path).
(5) E9 now holds: O3 filling-mode negotiation, O4 netting guard (TRTM is
structurally HEDGING-ONLY with NO guard today), O5 execution-mode init
guidance, O6 comment-integrity detection, PLUS b39's deferrals - E9-O2e
(never-filled timeout), W-7 (account-scoped identity), and item (2).
(6) E8 (profit-funded follow-on slice) unblocked since E6, own Gate 1 pending,
never opened. E2 draggable exit lines, E3 auto-entry still in the backlog.
Open findings: F3 (impossible in TRTM - empty OnTradeTransaction), F4 (design
note), F5 (E5 evidence-only, resolved).
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
