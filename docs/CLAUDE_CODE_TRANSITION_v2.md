# TRTM -> Claude Code: TRANSITION PLAN v2 (formalized)
# Supersedes CLAUDE_CODE_TRANSITION.md (written 2026-07-19, at Stage8-b28).
# Rewritten 2026-07-21 at Stage9s2-b33. Product facts verified against
# https://code.claude.com/docs on 2026-07-21 (not from memory).
# Also supersedes CLAUDE_CODE_HANDOFF.md - that file's content is folded
# into Part F here.

---

# PART 0 - VERDICT ON v1

| v1 item | Verdict |
|---|---|
| CLAUDE.md is Claude Code's native format | **KEEP** - verified correct |
| One git repo per workstream | **KEEP** - preserves project isolation |
| Keep sha256_16 in STATE.md despite git | **KEEP** - best idea in the doc |
| Junction/symlink into `MQL5\Experts` | **KEEP** - verify on Windows |
| "Faster hands make Gate 2 more important" | **KEEP** - correct |
| Claude Code never touches MT5 runtime | **KEEP the intent, FIX the mechanism** |
| MetaEditor CLI compile gate | **KEEP as candidate** - still unverified |
| Auto-memory description | **MOSTLY RIGHT** - refine, see B3 |
| Rollout schedule (steps 1-4) | **DROP** - overtaken by events |
| Step 7 first-session script | **REWRITE** - references dead files |
| CLAUDE.md size / structure | **MISSING** - see Part E |
| Enforcement layer (hooks/permissions) | **MISSING** - see Part D |
| Hygiene automation | **MISSING** - see D2, highest practical value |

---

# PART A - WHAT v1 GOT RIGHT (keep, no changes)

**A1. CLAUDE.md transfers as-is.** Verified: Claude Code loads project
instructions from `./CLAUDE.md` or `./.claude/CLAUDE.md` at the start of
every session, and the project-root CLAUDE.md is re-read from disk after
`/compact`. Your protocol file genuinely is the native format.

**A2. One repo per workstream.** trtm/ now; shadow/ and
xauusd-research/ later. This mechanically enforces the
"ECOSYSTEM_BACKLOG.md items never get re-imported" rule - a separate
repo has a separate CLAUDE.md and cannot bleed context.

**A3. Keep sha256_16 in STATE.md even with git.** This is the sharpest
call in v1 and it gets *more* important with a junction: git proves what
is in the repo, the hash proves what MT5 actually loads. They are not the
same file until you've verified they are.

**A4. ~~Junction into the MT5 folder~~ - REJECTED by Jeff 2026-07-21.**
DECISION: the repo stays **fully separate** from the MT5 installation.
Claude Code edits `src/TRTM.mq5` in the repo; Jeff copies the file into
`MQL5\Experts` manually and compiles in MetaEditor.
Rejected junction because: added Windows/admin complexity, and MetaEditor
compiling through a junction was unverified.
ACCEPTED COST: there are now TWO copies of TRTM.mq5 (repo master + MT5
runtime copy) which CAN diverge. This is precisely the failure the
section 0 hash rule exists to catch, so it is mitigated by protocol, not
ignored - see Part C Step 2b (deploy + verify). The sha256_16 in STATE.md
becomes load-bearing rather than belt-and-braces.

**A5. Prohibition on Claude Code touching MT5 runtime.** Right instinct.
The *mechanism* v1 proposed is wrong - see Part D.

**A6. Live verification, log pasting, and seal authority stay yours.**
Unchanged. Claude Code cannot see a demo account.

---

# PART B - WHAT IS WRONG OR STALE

**B1. The entire rollout schedule is overtaken by events.**
v1 planned: seal Stage 8 Step 1 in claude.ai -> set up repo -> first
Claude Code delivery = b29 observability -> Stage 9 as first full feature.
ALL of that has since happened in claude.ai:
- b28 Stage 8 Step 1 SEALED
- b29 Stage 9 Step 1 SEALED
- b30/b31/b32 Stage 10 observability SEALED
- b33 Stage 9 Step 2 SEALED (2026-07-21)
=> Baseline commit is **Stage9s2-b33**, not Stage8-b28. The first Claude
Code delivery is now whatever you pick from the queued list, not b29.

**B2. The first-session script references dead files.** It points at
`docs/HANDOVER_2026-07-19_stage8_b28.md` and expects the answer
"M6-1/S8-17/SELL lap". Current handover is
`HANDOVER_2026-07-21_stage9step2_b33.md`. Rewritten in Part F.

**B3. CRITICAL - "write the prohibition into CLAUDE.md" is not
enforcement.** Verified from the official docs: CLAUDE.md and auto memory
are treated as *context, not enforced configuration*; to block an action
regardless of what Claude decides, you need a PreToolUse hook. The docs
are explicit that CLAUDE.md "is not a hard enforcement layer" and that
settings rules "are enforced by the client regardless of what Claude
decides to do."
This matters for you specifically: "never attach an EA / never touch the
MT5 runtime" is a money-risk boundary, not a style preference. In v1 it
was a polite request. Part D makes it a wall.

**B4. Auto-memory needs two corrections.** v1 said "MEMORY.md + topic
files, ~200-line index auto-loaded, let Claude manage it" - broadly
right. Missing:
- It lives at `~/.claude/projects/<project>/memory/`, **not in your
  repo**, and it is **machine-local** (not shared across machines).
  So on your two-machine setup it will diverge. This *reinforces* v1's
  rule: never let auto memory be the system of record.
- Only the first 200 lines / 25KB of MEMORY.md load per session;
  the rest is silently dropped at load time.
=> v1's conclusion stands, with a harder edge: STATE.md and the
empirical-facts ledger are repo files. Auto memory is a convenience,
and you should expect it to differ between `jep-one-itx` and `PRDTR-JEP`.

**B5. Compile gate still unverified.** v1 flagged this correctly, and it
is *still* unverified - do not write it into CLAUDE.md until it runs on
your box. Two known gotchas to check: the exact flag syntax, and that
MetaEditor writes its compile log in a UTF-16 encoding, which means a
naive `cat`/`grep` of the log can come back empty or garbled. Verify
before adopting.

**B6. CLAUDE.md is over the recommended size.** Official guidance is to
target **under 200 lines** per CLAUDE.md; longer files consume more
context and reduce adherence. Your current CLAUDE.md is roughly double
that. It has never been a problem in claude.ai (it is pasted per
session), but in Claude Code it loads into every session's context and
adherence degrades. Part E splits it without losing a single rule.

---

# PART C - THE FORMALIZED PLAN

## Step 1 - Install (one time)
1. Node.js LTS.
2. `npm install -g @anthropic-ai/claude-code`
3. `claude` in a terminal, sign in.
Docs: https://code.claude.com/docs

## Step 2 - Repo layout
```
trtm/
├── CLAUDE.md                 <- trimmed core protocol (Part E)
├── STATE.md                  <- current build truth (unchanged role)
├── README.md
├── .claude/
│   ├── settings.json         <- permissions + hooks (Part D)
│   ├── rules/
│   │   ├── mql5-traps.md     <- path-scoped to *.mq5
│   │   ├── verification.md   <- path-scoped to docs/
│   │   └── mt5-runtime-boundary.md
│   └── hooks/
│       ├── guard_mt5.sh
│       └── check_hygiene.sh
├── src/TRTM.mq5              <- MASTER copy (repo SEPARATE from MT5)
├── docs/                     matrices, checklists, handovers, ledger,
│                             ECOSYSTEM_BACKLOG.md
├── presets/                  .set files per symbol
└── tools/extract_fn.py       function byte-identity diff (Part D3)
```

Then:
```
git init
git add -A
git commit -m "baseline Stage9s2-b33"
git tag Stage9s2-b33
```
From here: **one build delivery = one commit = one tag.** Recompute
sha256_16 AFTER the final edit and put it in STATE.md in the same commit.

## Step 2b - DEPLOY PROTOCOL (mandatory; replaces the junction)
Because repo and MT5 hold separate copies, every build delivery ends
with an explicit deploy + verify. Never assume the copy in MT5 is the
copy Claude Code edited.

**After every build, in this order:**
1. Claude Code finishes edits to `src/TRTM.mq5`, recomputes
   `sha256sum | cut -c1-16` + `wc -l`, writes them into STATE.md,
   commits, and tags the build.
2. Jeff copies `src/TRTM.mq5` -> `MQL5\Experts\TRTM.mq5` (overwrite).
3. Jeff verifies the DEPLOYED file, not the repo file:
   `sha256sum "<MQL5 path>\TRTM.mq5" | cut -c1-16`
   It MUST equal the STATE.md value. Mismatch = the copy failed or the
   wrong file moved; fix before compiling.
4. Compile in MetaEditor (gate zero). Paste errors if any.

**At the start of every session**, verify BOTH copies:
- repo:  `sha256sum src/TRTM.mq5 | cut -c1-16`
- MT5:   `sha256sum "<MQL5 path>\TRTM.mq5" | cut -c1-16`
Both must equal STATE.md. If repo and MT5 disagree, STOP and establish
which one produced the last live evidence - the logs came from the MT5
copy, so THAT is the file the evidence describes.

Write the MT5 path into CLAUDE.md once so it is never retyped from
memory. Claude Code may READ the MT5 copy to hash it, but must never
write to it - copying is Jeff's step (see D1: the MT5 tree is deny).

## Step 3 - Rewrite CLAUDE.md section 0 (resume protocol)
Replace upload-based resume with:
1. First action every session:
   `git status` (tree clean, or Jeff explains the dirt)
   `sha256sum src/TRTM.mq5 | cut -c1-16`  -> compare to STATE.md
   `wc -l src/TRTM.mq5`                   -> compare to STATE.md
   `sha256sum "<MT5 path>\TRTM.mq5" | cut -c1-16` -> MUST also match
   (two copies exist - repo master and MT5 runtime; see Step 2b)
   All match = "aligned", one line.
2. Mismatch = STOP. `git diff <last build tag>`, ask which copy runs
   in MT5. Never guess.
3. "Never rebuild from memory" now reads: **disk + git are truth;
   conversation memory and auto memory never override them.**
Everything else in CLAUDE.md transfers unchanged.

## Step 4 - Compile gate (verify BEFORE adopting)
Candidate:
`metaeditor64.exe /compile:"<path>\TRTM.mq5" /log`
Verify on your install: exact path, exact flags, where the log lands,
and the log's text encoding (see B5). Only once it runs clean and Claude
Code can *read* the log do you write the command into CLAUDE.md as
automated gate zero. Until then, gate zero stays manual (you compile,
you paste).

## Step 5 - Memory layers (division of labour)
- **CLAUDE.md** - protocol you author, version-controlled, binding.
- **.claude/rules/** - path-scoped protocol (loads only when relevant).
- **STATE.md** - current build truth, ships with every build.
- **docs/ facts ledger** - empirical observations, repo file, permanent.
- **auto memory** - Claude's own notes, machine-local, disposable.
  Audit with `/memory`. Promote anything important into STATE.md or the
  ledger. Never the system of record. Expect it to differ per machine.

## Step 6 - Skills
Your four skills (staged-delivery-protocol, session-continuity,
evidence-audit, empirical-facts-ledger) port to Claude Code. Skills load
on demand rather than every session, which makes them the right home for
anything procedural that would otherwise bloat CLAUDE.md.

---

# PART D - THE ENFORCEMENT LAYER (new; v1 had none)

Verified behaviour: deny rules and PreToolUse hooks are enforced by the
client regardless of what Claude decides, and hold even in bypass
permission modes. A hook's "allow" cannot loosen a deny rule. This is
the layer where your hard boundaries belong.

## D1 - MT5 runtime boundary (replaces v1's CLAUDE.md sentence)
In `.claude/settings.json`, deny the tooling that could touch the
running terminal, e.g. commands invoking `terminal64.exe`, taskkill
against MT5, or writes into the MT5 `Files\` state directory. Back it
with a PreToolUse hook (`guard_mt5.sh`) that inspects the full command
string and exits 2 on a match - the hook sees compound commands and
pipes that a pattern rule can miss.
Rule of thumb: **anything that could alter a live account or the running
terminal is a deny, not an instruction.**

## D2 - File-hygiene hook (highest practical value)
This session, an edit pass inserted LF-only lines into a CRLF file and
produced a mixed-ending file that would have gone to the compiler if the
hygiene check hadn't caught it. That is a recurring, mechanical,
100%-detectable failure - exactly what a hook is for.
`check_hygiene.sh` as a **PostToolUse** hook on Edit/Write for `*.mq5`:
- CR count == LF count (uniform CRLF)
- zero non-ASCII bytes
- brace delta still -1 vs baseline
- EOF byte unchanged (file ends `+`, no trailing newline)
Fail loudly. This removes an entire bug class from every future build,
permanently.

## D3 - The regression lever, as a repo tool
Ship `tools/extract_fn.py` (brace-counting function extractor) so any
"this engine is unchanged" claim is proven by byte-identity diff instead
of re-tested live. This session it collapsed ~6 must-NOT rows into one
diff and settled two guard items that had no practical live repro.
Standing rule: **the code plan names the functions that must stay
byte-identical; verification diffs them.**

## D4 - Plan mode = Gate 3
Claude Code's plan mode maps exactly onto your Gate 3. Use
`--permission-mode plan` or set `defaultMode` in settings.json so the
default posture is "propose, don't edit". Your gate order then has a
mechanical backstop rather than depending on Claude's good manners.

---

# PART E - CLAUDE.md RESTRUCTURE (keep every rule, halve the context)

Target: core CLAUDE.md **under 200 lines**. Nothing is deleted - the
detail moves to path-scoped rules that load only when relevant.

**Stays in CLAUDE.md** (always relevant):
- Section 0 resume protocol (rewritten, Step 3)
- Section 2 gate pipeline + definition of done
- Section 6 communication
- Section 7 flag-immediately / Section 8 never
- The MT5-runtime boundary (with a pointer to the hook that enforces it)

**Moves to `.claude/rules/mql5-traps.md`** (`paths: ["**/*.mq5"]`):
- `input` reserved word; uninitialized struct fields; helper-before-caller
  ordering; POSITION_IDENTIFIER wrapper; 64-bit IDs never as double;
  stale cached phase after closes; retcode meanings; CRLF/ASCII/brace
  hygiene (the hook enforces; the rule explains)

**Moves to `.claude/rules/verification.md`** (`paths: ["docs/**"]`):
- matrix format, checklist format, FAIL protocol, carry-forward and
  equivalence rules, audit-to-the-cent

**Moves to `docs/` (already there)**: empirical facts ledger, broker
observations, parked list.

Net effect: same protocol, far less per-session context, better
adherence. Note that `@path` imports do NOT save context (imported files
load at launch) - path-scoped rules do.

---

# PART F - FIRST SESSION PROOF (run this before any real work)

Paste into Claude Code at the trtm/ repo root:

```
Read CLAUDE.md fully. Run the resume protocol against STATE.md:
git status, sha256sum src/TRTM.mq5 | cut -c1-16, and wc -l.
Report alignment in ONE line.
Then read docs/HANDOVER_2026-07-21_stage9step2_b33.md section 3 and
tell me the queued items. Do not modify anything yet.
```

**PASS looks like:** clean tree; hash `b732b80fddf75fda`; 4296 lines;
says "aligned"; then names the queued items (BE anchor Gate 1, Stage 9
Step 3 auto-entry, Stage 8 Step 2 draggable exit lines, Stage 8
gold-hours items M6-1 / S8-17 / SELL lap, STATE.md env-note reword).

**FAIL looks like:** it reports alignment without running the commands,
or reconstructs the queue from memory, or edits something. If that
happens, the CLAUDE.md section 0 rewrite (Step 3) was not specific
enough - tighten it before doing real work.

Then a second proof, for the enforcement layer:
```
Attempt to run: taskkill /F /IM terminal64.exe
```
**PASS = the hook blocks it** and Claude reports the denial. If it runs,
D1 is not configured correctly. Test this on a machine with MT5 CLOSED.

---

# PART G - ORDER OF OPERATIONS

1. Install (C1) + repo init at baseline **Stage9s2-b33** (C2).
2. Rewrite CLAUDE.md section 0 + split to rules (Step 3, Part E).
3. Configure settings.json deny + the two hooks (D1, D2).
4. Run the Part F proofs. Do not skip the enforcement proof.
5. Verify the MetaEditor compile gate (Step 4); adopt only if clean.
6. First real delivery: pick a **small** queued item as the shakedown -
   the STATE.md env-note reword or Stage 9 Step 3 stub, NOT the
   draggable exit lines (that is a full money-path feature and a bad
   first run on unproven tooling).

---

# PART H - WHAT DOES NOT CHANGE

- The gates, in order. Faster editing makes Gate 2 more important.
- Your verification role: demo evidence, log pasting, seal authority.
- STATE.md with every build; build-tag bump every delivery.
- Surgical diffs - review every `git diff` before commit.
- One project = one repo = one CLAUDE.md.
- Terminal is truth.

# PART I - OPEN ITEMS TO VERIFY ON YOUR MACHINE
- [ ] MetaEditor CLI flags + compile-log path and encoding (B5)
- [ ] MT5 Experts path recorded in CLAUDE.md (for the deploy check)
- [ ] Hook scripts run under your shell (Git Bash vs WSL vs PowerShell)
- [ ] The D1 deny actually blocks (Part F second proof)
- [ ] Claude Code version supports path-scoped rules (v2.1.211+ for
      the `--setting-sources` behaviour noted in the docs)
