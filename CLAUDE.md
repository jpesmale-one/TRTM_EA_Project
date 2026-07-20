# CLAUDE.md — Working with Jeff (TRTM / trading EA projects)

Read fully before your first reply. This file is PROTOCOL, not
background. Follow it exactly; where it conflicts with your defaults,
this file wins. Current-state facts (build, hash, verified items,
broker observations, parked list) live in STATE.md — never in this
file, never from memory.

---

## 0. SESSION RESUME PROTOCOL (do this before anything else)

1. Jeff uploads TRTM.mq5 + STATE.md (+ latest handover + checklist).
2. Your FIRST action: `sha256sum TRTM.mq5 | cut -c1-16` and `wc -l`.
   Compare both to STATE.md. Match = fully aligned, say so in one
   line, zero reconstruction from conversation memory.
3. Mismatch = STOP. Ask which copy runs in MT5 before anything else.
4. Rebuild your working master from JEFF'S UPLOADED FILE, never from
   a sandbox copy, never from memory of past edits.
5. Read the handover's "remaining" list. Resume mid-checklist; do not
   re-plan sealed work or re-litigate locked decisions.

---

## 1. WHO JEFF IS (calibration, not protocol)

Day trader (XAUUSD focus, same-session exits) who builds his own
MQL4/MQL5 EAs, pipelines, and analytics. Senior-analytics-engineer
background: Python, SQL, dbt. Needs a thinking partner, not a tutor.
Thinks in systems and in risk-first terms; every capability ships
with guardrails. Respects a well-reasoned "no" and drops ideas when
shown they conflict — engage with his ideas, never rubber-stamp.
He verifies everything, including your work, including external
cross-reviews. Expect it; welcome it.

---

## 2. THE DELIVERY PIPELINE (non-negotiable order)

Every feature moves through these gates IN ORDER. No gate is skipped,
no gate is entered before the previous one is sealed by Jeff saying
so ("let's go", "confirmed", "sealed").

GATE 1 — DECISIONS. For anything touching money behavior (entries,
exits, lots, SL/TP logic, closes): present options with concrete
numeric examples (real prices, real lots), pros/cons each, your
recommendation with reasoning. One decision at a time. Jeff decides;
you record the decision AND the rejected alternatives with rationale
in STATE.md's locked-decisions log so it is never re-litigated.

GATE 2 — SCENARIO MATRIX. Before any code on routing, safety logic,
money paths, or user switches: a numbered matrix file (M-rows,
grouped) covering every condition combination, INCLUDING must-NOT-
fire rows (what must stay unchanged is tested, not assumed).
Restart/kill rows are mandatory for any stateful feature. Jeff seals
the matrix. Live findings later become new M-rows, never silent fixes.

GATE 3 — CODE PLAN. Numbered touch points; per point: what changes
and why. An explicit UNCHANGED list (name the engines/paths not
touched). Estimated line delta. Wait for confirmation.

GATE 4 — BUILD. See section 3 for mechanics. One build per delivery,
STATE.md updated in the same delivery, checklist items mapped 1:1
from matrix rows.

GATE 5 — VERIFICATION. Jeff runs it live on demo and pastes logs.
You audit (section 4). Items pass individually; the stage seals only
when the checklist is complete.

GATE 6 — SEAL + HANDOVER. Update STATE.md disposition, write the
session handover (resume protocol, builds delivered, empirical facts,
checklist disposition, remaining list with recipes, queued items).

DEFINITION OF DONE (a stage/step is finished when ALL of):
- [ ] Matrix sealed by Jeff before code was written
- [ ] Every checklist item PASS with pasted log evidence
- [ ] Every money number in that evidence recomputed and exact
- [ ] Must-NOT rows verified (absence of events checked, not assumed)
- [ ] STATE.md build/hash/lines current; locked decisions recorded
- [ ] README updated (beginner-audience section for the feature)
- [ ] Known cosmetics recorded, queued items listed, nothing silent
- [ ] Handover written if the session is ending
"Compiles and runs" is not done. "Jeff confirmed each item" is done.

---

## 3. CODE CHANGE MECHANICS

File hygiene (violating any of these corrupts the build):
- CRLF line endings, ASCII-only. Verify both after every edit pass.
- Brace-count sanity after edits (note: naive {/} count baseline is
  -1 in this codebase due to a brace in a string — compare DELTA).
- Surgical edits with unique anchors; never regenerate whole files;
  never present a wall of code without what-changed-and-why.
- Bump `TRTM_BUILD` ("StageN-bM") on EVERY delivery, even one-line
  fixes. Recompute sha256_16 + line count into STATE.md same message.
- You cannot compile MQL5. Say so; compiler output is checklist gate
  zero. Jeff applies mid-session local fixes — fold them into your
  master immediately on report.

MQL5/broker traps (each of these caused a real bug — do not relearn):
- `input` is a reserved word; never a local variable name.
- Local structs/simple types are NOT auto-initialized. Any new
  persisted field gets an explicit default BEFORE parse so absent
  JSON keys are deterministic (backward compat with old state files).
- New persisted fields also go into the state self-test write+compare.
- Functions may be used before definition, but keep file order
  helper-before-caller to match codebase style.
- Some brokers key on POSITION_IDENTIFIER not POSITION_TICKET — all
  position selection goes through the existing wrapper.
- 64-bit IDs never stored as double (53-bit mantissa).
- Cached phase/state computed at function entry is STALE after any
  close within the same call — recompute after closes.
- Broker stops/freeze levels are DYNAMIC (observed 20–100 pts on
  XAUUSD.s within one evening). Never treat a sampled value as a
  constant; guidance logs must say "at init".
- Retcodes: 10027 = AutoTrading toolbar off (client); 10026 = server
  disables; 10016/10015 = invalid stops/price. Diagnostics must name
  the ACTUAL cause — never print a generic hint that misdirects.
- Task Manager Processes "End task" is a GRACEFUL close. Only Details
  "End process" / `taskkill /F` is a real kill. Kill-test evidence
  from a soft kill is invalid.
- MT5 Inputs "Reset" restores ALL defaults (it has reverted risk
  settings mid-test). Jeff keeps a .set preset; when a config
  mystery appears, ask for a full inputs screenshot before debugging.

Observability rules (blocking, not style):
- Every skip, guard, refusal, block, and failure path LOGS. A
  dashboard-only block is a bug (file log too, one-shot).
- Risk-increasing events WARN with computed money impact (pts, lots,
  currency). Neutral/decreasing events INFO. One-shot where repeats
  add no information.
- Log labels state PROVENANCE by comparing values (which source
  produced this number), never by checking a flag that may be stale.
- Accepted cosmetics (ordering quirks, benign double-prints) are
  RECORDED in STATE.md, not churned into builds mid-verification.

---

## 4. VERIFICATION & EVIDENCE RULES

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

---

## 5. DOCUMENTATION DELIVERABLES (shipped WITH the work, not after)

- STATE.md: build/file/sha256_16/lines/date header; environment
  notes; per-build change summaries; locked-decisions log (decision,
  date, rejected alternatives, rationale); pending/verified
  disposition; parked list (TRTM-only — ecosystem items go to
  ECOSYSTEM_BACKLOG.md and are never re-imported).
- Checklist file: numbered S-items mapped to M-rows, grouped
  regression-first, kill tests last, seal condition stated.
- README: per-stage section, written for a beginner even though Jeff
  is not one; updated in the same delivery as the code it describes.
- Handover at session end: resume protocol, where-we-are, builds +
  fixes with root causes, empirical facts established, checklist
  disposition, remaining list WITH recipes (setup steps, expected
  logs), queued items, working agreements.

---

## 6. COMMUNICATION

- ONE question per message, the most important one. Answer his
  question before asking yours. He answers clearly; reciprocate.
- Match his directness. No padding, no flattery, no repeating his
  words back. Concise chat; depth goes in the artifact files.
- When auditing logs, credit checklist items explicitly ("S8-11
  PASS") so the scoreboard stays current in both heads.
- Push back with reasoning when he is about to break consistency,
  add scope, or take on unflagged risk. He has dropped features on a
  demonstrated conflict; expect the same treatment for your ideas.
- If he asks "is X wrong", the answer starts with what the evidence
  says, then why, then the fix — never with reassurance.
- Names are design: self-documenting identifiers, grouped inputs,
  section headers (`//--- Phase N ...`). No placeholder names.

---

## 7. FLAG IMMEDIATELY (interrupt whatever you are doing)

- Consistency breaks with locked decisions or sealed behavior —
  BEFORE implementing, with the specific conflict named.
- Any silent path: code that fails/skips/blocks without logging.
- Scope drift: new instruments, features, or ecosystem items —
  queue to backlog, do not fold in.
- Money-behavior changes hiding inside "small" edits — stop, name
  it, get explicit confirmation (Gate 1) even if the diff is tiny.
- Broker-behavior assumptions presented as facts — check STATE.md's
  observed facts; if unobserved, say it's an assumption and how to
  verify.
- Your own uncertainty about the codebase — read the actual code
  section before editing; never edit from memory of what it "should"
  say.

## 8. NEVER

- Code before a confirmed plan; a plan before a sealed matrix (money
  paths); a matrix before locked decisions.
- Rebuild from sandbox state or conversation memory when Jeff's
  upload is available.
- Declare PASS without recomputing the numbers.
- Deliver a build without STATE.md, or with an unbumped build tag.
- Re-litigate a locked decision without new evidence (if new
  evidence exists, present it as such against the recorded rationale).
- Leave a bug fixed but untracked (no matrix row, no checklist item).
- Assume the easy version is wanted. Correct > easy, always.
