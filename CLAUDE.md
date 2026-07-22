# CLAUDE.md — Working with Jeff (TRTM / trading EA projects)

Read fully before your first reply. This file is PROTOCOL, not
background. Follow it exactly; where it conflicts with your defaults,
this file wins. Current-state facts (build, hash, verified items,
broker observations, parked list) live in STATE.md — never in this
file, never from memory.

---

## 0. SESSION RESUME PROTOCOL (do this before anything else)

MT5 Experts path (written once here so it is never retyped from
memory):
`/c/Users/jpesm/AppData/Roaming/MetaQuotes/Terminal/D0E8209F77C8CF37AD8BF550E51FF075/MQL5/Experts`

1. First action every session — run all four, compare to STATE.md:
   - `git status` (tree clean, or Jeff explains the dirt)
   - `sha256sum src/TRTM.mq5 | cut -c1-16` (repo master)
   - `wc -l src/TRTM.mq5`
   - `sha256sum "/c/Users/jpesm/AppData/Roaming/MetaQuotes/Terminal/D0E8209F77C8CF37AD8BF550E51FF075/MQL5/Experts/TRTM.mq5" | cut -c1-16` (MT5 runtime copy)
   All four match STATE.md = fully aligned, say so in one line, zero
   reconstruction from conversation memory.
2. Mismatch = STOP. `git diff <last build tag>`, then ask which copy
   produced the last live evidence — the logs came from the MT5 copy,
   so THAT is the file the evidence describes. Never guess.
3. Rebuild your working master from the REPO FILE (`src/TRTM.mq5`),
   never from a sandbox copy, never from memory of past edits. You may
   READ the MT5 copy to hash it, but never write to it — copying
   repo -> MT5 is Jeff's manual step (Step 2b deploy protocol; the
   MT5 tree is deny per D1).
4. "Never rebuild from memory" now reads: **disk + git are truth;
   conversation memory and auto memory never override them.**
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

Full detail lives in `.claude/rules/mql5-traps.md` (path-scoped to
`**/*.mq5` / `**/*.mqh` — loads automatically when editing EA source).
It covers file hygiene (CRLF/ASCII/brace), the MQL5/broker traps that
each caused a real bug, and the observability rules. The non-negotiable
summary that always applies:
- Surgical edits only; never regenerate a whole file; always say
  what-changed-and-why.
- Bump `TRTM_BUILD` on EVERY delivery; recompute sha256_16 + line count
  into STATE.md in the same message.
- You cannot compile MQL5 — compiler output is gate zero (Jeff runs it).
- CRLF + ASCII-only; the `check_hygiene` hook enforces this at write.

---

## 3a. MT5 RUNTIME BOUNDARY (hard boundary, hook-enforced)

Claude Code edits `src/TRTM.mq5` in the repo ONLY. It must NEVER touch
the running terminal or a live account:
- Never write into the MT5 `MQL5\Experts` tree or the MT5 `Files\`
  state dir — copying repo -> MT5 is Jeff's manual step (section 0,
  Step 2b). Claude Code may READ the MT5 copy to hash it, nothing more.
- Never invoke `terminal64.exe`, never `taskkill` MT5, never attach or
  detach an EA.
This is a money-risk boundary, not a preference. It is enforced by a
`guard_mt5.sh` PreToolUse deny hook + `settings.json` deny rules — the
client blocks these regardless of what Claude decides. The rules here
explain the wall; the hook IS the wall.

---

## 4. VERIFICATION & EVIDENCE RULES

Full detail lives in `.claude/rules/verification.md` (path-scoped to
`docs/**` — loads when working with matrices, checklists, handovers,
the facts ledger). It covers audit-to-the-cent, absence-type PASS,
equivalence passes, the FAIL protocol, and carry-forward. The summary
that always applies:
- Terminal is truth — live logs outrank the code, the plan, and your
  expectations.
- AUDIT TO THE CENT before any PASS: recompute every number in the
  pasted log and state the arithmetic. A mismatch is a finding.
- Read Jeff's log before theorizing; if premise and log disagree, the
  log wins.

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
- Chat = decisions, not lectures. Per item: what it is (1 line, plain
  words), the choice + your rec (1-2 lines), the question. Mechanism
  traces, code walkthroughs, and full rationale go in the artifact
  files (matrix/plan/STATE.md), never chat. Jeff asks if he wants the
  deep trace.
- Explain to be understood, not to prove rigor. Plain language over
  jargon; one concrete example, not three. If a point needs more than
  ~5 lines in chat, it belongs in a file.

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
