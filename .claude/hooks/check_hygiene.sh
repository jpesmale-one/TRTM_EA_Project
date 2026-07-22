#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write) — file-hygiene wall (D2).
# After any edit to EA source, verify the four invariants that a mixed
# edit can silently break and that would corrupt the MetaEditor build:
#   1. uniform CRLF (CR count == LF count)
#   2. zero non-ASCII bytes
#   3. brace delta still -1 vs the codebase baseline
#   4. file still ends with '+' and no trailing newline
# PostToolUse cannot undo the write; exit 2 surfaces the failure to
# Claude loudly so it is fixed before the file reaches the compiler.

input="$(cat)"

fp="$(
  printf '%s' "$input" | python -c 'import sys,json
try:
    print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))
except Exception:
    pass' 2>/dev/null
)"

# Only police EA source; anything else passes untouched.
case "$fp" in
  *.mq5|*.mqh) ;;
  *) exit 0;;
esac
[ -f "$fp" ] || exit 0

python - "$fp" <<'PY'
import sys
p = sys.argv[1]
d = open(p, "rb").read()
errs = []

cr, lf = d.count(b"\r"), d.count(b"\n")
if cr != lf:
    errs.append(f"line endings not uniform CRLF: CR={cr} LF={lf}")

nonascii = sum(1 for b in d if b > 0x7f)
if nonascii:
    errs.append(f"{nonascii} non-ASCII byte(s) present")

delta = d.count(b"{") - d.count(b"}")
if delta != -1:
    errs.append(f"brace delta {delta:+d} (expected -1 baseline)")

if not d.endswith(b"+"):
    tail = d[-12:].decode("latin-1", "replace")
    errs.append(f"file does not end with '+' (tail={tail!r})")

if errs:
    sys.stderr.write(f"HYGIENE FAIL on {p}:\n")
    for e in errs:
        sys.stderr.write(f"  - {e}\n")
    sys.stderr.write("Fix before this file goes to MetaEditor.\n")
    sys.exit(2)
PY
