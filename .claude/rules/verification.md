---
paths:
  - "docs/**"
---

# Verification & evidence rules (loads when working in docs/)

These are the audit rules from CLAUDE.md section 4. They load when
working with matrices, checklists, handovers, and the facts ledger in
`docs/`. The DEFINITION OF DONE (Gate 5) and the "Declare PASS without
recomputing" prohibition stay in CLAUDE.md and always apply.

- Terminal is truth. Live logs and actual fills outrank the code,
  the plan, and your expectations.
- AUDIT TO THE CENT: before declaring any item PASS, recompute every
  number in the pasted log (entries, averages, TP/SL, point deltas,
  money impacts, projections). State the arithmetic. Two real bugs
  were caught this way; a mismatch is a finding, never noise.
- PASS requires log evidence for the specific item. Absence-type
  items (must-NOT rows) require checking the log for what is NOT
  there and saying so explicitly.
- Equivalence passes are allowed only when the untested case runs
  the IDENTICAL code branch as a tested one — name the branch and
  the bracketing evidence.
- FAIL protocol: root cause FIRST (trace the exact log lines), then
  fix build, then a new matrix row so it can never silently regress,
  then harden the checklist item, and RETAIN the FAIL evidence in
  STATE.md. A fix without a matrix row is incomplete.
- When Jeff reports a symptom, read his log before theorizing. If
  his premise and the log disagree, say so with the evidence — the
  log wins, kindly.
- Carry-forward: verified items survive a new build only if the
  delta provably cannot affect them (e.g. display-only); say which
  and why.
