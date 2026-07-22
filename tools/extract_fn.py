#!/usr/bin/env python3
"""
extract_fn.py -- byte-identity function extractor for MQL5 sources.

Purpose (transition plan D3, "the regression lever"): prove that an
engine/function is UNCHANGED across two builds by comparing the exact
bytes (or sha256) of the function body, instead of re-testing it live.
The code plan names the functions that must stay byte-identical;
verification diffs them with this tool.

Usage:
  python tools/extract_fn.py FILE --list
      List every function definition found: sha256_16, line, name.

  python tools/extract_fn.py FILE NAME [NAME ...]
      Print the exact source of each named function + its sha256_16.

  python tools/extract_fn.py FILE NAME [NAME ...] --hash
      Print only "<sha256_16>  NAME" per function (quiet; diff-friendly).

  python tools/extract_fn.py FILE --all --hash
      Print "<sha256_16>  NAME" for every function (a build fingerprint).

Compare two builds:
  diff <(python tools/extract_fn.py A.mq5 --all --hash) \
       <(python tools/extract_fn.py B.mq5 --all --hash)

Exit codes: 0 ok; 1 a requested name was not found; 2 usage/IO error.

The scanner skips braces inside "strings", 'char' literals, // line
comments and /* block comments, so the known "brace inside a string" in
TRTM.mq5 (the -1 brace baseline) does not confuse body matching. Bytes
are handled 1:1 via latin-1, so CRLF line endings are preserved in both
the extracted text and the hash.

Extraction span: from the start of the signature (first non-space char
after the previous ';', '{' or '}' at file scope) through the matching
closing '}' of the body. A leading banner comment on its own lines is
NOT included; an inline return type on the signature line IS.
"""
import sys
import hashlib

# Words that are followed by '(' but are not function definitions.
_KEYWORDS = {
    "if", "for", "while", "switch", "catch", "return", "sizeof",
    "do", "else", "case", "typeid", "new", "delete", "and", "or",
}


def _read(path):
    with open(path, "rb") as f:
        # latin-1: every byte maps to one char, losslessly and reversibly.
        return f.read().decode("latin-1")


def _sha16(text):
    return hashlib.sha256(text.encode("latin-1")).hexdigest()[:16]


def _code_mask(s):
    """Return a bool list: True where the char is active code (not inside
    a string, char literal, or comment)."""
    n = len(s)
    mask = [True] * n
    i = 0
    while i < n:
        c = s[i]
        nxt = s[i + 1] if i + 1 < n else ""
        if c == "/" and nxt == "/":
            j = i
            while j < n and s[j] != "\n":
                mask[j] = False
                j += 1
            i = j
        elif c == "/" and nxt == "*":
            mask[i] = mask[i + 1] = False
            j = i + 2
            while j < n and not (s[j] == "*" and j + 1 < n and s[j + 1] == "/"):
                mask[j] = False
                j += 1
            if j < n:
                mask[j] = False
                if j + 1 < n:
                    mask[j + 1] = False
                j += 2
            i = j
        elif c == '"' or c == "'":
            quote = c
            mask[i] = False
            j = i + 1
            while j < n:
                if s[j] == "\\":
                    mask[j] = False
                    if j + 1 < n:
                        mask[j + 1] = False
                    j += 2
                    continue
                mask[j] = False
                if s[j] == quote:
                    j += 1
                    break
                j += 1
            i = j
        else:
            i += 1
    return mask


def _is_ident_char(c):
    return c.isalnum() or c == "_"


def find_functions(s, mask):
    """Yield (name, line_no, start, end_inclusive) for each function
    definition (identifier '(' ... ')' ... '{' ... matched '}')."""
    n = len(s)
    i = 0
    while i < n:
        c = s[i]
        if mask[i] and (c.isalpha() or c == "_"):
            # Read identifier.
            j = i
            while j < n and _is_ident_char(s[j]) and mask[j]:
                j += 1
            name = s[i:j]
            # Skip whitespace to '('.
            k = j
            while k < n and s[k].isspace():
                k += 1
            if k < n and s[k] == "(" and mask[k] and name not in _KEYWORDS:
                rp = _match(s, mask, k, "(", ")")
                if rp != -1:
                    body = _after_params(s, mask, rp + 1)
                    if body != -1:  # index of '{'
                        end = _match(s, mask, body, "{", "}")
                        if end != -1:
                            start = _sig_start(s, mask, i)
                            line_no = s.count("\n", 0, start) + 1
                            yield name, line_no, start, end
                            i = end + 1
                            continue
            i = j
        else:
            i += 1


def _match(s, mask, open_idx, open_ch, close_ch):
    """Return index of the code close_ch matching the open at open_idx."""
    depth = 0
    n = len(s)
    i = open_idx
    while i < n:
        if mask[i]:
            if s[i] == open_ch:
                depth += 1
            elif s[i] == close_ch:
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    return -1


def _after_params(s, mask, i):
    """From just after ')', decide if a definition body follows. Allow
    whitespace and trailing specifiers (const/override) before '{'.
    Return index of '{', or -1 if this is a prototype/not a definition."""
    n = len(s)
    while i < n:
        if not mask[i] or s[i].isspace():
            i += 1
            continue
        c = s[i]
        if c == "{":
            return i
        if c == ";":
            return -1  # prototype
        if c.isalpha() or c == "_":
            while i < n and _is_ident_char(s[i]):
                i += 1  # skip a specifier like const/override
            continue
        return -1  # anything else -> not a plain definition
    return -1


def _sig_start(s, mask, ident_start):
    """Walk back to the statement boundary (previous code ';','{','}')
    then move forward past whitespace and any leading comment lines to
    the first real code token -- the start of the return type. Leading
    banner comments are excluded so a comment-only edit above a function
    does not make it look changed."""
    i = ident_start - 1
    boundary = -1
    while i >= 0:
        if mask[i] and s[i] in ";{}":
            boundary = i
            break
        i -= 1
    j = boundary + 1
    # Skip whitespace and non-code (comment) bytes to the first code char.
    while j < ident_start and (s[j].isspace() or not mask[j]):
        j += 1
    return j


def main(argv):
    args = [a for a in argv if not a.startswith("--")]
    flags = {a for a in argv if a.startswith("--")}
    if len(args) < 1:
        sys.stderr.write(__doc__)
        return 2
    path = args[0]
    names = args[1:]
    want_hash = "--hash" in flags
    do_list = "--list" in flags
    do_all = "--all" in flags

    try:
        s = _read(path)
    except OSError as e:
        sys.stderr.write(f"error: {e}\n")
        return 2

    mask = _code_mask(s)
    funcs = list(find_functions(s, mask))
    by_name = {}
    for name, line_no, start, end in funcs:
        by_name.setdefault(name, []).append((line_no, start, end))

    if do_list:
        for name, line_no, start, end in funcs:
            frag = s[start:end + 1]
            print(f"{_sha16(frag)}  L{line_no:<5} {name}")
        return 0

    if do_all:
        for name, line_no, start, end in funcs:
            frag = s[start:end + 1]
            if want_hash:
                print(f"{_sha16(frag)}  {name}")
            else:
                print(f"----- {name} (L{line_no}) -----")
                print(frag)
        return 0

    if not names:
        sys.stderr.write("error: give a function NAME, or --list / --all\n")
        return 2

    rc = 0
    for name in names:
        hits = by_name.get(name)
        if not hits:
            sys.stderr.write(f"not found: {name}\n")
            rc = 1
            continue
        for line_no, start, end in hits:
            frag = s[start:end + 1]
            if want_hash:
                print(f"{_sha16(frag)}  {name}")
            else:
                print(f"----- {name} (L{line_no}, {end - start + 1} bytes, "
                      f"sha256_16 {_sha16(frag)}) -----")
                sys.stdout.write(frag)
                if not frag.endswith("\n"):
                    sys.stdout.write("\n")
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
