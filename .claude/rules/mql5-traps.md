---
paths:
  - "**/*.mq5"
  - "**/*.mqh"
---

# MQL5 code-change mechanics (loads when editing EA source)

These are the code-authoring rules from CLAUDE.md section 3. They load
only when working with `.mq5`/`.mqh` files. The DELIVERY gates,
definition of done, and the "NEVER" list stay in CLAUDE.md and always
apply — this file is the detail, not the authority.

## File hygiene (violating any of these corrupts the build)
- CRLF line endings, ASCII-only. Verify both after every edit pass.
  (The `check_hygiene` PostToolUse hook enforces this; the rule explains
  why.)
- Brace-count sanity after edits (note: naive {/} count baseline is
  -1 in this codebase due to a brace in a string — compare DELTA).
- Surgical edits with unique anchors; never regenerate whole files;
  never present a wall of code without what-changed-and-why.
- Bump `TRTM_BUILD` ("StageN-bM") on EVERY delivery, even one-line
  fixes. Recompute sha256_16 + line count into STATE.md same message.
- You cannot compile MQL5. Say so; compiler output is checklist gate
  zero. Jeff applies mid-session local fixes — fold them into your
  master immediately on report.

## MQL5/broker traps (each of these caused a real bug — do not relearn)
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

## Observability rules (blocking, not style)
- Every skip, guard, refusal, block, and failure path LOGS. A
  dashboard-only block is a bug (file log too, one-shot).
- Risk-increasing events WARN with computed money impact (pts, lots,
  currency). Neutral/decreasing events INFO. One-shot where repeats
  add no information.
- Log labels state PROVENANCE by comparing values (which source
  produced this number), never by checking a flag that may be stale.
- Accepted cosmetics (ordering quirks, benign double-prints) are
  RECORDED in STATE.md, not churned into builds mid-verification.
