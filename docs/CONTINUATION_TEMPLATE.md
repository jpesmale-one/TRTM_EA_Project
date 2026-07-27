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

## Current instance - pre-filled for the NEXT break (E6-b38 SEALED; b39 hotfix at Gate 2->3)

```
Resume TRTM. Run the section 0 resume protocol FIRST: git status +
sha256_16 + wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared
to STATE.md (expect build E6-b38, f7766c859e4d3c7a, 4674 lines). Repo and
runtime are ALIGNED and SEALED - report "repo and runtime aligned at E6-b38,
sealed" in one line. A mismatch on EITHER side is a real STOP.

Then read docs/HANDOVER_2026-07-26_E6_b38_sealed.md, docs/B39_MATRIX.md and
STATE.md. E1, E4, E5 and E6 are ALL SEALED (do NOT re-open). The three
drawdown-reduction valves stack T2 percent -> T1 points -> T3 partial slice,
one fire per tick, all default OFF.

TOP PRIORITY THIS SESSION is b39, NOT E8. b39 is the async-fill registration
hotfix for a LIVE incident on Vantage XAUUSD.sc (2026-07-27): the broker
answers "order accepted" BEFORE executing (TRADE_RETCODE_PLACED, price 0.00,
deal 0), so no position exists when the EA looks for one, and a recovery level
went UNMANAGED - no TP, no SL, invisible to liveness, with the EA about to
open a duplicate every M5 bar. NOT an E6 defect: the affected code is Stage 4/5
CORE, latent since Stage 4, exposed only by an asynchronous-fill broker.

b39 is MID-PIPELINE: Gate 1 LOCKED (E9-S1, O1/O2, O2a-O2e, note N1 - all in
STATE.md's locked-decisions log), Gate 2 SEALED (docs/B39_MATRIX.md rev 1,
7 groups / 29 rows). Resume at GATE 3: draft the code plan from the sealed
matrix. Do NOT re-plan sealed rows.

Watch these three when planning:
- L-3 is a hazard in the SEALED b38 TODAY, independent of Vantage:
  RebuildLiveMap 2488 assigns lvl=0 on an unparseable comment and
  FormBasketGroup picks the LOWEST level as anchor, so an unidentified
  position inherits both the SL anchoring and Tier 3's slice target.
- R-1/R-2 are the real risk: b39 touches CORE REGISTRATION, which every
  sealed enhancement sits on. Diff against the E6 Run A
  (tests/2026.07.26 125653.086.txt) and Run C (130728.662.txt) logs to prove
  a synchronous-fill broker behaves exactly as b38.
- Run H (T3-K1/K2) rides on b39 and must run on VANTAGE, not just the Doo
  demo - it was closed by inheritance at the E6 seal and never exercised
  against an actual sliced anchor, and b39 rewrites the sequence-rebuild code.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-
decisions log. No code before a confirmed plan; no matrix before locked
decisions. Do not touch the MT5 tree (deploy is my manual step); recompute
every money number before any PASS.

Also carried forward:
(1) STALE COMMENT - EvaluateBasketClose header TRTM.mq5:2300-2308 still says
"Tier 2 FIRST, then Tier 1" / "Both share ONE group"; three tiers now. Left
unfixed at the E6 seal deliberately (a comment-only edit re-bumps the manifest
sha). BUNDLE IT INTO b39.
(2) T3-DS1 dashboard never visually confirmed (display-only, no money path).
(3) E9 holds the deferred broker-hardening work: O3 filling-mode negotiation,
O4 netting guard (TRTM is structurally HEDGING-ONLY and has NO guard today),
O5 execution-mode init guidance, O6 comment-integrity detection.
(4) E8 (profit-funded follow-on slice) is unblocked by E6 but DEPRIORITISED
behind b39. E2 draggable exit lines, E3 auto-entry still in the backlog.
Open findings: F3 (impossible in TRTM - empty OnTradeTransaction), F4 (design
note), F5 (E5 evidence-only, resolved).
```

> After each future break, replace this "Current instance" block with a
> freshly filled one for the next resume, so the file always carries a
> ready-to-paste prompt.
