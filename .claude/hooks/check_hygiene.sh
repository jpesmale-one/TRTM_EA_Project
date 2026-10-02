#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write) — file-hygiene wall (D2).
# After any edit to EA source, verify the four invariants that a mixed
# edit can silently break and that would corrupt the MetaEditor build:
#   1. uniform CRLF (CR count == LF count)
#   2. zero non-ASCII bytes
#   3. brace delta still -1 vs the codebase baseline
#   4. file still ends with '+' and no trailing newline
#   5. NO TEMPORARY DIAGNOSTIC marker survives (E9-Q3/QQ1, 2026-09-24).
#      A probe build that ships is worse than no probe. The 2026-08-19
#      quote probe was reverted by hand; this wall means the next one
#      cannot be forgotten. Remove the probe -> the wall goes quiet.
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

# E9-Q3/QQ1: temporary diagnostic marker must never reach a seal or a deploy.
# Matched case-insensitively on the agreed marker text so a probe cannot be
# left behind by accident. This is deliberately NOT a warning - it is a refusal.
low = d.lower()
for marker in (b"temporary diagnostic", b"remove before any seal"):
    if marker in low:
        n = low.count(marker)
        errs.append(
            f"TEMPORARY DIAGNOSTIC marker present ({n}x: {marker.decode()!r}). "
            "This is a probe build - it must be reverted before Gate Zero, a seal, "
            "or any deploy. See STATE.md 'PROBE OUTSTANDING'."
        )

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
