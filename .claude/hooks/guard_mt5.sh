#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash) — the MT5 runtime boundary wall (D1).
# Blocks any Bash command that could touch the running MT5 terminal or
# write into the live MT5 installation tree. exit 2 = hard block.
#
# READS of the MT5 copy (sha256sum for the resume protocol) are ALLOWED;
# only writes/process-control are blocked. Backs the settings.json deny
# rules — the hook sees pipes and compound commands a prefix rule misses.
#
# Fails OPEN on an internal error (so a hook bug can't brick the session);
# the settings.json deny rules are the second layer.

input="$(cat)"

command="$(
  printf '%s' "$input" | python -c 'import sys,json
try:
    print(json.load(sys.stdin).get("tool_input",{}).get("command",""))
except Exception:
    pass' 2>/dev/null
)"

[ -z "$command" ] && exit 0

block() { echo "BLOCKED by guard_mt5: $1" >&2; exit 2; }

shopt -s nocasematch

# Process control against the MT5 terminal — never allowed.
case "$command" in
  *terminal64*) block "invokes terminal64 — the MT5 runtime is off-limits";;
  *taskkill*)   block "taskkill — never kill or detach the MT5 terminal";;
esac

# Any reference to the live MT5 tree...
if [[ "$command" == *MetaQuotes*Terminal* || "$command" == *MQL5*Experts* ]]; then
  # ...is allowed only if it is a pure read (hashing the deployed copy).
  # A write verb or output redirection into that tree is a block.
  if [[ "$command" =~ (^|[^[:alnum:]_])(cp|mv|rm|tee|dd|truncate|install|touch|mkdir|sed[[:space:]]+-i)([^[:alnum:]_]|$) \
        || "$command" == *">"* ]]; then
    block "writes into the live MT5 tree — copying repo -> MT5 is Jeff's manual step"
  fi
fi

exit 0
