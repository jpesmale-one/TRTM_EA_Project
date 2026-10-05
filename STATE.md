# TRTM SYNC MANIFEST - update with EVERY build delivery
# Resume protocol (repo-based; see CLAUDE.md section 0). First action on
# resume: git status + sha256_16 + wc -l of src/TRTM.mq5 AND the MT5
# runtime copy, all compared to this manifest. Match = aligned in one
# line. Disk + git are truth, never conversation or auto memory.

# ############################################################################
# ### PROBE OUTSTANDING - READ BEFORE ANY SEAL, GATE ZERO, OR DEPLOY #########
# ############################################################################
# STATUS 2026-09-24 (FINAL): NO PROBE IS IN THE TREE. b42 is clean and PROVEN clean:
#   sha256_16 9209dbe131c9d651 / 5112 lines, byte-identical to the pre-probe build,
#   and `grep -ci` for the marker text returns 0. The check_hygiene hook PASSES
#   (exit 0) on the reverted file, having REFUSED (exit 2) the probe build.
#   THE A-1 PROBE RAN AND WAS REVERTED 2026-09-24. It did its job: A-1 PASSED on
#   live evidence (USDCADS 708972, 10:12:46.711). Do not re-run it - the row is closed.
#   The three-layer reminder (hook / this banner / CLAUDE.md section 0 step 6) is
#   PROVEN END TO END: the hook caught a real probe, not just a synthetic test.
# HISTORY: the E9-Q3 / QQ1 option (b) probe was Jeff's call 2026-09-24, built, run and
#   reverted the same day. This banner stays as the STANDING mechanism for the NEXT
#   probe, whenever one is needed - it is not specific to that one.
# THE RULE: a probe NEVER reaches Gate Zero, a seal, or the MT5 tree.
# THREE INDEPENDENT REMINDERS EXIST SO THIS CANNOT BE FORGOTTEN:
#   (1) THIS BANNER - the resume protocol reads STATE.md's header first, every session.
#   (2) .claude/hooks/check_hygiene.sh REFUSES (exit 2) any .mq5/.mqh write containing
#       "TEMPORARY DIAGNOSTIC" or "REMOVE BEFORE ANY SEAL". Tested 2026-09-24: clean
#       b42 passes, a marked file is refused. The hook is the WALL; this banner explains it.
#   (3) CLAUDE.md section 0 step 7 - the resume protocol checks this banner explicitly.
# PRECEDENT: the 2026-08-19 quote probe was reverted BY HAND to a byte-identical build
# with an empty git diff. It worked, but it depended on memory. This does not.
# ############################################################################

build: b46
file: TRTM.mq5
sha256_16: df5d2ae97c3137a7
lines: 5701
date: 2026-10-05
# *** b45 BUILT 2026-10-05, AWAITING GATE ZERO (Jeff compiles). *** E9-R1 drawdown auto
#   close - the inert-input defect. The three DD inputs existed in the dialog since the
#   original layout and NO CODE READ THEM: ticking the box and setting 2% did nothing, and
#   said nothing. Jeff found it by enabling it live and watching it not fire.
#   b45 implements it per locked D1-D6: cap = MIN of the two positive limits, per SYMBOL,
#   percent of BALANCE; enforced as a BOUNDARY SL every leg adopts (broker-held, so it
#   fires with MT5 closed) derived from the FULL ANTICIPATED GRID and re-derived on every
#   STRUCTURAL change. Both-limits-off now REFUSES TO ARM loudly instead of silently.
#   Previous: b44 57bc3811df272e40 / 5224 lines.
#   SCOPE: adds an EVALUATOR, a PROJECTION and a GUARD. Reuses the SEALED ComputeLevelLot()
#     for every projected lot and ONE shared NextLadderPrice() for the interval step, so the
#     projection and the live recovery engine CANNOT drift (matrix B-3, the biggest build risk).
#   b44's E9-Q2 keep logic, the 90-day expiry, the three DD-reduction tiers and state schema v5
#     are ALL UNTOUCHED. The boundary is DERIVED-ONLY - nothing new is persisted, no schema bump.
#   REPO src    = b46 (df5d2ae97c3137a7 / 5701)  <- this manifest tracks REPO.
#   MT5 runtime = b44 (57bc3811df272e40 / 5224) *** NOT YET ALIGNED - GATE ZERO PENDING. ***
#     Jeff compiles at the LIVE path; expect "=== TRTM b45 init ===" and a clean self-test.
# E9-Q2-D2: the b43 GATE 4 FAIL fix. An UNKNOWN record is NEVER loaded into g_state - "keep
#   the record" means PRESERVE THE FILE, not resurrect an unconfirmed ticket as a live
#   sequence. Implements sealed matrix rev 2 rows A-7 / A-8 / A-9.
# DELTA FROM b43: +14 lines (2 code, 12 comment). ONE statement changed:
#   `g_state = file;`  ->  `StateReset(g_state); g_state.lastCloseTime = lastClose;`
#   Verified by direct diff against the b43 baseline - nothing else differs but the tag.
# HYGIENE: 0 bare LF, ASCII-only, brace delta -1 (baseline-preserved), paren 0, bracket 0.
# NO new input, NO new global, NO new persisted field, schema STAYS 5, NO new file.
# Prior build: b43 (88fa5ce0cbea7920 / 5210, Gate Zero passed 2026-10-03, NOT sealed - it
#   carries the A-8 defect and must NOT be deployed).
# b43 BUILT 2026-10-02. GATE ZERO PASSED 2026-10-03 00:00:40 (XAUUSDS 715358, clean init).
#   NOT SEALED - Groups A/B verification outstanding (the fixtures).
#   REPO src    = b43 (88fa5ce0cbea7920 / 5210)  <- this manifest tracks REPO.
#   MT5 runtime = b43 (88fa5ce0cbea7920 / 5210) ALIGNED 2026-10-03, verified byte-identical
#     at the LIVE path with 0 probe markers.
# C-4 PASSED AT GATE ZERO, ON EVIDENCE: the init logged "Reconcile complete: FLAT" and
#   NOTHING ELSE NEW. The state file was a flat marker (levelCount 0), so the unchanged
#   `if(haveFile && file.levelCount > 0)` guard correctly SKIPPED the whole classification
#   block. A healthy run gains ZERO new log lines - the UNKNOWN path is unreachable when
#   there is nothing to classify. That is the must-NOT row, closed on a real init.
#   The self-test also PASSED with TRTM_UNKNOWN_MAX_AGE_SEC in scope (no schema impact).
# E9-Q2: directional record management. The EA no longer deletes a position record on an
#   ABSENCE of evidence - deletion requires MT5 to AFFIRM closure via a closing deal.
# HYGIENE: 0 bare LF, ASCII-only, brace delta -1 (baseline-preserved), paren 0, bracket 0.
# DELTA: +98 lines (5112 -> 5210): 58 code, 47 comment, rest blank. NO new input, NO new
#   global, NO new persisted field, state schema UNCHANGED at 5, NO new file.
# Prior SEALED build: b42 (9209dbe131c9d651 / 5112, sealed 2026-10-02, commit 83af0ba).
# *** b42 SEALED BY JEFF 2026-10-02 *** E9-Q3 retcode validity. All six gates cleared.
#   Built 2026-09-24. Gate Zero passed 2026-09-24 (USDCADS) and again on genuinely clean b42
#   2026-10-02 13:14:52 (XAUUSDS) after the probe incident. Gate 4 complete: A-1/A-2/D-3 and
#   C-1/C-2/C-4 on LIVE evidence, the rest on inspection + filtered diff (B-2 inspection-
#   closed on Jeff's call, recorded honestly as such).
#   REPO src    = b42 (9209dbe131c9d651 / 5112)  <- this manifest tracks REPO.
#   MT5 runtime = b42 (9209dbe131c9d651 / 5112) ALIGNED 2026-10-02 13:14 - compiled by Jeff
#     at the LIVE path (Terminal/55DBD2FC.../MQL5/Experts/FA_EA/), verified byte-identical
#     with 0 probe markers. The D0E8209F copy is STALE b41 and is NOT the runtime - see the
#     corrected path note in CLAUDE.md section 0 and the probe incident below.
# E9-Q3: retcode validity. g_trade.Result*() was read after CTrade returned false WITHOUT
#   reaching OrderSend, so the EA reported the PREVIOUS order's retcode as this call's.
# HYGIENE: 0 bare LF, ASCII-only, brace delta -1 (baseline-preserved), paren 0, bracket 0.
# *** THE MANIFEST SHA DESCRIBES THE WORKING / RUNTIME FILE, NOT THE GIT BLOB. ***
#   git normalizes CRLF -> LF on commit in this repo, so the committed blob of the SAME
#   content hashes DIFFERENTLY: working 9209dbe131c9d651 (256167 bytes, 5112 CRLF, 0 bare
#   LF) vs `git show HEAD:src/TRTM.mq5 | sha256sum` 8893ec931e1cf706 (251055 bytes, 5112
#   bare LF). The 5112-byte gap is exactly the stripped CR bytes; content verified
#   IDENTICAL ignoring EOL. This is PRE-EXISTING repo behaviour, not a b42 change - b41
#   behaves the same. The manifest tracks the file MetaEditor compiles and section 0
#   hashes, which is correct. A `git show | sha256sum` mismatch is EXPECTED and is NOT
#   drift - do not declare a STOP on it.
# DELTA: +49 lines (5063 -> 5112). NO new input, NO new global, NO new persisted field,
#   state schema UNCHANGED at 5. Exactly ONE deletion in the whole diff: the build tag.
# Prior SEALED build: b41 (d2354c4c1269874e / 5063, 2026-08-19).
# b41 SEALED BY JEFF 2026-08-19. E9-M1 reconcile discriminator + state schema 4 -> 5.
#   REPO src    = b41 (d2354c4c1269874e / 5063)  <- this manifest tracks REPO.
#   MT5 runtime = b41 (d2354c4c1269874e / 5063) - DEPLOYED on a FLAT sequence 2026-08-19
#     19:50 (Doo XAUUSD.s, magic 715358) per b41-C1's condition. Repo and runtime ALIGNED.
# GATE ZERO: PASSED 2026-08-19 - 0 errors, 0 warnings, AFTER the K-4 withdrawal (the only
#   warning was the withdrawn code's string->number conversion).
# HYGIENE: 0 bare LF, ASCII-only, brace delta -1 (baseline-preserved), paren 0, bracket 0.
# DELTA: +89 lines (4974 -> 5063). NO new input, NO new global. TWO new PERSISTED fields.
# GATE 4 CLOSED ON EVIDENCE 2026-08-19 (tests/2026.08.19 212941.548..txt):
#   B-1 the row RUN H FAILED - reconcile no longer adopts the EA's own applied TP.
#   B-2 discriminator proven: a removal REVERTED, a real edit ADOPTED, back to back.
#   D-1 Tier 3 fire recomputed INDEPENDENTLY on BOTH derivations, agreeing to 8 decimals.
#   C-1..C-5 closed at deploy (self-test PASS, the strengthened discard WARN fired verbatim).
# SCOPE CUT, ON THE RECORD: K-4 (Group A, rows A-1..A-8) was WITHDRAWN at Gate Zero when
#   the fix proved impossible as planned - CTrade cannot comment a close. Those rows are
#   NEITHER CLOSED NOR FAILED, and K-4 is parked to E9. b41-S1's escape hatch fired in the
#   opposite direction from the one it predicted.
# Prior SEALED build: b40 (2e902e9032d820a9 / 4974, documentation-only, 2026-07-30).
# b40 - DOCUMENTATION-ONLY BUILD, 2026-07-30. NOT a behaviour change.
#   REPO src    = b40 (2e902e9032d820a9 / 4974)  <- this manifest tracks REPO.
#   MT5 runtime = b40 (2e902e9032d820a9 / 4974) - DEPLOYED + RECOMPILED by Jeff
#     2026-07-30, verified byte-identical to repo. EA re-initialized "=== TRTM b40
#     init ===" on XAUUSD.s (magic 715358), self-test PASS, Reconcile FLAT, stops
#     level 100 pts. Repo and runtime ALIGNED - the resume protocol should say so.
# WHY: the file header still claimed Stage 5 "[>] in progress" and Stages 6/7 "[ ]"
#   unbuilt - both sealed weeks ago - and four other comment blocks asserted states that
#   had since become false. A comment that lies is worse than no comment: the next cold
#   start reads it as truth.
# PROVEN COMMENT-ONLY: `git diff -U0` filtered to non-comment lines shows EXACTLY ONE
#   changed line on each side - "#define TRTM_BUILD b39" -> "b40". Nothing else
#   executable was added or removed. b40 is BEHAVIOURALLY IDENTICAL to b39, so every
#   b39 Gate 4 evidence row carries forward UNCHANGED and needs no re-run.
# SIX FIXES:
#   1. File header - stage status was 3 builds stale. Now lists Stages 1-10 sealed,
#      E1/E4/E5/E6/b39 sealed (with b39's caveat named), backlog, and a note that the
#      "Stage N (bNN)" / "E4 C-1" / "matrix W-3" markers are the AUDIT TRAIL, not noise.
#   2. NormalizeSymbol - "Stage 2 WILL reuse this" (it shipped). Now also records the
#      E9-P2 consumer and the W-7 evidence: XAUUSD.s -> XAUUSDS (715358) vs XAUUSD+ ->
#      XAUUSD (758105), so Jeff's two accounts CANNOT collide.
#   3. StateSave/Load header - "later stages" (they are done). Now states the b2 flat-
#      marker rule instead.
#   4. Exit-engine header - said avg-entry TP and SL re-anchoring were "DORMANT until
#      Stage 4" and that ALL manual edits are reverted. Both false since Stage 4/Stage 8:
#      every exit path is live, and b24-b28 CLASSIFY non-zero manual edits (adopt or
#      refuse) rather than blanket-revert. Also records E1's lot-weighted VWAP basis.
#   5/6. Two comments written during b39 cited LINE NUMBERS that b39's own edits then
#      shifted (ComputeRecoveryTrigger "2009-2011", Reconcile's baseLot WARN "2766+").
#      Replaced with function-name references - line numbers rot on every build.
# GATE ZERO: PASSED 2026-07-30 - 0 errors, 0 warnings, 2214 ms, cpu='X64 Regular'.
# HYGIENE: 0 bare LF, ASCII-only, brace/paren/bracket deltas all 0.
# DELTA: +35 lines (4939 -> 4974), all comment text.
# Prior SEALED build: b39 (12c69766c709bd0d / 4939, sealed 2026-07-30, commit aed4b26).
# b39 SEALED BY JEFF 2026-07-30 - WITH ONE EXPLICIT CAVEAT, SEE BELOW. Async-fill
# registration hotfix, implemented per the CONFIRMED plan docs/B39_PLAN_2026-07-29_gate3.md
# (10 touch points) + TP-11 (E9-P6) added at a post-build audit. GATE ZERO PASSED,
# DEPLOYED, GATE 4 CLOSED WITH CAVEAT, SEALED.
# b39 superseded E6-b38. SUPERSEDED IN TURN by b40 (documentation-only, see the header
# above) - b40 is BEHAVIOURALLY IDENTICAL, so everything below stands unchanged.
#   b39 identity for the record = 12c69766c709bd0d / 4939, deployed 2026-07-29.
# *** SEAL CAVEAT - RETIRED 2026-08-18 ON LIVE EVIDENCE (Jeff's word) ***
#   The caveat below stood from the b39 seal until 2026-08-18. It is now RETIRED: the
#   watcher ADOPTED A POSITION on the Cent LIVE account, unprompted, and the three-line
#   retirement signature the caveat itself specified appeared in order. Evidence and the
#   row-by-row audit are in the Gate 4 log section "WATCHER CAVEAT RETIRED". A-1 and
#   W-1..W-5 are CLOSED ON EVIDENCE; W-6 is closed SPLIT (see there). The caveat text is
#   preserved verbatim below because the reasoning that produced it is still the record of
#   why those rows were ever inspection-only - do not delete it, and do not read it as
#   still-open.
#   [HISTORICAL, SUPERSEDED] "A-1 and W-1..W-6 closed on CODE INSPECTION, NOT EVIDENCE.
#   WatchUntrackedLevels has never adopted a position in any run. On Vantage the
#   TRADE_RETCODE_PLACED signature is ROUTINE (reproduced live, Run 5) but the fill lands
#   within the tick, so the fast path never missed. The registration MISS behind the
#   2026-07-27 incident is a TIMING TAIL, not reproducible on demand on any account
#   available. Jeff will not run further tests on the Cent LIVE account to chase it.
#   PARKED: if it recurs, the journal is the reproduction - 'order accepted but no
#   position yet' -> 'Watcher: L<n> REGISTERED' -> 'Exits applied' closes the rows on live
#   evidence; an orphan with NO watcher line is a b39 DEFECT, capture the log and reopen."
# GATE 4 CLOSED ON EVIDENCE: R-1 R-2 R-3 R-4 (no regression, 3 brokers, tester + live +
#   restart-with-open-positions), A-3, A-5, O-3, O-4 (the last three proven ON THE LIVE
#   CENT ACCOUNT that produced the incident), K-3, TP-10, E9-P2 (normalized comparator on
#   3 suffixes .s / + / .sc). Two Tier 3 fires recomputed to the cent on BOTH derivations.
#   PLUS, 2026-08-18: A-1, W-1, W-2, W-3, W-4, W-5 on live evidence; W-6 split.
# ALSO OPEN ON INSPECTION: L-1..L-4 (need a deliberately corrupted comment), F-1..F-5
#   (flat-state rebuild never triggered), K-1/K-2/K-4 (Run H not run).
#   [A-1 and W-1..W-6 were on this list until 2026-08-18 - now closed on evidence, see the
#    retirement note above. W-6's complexity half remains inspection-only by nature.]
#   [K-1/K-2(b) CLOSED ON EVIDENCE and K-4 CLOSED AS **FAIL** by RUN H 2026-08-18. Only
#    K-2(a) remains inherited. L-1/L-2/L-4 still inspection-only; L-3 now DEFENDED on live
#    evidence. See "RUN H - EXECUTED 2026-08-18".]
# GATE ZERO: PASSED 2026-07-29 - 0 errors, 0 warnings, 2590 ms, cpu='X64 Regular',
#   compiled from the REPO copy with MetaEditor64 (Vantage terminal build) against the
#   D0E8209F MQL5 include tree. The .ex5 and compile log were deleted after witnessing -
#   they are build artifacts, and the MT5 tree was NOT touched.
# HYGIENE: 0 bare LF, ASCII-only (0 bytes > 127), brace/paren/bracket deltas all 0 and
#   identical to the b38 baseline. No new input, no new global, NO NEW PERSISTED FIELD,
#   no state-schema change (R-3 by construction).
# DELTA: +265 lines (4674 -> 4939) across ELEVEN touch points, per the CONFIRMED plan
#   docs/B39_PLAN_2026-07-29_gate3.md + TP-11 (E9-P6, added at post-build audit).
# GATE ZERO RE-RUN after TP-11: 0 errors, 0 warnings, 2134 ms. Hygiene re-verified
#   (0 bare LF, ASCII-only, all delimiter deltas 0).
# CARRIED FORWARD to the next build (NOT fixed in b39):
#   (1) Run H (K-1/K-2) against an actual SLICED anchor on Vantage, + K-4 (do comments
#       survive a PARTIAL CLOSE on Vantage). Overdue since the E6 seal.
#       [DONE 2026-08-18: RUN EXECUTED. K-1 and K-2(b) PASS on evidence; K-4 answered and
#        it is a FAIL - comments do NOT survive, and the cause is TRTM's own untagged
#        slice order. NEW WORK ITEM: tag the slice order in SliceLegAtMarket (Gate 1).]
#   (2) T3-DS1 dashboard visual confirm (display-only, no money path).
#   (3) E9: O3 filling-mode negotiation, O4 netting guard, O5 exemode init guidance,
#       O6 comment-integrity detection, PLUS b39's own deferrals - the never-filled
#       timeout (E9-O2e), account-scoped identity (W-7), and unifying
#       AdoptionCandidateExists with TryAdopt (they duplicate admission logic today
#       and MUST be kept in step - see E9-P6).
# Prior SEALED build: E6-b38 (f7766c859e4d3c7a / 4674, sealed 2026-07-26, commit
#   8722fcc). b39 is UNCOMMITTED as of the seal - committing it is Jeff's call.
# E6-b38 SEALED BY JEFF 2026-07-26. Drawdown Reduction Tier 3 (partial-lot anchor
# slice) implemented per the CONFIRMED plan docs/E6_PLAN_2026-07-26_gate3.md (8 touch
# points, +106 lines 4568->4674). GATE ZERO PASSED, DEPLOYED, GATE 4 CLOSED, SEALED.
# E6-b38 is now the CURRENT SEALED BUILD (supersedes E5-b37).
#   REPO src    = E6-b38 (f7766c859e4d3c7a / 4674)  <- this manifest tracks REPO.
#   MT5 runtime = E6-b38 (f7766c859e4d3c7a / 4674)  - byte-identical to repo, no
#     deploy drift. Resume protocol should now show repo and runtime ALIGNED.
# GATE ZERO: compiled 2026-07-26 12:34:12 in Jeff's terminal - 0 errors, 0 warnings
#   (metaeditor.log; re-witnessed in-session at Jeff's request after an earlier
#   01:48:22 compile of the same byte-identical source, also 0/0). TRTM.ex5 rebuilt
#   12:35:02; EA re-initialized "=== TRTM E6-b38 init ===" on XAUUSD.s + BTCUST,
#   self-test PASS, Reconcile FLAT.
# GATE 4: CLOSED 2026-07-26. docs/E6_VERIFY_CHECKLIST.md - 36 rows: 32 closed on LIVE
#   evidence, 2 CODE-GUARANTEED (PR2/PR3, jump-only per the sealed E5 T2-PR1 precedent),
#   2 INHERITED (K1/K2, Run H not run - Jeff's call, residual risk recorded), 1
#   dose-response (T3-3), 1 display not visually confirmed (DS1, non-blocking).
#   TEN tester runs on XAUUSD.s real ticks -> 19 Tier 3 fires + 3 Tier 1 + 1 Tier 2, every
#   one recomputed to the cent on BOTH derivations (leg-by-leg AND marginPts x sumVol),
#   never disagreeing once.
# CARRIED FORWARD to the next build (NOT fixed now - a comment-only edit would re-bump the
#   manifest sha and break this seal's build identity):
#   (1) stale EvaluateBasketClose header comment 2300-2308; (2) Run H against an actual
#   sliced anchor before live deployment; (3) DS1 visual confirm.
# Prior SEALED build: E5-b37 (compiled+deployed+verified 2026-07-25, all 34 E5
# rows). E6-b38 is COMMITTED (8722fcc) and PUSHED (origin/main = 8722fcc); E5-b37
# (d094c65) and E4-b36 went up with it. Hygiene: 0 bare LF, ASCII-only, brace delta
# -1 (baseline-preserved), parens balanced; no new global, no new persisted field.

## b41 - GATE 1 OPEN (2026-08-18). TWO DEFECTS, ONE BUILD, TWO GATES, SEQUENCED.
LOCKED DECISION b41-S1 (scope + sequencing, Jeff's call 2026-08-18): ONE BUILD carrying
  BOTH the K-4 comment fix and the E9-M1 manual-TP-at-reconcile fix, but with SEPARATE
  Gate 1s run in sequence - K-4's decisions locked FIRST and its touch point landed
  FIRST, E9-M1's gated behind a diagnostic question that must resolve before it is scoped.
  WHY: both defects can only be verified against the SAME test shape - a sequence run to
  4+ levels, a Tier 3 fire, then a restart over the sliced anchor (exactly Run H's shape,
  now proven producible on the Vantage demo). One build means ONE such run instead of two.
  WHY SEQUENCED RATHER THAN MERGED: they are not equally ready. K-4's root cause is PROVEN
  from the broker report (untagged slice order), is one touch point, and needs NO state-
  schema change. E9-M1's leading fix candidate (persist lastAppliedTP/SL) IS a state-schema
  change, and it still carries an unresolved diagnostic question (below). Gating them
  together would put a one-line emission fix behind a schema change in the same unsealed
  build - and K-4 is the one with a live consequence today (every sliced position loses its
  identity, contained only by b39's O2b guard).
  ESCAPE HATCH, EXPLICIT: if E9-M1 does not resolve cleanly at its Gate 1, K-4 SHIPS ALONE
  as b41 and E9-M1 waits for b42. No coupling penalty is accepted to keep them together.
  REJECTED: (a) two separate builds - honest but costs two multi-level live runs, and the
  second would re-run the identical setup for no new coverage; (b) one build, one merged
  Gate 1 - fewer gate cycles, but couples a schema change to an emission fix and blocks the
  urgent item behind the harder one; (c) K-4 alone now, E9-M1 never scheduled - rejected,
  E9-M1 is a live misclassification on a money path and parking it indefinitely is how it
  gets forgotten.
GATE 1a (K-4) - OPEN, decisions being taken now.
LOCKED DECISION K4-D1 (slice order comment, Jeff's call 2026-08-18): THE SLICE ORDER
  CARRIES THE ANCHOR'S EXISTING TAG, RE-DERIVED from the same builder that writes it on
  open (the "_l" + level + "_" + buy/sell idiom at 2231). The position comment is therefore
  overwritten with the STRING IT ALREADY HAD, so it survives the partial close unchanged.
  ParseTag (671) keeps working untouched, RebuildLiveMap parses the real level, and b39's
  O2b fallback never fires on a sliced anchor. This restores the invariant E6's K-1
  inheritance argument ASSUMED but never verified ("level survives a partial close").
  WHY MINIMAL: the fix makes the slice comment-NEUTRAL rather than comment-DESTROYING, and
  it reuses an existing sealed builder instead of inventing a format. CTrade's
  PositionClosePartial has a comment overload, so this is a parameter addition, not a
  rewrite of SliceLegAtMarket.
  REJECTED: (a) a distinct slice marker (e.g. _l1_buy_s) recording that a slice occurred -
  genuinely useful for E9-O6 comment-integrity work, but ParseTag would have to tolerate
  the suffix, pulling SEALED Stage 1 comment PARSING into a build that otherwise only
  touches comment WRITING; (b) echo the anchor's current comment back verbatim via
  PositionGetString - cannot drift from the builder, but silently re-blanks a position
  whose comment is ALREADY empty (an adopted magic-0 L1, or anything sliced twice before
  this fix), which is exactly the failure case being repaired.
  NOT RETROACTIVE, ACCEPTED: positions already sliced under b40 keep their blank comments
  and will still hit the O2b guard on restart. That is fine - O2b is proven to work
  (Run H, 2026-08-18).
LOCKED DECISION K4-D2 (how the tag is re-derived, Jeff's call 2026-08-18): EXTRACT A
  SHARED HELPER. The tag builder is currently THREE INLINE LINES (2229-2231) inside the
  recovery-open path, and SliceLegAtMarket is a different function with no access to it.
  Extract BuildLevelTag(level, dir) and call it from BOTH sites, so there is exactly ONE
  definition of the tag format.
  WHY: option (b) below would duplicate the format across two call sites - which is
  PRECISELY the maintenance hazard already logged as E9-P6 (AdoptionCandidateExists
  duplicating TryAdopt's admission logic and needing to be kept in step). That hazard was
  accepted once, inside a hotfix, under protest. Knowingly creating a SECOND instance of
  the same pattern is a step backwards, and the whole point of K-4's fix is that a tag
  which silently diverges from its parser is what caused this defect class.
  COST ACCEPTED: this edits the SEALED Stage 4 recovery-open path - three lines become one
  call. Behaviour-identical by construction, and provable the way b40's comment-only claim
  was proven: a filtered diff showing the open path's emitted string is unchanged. Gate
  Zero + a live re-run of the recovery-open path (any multi-level sequence) must both
  confirm the tag on a NEWLY opened level is byte-identical to b40's.
  REJECTED: (a) duplicate the three lines inside SliceLegAtMarket - zero sealed-code edit,
  but creates the E9-P6 hazard a second time deliberately; (b) read the anchor's live
  comment and pass it through with a rebuild fallback - this is rejected D1 option (c)
  wearing a hat, and adds a branch to a money path for a case O2b already covers.
  SIGNATURE NOTE (implementation detail for Gate 3, not a locked decision):
  SliceLegAtMarket takes (ticket, level, sliceVol) and does NOT currently carry direction.
  It can either take a dir parameter or read g_state.direction, which is available
  globally. Parameter preferred for testability; either is acceptable.
GATE 1b (E9-M1) - DIAGNOSTIC RUN AND RESOLVED 2026-08-18. UNBLOCKED.
  FINDING: the Cent-account case is NOT a defect (full reasoning in the E9-M1 section's
  "SCOPE CORRECTED" block). E9-M1 therefore has EXACTLY ONE instance - the reconcile
  misclassification proven by Run H - and the fix scope NARROWS accordingly: one code path
  (ReconcileManualExits), one cause (g_lastAppliedTP/SL are runtime-only and reset on init),
  and the leading candidate (a) persist lastAppliedTP/SL is now the obvious shape rather
  than one of three guesses.
  CONSEQUENCE FOR b41-S1's ESCAPE HATCH: it is NOT needed. E9-M1 resolved cleanly, so both
  fixes proceed into one build as intended.
  STILL A STATE-SCHEMA CHANGE: candidate (a) adds persisted fields, so the schema version
  and StateLoad's back-compat path are in scope for the matrix (schema is currently 4).
  A b40-written state file MUST still load - that is a MUST-NOT row.
LOCKED DECISION E9M1-D1 (how reconcile learns what the EA last applied, Jeff's call
  2026-08-18): PERSIST lastAppliedTP / lastAppliedSL in the state file and SEED the runtime
  globals from it at load. The b25 anti-oscillation guard already exists and is
  sealed-proven; it simply cannot see across an init because g_lastAppliedTP/SL are runtime
  globals (1041) reset to 0.0 (1082). Persisting them lets the EXISTING guard do its job
  after a restart. Exact, no inference.
  REJECTED (a) DERIVE at reconcile - recompute the target from the PERSISTED level set and
  treat a matching broker value as the EA's own. Philosophically tidier and consistent with
  E4/E5/E6's "derive everything per tick" principle, but IT FAILS ON THE EXACT CASE THAT
  PRODUCED THE BUG: Run H's restart followed a Tier 3 SLICE, so the level set and lot
  weights had changed between the EA's last write (4401.17) and the reconcile. The
  derivation reproduces 4401.67, not 4401.17, and the guard still misses. Derivation only
  works when nothing changed while offline - which is the case that does not need a guard.
  REJECTED (b) SUPPRESS manual-TP adoption at reconcile when the recomputed target differs
  only because the level set changed. Smallest change, no schema bump, but it discards a
  GENUINE trader edit made while the EA was offline - which is precisely what M7-5 exists
  to honour. Sacrifices a sealed, deliberate feature to dodge a schema version.
  SCHEMA COST - CORRECTED 2026-08-18 AFTER READING StateLoad, AND IT IS BIGGER THAN FIRST
  STATED. An earlier draft of this decision claimed back-compat was "clean by construction"
  because an absent key defaults to 0. THAT IS WRONG. StateLoad (588-590) rejects the
  ENTIRE FILE on any schema mismatch: "schema mismatch or missing (found %d, expected %d)
  - discarding file". So bumping 4 -> 5 means a b40-written state file is DISCARDED on the
  first init after deploy, not loaded with defaults.
  WHAT DISCARDING ACTUALLY COSTS: the file carries direction, tickets, levels, baseLot,
  adoptedL1, the override flags, manualTP/SL and the timestamps. Discarding it forces
  Reconcile down its rebuild-from-broker path - which is EXACTLY the path Run H just proved
  works (T3-K1 PASS, rebuilt 4 levels/0.23 lots correctly from positions alone, including
  a sliced anchor with a BLANK comment). The real exposures are the fields that CANNOT be
  rebuilt from positions: the override flags and any live manualTP/SL.
  THIS IS NOW A GATE 2 MATRIX QUESTION, NOT A SETTLED COST. Three shapes to weigh there,
  none locked yet: (i) accept the discard and require deploy on a FLAT sequence (operational
  constraint, zero code); (ii) make StateLoad accept schema 4 as a readable legacy version,
  defaulting the two new keys - a real back-compat path, but it edits SEALED persistence
  code; (iii) do not bump the schema at all - add the keys and leave the version at 4, which
  makes b40 and b41 files mutually readable but silently mis-versioned, and is the option I
  would argue AGAINST on record-integrity grounds.
  MUST-NOT ROW REGARDLESS: no state-file transition may silently lose an ACTIVE override
  flag or a live manualSL. If the chosen shape can lose them, the deploy procedure must
  say so explicitly.

LOCKED DECISION E9M1-D2 (the Cent-account first-adoption ordering, Jeff's call
  2026-08-18): ACCEPT CURRENT BEHAVIOUR. NO CHANGE, NO NEW BACKLOG ITEM.
  THE QUESTION: at the Cent sequence's L2 open, the per-tick order was RELEASE (nothing to
  release - manualTP was still 0) -> ADOPT (Jeff's 4407.20, seen by the classifier for the
  first time) -> APPLY. So the manual TP survived a structure change not because the
  release failed, but because adoption happened AFTER it in the same tick. Jeff's stated
  intent ("a manual TP should only survive as long as the current state is intact") could
  be read as requiring first-time adoption to be suppressed on a structural tick.
  DECIDED: current behaviour stands. The TP was honoured because the EA genuinely had no
  computed alternative to assert (single level -> AvgTP not computable), and the moment one
  existed the release fired correctly - proven live at Run H 16:48:00, where the computed
  target took over on L5's open with no re-adoption. The window in which a manual TP can
  outlive its structure is NARROW: only before a second level exists.
  REJECTED: suppressing first-time adoption on the same tick as a structural change. It
  would need its own Gate 1, a change to SEALED b24 adoption semantics, and a matrix row
  for the trader who legitimately edits DURING a level add. Cost is not justified by a
  window this narrow.

## b41 GATE 2 - **SEALED 2026-08-19 BY JEFF**. docs/B41_MATRIX.md rev 1, 26 rows.
GATE 2 CLOSED. No row may change without Jeff re-opening the seal. Gate 3 (code plan) may
now be drafted. FOUR OBLIGATIONS carried onto that plan, recorded in the matrix's seal
block: (1) show how the new lastApplied discriminator composes with M7-8's releasedTP at
2816; (2) deploy note says DEPLOY ON FLAT + C-4's WARN names what a discard drops;
(3) prove the recovery-open path edit behaviour-identical by FILTERED DIFF; (4) state the
touch-point count and expected line delta up front for Gate Zero to check.

## b41 GATE 2 - matrix history (drafted 2026-08-18)
docs/B41_MATRIX.md drafted. 4 groups, 25 rows (A-1..A-8 K-4; B-1..B-8 E9-M1; C-1..C-4
schema; D-1..D-5 regression). MUST-NOT rows: A-3, A-4, B-2, B-3, C-1, D-1, D-2, D-3.
THE TWO ROWS THAT DEFINE THE BUILD: A-1 (a slice leaves the anchor's comment intact) and
B-1 (reconcile does not adopt the EA's own computed TP) - both are rows RUN H FAILED.

FINDING MADE WHILE DRAFTING - E9-M1 IS NARROWER AND SAFER THAN STATED AT GATE 1:
  Reconcile ALREADY HAS this guard. b28's M7-8 (2744-2757) keeps `releasedTP` precisely so
  the M7-5 branch cannot re-adopt the EA's own pre-kill propagation as a trader edit; its
  own code comment calls it "the reconcile-path analogue of the b25/M5-6 discriminator".
  It did not fire in Run H because it arms ONLY when g_state.manualTP > 0.0 - a MANUAL TP
  owned before the kill. Run H's 4401.17 was purely COMPUTED, so releasedTP stayed 0 and
  M7-5 adopted freely.
  => E9-M1 is the SAME DEFECT CLASS AS M7-8, ONE CASE WIDER: the EA's own stale write goes
     unrecognised when the value was COMPUTED rather than MANUAL. Persisting
     lastAppliedTP/SL GENERALISES a sealed, working idiom rather than introducing a new
     mechanism - lower risk than Gate 1 assumed. It also creates an obligation: B-3 must
     prove the new guard does not shadow or duplicate M7-8, since both now sit on the same
     branch.

ALL THREE QUESTIONS ANSWERED 2026-08-19 - MATRIX READY TO SEAL (26 rows).
LOCKED DECISION b41-C1 (Q1, schema shape): SHAPE (i) - bump TRTM_STATE_SCHEMA 4 -> 5,
  accept the discard of a b40 file, DEPLOY ON A FLAT SEQUENCE.
  THE FACT THAT DECIDED IT: StateSave runs at the END of Reconcile (2980) on EVERY init, so
  the discard is repaired within the SAME OnInit - load discards -> rebuild from broker ->
  save schema 5, milliseconds apart. Every restart after that first init (crash, power
  loss, MT5 update, chart change) loads normally. THE CRASH SCENARIO THEREFORE DOES NOT
  DISTINGUISH (i) FROM (ii); the whole difference reduces to ONE controllable event.
  (An earlier analysis in this session claimed the exposure ran "until the first b41 state
   write" and implied an ongoing risk across restarts. WRONG - corrected by reading the
   save sites. Recorded so it is not re-derived.)
  NOT RECOVERABLE if b41 is deployed over a LIVE sequence: the override flags, manualSL,
  and adoptedL1 (the last is the serious one - the position would go unmanaged). Deploy on
  flat eliminates all three.
  REJECTED (ii) legacy-read schema 4: buys protection for a single controllable init and
  pays with a permanent silent-partial-load pattern on the gate every state read passes
  through; the self-test would stay GREEN on a subtly wrong legacy branch (it only
  exercises the new path); it invites unsafe extension at the next bump where a field's
  MEANING changes; rollback to b40 discards a schema-5 file anyway, so the symmetry it
  implies is false; and it does not close the adoptedL1 hole (see E9-M4).
  REJECTED (iii) no bump: two formats sharing version 4 forfeits the versioning invariant
  and contradicts the contract at line 152.
  CONDITIONS ATTACHED: (1) C-4 strengthened - the discard WARN must NAME what was lost;
  (2) the b41 deploy note must say DEPLOY ON A FLAT SEQUENCE. Both are matrix obligations.
  HONESTY NOTE recorded in the matrix: C-1 is closed BY PROCEDURE, not by construction.
Q2 (A-6, O2b) and Q3 (B-3, M7-8) both ANSWERED: close on INSPECTION. A-6 rests on Run H's
  live evidence that a blank comment yields "counted as L1" and never becomes the anchor;
  exercising it freshly would pull L-1..L-4's deliberate-corruption setup into scope. Q3
  carries an obligation onto the Gate 3 plan: show the branch order at 2816 and state how
  the new discriminator composes with M7-8's releasedTP.

ALSO SURFACED BY THIS ANALYSIS: E9-M4 (adoptedL1 unrecoverable on ANY state-file loss).
  Standing property of b40 today, not a b41 defect. Parked - see its own section.

## b41 GATE 3 - PLAN DRAFTED 2026-08-19, NOT CONFIRMED
docs/B41_PLAN_2026-08-19_gate3.md. TEN touch points, all in src/TRTM.mq5, expected delta
~+61/-10 (net ~+51, 4974 -> ~5025). NO new input, NO new global; TWO new PERSISTED fields
(lastAppliedTP/SL) and schema 4 -> 5.
ALL FOUR MATRIX OBLIGATIONS DISCHARGED IN THE PLAN:
  (1) The discriminator composition is spelled out: b41 INSERTS a second "EA's own" test
      AFTER M7-8's, never replacing it. M7-8 is tested FIRST, so where both could claim the
      same value (a manual TP that was also the last applied) M7-8 wins and its sealed log
      wording is preserved. b28's behaviour is bit-identical in every case it already
      covered; b41 only catches what M7-8 declined (releasedTP == 0). ORDER MUST NOT BE
      SWAPPED - that ordering is what makes B-3 true.
  (2) C-4's new WARN text is written out in full, naming override flags / manual SL /
      adopted-L1 as what a discard drops, plus the deploy-on-flat instruction.
  (3) The recovery-open edit is a VERBATIM lift of 2229-2231 into BuildLevelTag, to be
      proven by filtered diff against the Run H baseline strings (xauusd_l2_buy ..
      xauusd_l8_buy).
  (4) Touch-point count and line delta stated up front for Gate Zero to check.
BUILD ORDER: K-4 first (TP1/2/10), then persistence+schema, then the discriminator - so a
  failure in the later steps still leaves a coherent K-4-only build and b41-S1's escape
  hatch usable without unpicking work.
STALE COMMENT FOUND: 1038-1040 says g_lastAppliedTP/SL are "deliberately NOT persisted:
  under policy A ... (scenario S7)". POLICY A WAS RETIRED WITH b24 (see line 1742 of this
  file), so E9M1-D1 is not contradicting a live decision - it is updating a comment that
  outlived its reasoning. The plan says so explicitly so no cold read misreads it.
ONE OPEN QUESTION (QP1): whether to also SEED the runtime globals from the file at
  reconcile. Strictly more correct but beyond the minimum B-1 needs. RECOMMEND INCLUDE -
  excluding it leaves a one-apply-cycle blind window after every restart, the same class of
  hole as E9-M1 itself.

## b41 SCOPE CUT 2026-08-19 - K-4 WITHDRAWN AT GATE ZERO, E9-M1 SHIPS ALONE
GATE ZERO DID ITS JOB. The K-4 fix does not compile as planned:
  "implicit conversion from 'string' to 'number'" at the PositionClosePartial call.
ROOT CAUSE - A GATE 3 PLANNING ERROR, MINE: the plan stated "CTrade's
  PositionClosePartial has a comment overload, so this is a parameter addition, not a
  rewrite". IT DOES NOT. The signature is (ticket, volume, ulong DEVIATION) and the
  implementation NEVER sets m_request.comment - only PositionOpen does (Trade.mqh 334).
  The overload was INFERRED from PositionOpen's shape and never verified against the
  header. Verified now, after the fact: Trade.mqh 104-105 and 599-640.
HOW IT WOULD HAVE FAILED SILENTLY IF THE WARNING HAD BEEN IGNORED: it compiles as a
  WARNING, not an error. The tag string converts to a garbage deviation, the slice order
  still carries NO comment, and A-1 fails at the verification run - presenting as a broker
  behaviour rather than as our own bug. Warnings are not cosmetic; this one was the defect.
DECISION (Jeff, 2026-08-19): ADDRESS K-4 SEPARATELY LATER. Not fixed another way in b41.
  WHY: the only remaining route is a hand-built MqlTradeRequest + OrderSend - a SECOND
  close path, which the sealed E4 X-4 rationale deliberately avoided ("no new close path
  invented"). That price is not justified against a defect b39's O2b ALREADY CONTAINS.
  EVIDENCE FOR THE CONTAINMENT: Run H restarted over a blank-comment sliced anchor and
  rebuilt CORRECTLY (T3-K1 PASS, 4 levels / 0.23 lots, anchor at L1).
  RESIDUAL RISK, STATED HONESTLY: O2b assigns maxLvl+1, so if a restart scans the sliced
  anchor AFTER other levels it gets a HIGH level and FormBasketGroup anchors on the wrong
  position - affecting SL anchoring and the next Tier 3 slice target. Volumes and entries
  are read live, so TP/PL arithmetic stays correct. Low-moderate, restart-only.
  -> K-4 PARKED TO E9, alongside O6 comment-integrity detection (same problem area,
     should be designed together).
COST/BENEFIT CORRECTION ON THE RECORD: when K4-D1 was locked at Gate 1 I believed the fix
  was a one-parameter addition. It is ~25 lines bypassing the sealed CTrade wrapper. Had
  that been known at Gate 1, K-4 would likely not have been bundled into b41 at all.
WHAT b41 STILL SHIPS: Group B (E9-M1) + Group C (schema 4->5) + Group D (regression).
  b41-S1's escape hatch fired - in the OPPOSITE direction from the one it predicted.
KEPT FROM THE K-4 WORK: BuildLevelTag (K4-D2). The one-definition rule stands on its own,
  the extraction is proven behaviour-identical by filtered diff, and the eventual E9 fix
  will call exactly it. Its sole caller today is the recovery-open path.

## b41 BUILT 2026-08-19 - GATE ZERO NOT YET RUN, NOT DEPLOYED
Plan CONFIRMED by Jeff (QP1 answered: INCLUDE the seeding). All TEN touch points written
per docs/B41_PLAN_2026-08-19_gate3.md, plus ONE addition noted below.
  BUILD b41  sha256_16 d2354c4c1269874e  /  5063 lines  (b40 was 2e902e9032d820a9 / 4974)
  (identity revised twice on 2026-08-19, both BEFORE any deploy: a comment-only header
   cleanup, then the K-4 scope cut above. Earlier code builds for the record:
   79b367bfa57b0b14 / 5045 (pre-cleanup) and dba6c661efdbc09f / 5055 (pre-scope-cut).)
  (identity revised 2026-08-19 by a COMMENT-ONLY header cleanup folded in BEFORE Gate Zero -
   see "b41 HEADER CLEANUP" below. The pre-cleanup code build was 79b367bfa57b0b14 / 5045.)
  DELTA +71 lines. The plan predicted ~+51 (~5025); the overrun is COMMENT VOLUME, not
  extra logic - the filtered diff below is exactly the ten planned edits and nothing else.
  Stated plainly rather than quietly: the estimate was low, the code was not.
HYGIENE: 0 bare LF, ASCII-only (0 bytes > 127), brace delta -1 (IDENTICAL to the sealed b40
  baseline, preserved), paren 0, bracket 0.
NEW INPUT: none. NEW GLOBAL: none. NEW PERSISTED FIELDS: two. SCHEMA: 4 -> 5.

ONE ADDITION BEYOND THE TEN TOUCH POINTS (declared, not slipped in): the persistence
  SELF-TEST was extended to round-trip lastAppliedTP/SL, following the b24 precedent that
  added manualTP/SL to it. Matrix row C-2 requires the round-trip to cover the new fields
  and the plan omitted the self-test as a touch point - that was a gap in the plan, not a
  scope change. Two write lines + two assert lines.

FILTERED DIFF (non-comment changed lines) maps 1:1 to the plan:
  TRTM_BUILD b40 -> b41; TRTM_STATE_SCHEMA 4 -> 5; struct +2 fields; StateReset +2 defaults;
  StateToJson +2; StateLoad +2 defaults +2 parses; the C-4 WARN text; BuildLevelTag (new);
  SliceLegAtMarket signature + the tagged PositionClosePartial; its call site; the
  recovery-open path's 3 lines -> 1 call; the apply site writing struct+global together;
  the TP-side E9-M1 discriminator; the SL-side E9-M1 discriminator; the reconcile seeding.
  NOTHING ELSE CHANGED.

A-4 PROOF (matrix obligation 3): BuildLevelTag's body is TOKEN-IDENTICAL to the three lines
  it replaced - same globals, same operators, same order (g_symbolNorm -> StringToLower ->
  "_l" + level + "_" + buy/sell). The emitted string cannot differ. Live confirmation still
  required at verification: L2..LN comments must match the Run H baseline byte-for-byte.

HYGIENE INCIDENT WORTH RECORDING: an intermediate edit normalized the file to bare LF
  (5041 bare LF at one point). Caught by the hygiene check BEFORE any commit and repaired -
  the file is CRLF throughout again, 0 bare LF. No bad state was ever committed, but the
  lesson is that the scripted edits must preserve line endings explicitly.

## b41 HEADER CLEANUP - COMMENT-ONLY, folded in 2026-08-19 BEFORE Gate Zero
Jeff asked for a stale-comment sweep (the same class of work b40 existed to do). Folded
into b41 rather than deferred to a b42 docs build BECAUSE b41 had not been compiled or
deployed - there was no build identity carrying evidence to invalidate. (Contrast E6-b38,
which deliberately deferred exactly this kind of edit: there, a comment-only change WOULD
have broken a sealed build's identity. That reasoning does not apply to an uncompiled build.)
PROVEN COMMENT-ONLY: `git diff -U0` filtered to non-comment lines is EMPTY - zero
executable lines changed. Same proof standard b40 used.
THREE FIXES:
  1. THE IMPORTANT ONE - the file header still said the b39 watcher "has never adopted a
     position in testing". FALSE since 2026-08-18: it adopted on the LIVE Cent account,
     unprompted, and Jeff retired the caveat. A cold start reads this header first, so a
     retired caveat presented as live is exactly the "comment that lies" b40 was built to
     eliminate. Now records the retirement and how it happened.
  2. Provenance list ended at b39 - b40 and b41 were absent, and the Stage 8 line did not
     record that b41 extended its reconcile classification. Both added.
  3. LINE-NUMBER ROT I INTRODUCED MYSELF, one day old: BuildLevelTag's comment (written
     2026-08-19 in the b41 build) said "ParseTag (671)". b41's own edits had already pushed
     ParseTag to 685. This is precisely the rot b40 fixed twice, reintroduced by me in the
     very build after it. Replaced with a function-name reference, per b40's own rule that
     line numbers rot on every build. Worth recording as a recurring failure mode, not a
     one-off slip.
ALSO FIXED: the 13 new header lines were 71 chars against a 70-char box border. Trimmed to
  match; the whole header block is now uniformly 70.
HYGIENE RE-VERIFIED AFTER THE CLEANUP: 0 bare LF, ASCII-only, brace -1 (baseline-preserved),
  paren 0, bracket 0.

## b41 VERIFICATION RUN COMPLETE 2026-08-19 - B-1, B-2, D-1 ALL PASS ON EVIDENCE
EVIDENCE: tests/2026.08.19 212941.548..txt, DooTechnology XAUUSD.s, magic 715358, b41
(d2354c4c1269874e / 5063), live chart M1. Config per the sealed matrix's verification
shape: entry 0.05, Tier 3 ON, MinTrades 4, MinProfitPts 200, MinLots 0.02, ClosePercent 50,
Tiers 1+2 OFF, trailing OFF, BE OFF, SL 0, interval 150, RecoveryTF M1.

B-1 *** THE ROW RUN H FAILED - NOW PASSES *** CLOSED ON EVIDENCE.
  21:50:01  "Exits applied to ticket 743845988: TP 4457.93"  <- the EA's OWN computed value,
            propagated to all FOUR tickets.
  21:50:27  "Deinit (reason 1) - state saved (sequence alive)"
  21:50:36  init -> "Reconcile: flags restored" -> "Structure: 4 level(s), 0.26 lots" ->
            "Reconcile complete: dir=BUY levels=4"
  THERE IS NO "adopted as manual (M7-5)" LINE. Under b40 this is EXACTLY where Run H
  produced "TP edited to 4401.17 while EA was offline (computed 4401.67) - adopted as
  manual (M7-5)". The E9-M1 defect is FIXED.
  NOTE ON THE SILENCE: the new E9-M1 log line did not fire either, and that is correct -
  the broker value MATCHED the persisted lastAppliedTP, so the branch reached its "do not
  adopt" conclusion. The row is proven by the ABSENCE of the M7-5 adoption plus the correct
  rebuild (4 levels / 0.26 lots, identical to pre-restart), not by a new line.

B-2 MUST-NOT (a GENUINE trader edit is STILL adopted) - CLOSED ON EQUIVALENT EVIDENCE.
  The run exercised BOTH classification outcomes back to back:
  21:50:49  "Manual TP REMOVAL on ticket 743853940 - reverted to 4457.93 (removals are
            never adopted)"                                    -> REVERT branch
  21:51:06  "Manual TP 4459.25 ADOPTED (was 4455.85) - RISK: target moved 340 pts farther
            from price"                                        -> ADOPT branch, then
            propagated to all four positions.
  SO THE FIX IS A DISCRIMINATOR, NOT BLANKET SUPPRESSION - which is the whole point of this
  MUST-NOT row.
  HONEST QUALIFICATION, NOT ROUNDED UP: B-2 as written asks for an edit made while the EA
  is OFFLINE. These were made LIVE. The classification code path is the same and the
  outcome is the one the row demands, so it closes on EQUIVALENT evidence - not identical.
  Recorded this way deliberately.

D-1 MUST-NOT (Tier 3 arithmetic unchanged, recomputed on BOTH derivations) - CLOSED ON
  EVIDENCE, and RECOMPUTED INDEPENDENTLY HERE rather than taken from the log:
  21:52:26  "Tier 3 FIRE: BUY group 3 leg(s) (anchor L1 slice 0.02 of 0.05 + 2 profitable)
            | sliced-VWAP 4450.13 far 4452.37 margin 223.7 pts >= 200/lot"
  Sliced group = L1 slice 0.02 @ 4461.52 + L4 0.08 @ 4450.44 + L5 0.09 @ 4447.33.
    VWAP  = (0.02*4461.52 + 0.08*4450.44 + 0.09*4447.33) / 0.19
          = 845.5253 / 0.19 = 4450.1332      -> log 4450.13  MATCH
    margin= 4452.37 - 4450.1332 = 2.2368     = 223.7 pts     -> log 223.7  MATCH
  BOTH DERIVATIONS (the E6 standard):
    leg-by-leg  sum((far - entry) * vol) = 0.42500000
    marginPts x sumVol = 2.2368 * 0.19    = 0.42500000
    AGREE to 8 decimal places.
  Structure after the fire: 0.35 - 0.09 (L5) - 0.08 (L4) - 0.02 (slice) = 0.16, and the log
  reads "Structure: 3 level(s), 0.16 lots". MATCH. Anchor survives at 0.03 of its 0.05.
  => E6's money path is UNCHANGED by b41.

BONUS ROW, NOT REQUIRED BUT WORTH RECORDING: at 21:52:27 the fire's level closes triggered
  "Manual TP 4459.25 RELEASED - level close (structure changed: computed target
  re-asserted)" and the computed 4459.67 re-asserted on the three survivors. That is the
  b24 structural-release rule working correctly on a LEVEL CLOSE - the same asymmetric
  TP-releases/SL-persists behaviour whose intent Jeff re-confirmed on 2026-08-18, and it
  independently corroborates the E9M1-D2 decision to leave that path alone.

GROUP A (K-4) NOT ATTEMPTED - withdrawn from b41 at Gate Zero. Rows A-1..A-8 are neither
  closed nor failed. K-4 is parked to E9.

## STALE-QUOTE INCIDENT 2026-08-19 - RESOLVED, NOT A TRTM DEFECT. PROBES REMOVED.
OUTCOME: a TERMINAL RESTART cleared it. Nothing in TRTM was at fault, and no TRTM code
change was made - the probe build was reverted to byte-identical b41 (d2354c4c1269874e /
5063), confirmed by an EMPTY `git diff` against the scope-cut commit. The deployed build
identity is therefore UNCHANGED and needs no recompile.
PROOF THE FEED RECOVERED (21:13:57, after the restart): "L1 SELL OPENED @ 4458.43",
"TRAILING ACTIVATED @ 4455.75", "trail ratchet SL 4457.75 already exceeded by market
(4458.64)", "Closed L1 @ 4458.58" - four distinct live prices inside one second, against
the frozen 4363.94 that had stood for over an hour.

WHAT WAS ELIMINATED, AND HOW (this is the durable part - do not re-derive it):
  NOT the accessor. The probe printed SymbolInfoDouble and a fresh SymbolInfoTick side by
    side: both returned the IDENTICAL frozen values with ok=Y. Switching the money paths to
    SymbolInfoTick would have fixed NOTHING. That was the leading hypothesis and it was
    wrong.
  NOT TRTM state. A full remove -> re-attach (21:05) rebuilt every global, re-ran
    Reconcile, passed the self-test - and tickTime was STILL 14:52:52, unchanged. Nothing
    the EA owns survives a re-init, so the stale tick lived BELOW the EA.
  NOT SymbolSelect. A re-init already does strictly more than SymbolSelect would, and it
    did not help - so the "add SymbolSelect(_Symbol,true)" fix I was about to propose would
    have been useless. Recorded so it is not proposed again.
  NOT the account switch DIRECTLY. The live->demo switch is real (Journal 19:52:53 local =
    14:52 server; ticket format changes 2027545297 -> 742972617 at exactly that boundary),
    and tickTime froze in that gap - BUT the EA went on reading live, MOVING prices for ~25
    minutes afterwards (14:53:18 @ 4364.93 ... 15:02:00 @ 4363.91). So the switch alone does
    not explain it.
  NOT the chart, refresh, or another EA. Jeff confirmed the symbol is XAUUSD.s, chart
    Refresh did nothing, no other EA was running, and the terminal had been up all day.
MECHANISM NOT ESTABLISHED. The terminal's symbol cache held a dead tick that neither a
  chart refresh nor an EA re-init could dislodge, and only a terminal restart cleared. Three
  successive theories failed against evidence today; a fourth is not offered. The probe is
  what killed each one - it earned its cost.
OPERATIONAL LESSON: after switching accounts in a running terminal, RESTART THE TERMINAL
  before trusting quotes. A chart refresh and an EA re-attach are NOT sufficient.

THE REAL DELIVERABLE - A STALE-QUOTE GUARD, -> E9 (E9-Q1), own Gate 1, NOT part of b41:
  For over an hour TRTM read a dead quote as truth and silently refused every recovery
  entry. Worse, the forfeit WARN actively MISDIAGNOSED it - "spread pushes entry inside the
  interval" - which is what sent the first several exchanges of this investigation chasing a
  spread problem that did not exist. A guard comparing MqlTick.time against TimeCurrent()
  would have said "quote is 73 minutes stale, refusing to trade" on the FIRST forfeit.
  That gap is real, cheap to close, and independent of whatever caused this incident. It is
  exactly the class of failure that bites an unattended EA.

## *** [RESOLVED - see above] b41 VERIFICATION PARKED 2026-08-19 - LIVE QUOTE DEFECT ***
FOUND BY JEFF during the b41 verification run, on the DASHBOARD first ("the ask is not
capturing the latest price") and then confirmed in the journal.
EVIDENCE - tests/2026.08.19 195529.548.txt, DooTechnology XAUUSD.s, magic 715358:
  TWELVE consecutive "Recovery L2 FORFEITED" lines, 20:21 -> 20:36, every one reporting the
  fill-side price as EXACTLY 4363.94, while the M1 bar closes in the SAME log lines climbed
  4370.73 -> 4387.36. That is 236 points of real movement against a quote that never moved
  by one tick. A spread artifact cannot do this.
  The frozen 4363.94 is ~L2's fill price from the PREVIOUS sequence at 20:02 (4363.91), so
  the value appears stuck at roughly that moment.
  CORROBORATION: the panel's Next row showed a frozen "ask 4364.24" across two screenshots
  minutes apart - the same quote, other side of the spread (4363.94 + ~30pts).
JEFF CONFIRMED Market Watch was TICKING for XAUUSD.s at the time, and that the chart symbol
  IS XAUUSD.s. So the terminal HAS live quotes; something in the read path does not see them.
WHY THIS IS SERIOUS: the forfeit guard is a MONEY PATH (EvaluateRecovery's entry-side
  guard). With the quote frozen on the wrong side of the trigger, recovery is PERMANENTLY
  DEAD for that sequence - it can never satisfy the condition. The earlier BUY sequence
  worked only because the frozen value happened to sit on the favourable side. That is luck,
  not correctness.
NOT A b41 REGRESSION: b41 touched reconcile classification and persistence only; it does not
  go near quote reading. This defect is older and was simply never observed before. It does,
  however, BLOCK the b41 verification run, so it jumps the queue.
DIAGNOSIS IN PROGRESS - TEMPORARY PROBE BUILD (4418e3c468752f26 / 5104 lines), NOT A FIX:
  two "QUOTE PROBE" log lines added, printing SymbolInfoDouble's cached bid/ask NEXT TO a
  fresh SymbolInfoTick, plus the tick's own timestamp and TimeCurrent:
    (1) in EvaluateRecovery immediately before the entry-side guard - samples at the exact
        instant of the bad read, but only fires on a bar close;
    (2) in NextTriggerRowText, throttled to one line per 10s - the panel path runs every
        500ms from OnTimer, so it samples far more often.
  READING THE RESULT: if SymbolInfoTick returns LIVE values while SymbolInfoDouble returns
  the frozen one, the fix is mechanical (switch the money-path reads to SymbolInfoTick). If
  BOTH are stale, the problem is terminal-side and TRTM cannot fix it in code.
  BOTH PROBES ARE MARKED "TEMPORARY DIAGNOSTIC ... REMOVE BEFORE ANY SEAL" in the source.
  THEY MUST NOT SHIP. They log at WARN deliberately so they are impossible to miss.
NOTE ON THE PANEL ROW, separate and lower priority: in BAR-CLOSE mode the Next row displays
  "ask <x> <=" as though a live tick decided the entry, but the decision uses the CLOSED M1
  bar's close (visible in the same log: "bar closed 4370.73 vs trigger"). The row implies a
  basis that is not in force. Display honesty, same family as E9-M2. Park, do not fix now.

## b41 GATE ZERO PASSED + DEPLOYED 2026-08-19
COMPILE: clean after the K-4 withdrawal (the string->number warning was the withdrawn
  code; nothing else touches CTrade).
DEPLOYED by Jeff 2026-08-19 19:50 on DooTechnology XAUUSD.s, magic 715358, chart M1.
  NOTE: this is the DOO terminal, not the Vantage demo (758105) where Run H ran.
INIT EVIDENCE - THREE GROUP C ROWS CLOSED ON THIS INIT ALONE:
  C-3 "State persistence self-test: PASS" - and the self-test now ROUND-TRIPS
      lastAppliedTP/SL, so a PASS proves the two new fields serialize, parse and compare.
      C-2 (round-trip incl. new fields) closes with it.
  C-4 THE STRENGTHENED WARN FIRED VERBATIM:
      "StateLoad: schema mismatch or missing (found 4, expected 5) - DISCARDING the state
       file. Override flags (trail/BE), manual SL ownership and any adopted-L1 record are
       LOST; the sequence rebuilds from broker positions. On the b41 upgrade this is
       EXPECTED EXACTLY ONCE - deploy on a FLAT sequence to avoid it."
      "found 4, expected 5" proves the bump; the text names the consequence, which is
      exactly the condition attached to b41-C1.
  C-5 the gate still REJECTED a non-matching schema rather than silently accepting it.
  C-1 SATISFIED BY PROCEDURE, not by code (as the sealed matrix records honestly):
      "Reconcile complete: FLAT" - deployed on a flat sequence, so nothing was lost.
INCIDENTAL: stops level 50 pts on this broker (20 on the Cent/Vantage terminals). Geometry
  only, no bearing on b41.

STILL OPEN - THE VERIFICATION RUN (Group B + D):
  B-1 restart over a sequence whose TP the EA itself applied -> expect NO M7-5 adoption.
  B-2 MUST-NOT: a GENUINE offline trader edit is STILL adopted (proves discriminator, not
      blanket suppression).
  D-1 Tier 3 fire arithmetic unchanged, recomputed on both derivations.
  Broker choice: E9-M1 is fill-model INDEPENDENT, so Doo works for B-1/B-2. A Tier 3 fire
  for D-1 needs the Run H config (entry 0.05, MinTrades 4, interval 150, RecoveryTF M1).
  Restart legs MUST be a LIVE CHART - the tester replays from bar zero.

NEXT: the single verification run (Groups B + D), then Gate 4, then seal on Jeff's word.
  Rows A-1..A-8 are NOT attempted in b41 (K-4 withdrawn) and are neither closed nor failed.

## RUN H - EXECUTED 2026-08-18. T3-K1/K2(b) PASS, K-4 FAIL, L-3 DEFENDED.
The oldest outstanding debt in the project - overdue since the E6 seal 2026-07-26, doubly
so after b39 rewrote the sequence-rebuild code - IS NOW RUN.
EVIDENCE: tests/2026.08.18 124554.100.txt (full journal incl. the appended "Previous 1Hr"
block), tests/ReportHistory-25948001.xlsx, tests/state_XAUUSD_758105_PRE_RESTART.json,
tests/state_XAUUSD_758105.json, plus two Trade-tab screenshots (live + history views).
ACCOUNT: VantageMarkets-Demo 25948001, USD, HEDGE, XAUUSD (raw, no suffix), magic 758105,
build b40. THIS IS A VANTAGE ACCOUNT - the K-4 question is answered on the right broker.
(Note for the record: the raw symbol is bare XAUUSD here, so magic derives to 758105, the
same identity W-7 documents for XAUUSD+. Not the Cent LIVE account, which is XAUUSD.sc /
725639.)
CONFIG: InpEntryLotSize 0.05, Tier 3 ON, MinTrades 4 (see the FALSE START below),
MinProfitPts 200, MinLots 0.02, ClosePercent 50, Tiers 1+2 OFF, trailing OFF, BE OFF,
SL 0, RecoveryIntervalPts 150, RecoveryTF M1, chart M5.

FALSE START WORTH RECORDING (cost one sequence): InpTier3MinTrades was first set to 2 to
shorten the wait. Tier 3 then never fired and the EA said why -
"Basket close stands down: group would close the whole basket (no underwater survivor to
valve) - sequence AvgTP/BE/trail owns the full close (M-1)". With 2 levels both in profit
the profitable group IS the whole basket, so there is no underwater survivor to slice
against. TIER 3 NEEDS >= 3 LEVELS TO HAVE ANYTHING TO WORK WITH; the default MinTrades 4
exists for this reason. E6's Run C used the default. Do not lower it again.

TWO TIER 3 FIRES, BOTH RECOMPUTED AND BOTH CLEAN:
  FIRE 1  16:32:30  anchor L1 slice 0.02 of 0.05 + L7 0.11 + L8 0.12
                    sliced-VWAP 4390.46, far 4392.53, margin 206.6 pts >= 200 ... PASS
                    8 levels 0.68 lots -> 6 levels 0.43 lots (0.68 - 0.12 - 0.11 - 0.02)
  FIRE 2  16:35:48  anchor L1 slice 0.01 of 0.03 + L5 0.09 + L6 0.10
                    sliced-VWAP 4394.47, far 4396.64, margin 217.0 pts >= 200 ... PASS
                    6 levels 0.43 lots -> 4 levels 0.23 lots (0.43 - 0.10 - 0.09 - 0.01)
  FIRE 2 IS STRONGER THAN RUN H SPECIFIED: it re-slices an ALREADY-SLICED anchor
  (0.05 -> 0.03 -> 0.02). E6 never exercised a second slice of the same position.
  Anchor P/L across both slices reconciles against the broker report: ticket 1786381814
  closed 0.03/0.05 at -26.49 with the remaining legs; net day +306.84, balance 2806.84.

ROW RESULTS:
  T3-K1  restart with a sliced anchor ........ PASS ON EVIDENCE. Deinit (reason 1)
         16:41:17, re-attach 16:42:58. Rebuilt "4 level(s), 0.23 lots", dir=BUY, levels=4,
         anchor at L1 carrying 0.02. NO renumbering, NO orphan, NO lost baseLot
         (state file baseLot 0.05 preserved across the restart). The pre/post state files
         agree on tickets and levels; the ONLY delta is manualTP 0 -> 4401.17, which is
         E9-M1, not a rebuild fault.
  T3-K2  sub-case (b), killed AFTER the slice . PASS ON EVIDENCE - same restart. The
         sequence resumed and went on to open L5/L6 normally at 16:48/16:50.
  T3-K2  sub-case (a), killed BETWEEN the profitable close and the slice - NOT EXERCISED.
         The window is sub-second (16:32:32.358 -> .614) and is not hittable by hand.
         REMAINS INHERITED on the X-3 abort-path identity argument. Jeff's call whether
         that ever needs a deliberate test harness.
  K-4    comments across a PARTIAL CLOSE ...... **FAIL** - see below. Row CLOSED, answer
         is NO.
  L-3    level-0 anchor hazard ................ **DEFENDED, PROVEN LIVE** - see below.
  T3-X4  broker partial rejection ............. still not naturally occurring; unchanged.

*** K-4 FAIL - COMMENTS DO NOT SURVIVE A PARTIAL CLOSE, AND THE CAUSE IS OURS ***
At 16:42:58 the EA read the sliced anchor's comment as EMPTY:
  "RebuildLiveMap: position 1786381814 has our magic but unparseable level comment ''"
Every UNTOUCHED level kept its tag (xauusd_l2_buy .. xauusd_l6_buy). Only the position
that was PARTIALLY CLOSED lost it. Confirmed in the live Trade tab (Comment column blank
for 1786381814, populated for all others).
ROOT CAUSE IDENTIFIED FROM THE BROKER REPORT - IT IS NOT A BROKER QUIRK, IT IS TRTM'S OWN
CODE: the Orders sheet shows every EA-opened order carrying its tag, but ALL FOUR closing
market orders carry NO comment (11:32:30 sell 0.12, 11:32:31 sell 0.11, 11:32:32 sell 0.02
= THE SLICE, 11:35:49 sell 0.10). MT5 surfaces a position's comment as that of the LAST
order to modify it, so the untagged slice order overwrote the position comment.
=> SliceLegAtMarket (1498) sends its partial close WITHOUT a comment. Tag the slice order
   with the same _lN_ string and the position comment survives. This is a FIXABLE TRTM
   defect, not a broker limitation, and it is therefore NOT Vantage-specific: any MT5
   broker will do this.
IMPORTANT NUANCE FOR ANY FIX: the ORDER/DEAL comment persists in account history
(the history view still shows xauusd_l1_buy for that ticket) while the POSITION comment is
gone. History is NOT a runtime recovery source - PositionGetString(POSITION_COMMENT)
returned "" and that is what the money paths read.
ESCALATES E9-O6 (comment-integrity detection) from theoretical to demonstrated.

*** L-3 DEFENDED - b39's O2b FIX PROVEN ON LIVE EVIDENCE ***
The blank comment did NOT produce lvl=0. RebuildLiveMap logged a WARN and assigned a SAFE
level: "counted as L1 (never 0: a level-0 position would become the anchor). Manual review
advised." So the level-0 anchor hazard - CRITICAL in the b39 matrix, and the reason K-4
mattered - is defended in shipped code. L-3 stays DEFENSIVE, does NOT become ACTIVE.
This closes on EVIDENCE what was previously locked-decision-plus-inspection (E9-O2b).
L-1/L-2/L-4 remain open on inspection (still need a deliberately corrupted comment).

OBSERVABILITY: NO GAP. An earlier reading of a truncated journal suggested fire 2 went
unlogged; the full log shows fire 2 fully emitted (FIRE line, two Closed lines, the slice
line, two liveness lines, Structure, and the exit re-applies). Stage 10 emission intact.

CARRIED OUT OF RUN H:
  (1) K-4 fix - tag the slice order in SliceLegAtMarket. Needs Gate 1; touches sealed E6
      money-path code. Highest-value item from this run.
  (2) E9-M1 root cause narrowed to the reconcile path (see the E9-M1 section).
  (3) T3-K2(a) still inherited.
  (4) T3-DS1 dashboard visual confirm STILL not done.

## E9-M1 PARKED DEFECT - MANUAL TP SURVIVES A STRUCTURAL RELEASE (found 2026-08-18)
FOUND LIVE on Vantage Cent XAUUSD.sc (magic 725639), b40, log
tests/2026.08.18 095950.169.txt lines 41-46. NOT a b39/b40 defect - the faulty code is
SEALED Stage 8 b24/b25. b39 only makes it EASIER TO HIT (watcher adoption and the enforce
loop now land in the same millisecond).

*** SCOPE CORRECTED 2026-08-18 BY THE GATE 1b DIAGNOSTIC - READ THIS FIRST ***
THE CENT-ACCOUNT CASE (log 095950.169 line 45) IS **NOT** A DEFECT. It was investigated as
the founding symptom of E9-M1 and it does not survive scrutiny. E9-M1 has EXACTLY ONE
instance: the Run H reconcile misclassification. Details of the exoneration:
  - Between L1's registration (10:02:35) and L2's open (10:35:01) there is NO
    "Exits applied to ticket 520695723" line. The EA NEVER applied a TP to L1.
  - Why: with ONE level, "Structure: 1 level(s) ... projected at TP n/a" - the recovery
    AvgTP is not computable until a second level exists, so there was nothing to write.
  - So L1 carried Jeff's MANUALLY PLACED 4407.20 the whole time, never overwritten,
    because the EA had no computed value to overwrite it with.
  - At 10:35:01 L2 opens. ReleaseManualTP fires but manualTP was ALREADY 0 (nothing had
    ever been adopted), so it returns early at 1134 and logs nothing. THE ABSENCE OF A
    "RELEASED" LINE - originally cited as corroboration of a defect - is actually proof
    that there was nothing to release.
  - compTP becomes computable for the first time (2 levels -> 4401.83). DetectManualExitEdits
    sees L1 at 4407.20 vs baseline 4401.83 with g_lastAppliedTP == 0 (never applied), so
    the b25 guard's "g_lastAppliedTP <= 0.0" clause is TRUE and admits the candidate.
  - Adopted as manual. CORRECTLY. 4407.20 genuinely WAS a trader edit.
  => The answer to Jeff's original question ("why didn't the recovery TP overwrite my
     manual TP?") is: because manual TP OUTRANKS computed TP by design (b24), and his was
     a real manual edit. The b24 adoption semantics were working as specified.
[HISTORICAL - the original symptom write-up, now disproven, kept so the reasoning trail
 is intact:]
SYMPTOM: Jeff set a manual TP 4407.20. Recovery L2 opened. Expected (and DESIGNED)
behaviour: manual TP RELEASES on a level add and the computed recovery TP (4401.83) takes
over. Observed: line 45 "Manual TP 4407.20 ADOPTED (was 4401.83)" - the released value was
immediately RE-ADOPTED as if it were a fresh trader edit, and propagated to both tickets.
CORROBORATION: ReleaseManualTP() logs a WARN on every non-zero release. There is NO
"Manual TP ... RELEASED" line anywhere in the log, so the release either never saw a
non-zero manualTP or its effect was undone within the tick.

DESIGN INTENT IS NOT IN QUESTION - it is already coded and correct in principle
(TRTM.mq5:206-208): manualTP RELEASES on structural change (level add 2625, level close
960, trail-arm 1388); manualSL PERSISTS by design (M3-4 / M7-4, locked). Jeff re-confirmed
this intent 2026-08-18. So this is a DEFECT, not a change request.

ROOT CAUSE - NARROWED 2026-08-18 BY RUN H EVIDENCE. The defect is in the RECONCILE
classification path, NOT the level-add release path. Run H proved the level-add release
works correctly (see below), so the original inspection hypothesis about
ReleaseManualTP/g_lastAppliedTP ordering on the level-add path is WRONG and is retained
below only as a rejected line of inquiry.
WHAT RUN H PROVED (tests/2026.08.18 124554.100.txt, Vantage demo 25948001):
  16:35:50  "Exits applied to ticket 1786381814: TP 4401.17"   <- the EA's OWN computed
            value, applied by the EA itself after Tier 3 fire 2.
  16:41:17  Deinit (reason 1) - clean.
  16:42:58  "Reconcile: TP edited to 4401.17 while EA was offline (computed 4401.67)
             - adopted as manual (M7-5)"                        <- MISCLASSIFIED.
  NOTHING WAS EDITED BY THE TRADER. On restart the EA recomputed 4401.67 (four legs at
  different weights after the slice), compared it to the 4401.17 it had applied itself
  6 minutes earlier, saw a 0.50 difference, and adopted its OWN value as a manual TP.
  ReconcileManualExits has NO equivalent of the b25 g_lastAppliedTP guard - g_lastAppliedTP
  is a RUNTIME global (1041) that resets to 0.0 on init (1082), so after a restart there is
  no memory of what the EA last applied and every stale broker value looks like a trader
  edit. The persisted state carries manualTP/manualSL but NOT lastAppliedTP/SL.
THE RELEASE PATH IS PROVEN GOOD (same log, 16:48:00):
  "Manual TP 4401.17 RELEASED - level add (L5) (structure changed: computed target
   re-asserted)" - and it was NOT re-adopted on the following passes. So ReleaseManualTP +
  the b25 guard behave correctly on a level add within one session. Jeff's design intent
  (TP releases on structure change, SL persists) is intact in the running code.
CONSEQUENCE: the 2026-08-18 Cent-account case (log 095950.169, line 45) must be re-read.
  That one adopted on a LEVEL ADD, not a reconcile, so it is either a SECOND distinct
  instance or the sequence had a prior reconcile that seeded manualTP. Gate 1 must
  establish which before scoping a fix - do NOT assume one root cause covers both.
  [RESOLVED 2026-08-18 by the Gate 1b diagnostic: NEITHER. The Cent case is NOT a defect
   at all - the EA had never applied a TP to L1 (single level, AvgTP not computable), so
   4407.20 was a genuine un-overwritten manual edit and adopting it was correct. See the
   SCOPE CORRECTED block at the head of this section. E9-M1 = ONE instance, the reconcile
   path. This NARROWS the fix rather than widening it.]
CANDIDATE FIXES to weigh at Gate 1 (NOT decided): (a) persist lastAppliedTP/SL in the
  state file so reconcile can apply the b25 guard across a restart; (b) on reconcile, treat
  a broker TP that equals the value implied by the PERSISTED level set as the EA's own,
  not a manual edit; (c) suppress manual-TP adoption entirely at reconcile when the
  recomputed target differs only because the level set changed. (a) is the smallest and
  most direct - the guard already exists, it just cannot see across an init.
[REJECTED HYPOTHESIS, recorded so it is not re-derived: the b25 anti-oscillation guard
 (1595-1601) suppresses a stale broker value only while it equals g_lastAppliedTP;
 ReleaseManualTP (1132) clears g_state.manualTP but never g_lastAppliedTP, and the enforce
 loop advances g_lastAppliedTP at 1869 after a PARTIAL apply. Plausible on inspection, but
 Run H's 16:48:00 release line disproves it as the operative cause on the level-add path.]

DO NOT HOTFIX. Touches sealed b24/b25/b28 classification code with one-shot logging side
effects; needs its own Gate 1 -> matrix -> plan. THE CANDIDATE FIXES TO WEIGH ARE THE
(a)/(b)/(c) LISTED UNDER "ROOT CAUSE" ABOVE (persist lastAppliedTP/SL, etc.) - those are
aimed at the reconcile path Run H identified.
[SUPERSEDED candidate list, from the rejected level-add hypothesis - do NOT scope from
 these: (a) ReleaseManualTP also clears g_lastAppliedTP; (b) suppress
 DetectManualExitEdits for one pass after a structural release via g_manualDetectSkipOnce
 (1555); (c) make g_lastAppliedTP per-ticket. Retained only to show they were considered.]

## E9-M4 PARKED - adoptedL1 IS UNRECOVERABLE IF THE STATE FILE IS LOST (found 2026-08-19)
FOUND while analysing b41's schema decision. NOT a b41 defect and NOT caused by the schema
bump - it is a standing property of the design, true in b40 today.
An ADOPTED L1 is a magic-0 position taken over via its comment tag. Because it does NOT
carry our magic, RebuildLiveMap cannot see it - Reconcile restores it FROM THE STATE FILE
ONLY (2887-2911, "restored adopted L1 ticket %I64u from state file"). So if the file is
lost for ANY reason - corruption, deletion, a fresh terminal, a different data folder, a
schema mismatch - the adopted L1 becomes INVISIBLE to the EA and goes UNMANAGED: no TP
maintenance, no liveness, no participation in the sequence or the tiers.
WHY IT IS NOT IN b41: b41's schema bump makes this reachable exactly ONCE, on the first
init after deploy, and the deploy-on-flat condition (b41-C1) eliminates that instance. The
GENERAL hole is older, wider, and independent of b41 - closing it means giving an adopted
L1 a broker-side identity that survives file loss, which is a design change with its own
gate. Neither shape (i) nor (ii) of the schema decision addresses it; that was one of the
arguments AGAINST (ii) claiming to be the "safe" option.
SEVERITY: worse than losing the override flags, because an unmanaged live position is a
money path. Bounded by the fact that adoption is opt-in (InpManageMobileTrades) and the
file is only lost in unusual circumstances.
-> E9. Candidate directions (NOT decided): (a) write our magic onto the adopted position at
adoption time if the broker permits; (b) re-derive adoption from the comment tag at
reconcile the way the OnTick adoption scan already does, subject to the stale-tag gate;
(c) accept and document. (b) looks closest to existing machinery.

## E9-M2 PARKED (cosmetic, same log) - STALE PROJECTION IN THE Structure: LINE
AdoptUntrackedLevel calls ReleaseManualTP (2625) BEFORE LogStructure (2629), so on
2026-08-18 line 44 printed "projected at TP +263.00" against a target that line 45 changed
in the same millisecond. Display only, no money path, no state. Misleads a cold read of
the journal, which is why it is recorded rather than ignored.

## Environment note
ALL charts are DEMO; multi-symbol attachments are test surface.
Checklist EVIDENCE comes from XAUUSD.s only.
Broker facts: Doo Prime XAUUSD.s stops level (broker minimum SL/TP
distance) is DYNAMIC - 100 pts was a sample observed at one init; it has
ranged ~20-100 pts within one evening. Never treat it as a constant;
guidance logs must say "at init". The sealed b28 deferral evidence
(93 < 100 pts) was audited against that 100-pt init sample.
DEPLOY NOTE (b24): no policy selector - manual exit adoption is live
behavior on EVERY chart b24 is attached to. Flagged and accepted.

## CORE STATUS - COMPLETE (2026-07-22, first Claude Code session)
Core trade functionality is CLOSED. Sealed: Stages 1-7, Stage 8 Step 1,
Stage 9 Steps 1-2, Stage 10 observability. The full live loop - entry,
grid/martingale levels, SL/TP, break-even, manual-exit adoption,
recovery, state persistence, observability - is built and demo-verified.
Nothing in the core loop is unbuilt or unverified.

Reconciliation - the b33 handover section 3 "queued" list was STALE;
these three were already PASS and sealed under Stage 8 Step 1, not
remaining work:
- SELL lap (direction symmetry): DONE. Three SELL sequences PASS
  (S8-10(S)/S8-15(S)/S8-6(S), 2026-07-20) satisfy the STAGE8_MATRIX
  spot-check symmetry contract (matrix is BUY-worded, direction-
  symmetric, evidence = BUY + SELL spot-checks). Jeff confirmed closed
  2026-07-22.
- M6-1 (post-BE SL adoption above floor): DONE, PASS 07:16:42, sealed.
- S8-17 (trail-arm TP release): DONE, PASS 16:01:01, sealed.

## Enhancement backlog (TRTM-only; post-core; NONE started)
Plan phase next. Each is a fresh delivery through the gates when picked.
E4-E7 merged 2026-07-23 from docs/ENHANCEMENT_INPUT_2026-07-23_tier1.md
(Gate 1 INPUT only - nothing locked, no matrix, no code). E4-E7 are
reverse-engineered from a third-party reference EA (Shadow Trade Manager
PRO v3.21) via tester logs only; each item is tagged OBSERVED (evidenced,
arithmetic recomputed in the input doc) or CHOSEN (Jeff's TRTM design
decision). Shadow is a REFERENCE, never a spec. The input doc holds the
full arithmetic and per-fire evidence; entries below are the durable
summary.
E1 (SEALED E1-b34, 2026-07-23) BE/TP/trail anchor -> LOT-WEIGHTED, ALL
   PATHS + DASHBOARD. DONE - all gates cleared, sealed by Jeff after 5
   live runs (see b34 changes for the seal evidence). Lot-weighted average
   replaced the simple-average anchor across avg-TP, BE stop/trigger, trail
   activation/trigger, AND the dashboard projection/avg-entry. Two
   compute sites converted in-loop (ComputeTargets, ComputeProjection);
   a shared helper was drafted then removed (dead code, deferred to E4).
   Docs: E1_MATRIX.md (sealed, 25 rows), E1_PLAN.md, E1_CHECKLIST.md (all
   PASS). Lot-weighted is the
   financially correct basket break-even; simple average only coincides
   when all lots are equal. NEW COUPLING: E4's Tier 1 trigger computes
   from a lot-weighted VWAP - landing E4 while TP/BE stays simple-average
   puts two averaging bases in one money path (section 7 consistency
   break). Therefore E1 and E4 are ONE Gate 1, OR E1 lands FIRST and E4
   follows. E4 MUST NOT land before E1. Matrix caveat: under the sealed
   closed-form stall (base 0.01/mult 1.5 -> L3-L6 all 0.02) equal lots
   are common, so simple and weighted coincide across a stalled band -
   any E1 matrix MUST include an unequal-lot sequence or it proves
   nothing. Full evidence + rationale below in "Parked additions".
E2 Stage 8 Step 2 - draggable EXIT (SL/TP) lines LIVE. Not built; only
   the pending PLACEMENT line exists today. Money-path UX; Gate 1 ->
   matrix -> plan.
E3 Stage 9 Step 3 - auto-entry stub (MQL_TESTER-gated). Optimization
   infra, required before parameter optimization. Reuse the OFFSET seed
   (rejected for Step 2, held in reserve for Step 3).
E4 (NEW 2026-07-23) Drawdown Reduction Tier 1 - point-based basket
   close. One-line: when the basket is deep, close the OLDEST position
   together with every currently-profitable position, but only if that
   group's combined P/L clears a per-lot profit threshold. Money-path;
   full Gate 1 -> matrix -> plan. DEPENDS ON E1 (lot-weighted) - now
   SATISFIED: E1 sealed E1-b34 2026-07-23, so E4 is UNBLOCKED. NOT STARTED;
   next up when picked, opens with its own Gate 1.
   OBSERVED (Shadow, both runs, arithmetic in input doc): trigger = open
   count >= MinTrades (was 4) AND group (anchor + ALL profitables) VWAP
   >= MinProfitPoints (was 150 pts) in front of the FAR-side market
   price. Sells close at Ask (confirmed 3x); buys would close at Bid
   (NOT observed). Evaluation TICK-based, not bar-gated (both fires
   mid-bar). On fire: close every member at market, anchor first then
   profitables descending ticket, then recompute sequence TP + refresh
   ladder. Threshold restated: group must net >= MinProfitPoints per lot
   (VWAP framing is the lot-size-independent form) => group can NEVER
   close at combined loss; only the anchor realizes a loss. Anchor cost
   MEASURED to escalate (run B: fire1 anchor 0.01 -26.99 lot-pts; fire2
   anchor 0.02 -43.92, +63%) - the squeeze C1 accepts.
   CHOSEN for TRTM (Jeff 2026-07-23):
     C1 anchor = OLDEST position strictly; transfers to next-oldest when
        it closes; NO skip-to-affordable. Rationale: oldest = most
        swap-expensive; Tier 1 failing to fire on an expensive anchor is
        acceptable, not a defect. Rejected skip-ahead (leaves oldest
        alive longest, unpredictable next-close). Cost accepted:
        cost-to-close rises each fire so Tier 1 fires progressively less
        often. Evidence note: Shadow CANNOT confirm its own anchor rule
        and no ordinary run can - in an unbroken additive ladder
        oldest = deepest = smallest-lot coincide structurally; behavior
        (#2 then #3 across both fires) agrees with C1 but the RULE is
        unproven. Edge case named: on a V/whipsaw the oldest can be the
        shallowest loser - the rationale that always holds is "oldest =
        most swap-expensive", not "oldest = deepest".
     C2 at least one profitable position NOT mandatory; threshold test
        alone governs (Shadow never fired with zero profitables -
        unevidenced, a TRTM choice).
     C3 PRESERVED LADDER INDEX (diverges from Shadow, which re-indexes by
        count). A rung is an ADDRESS not a counter position: Level N
        always = (price from anchor + N*interval, lot =
        ComputeLevelLot(N)); price revisits a level -> refills at that
        level's lot. Still nothing stored (both derived). Rationale:
        restores basket weight so lot-weighted VWAP/TP returns to where
        the sequence earned it; Shadow's re-index leaves the basket
        permanently lighter at the top, pushing TP further away and
        compounding across heals. Rejected count-based re-index (silently
        discards rungs, degrades TP). WARNING: C3 touches the SEALED
        martingale path (ComputeLevelLot 1752/1776, normalizer 1798) and
        the level counter - the matrix MUST carry must-NOT-fire rows
        proving closed-form output is bit-identical for the no-heal case,
        and rows sited at a curve STEP not inside a stall (a stall makes
        preserved-index and count-re-index indistinguishable).
     C4 3-second post-fire recovery suppression (Shadow hardcodes it);
        TRTM to decide input vs hardcoded - see O3.
   OPEN sub-decisions (resolve in E4's Gate 1): O1 rung re-arm after a
     Tier 1 close (preserved index allows repeated whipsaw refill; each
     cycle net-positive by construction so no loss leak, but ladder
     CONSUMPTION is real - 9 fires empties it; decide whether a closed
     rung needs extra travel before re-arming; the existing 3 entry gates
     do NOT bound the count, bar-close bounds only the rate). O2 threshold
     scaling with depth (flat 150 for first and ninth fire; later fires
     already harder under C1 - a knob, decide or park). O3 post-fire
     suppression window input vs hardcoded (C4). O4 BUY-side far-price =
     Bid (NOT observed - no buy sequence exists); matrix MUST carry a SELL
     lap AND a BUY lap, close-side price DIRECTION-DERIVED never a fixed
     Bid/Ask read (known defect class, surfaces on one direction only).
     O5 group close ordering + partial-fill handling (Shadow: anchor-first
     then profitables descending, separate market orders, no retry; a
     mid-group leg failure leaves a partially-closed group whose combined
     P/L no longer matches what was tested - needs a rule; unaddressed by
     Shadow logs).
E5 (SEALED E5-b37 2026-07-25) Drawdown Reduction Tier 2 -
   percent-based (Shadow InpPC2_ProfitPercent/InpPC2_MinTrades). E7 R1 reference
   run DELIVERED 2026-07-24 (docs/STM Drawdown Reduction Tier2 Logs.txt; analysis
   docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md) - one Tier 2 fire captured and
   recomputed. Tier 2 = Tier 1's close machinery fired by a MONEY test (group P/L
   >= ProfitPercent% of account BALANCE) instead of per-lot points. T2-O0 LOCKED:
   separate default-off tier (InpEnableTier2), see locked-decisions log. DONE - all
   gates cleared (Gate 1 T2-O0..O7 locked; matrix SEALED rev 2; plan CONFIRMED; built
   E5-b37; verified + SEALED 2026-07-25). Reuses Tier 1's sealed close machinery via a
   shared dispatcher: Tier 2 (group P/L >= % of BALANCE) evaluated FIRST, then Tier 1
   (points). See seal entry in the locked-decisions log + docs/E5_VERIFY_CHECKLIST.md.
E6 (NEW 2026-07-23) Drawdown Reduction Tier 3 - partial-lot close
   (Shadow InpPC3_MinTrades/MinLots/MinProfitPoints/ClosePercent).
   DISABLED in both runs - ZERO observed behavior. Input names imply
   closing a PERCENTAGE of a position's lots (a different mechanism from
   E4); requires its own reference run (E7 R2).
E7 (NEW 2026-07-23) Reference-EA behavior capture - RESEARCH task, NOT a
   TRTM build, no gates, pure evidence gathering. Rerun Shadow with
   disabled features ON to get E5/E6 data and close E4's unobserved
   branches: R1 InpEnablePartialClose2=true (Tier 2); R2
   InpEnablePartialClose3=true (Tier 3); R3 a BUY sequence (all data
   today SELL-only) - SUPERSEDED 2026-07-23: O4 was decided from the
   platform invariant (buy closes at Bid, already TRTM's sealed-core
   behavior), so R3 is NO LONGER NEEDED for O4 and nothing in E4 blocks
   on it; de-prioritized, retains only general buy-side corroboration; R5 a BE reference run (price
   favourable to basket AND Tier 1 disabled so it cannot harvest
   positions before BE arms - see F4; only if Shadow's BE is ever wanted
   as a reference, TRTM's own BE is sealed). R4 WITHDRAWN 2026-07-23: a
   different run cannot separate oldest/deepest/smallest-lot (they
   coincide by construction in every additive ladder; verified against
   run B's two fires); disambiguation would need an artificial basket,
   no longer a faithful reference. Formally parked as
   undeterminable-by-observation; C1 does not depend on the answer.
   R2 (Tier 3) DELIVERED 2026-07-25: docs/STM Drawdown Reduction Tier3
   Logs.txt captured 2 Tier 3 fires; analysis
   docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md (both fires recomputed to the
   cent). Unblocked E6; E6 Gate 1 is now OPEN (see locked-decisions log
   T3-O0/O2/O3/O4/O5/O6 locked 2026-07-25..26).
E8 (NEW 2026-07-26, Jeff's idea; ADOPTED, own Gate 1 pending) PROFIT-FUNDED
   TAIL SLICE - CHOSEN, TRTM-native (NOT reference-derived). After a full
   T1/T2 close banks net profit +P on a tick, spend up to a fraction f of P
   to ALSO partial-slice the NEW anchor (next-oldest survivor = deepest
   remaining loser), the combined tick staying net >= (1-f)*P >= 0. Reuses
   the Tier 3 partial-close primitive (E6 O1) but with a DIFFERENT funding
   source/gate: standalone Tier 3 fires on a self-funding group that is
   itself net-positive (guaranteed win); E8's slice realizes a PURE loss on
   a loser, funded only by the just-banked harvest. RISK CHARACTER (must be
   costed at Gate 1, cf. the 2026-07-21 martingale-basis R-a rejection): it
   is a DIRECTIONAL tail-risk lever that bets AGAINST the basket's own
   mean-reversion recovery thesis (the deep losers are held precisely to
   profit when price reverts to TP); nets NEUTRAL at the instant (pays L out
   of P), buying reduced future tail variance + a VWAP nudge toward TP, at
   the cost of banked profit if price reverts. DEPENDS ON E6 (needs the
   partial-close primitive + dispatcher landed first). Open sub-decisions to
   spec at E8 Gate 1: E8-O1 reinvest fraction f (input; default off / 0);
   E8-O2 target = new anchor only vs next-N losers; E8-O3 atomic sequencing
   (harvest must be REALIZED before the funded slice is sized - no
   hypothetical funding; partial-fill discipline); E8-O4 how L is measured
   (realized close P/L in account currency; cross-currency valuation
   collapses on USD-quote symbols); E8-O5 gate/skip when f*P < 1-lot-step
   loss (nothing affordable to slice); E8-O6 interaction with the T3 gate
   and single-fire rule (E8 rides a T1/T2 fire, so it is NOT a separate
   dispatcher branch - it is a follow-on to a full-close fire). NOT STARTED;
   no matrix, no code.

## Verified (demo, logs audited)
Stages 1-7 SEALED (S7 sealed 2026-07-16 on b23; kill tests on b21).
Stage 8 Step 1 SEALED by Jeff 2026-07-20 on b28 (see seal section).
Stage 8 Step 2 (draggable lines) is the only parked Stage 8 item.
Stage 9 Step 1 SEALED by Jeff 2026-07-20 on b29 (tester interactive).
Stage 10 (observability batch) SEALED by Jeff 2026-07-21 at Stage10-b32.
A1 guards A/B/C, A2 (reworked b31), A3 (>0 branch), A4 all PASS with
audited live logs; A5 + A3 0-stops sub-case accepted by inspection.
Full scoreboard in HANDOVER_2026-07-21_stage10_b32.md.

## b34 changes (E1: lot-weighted anchor - SEALED by Jeff 2026-07-23).
## MONEY PATH - anchor basis change. All gates cleared (locked-decisions
## 2026-07-23; docs/E1_MATRIX.md 25 rows; docs/E1_PLAN.md;
## docs/E1_CHECKLIST.md all PASS across 5 live runs). +11 lines
## (4296 -> 4307). Compiled clean (0/0, Jeff's terminal).
1. ComputeTargets: loop now accumulates sumPrice=sum(lot*entry) + sumVol;
   g_curAvgEntry = sumPrice/sumVol (was sum(entry)/count). avg-TP (>1
   level) reads g_curAvgEntry (inline sum/count duplicate removed).
   anchorEntry (lowest-level SL anchor) + levelCount==1 TP UNCHANGED.
   Stale "simple average implemented to match spec" comment replaced.
2. ComputeProjection: loop now accumulates sumWV=sum(lot*entry); avgEntry
   = sumWV/lots (was sum(entry)/count). Drives dashboard avg-entry row +
   "Proj at TP/SL" - now the SAME lot-weighted basis as the engine (no
   b26/S8-25 display drift). Per-leg pTP/pSL math untouched.
3. Lot-weighted computed IN-LOOP at both existing scan sites (no
   redundant per-tick pass). A shared helper was drafted then REMOVED
   before handoff (it had no caller - both consumers own a loop - so it
   was dead code / unused-function warning risk at gate zero); deferred
   to E4, which needs the average outside these loops. C-1 single-basis
   guarantee is enforced by matrix recompute, not code sharing.
UNCHANGED (money/state): Recovery lot sizing (ComputeLevelLot) + level
spacing; SL anchor (lowest-level entry); CostCoverPoints; manual-exit
substitution + [MANUAL] tag; state schema + RunStateSelfTest (no new
persisted field - g_curAvgEntry already per-pass non-persisted). Equal-
lot sequences are bit-identical to b33 by construction (weighted==simple
when lots equal). Hygiene: 0 bare LF, ASCII-only, brace delta preserved
(-1 pre-existing string/comment brace, +2/+2 from the new helper).
STATUS: SEALED by Jeff 2026-07-23. Verified across 5 live demo runs on
XAUUSD.s (audited to the cent, docs/E1_CHECKLIST.md): unequal-lot BUY
10-level lifecycle (weighted TP exact every level + BE fire + weighted-TP
exit), equal-lot SELL 10-level no-op (weighted==simple) + SELL BE, trail
activation (weighted threshold discriminated vs simple), manual-TP edit
(path unchanged, computed re-assert weighted), hard-kill recompute +
lowest-level re-anchor. SELL/descending/manual-list by equivalence (the
averaging code has no direction/order term). No FAILs, no findings.
Empirical: XAUUSD.s stops level read 100 pts at 22:03/22:11 inits (within
the DYNAMIC 20-100 band). E4 (Tier 1) is now UNBLOCKED - E1 has landed.

## b33 changes (Stage 9 Step 2: tester pending-line NUDGE, matrix SEALED
## 2026-07-21). ZERO money paths (trade-primitive count 8=8 vs b32).
1. INPUT InpTesterNudgePts (default 50) + "=== Tester (Stage 9) ===" group.
   Global g_nudgePts clamped >=1 in OnInit (N1-5). LogTesterModeOnce now
   says "12 buttons" and announces the nudge step.
2. NEW FN NudgePendingLine(dir) [helper-before-caller, above
   HandlePanelClick]: moves ONLY PLINE OBJPROP_PRICE by +/- g_nudgePts;
   reads g_pendDir, never writes (N3-4); no-line -> INFO "no pending line
   to move" (N3-3, not silent). Free movement either side of market;
   CONFIRM stays sole authority (G4).
3. DISPATCH B_PUP/B_PDN in HandlePanelClick (reuse shared un-press +
   PanelRefresh). 
4. LAYOUT (placing branch): TESTER-only 4-button row CONFIRM|+|-|CANCEL
   via x-cursor; LIVE else-branch byte-identical (bw2+40 CONFIRM, N3-1).
   Nudge buttons collapse to 10x10 off when not placing, tester-guarded
   so the live panel never creates the objects.
5. POLL ARRAY 10 -> 12 (B_PUP/B_PDN appended last; up-before-dn = N1-4
   order); loop bound now ArraySize (no second magic number). Existing 10
   dispatch order + behavior unchanged.
No persisted field added (state schema/self-test unchanged, N4-2). Line
delta +60 (est. was +40; tester layout split + comments ran longer).
STATUS: SEALED by Jeff 2026-07-21. All 20 checklist items resolved
(12 PASS audited, S13/S14 equivalence, S15/S17/S19/S20 inspection).
S1 full lifecycle recomputed exact to the cent; money engines proven
byte-identical to b32. No FAILs, no new parked items.

## b32 changes (Stage 10: A5 reword, 2026-07-21)
Finding (evidence: every reason-5 deinit this session -> "acquired (no
existing lock)"): OnDeinit calls ReleaseInstanceLock() UNCONDITIONALLY,
so a clean re-init (param change, recompile) releases the lock and the
next init logs "acquired", NOT "re-asserted". The re-assert branch
(owner==ChartID + fresh heartbeat + lock present) is therefore only
reachable via an UNCLEAN shutdown that skips OnDeinit. b29's and b31's
"parameter-change re-init" descriptor named an unreachable case.
FIX (wording only, line count unchanged): re-assert message now names
ONLY the unclean-shutdown-survivor case and notes a clean re-init
releases the lock first. A5 accepted by INSPECTION: trigger branch
byte-identical to b29, string-only change, and forcing a hard-kill +
fast-restart purely to watch a wording line is disproportionate.

## b31 changes (Stage 10: A2 REWORK after live FAIL, 2026-07-21)
Live verification found A2-as-b30 broken two ways (evidence retained):
- S10-11 FAIL: init sibling never fires - MQL_TRADE_ALLOWED reads TRUE at
  OnInit even with F7 "Allow Algo Trading" unchecked (12:45 init silent,
  12:46 send blocked "by client"). Flag does not track the checkbox at
  init on this MT5 build.
- TP4 (flag-aware 10027) was on the PENDING path only; the common
  MARKET-entry path (E7) printed MT's generic string, no cause hint
  (12:46 BUY 10027). BUT the flag IS correct at TRADE time: 12:55 pending
  10027 with box off printed the EA-checkbox branch = S10-15 PASS.
b31 fix (ZERO money paths, +8 lines 4228->4236):
1. Removed the dead init sibling (TP3). Toolbar-off at init still covered
   by the existing WARN.
2. New helper AutoTradingDisabledHint() - single source for the 3-branch
   10027 cause hint, called at SEND time only (flag reliable there).
3. E7 (market entry) now appends the hint on 10027 (was bare).
4. P6 (pending) now calls the helper (+ keeps "Distance was fine.") -
   no duplicated branch logic to drift.

## b30 changes (Stage 10: observability batch, matrix SEALED 2026-07-21)
Design: STAGE10_MATRIX.md (20 rows) + STAGE10_PLAN.md (7 touch points).
ZERO money paths - emission/wording only. +31 lines (4197 -> 4228).
Compile is gate zero (Jeff's terminal); not yet compiled.
1. A1 (M1): Guards A/B/C blocked-while-flat now FILE-log a WARN, not
   dashboard-only. Reason-tracked via transient g_flatBlockReasonLogged
   (0/1/2/3): one WARN per reason, re-announce on reason switch, re-arm
   on clear or when a sequence opens. reasonNow set only in the flat
   branch => never fires while a sequence is live (M1-7). Closes the
   Inputs-Reset silent path that bit Jeff (Guard A blocked, no journal).
2. A2 (M2): per-EA MQL_TRADE_ALLOWED now checked. Init sibling WARN
   (gated toolbar-ON && program-OFF, no double-blame) names the EA
   properties checkbox. 10027 diagnostic now reads both flags live and
   names the ACTUAL off-switch (toolbar / EA-checkbox / toggled-at-send)
   instead of always blaming the toolbar - same class as the b27
   distance/10027 misdirect fix.
3. A3 (M3): broker-geometry INFO now says "no fixed stops/freeze
   reported (0 pts)" + dynamic caveat when the broker reports 0, instead
   of a bare "0 pts" that read as known-safe.
4. A4 (M3): tick/ask recovery-signal branch now logs an INFO naming the
   tick basis (was silent; only bar-close mode logged, at 1970).
5. A5 (M3): own-chart lock re-assert message now names the unclean-
   shutdown-survivor case, not only parameter-change re-init.
6. A6 PARKED - manual-SL-refused throttle; never observed spamming
   (Jeff 2026-07-21). Re-opens only on real repeat evidence.
No persisted field added => state-file schema / self-test unchanged.

## FINDING (raise with Jeff) - stale broker fact in this manifest
The Environment note above states "Doo Prime XAUUSD.s stops level =
100 pts" as a constant, but the b29 handover empirical ledger records
it as DYNAMIC 20-100 pts intraday (sampled). A3 (above) codifies the
dynamic reality. The "= 100 pts" line should be reworded to "sampled
100 pts; DYNAMIC 20-100 intraday" - not silently changed here because
it underpins sealed b28 deferral evidence (93 < 100). RESOLVED 2026-07-23:
the Environment note already read DYNAMIC (not a "= 100 pts" constant);
Jeff confirmed the wording and it now names the stops level as the broker
minimum SL/TP distance and ties the 100-pt sample to the sealed 93 < 100
evidence. See F2 below.

## FINDINGS (raise with Jeff) - 2026-07-23 enhancement input merge
From docs/ENHANCEMENT_INPUT_2026-07-23_tier1.md. F1-F4 RAISED, none
applied to code or to the referenced STATE.md text yet.
F1. E1 wording (backlog above): the ORIGINAL E1 line read the choice as
    open ("SIMPLE avg vs lot-weighted"). Jeff directed LOT-WEIGHTED
    2026-07-23. E1 has been reworded in the backlog to record the
    intended direction while keeping the Gate 1 requirement. The
    "Parked additions 2026-07-20" evidence block (below) is UNCHANGED -
    it still states simple-vs-lot-weighted as pending because it is the
    dated evidence record, not the decision. Do not edit that block.
F2. RESOLVED 2026-07-23. The stale-broker-fact FINDING immediately above
    (stops level "= 100 pts" constant vs the DYNAMIC 20-100 pts ledger)
    was found already corrected in the Environment note - it read DYNAMIC,
    not a constant. Jeff confirmed the wording; the note now names the
    stops level as the broker minimum SL/TP distance and ties the 100-pt
    init sample to the sealed b28 93 < 100 deferral evidence. No code
    change (doc clarity only).
F3. Shadow log cosmetic (reference-EA defect, informational): its three
    Tier 1 CLOSING deals each print "Confirmed initial deal #N. Position
    count is 0", misclassifying close-deals as initial entries and
    reporting count 0 while 7 positions remained open. Recorded as a
    defect CLASS for TRTM to avoid - close deals must NOT route through
    the initial-entry branch. Not a TRTM bug; a design guardrail note.
F4. Shadow's break-even engine is UNOBSERVED across the full four-day
    run despite InpEnableBreakEven=true: no BE line, no SL modification,
    no armed message; every modify carries sl: 0.00000. Reason
    demonstrated (not assumed): price ran persistently AGAINST the
    basket, and the two times positions moved into profit Tier 1 closed
    them (14:57 06.24, 15:48 06.25) before any held the 200-pt trigger.
    STRUCTURAL NOTE worth carrying into TRTM design thinking: an
    aggressive Tier 1 can systematically harvest exactly the positions a
    BE engine would otherwise arm on. TRTM's own BE is sealed; if
    Shadow's BE is ever wanted as a reference it needs E7 R5 (price
    favourable AND Tier 1 disabled).
F5. RAISED + ANNOTATED 2026-07-25 (E5 Gate 4 recompute). The sealed E5_MATRIX.md
    WORKED REFERENCE (Tier 2 fire VWAP 1.9311258 / margin 181.6 pts) and the T2-O4
    locked decision claimed Tier 1's gate was ALSO met at the 07/02 15:30 Tier 2
    fire, "proving" Tier-2-first precedence. RECOMPUTE (two independent ways:
    0.5985490/0.31, and the group-P/L identity 46.29/(0.31*1e5)) gives margin
    149.3 pts (VWAP 1.9308032), BELOW the 150 threshold - Tier 1's gate was NOT met.
    The matrix numerator was 0.5986490, exactly 0.0001 above the real 0.5985490 (a
    division slip). CONSEQUENCE: the reference run has ZERO both-gates-pass
    observations; T2-PR1 precedence has NO reference support and MUST be verified
    LIVE (constructed both-gates-pass tick, already in the plan's verify map). NOT a
    code defect (Tier-2-first is correctly implemented + money-neutral per T2-PR4),
    NOT a re-seal, NOT a STOP. Matrix (WORKED REFERENCE / G-PR / T2-PR1 / Status) and
    the T2-O4 block annotated in place (evidence corrected; the locked DECISION and
    the matrix SEAL are unchanged). Full recompute in docs/E5_VERIFY_CHECKLIST.md F5.

## b24 changes (Stage 8 Step 1: manual exit adoption, matrix SEALED)
Design: STAGE8_MATRIX.md (37 rows, sealed 2026-07-16). Summary:
1. SequenceState: manualTP/manualSL persisted (absent-key = 0.0,
   backward compat; self-test extended). 14th save site at adoption.
2. DetectManualExitEdits (pre-substitution, each pass): armed-ticket
   deltas classified - adopt (WARN w/ money impact if exposure-
   increasing, else INFO) / conflict = adopt none + WARN / post-BE
   looser SL refused / trailing skipped (ratchet path owns it).
   Removals never adopted - enforce loop reverts + WARN (both TP+SL).
3. Want-value substitution: owned manual overrides computed before
   ApplyProtectiveEngines; engines still tighten on top. Exceeded-
   close messages name manual vs computed. Re-anchor INFO gated off
   while manual SL owned.
4. Structural TP release (ReleaseManualTP): level add / level close /
   trail-arm, WARN names trigger. Manual SL: NO structural release
   (locked - risk statement + level budget).
5. ReconcileManualExits (end of Reconcile live path): ownership
   continues on agreement; death-window close releases TP only;
   dead-window edits adopted (M7-5); mid-propagation kill completed
   + WARN (M7-7); conflicts drop to computed + WARN (M7-6). Seeds
   lastApplied/armed; one-pass detection skip (Reconcile's verdicts
   propagate without re-classification).
6. Dashboard: TP/SL rows show " [MANUAL]" while owned.

## b25 fix (found live 2026-07-17, Jeff's log - S8-2 regression FAIL)
b24 detection read the EA's OWN stale write after a structural recompute
as a trader edit (cur == lastApplied != new want for one pass) and
adopted its own previous TP: adopt/release oscillation per level add,
TP never recalculating. SL variant latent and worse (no structural
release = stale anchor frozen permanently). Fix: candidate requires
delta from want AND from lastApplied (the discriminator policy A had,
dropped in the b24 rewrite). Matrix row M5-6 added; S8-2 hardened.

## b26 fix (found live 2026-07-17, Jeff's dashboard observation)
Manual substitution was enforcement-path only: dashboard TP/SL rows,
Proj at TP/SL, and LogStructure projected from raw computed while the
broker ran on the manual value (TP row showed computed value wearing
the [MANUAL] tag; projection frozen). Fix: same substitution at both
display call sites; zero money-path changes. Matrix M2-7, checklist
S8-25 added. Pre-existing (NOT b26, parked as fold-in candidate):
Proj at SL under BE projects from the computed anchor, not the BE
floor - predates Stage 8, raise for a display decision separately.

## b27 changes (found live 2026-07-17, BE + pending sessions)
1. D2 lock enforced at arm: manual SL cleared with INFO at BE trigger
   ("BE floor owns; tighter edit can re-own, M6-1") and at trail
   activation ("ratchet owns; tighter edit becomes floor"). b26 left
   manualSL set after arm - no money impact (floor logic superseded
   it) but dashboard showed [MANUAL] on an engine-owned SL and fed
   defect 2.
2. Exceeded-close labels derive from the value's ACTUAL source
   (manual / BE floor / trail ratchet / computed by comparison, not
   manualSL>0). b26 labeled a BE-floor backstop close "manual (trader
   risk cap)" - wrong provenance in a money log line.
3. LogBrokerExitGeometry() at init (both paths, incl CONFIG-BLOCKED):
   one-shot INFO stops/freeze levels + config guidance WARNs when BE
   (Trigger-Offset < broker min: stop born unplaceable, backstop
   closes at BE price but NOT broker-held/kill-proof) or Trail
   (Distance < broker min: chronic deferral) geometry cannot place.
   Jeff's request: broker constraints guide config, not surprise
   mid-trade. Plus WARN when AutoTrading toolbar is OFF at init.
4. P6 pending-reject WARN is retcode-aware. Found live: 10027
   (AutoTrading off, toolbar) printed the fixed "broker min distance"
   suffix and sent Jeff hunting a distance problem that pre-check had
   already passed (line 262-344 pts out). 10027/10026/10017 now name
   the real cause; 10015/10016 carry the distance context.
   (Also confirmed from code: NO auto-retry on pendings - the 3 rapid
   sends were 3 confirm clicks; success clears armed state so
   double-placement is not possible.)

## Session 2026-07-18 (weekend, BTCUST surface)
Locked: seal-evidence amendment - symbol-AGNOSTIC branches accept
BTCUST demo evidence (kill battery S8-23/S8-24, S8-12/13/14, 10027);
symbol-SENSITIVE items (money-impact arithmetic, M6-1, S8-17, SELL
lap) remain XAUUSD.s-only. Rationale: TRTM is multi-instrument by
design; persistence/reconcile paths have no symbol math. Rejected:
BTC-for-everything.
S8-14 manual conflict window: attempted x3, best separation 525ms
(adjacent passes) - NOT reproducible manually. Accepted per procedure;
conflict branch evidence = K4 (M7-6 reconcile path), now REQUIRED.
Sealed this session: S8-23 (terminal-restart half, K0), S8-24a (K1,
lock re-assert proves hard kill vs K0's clean release). Bonus: 6-flip
S8-9 chain + fat-finger 650008.00 adoption (58,585,827-pt WARN exact)
recorded as live evidence attached to the rev-2 locked rationale.
BTCUST empirical: stops/freeze 0 pts at init; spread ~1400-1418 pts;
tether tick-value factor ~0.9991 on all money projections; MaxSpread
80 (gold-tuned) forfeited L2 until raised (forfeit WARNs correct).

## b29 changes (Stage 9 Step 1: tester interactive mode, matrix SEALED)
Design: STAGE9_MATRIX.md (21 rows, 5 groups, sealed 2026-07-20).
Purpose: make the SHIPPING EA interactive in the MT5 visual tester
(chart events never fire there, build 5833) with ZERO live-chart
behavior change. NO money-path changes in this build.
Touch points (+55 lines, all one file; +27 was the code estimate,
overage is inline rationale comments, no extra logic):
1. TP-1 PanelButtonSet create-block: OBJPROP_ZORDER=10 on buttons
   (bg stays 0), unconditional (D1). Only live-visible delta; M4
   proves live clicks unaffected.
2. TP-2 PollTesterButtons(): MQL_TESTER-gated, polls 10 button STATEs
   every tick (D2, no throttle); latched button -> [TESTER] click
   line -> HandlePanelClick (reused verbatim, un-presses internally).
   Two-latched-same-tick dispatch in array order (M2-5).
3. TP-3 OnTick head: poll call placed ABOVE the g_configBlocked
   early-return so a click under config-block still reaches
   HandlePanelClick's own guard (M3-1). Verified 4144 before 4145.
4. TP-4 LogTesterModeOnce(): one-shot [TESTER] init INFO (D3),
   MQL_TESTER-gated, called from BOTH OnInit exit paths (config-
   blocked + normal) so the channel is announced either way.
UNCHANGED (explicit): HandlePanelClick body, OnChartEvent (live event
path byte-identical - regression anchor), all 10 click handlers, ALL
money paths (exits/recovery/adoption/reconcile/BE/trail), state
persistence + self-test (no new persisted field), PanelRefresh value-
update path, all inputs. MQL_TESTER is net-new in the file.
Hygiene: brace delta -1 (unchanged), CRLF clean (0 bare LF), ASCII-
only. Cannot compile MQL5 - compiler output is checklist gate zero.

## b28 fix (found live 2026-07-18, K2 kill test on BTCUST - FAIL)
K2 (S8-24b) FAIL on b27: death-window close released manual TP
correctly (M7-4 WARN), but ReconcileManualExits' M7-5 branch then
re-adopted the SURVIVING ticket's broker TP 64500.00 - the EA's own
pre-kill propagation - as a trader edit, because the release had
already cleared manualTP and the branch lacked the b25 discriminator.
Net: computed 64272.94 never re-asserted; the release WARN's
"re-asserted" claim was false. SL half PASSED (ownership continued).
Root cause: order-of-operations (release clears ownership, then
classification runs against the emptied persisted value). Fix:
capture releasedTP at the release site; M7-5 candidate must differ
from it; suppressed case logs one-shot M7-8 INFO. Nuance mirrors
M5-6: a genuine dead-edit to exactly the old value is reverted once.
Matrix row M7-8 (38 rows); S8-24b hardened. Live-path detection
untouched (b25 discriminator already correct there). Queued
observability items remain queued (fix-only build). FAIL evidence
retained: 23:44:59 log block 2026-07-18, b27.

## Stage 9 Step 1 - SEALED by Jeff 2026-07-20
Tester interactive mode on the SHIPPING EA. All 19 checklist items
PASS. Two environments: LIVE demo (regression) + MT5 visual tester
(GBPAUD.s M15, build 5833). Evidence audited to the cent.

LIVE regression (safety gate - proves zorder change is clean live):
- S9-1 PASS: live init shows NO [TESTER] line (gate holds, MQL_TESTER
  false live). S9-2 PASS: all buttons dispatch via OnChartEvent, NO
  [TESTER] poll line ever (verified absence). S9-3 PASS: object list
  = 0 objects (buttons still HIDDEN, no strays, screenshot). S9-4
  PASS: zorder survived ~3 min refresh churn, all buttons responsive
  first-click (M4-3 clean, no finding).

TESTER items:
- S9-5 PASS: one-shot [TESTER] init INFO, at init not per-tick (x2+
  launches). S9-6 PASS: same line fires from the CONFIG-BLOCKED init
  path too (TP-4 both call sites live).
- S9-7/S9-8 PASS: poll channel dispatches on shipping EA; ALL 10
  buttons have DIRECT [TESTER] poll lines (equivalence not needed) -
  B_BUY/SELL/CLOSE/PBUY/PSELL/PCONF/PCXL/CXLP/BE/TRAIL.
- S9-9 PASS: latch-fires-once, accepted on ~18-click accumulated
  evidence (no double-fire ever). S9-10 PASS by inspection+procedure:
  same-tick two-button contention not manually reproducible (3 tries,
  best 1 tester-sec; mirrors S8-14). Poll loop is for(i=0..9) over a
  static array, no inter-iteration state -> array-order dispatch is a
  structural guarantee. Adjacent-tick sequential (E4 arm-switch)
  directly evidenced.
- S9-11 PASS (the no-silent-path row): under config-block the poll
  reaches HandlePanelClick (loop sits ABOVE the OnTick config-blocked
  return, 4144<4145), refusal logged ONE-SHOT via AlreadyLogged, no
  order, no silent swallow. Repeat clicks still emit the poll line
  (channel never silent) while the refusal is suppressed (one-shot) -
  both observability axes satisfied. S9-12 PASS by composition: true
  mid-run input change is a TESTER LIMITATION (inputs locked per
  pass); block->clean transition proven by blocked-run clean latch
  behavior + clean-run dispatch + g_configBlocked reset at OnInit
  boundary (line 4009, code-confirmed).
- S9-13..S9-19 PASS: full lifecycle via poll. BUY/SELL arm+open
  (signs exact), CLOSE arm+confirm+flat (x2), pending PBUY place+
  confirm+CXLP cancel AND PSELL/PCXL placement-cancel, BE arm+trigger
  (floor = avg + 30 offset exact: 1.88457+30pts=1.88487), trail
  arm+ratchet+exit (activation -100 exact; steps 34pt/11pt >= min 10;
  exit on trailed SL 1.88297, attribution correct). Pending-confirm
  broker-min guard fired correctly (line 1pt from market < 25 min,
  named cause).

TESTER EMPIRICAL FACTS (ledger; terminal is truth):
- GBPAUD.s stops level = 25 pts (tester), confirms prior probe.
- Cross-pair first-trade symbol auto-sync (GBPUSD.s, AUDUSD.s load on
  first GBPAUD position): this is MetaTester's USD-valuation engine
  loading conversion legs, NOT a TRTM behavior (plain tester lines,
  no [TRTM] tag; TRTM only touches _Symbol via the wrapper). Would
  reproduce on b28. Verifiable: USD-quote symbol shows no pop-ups.
- Config-block refusal ("Buttons are config-blocked") is one-shot in
  tester too (AlreadyLogged cfgclick).
- Tester input limits: inputs locked per pass (no mid-run change);
  object drag dead (draggable pending line). WORKAROUND b33: Stage 9
  Step 2 adds tester-only +/- nudge buttons to move the pending line.
- MT5 visual tester has NO in-pass EA restart (observed 2026-07-21,
  Jeff-corrected): no remove/re-attach, no Properties/param-change
  re-init mid-pass. To re-init you must stop and restart the whole pass
  from the beginning. => restart-row tests (e.g. S18) run on a LIVE demo
  chart, where remove/re-add / recompile / param-change fire a real
  OnDeinit->OnInit. (OBSERVED, not assumed.)

## b29-QUEUED observability batch: NOW BUILT as Stage10-b30 (2026-07-21).
Own matrix/checklist (STAGE10_*). All 5 confirmed items (A1-A5) in the
build; A6 parked. Awaiting live+tester verification before seal.

## Stage 8 Step 1 - SEALED by Jeff 2026-07-20
Final market-hours session (XAUUSD.s, demo, logs audited to the cent):
- M6-1 PASS 07:16:42 - post-BE above-floor SL edit 3991.74 (floor
  3991.66, +8 pts) adopted INFO with level-budget note. BE trigger
  3992.36 fired @ 3992.59; floor = avg 3991.36 + 30 pts exact;
  deferred placement (93 pts < 100 min) then applied - acceptable
  per seal criteria.
- S8-17 PASS 16:01:01 - manual TP 4024.59 owned at trail arm ->
  "RELEASED - trailing armed" WARN (M5-3 call site), TP removed same
  pass, supersede INFO for owned SL 4009.46, activation SL
  4021.06 = 4022.56 - 150 exact.
- SELL lap PASS (three sequences 16:02-17:45):
  S8-10(S): tighter-classification SELL sign flip proven (4048.72,
    4040.91 each lower = tighter -> INFO; same branch as
    tighter-vs-computed). Loosen side corroborated: 4050.54 WARN
    $34.64 = 1732 pts x 0.02 exact (M3-2 SELL, gold arithmetic).
  S8-15(S): PASS twice (L2 add 16:17, L3 add 17:42) - release WARN
    names level, computed re-asserted, manual SL untouched in every
    exits-applied line (M5-1(S) + M3-4(S)).
  S8-6(S): PASS 17:44:54 - 3-level seq (0.02/0.02/0.03), TP edited
    on MIDDLE ticket 666655888 (L2), adoption INFO (36 pts closer =
    exposure-decreasing, correct), propagated to L1+L3 within 216ms
    one pass, all 3 carry 4015.70.
- Projection audits exact throughout: 2-level +12.00/-35.76;
  3-level +23.11/-53.19 (proj from manual SL when owned - display
  truth holding); computed TP 4015.34 = simple avg 4018.3433 - 300.
- Bonus evidence: M6-3 ratchet-floor adopt live BOTH directions
  (4021.26 BUY 16:01:12, 4024.36 SELL 16:29:15) - upgrades S8-21
  from equivalence to direct evidence.
- First trail-arm attempt 07:52 was NOT S8-17 evidence (L2 add at
  07:41 had already released the TP via M5-1; M5-3 site never ran) -
  rerun performed; recorded so equivalence is never claimed here.

## Accepted cosmetics (recorded, not churned)
- Benign duplicate "Exits applied" line after stops-level deferral
  retry (same value, no money impact). Seen 16:01:07/16:01:08 (BUY)
  and 16:29:06 (SELL). Display/log ordering quirk only.

## Parked additions 2026-07-20
- Computed-TP anchor: SIMPLE average of entries (code comment lines
  1094-1097 marks simple-vs-lot-weighted as a PENDING decision,
  "implemented to match spec until then"). First unequal-lot live
  evidence today: 0.02/0.02/0.03 -> simple avg 4018.3433 vs weighted
  4018.6414; simple sets TP beyond financial BE+300 when late lots
  are larger (errs profitable). Needs its own Gate 1 when raised -
  money-path change, do not fold in.

## Locked decisions log (additions this session)
2026-07-23 E4 O1 RUNG RE-ARM = UNRESTRICTED REFILL (Gate 1 LOCKED; matrix +
plan still required before any code). After a Tier 1 fire vacates a rung's
ADDRESS, that address refills by the ORDINARY recovery-ladder re-arm - the
same derived path as the level's first open (price = anchor + N*interval, lot
= ComputeLevelLot(N) under C3 preserved index). NO extra re-arm-travel
criteria, NO "armed" flag, NO per-rung last-closed state. Nothing new
triggers the refill (the normal recovery ladder recomputing from the
surviving top does) and nothing is stored - both price and lot stay DERIVED,
C3 invariant intact. FIRE-GROUP reminder (so the re-arm scope is not
misread): Tier 1 closes the anchor (oldest) + ALL currently-profitable
positions, so a 6-level basket can vacate e.g. L1(anchor)+L4/L5/L6, leaving
underwater survivors L2/L3 - not just top+bottom; every vacated address
re-arms by the same rule.
  DIRECTION REALITY (Jeff's clarification 2026-07-23, structural not
  probabilistic): only the HIGHER closed rungs re-arm; the LOWEST closed rung
  (the anchor) NEVER re-arms. The recovery ladder extends ONLY in the adverse
  direction (a SELL adds higher rungs as price rises), never below the current
  lowest survivor. The closed anchor sits at the FAVOURABLE extreme (lowest
  price for a SELL), so revisiting it needs price to move FOR the basket -
  which heads toward basket TP, not toward a recovery add. Concretely: a fire
  closes L1(anchor,bottom) + the profitable top band L4/L5/L6, leaving
  survivors L2/L3; recovery re-arms L4->L5->L6 above the top survivor as price
  moves adverse again, and L1's address is never revisited by an add.
  RATIONALE: every refill->close cycle is net-POSITIVE by construction - the
  threshold guarantees the group nets >= MinProfitPoints/lot (run A +30.16
  lot-pts; run B fire2 +29.72), so there is NO loss mechanism to gate against.
  Rate is already bounded: the bar-close entry gate caps refills at 1/M15 bar
  (<=96/day) and each refill still needs a qualifying tick clearing the
  threshold (observed: 2 fires in 4 days, run B). A re-arm-travel gate would
  defend against no loss while forcing per-rung STORED state that breaks C3's
  derived-only design and adds a fresh touch on the sealed ladder - cost
  against zero financial benefit. Jeff confirmed 2026-07-23.
  LADDER-CONSUMPTION cost ACCEPTED (bounded by fires; each fire spends the
  oldest; 9 fires empties a 9-rung ladder even if all 9 profit) - that IS the
  intended pressure-valve behavior. The residual "should deeper/later fires be
  worth MORE" question is handed to O2, not gated here.
  Rejected: require extra travel before a vacated rung re-arms. Rejected -
  defends against no loss (every cycle net-positive), requires per-rung stored
  state breaking C3, and duplicates the rate throttle the bar-close gate
  already provides.

2026-07-23 E4 O4 FAR-SIDE PRICE = DIRECTION-DERIVED, basis = PLATFORM INVARIANT
(Gate 1 LOCKED; matrix + plan still required before any code). The Tier 1
trigger far-price - the price the group's margin is measured against AND the
side the group closes at - is DERIVED FROM BASKET DIRECTION: SELL basket ->
Ask, BUY basket -> Bid. Never a hardcoded/fixed side.
  BASIS (Jeff 2026-07-23, first-principles - stronger than a single Shadow
  observation): a market close of a BUY is a SELL executed at BID; a close of a
  SELL is a BUY executed at ASK. Broker/platform INVARIANT, always true, and
  ALREADY the behavior of TRTM's SEALED TP + manual-exit close paths (buys have
  always exited at Bid across the whole sealed core). So the BUY side needs NO
  Shadow buy fire to justify it - buy-closes-at-Bid is a platform fact TRTM
  already relies on. Shadow's SELL-closes-at-Ask (observed 3x: run A + run B
  x2) corroborates the SELL side.
  DEFECT CLASS the rule guards (EA-CODE risk, NOT a platform risk): computing
  the trigger MARGIN against a FIXED side (e.g. SYMBOL_BID as "current price"
  regardless of direction). The CLOSE always executes on the correct broker
  side, so the danger is a MISMATCH - the EA tests the margin on the wrong
  side, so tested margin != realized margin by one spread (a BUY tested vs Ask
  fires ~1 spread optimistic; realized close at Bid is worse). TRTM must
  compute the trigger far-price on the SAME side the close will execute, so
  tested margin == realized margin.
  MATRIX: still BOTH laps (SELL + BUY) - NOT to prove buys close at Bid
  (platform-guaranteed) but to prove TRTM's CODE derives the far-price from
  direction and does not hardcode a side. The BUY lap is validated against the
  platform invariant + arithmetic, not against a Shadow reference.
  CONSEQUENCE for E7 R3: R3 ("get a BUY sequence") was listed ONLY to observe
  O4's buy side. O4 is now decided from the platform invariant, so R3 is NO
  LONGER NEEDED for O4 and nothing in E4 blocks on it (R3 retains only general
  buy-side corroboration value; de-prioritized).
  Rejected: any fixed Bid/Ask read - passes SELL-only evidence, breaks live on
  the first BUY basket, surfaces only on the untested side.

2026-07-23 E4 O3 POST-FIRE SUPPRESSION = NONE (no input, no hardcoded timer)
(Gate 1 LOCKED; matrix + plan still required before any code). TRTM does NOT
port Shadow's hardcoded 3s recovery-suppression window and does NOT expose it
as an input.
  RATIONALE: TRTM recovery entry is BAR-CLOSE gated (the same gate O1 relies
  on - 1 refill per M15 bar). A 3s window NEVER binds under bar-close entry:
  the fire lands mid-bar (Shadow log 14:57:40) and the next possible recovery
  entry is the next M15 bar close, minutes away, always >> 3s. Porting the
  timer would be dead code. Shadow itself ran InpRecoveryBarCloseEntry=true in
  both runs AND still hardcoded 3s - a generic defensive belt, redundant once
  entries are bar-gated.
  WHAT ACTUALLY NEEDS PROTECTING (implementation invariant, not a knob): the
  recovery-state refresh (Shadow's RefreshRecoveryState) must be ATOMIC with
  fire completion - synchronous, in the same handler, before any next
  bar-close evaluation - so the next bar-close already sees correct post-fire
  state (survivors, Level, LastPrice). No stale-state window then exists, so no
  timer is needed. A post-fire rung re-arming on the next bar close is exactly
  the O1 unrestricted-refill behavior already locked - desirable, not
  suppressed.
  Rejected: expose a suppression input (a knob that does nothing under
  bar-close entry - misleading). Rejected: port Shadow's hardcoded 3s (dead
  code under bar-close gating).
  PLAN-TIME RIDER (parked): this rests on recovery staying bar-close gated. If
  TRTM ever adds TICK-based recovery entry (relevant to E3 auto-entry),
  revisit with a minimal "no recovery entry on the same fire tick" guard, NOT
  a wall-clock timer. Out of scope for E4.

2026-07-23 E4 O5 GROUP-CLOSE ORDER + PARTIAL-FILL = PROFITABLES-FIRST /
ANCHOR-LAST + ABORT-ON-FAILURE (Gate 1 LOCKED; matrix + plan still required
before any code). CHOSEN - a deliberate safety divergence from Shadow's
OBSERVED order. Rule:
  1. Reuse the SEALED close-with-retry routine (manual-exit/TP path); do NOT
     invent a new close path.
  2. ORDER: close ALL profitable legs FIRST, the ANCHOR LAST (inverts Shadow's
     anchor-first). The anchor is the only loss leg; its loss is realized ONLY
     after the covering profit is already banked. Among profitables, descending
     ticket for determinism.
  3. Bounded retries per leg via the sealed routine, then treat the leg as
     failed.
  4. ABORT RULE: the anchor closes ONLY if every profitable leg is confirmed
     closed. If any profitable leg fails after retries -> STOP, do NOT touch
     the anchor; leave it open. Tier 1 re-evaluates next qualifying tick (group
     re-forms from what is open, threshold re-checked - self-correcting).
  INVARIANT PROOF (protects O2's "group never closes at a combined loss"): all
  profitables + anchor -> = tested group, >=0. Some profitables close then one
  fails -> abort anchor -> realized = pure profit subset, strictly >=0. All
  profitables close then anchor fails -> realized = pure profit, anchor stays,
  strictly >=0. Worst partial outcome is a SAFE DEFERRAL (harvested winners,
  did not shed the anchor this cycle), never a realized combined loss.
  OPTIONAL GUARD NAMED, NOT ADOPTED (Jeff 2026-07-23, my lean out): gating the
  final anchor close on banked-profit-so-far >= anchor cost-to-close would
  cover adverse anchor drift between banking profit and closing the anchor -
  negligible in practice (Shadow's fires landed whole-group on one sub-second
  tick), and the profitables-first order + abort rule already protect the
  invariant. Parked as a cheap future hardening if ever wanted.
  SHADOW EVIDENCE (run B 14:57:40 fire, pasted 2026-07-23, CONFIRMS the
  OBSERVED half and the GAP): Shadow closes ANCHOR FIRST (#2, the loss leg)
  then profitables DESCENDING TICKET (#11 then #10), ONE market order per leg
  (a buy to close each sell), all three filled on one sub-second tick
  (23:49:26.959->.965). NO retry, NO error handling, NO partial-fill path -
  the failure branch is never exercised, so Shadow's logs CANNOT define
  failure behavior. That is precisely why O5 is a TRTM CHOSEN rule. Shadow got
  away with the fragile anchor-first order only because no leg ever failed.
  Also re-confirms F3 (close deals #12/#13/#14 print "Confirmed initial deal
  #N. Position count is 0" - close-deals routed through the initial-entry
  branch; TRTM's transaction handler must not).
  Rejected: Shadow's anchor-first (realizes the loss before securing the
  profit - the exact failure the invariant forbids). Rejected: rollback/reopen
  a closed leg on failure (reopening is fresh entry risk - new price, slippage,
  re-derived lot/level). Rejected: all-or-nothing pre-check (cannot pre-verify
  a market order will fill; not implementable).

2026-07-23 E4 O2 THRESHOLD = FLAT MinProfitPoints, scaling PARKED (Gate 1
LOCKED; matrix + plan still required before any code). MinProfitPoints stays a
single flat constant - same value for the first fire and the ninth. NO
depth-scaling term (no 150 + K*(count-MinTrades)).
  RATIONALE: C1's anchor-cost escalation ALREADY provides implicit
  depth-scaling - a more-negative anchor demands a larger profitable tail to
  reach the same VWAP-margin, so later fires are structurally harder without a
  new knob (run B: fire1 surplus +30.16 lot-pts on a 0.01 anchor; fire2
  surplus FELL to +29.72 despite a LARGER profitable tail, because the 0.02
  anchor cost +63% more). Eventually cost-to-close exceeds any achievable tail
  and Tier 1 simply stops firing (run A basket 14:57: L1 27.1 -> L2 46.9 ->
  L3 59.2 -> L4 63.6 lot-pts). An explicit scaling term double-counts this and
  adds an UNVALIDATED tuning constant with zero reference evidence (Shadow ran
  flat 150 across both fires). Reversible: if live TRTM runs later show Tier 1
  firing too eagerly at depth, a scaling term is a clean follow-up.
  Rejected: depth-scaled threshold now - premature, redundant with the
  automatic anchor-cost self-limiting, unvalidated knob.

  TWO-GATE TRIGGER STRUCTURE clarified this session (Jeff's two points
  2026-07-23), both LOCKED, feeding the matrix:
    GATE A (depth): total OPEN POSITION COUNT >= MinTrades. NEW INPUT "Tier 1:
      Min Trades to Activate" (Shadow's MinTrades, was 4; TRTM default 4).
      Gates on the COUNT of currently-open positions, NOT the level index. In
      a fresh unbroken ladder these coincide (reach L4 = 4 open); under C3
      after a fire the index is preserved while the count drops, so they
      DIVERGE and the durable rule is COUNT-based. CONSEQUENCE (Jeff confirmed
      2026-07-23): a fire that drops open count below MinTrades makes Tier 1
      DORMANT until recovery rebuilds the count to >= MinTrades - a shallow
      basket is not under drawdown pressure and does not need the valve;
      Tier 1 re-activates once the ladder deepens again. Count is always the
      REMAINING open positions.
    GATE B (profit): the group (anchor + ALL currently-profitable positions)
      combined P/L must clear MinProfitPoints per lot (the VWAP-margin framing
      is the lot-size-independent form of the same test). This subsumes "is it
      positive?" - clearing a positive MinProfitPoints guarantees combined > 0.
    HARD MONEY-SAFETY INVARIANT (Jeff's Point 1, elevated): a Tier 1 group must
      NEVER close at a combined loss. The ANCHOR alone always realizes a loss;
      the GROUP (anchor + profitables) never does. Positivity is the GROUP
      combined, NOT each leg and NOT the whole basket. O5 (partial-fill) must
      protect this invariant if a close leg fails mid-group.
  PLAN-TIME RIDER (not an O2 decision): MinProfitPoints is in POINTS and
  symbol-relative. Shadow's 150 was GBPAUD.s (5-digit); on XAUUSD.s (_Point
  0.01) 150 pts = a $1.50 move - the DEFAULT value for gold must be chosen
  deliberately at plan time, independent of flat-vs-scaled.

2026-07-24 E4 O2 PLAN-TIME RIDER RESOLVED (Gate 3): InpTier1MinProfitPts
DEFAULT = 150 points. ONE input, in POINTS, symbol-relative, per-chart
overridable - the EA does NOT branch on symbol (same as the existing
InpRecoveryIntervalPts / InpAvgTPPts defaults).
  RATIONALE (Jeff 2026-07-24): TRTM's PRIMARY use is FOREX recovery-trade
  management; XAUUSD.s is only a fast TEST surface (volatility reaches levels
  faster). The shipped default therefore targets the primary use, not gold.
  150 is the forex-native number (Shadow's GBPAUD.s value) and is kept ON
  MERIT for forex, not as a coincidental gold point-count. A gold user
  overrides per chart.
  Rejected: 200 pts (parity with InpAvgTPPts, a GOLD-framed rec I proposed
  before the forex-primary framing was corrected) and 300 pts (one full
  recovery interval) - both were gold-centric and do not fit the forex
  primary use. Reversible per chart at any time (it is an input, not a
  constant).

2026-07-24 E4 H-6 SL RE-ANCHOR IMPLEMENTATION = CONFIRM EXISTING PATH +
FIRE-THEN-RETURN (Gate 3; Jeff confirmed 2026-07-24). NO new SL code. On a
Tier 1 fire, EvaluateTier1 returns from the tick (no recovery add that tick);
the NEXT tick CheckSequenceLiveness prunes the EA-closed anchor and
ComputeTargets recomputes minLvl = new lowest survivor, re-anchoring the SL
through the EXISTING path (EnforceExits:1511) - the same mechanism a manual L1
close already uses.
  RATIONALE: ComputeTargets already anchors SL to the lowest surviving level
  and skips missing tickets; the re-anchor is not new behavior. Fire-then-return
  is the only guard needed (H-5 atomicity - no higher rung added before the
  prune+re-anchor settles). Mid-fire the survivors hold their old (tighter,
  protective) broker-side SL; the basket is NEVER left unprotected. Preserves
  the "EnforceExits is the single SL writer" invariant.
  Rejected: explicit synchronous re-anchor inside EvaluateTier1 - adds a SECOND
  SL writer, touches the sealed exit path more heavily, and risks the async gap
  where the just-closed anchor is still PositionSelectByTicket-visible for a
  tick (wrong-anchor read). H-6 remains a VERIFY-time proof obligation (SL moves
  to new oldest, never references a closed ticket, never unprotected mid-fire,
  BUY+SELL laps), not a code rewrite.

2026-07-24 E4 M-1 WHOLE-BASKET STAND-DOWN (live finding -> matrix rev 2 amendment;
build E4-b36). Jeff confirmed 2026-07-24. When the Tier 1 group would close the
ENTIRE open basket (no underwater survivor remains), Tier 1 STANDS DOWN instead
of firing. Guard: grp size >= openCount (grp always contains the anchor, so this
means every non-anchor position is profitable).
  FINDING (live gold demo, 2026-07-24 16:02): a 4-level all-in-group fire closed
  the whole basket at group margin 152.8 pts, PRE-EMPTING the sequence's own
  AvgTP (200 pts, projected +19.98). Because group==basket, Tier 1's VWAP == the
  sequence VWAP, so with MinProfitPts(150) < AvgTPPts(200) Tier 1 always fires
  first and banks LESS than the sequence would unaided. Spec-compliant with G-1
  but not traced in the sealed matrix (which assumed partial valving on a deep
  underwater basket).
  DECISION (A) chosen over (B): (A) stand down whenever group==whole basket (no
  survivor); (B) stand down only when the anchor itself is profitable. (A) makes
  Tier 1 NEVER worse than the baseline sequence exit (the finding's core concern)
  and covers the anchor-sole-loser case (the likely live fire); (B) leaves that
  case still clipping the TP. Give-back objection answered: standing down hands
  the full close to the sequence's OWN AvgTP-exceeded market close (bank-at-market,
  give-back-averse, banks the higher +200) - deferral to a better guaranteed exit,
  not hoping.
  SCOPE: inert on every partial valve (grp < openCount) - all prior VERIFIED fires
  (GBPAUD SELL x4, gold BUY x5, GBPAUD fire1) had grp < openCount, so they are
  unchanged. Only the whole-basket case flips from fire to stand-down.
  Rejected: (B) anchor-profitable-only (partial fix); accept-as-is (leaves Tier 1
  strictly worse than Tier1-off on green baskets); scaling MinProfit vs AvgTP by
  guidance only (relies on the trader tuning, does not fix the interaction).
  VERIFY BEFORE RE-SEAL: reproduce the whole-basket case -> now logs "Tier 1
  stands down ... (M-1)" and the sequence AvgTP banks the full close; confirm a
  PARTIAL fire still fires byte-identical (regression vs the verified runs).

2026-07-24 E4-b36 SEALED by Jeff. Full evidence-audited verification complete
(see docs/E4_VERIFY_CHECKLIST.md). Matrix rev 2 (36 rows + M-1) SEALED. Every
money-path row recomputed to the cent: fire path BOTH directions (SELL GBPAUD.s
tester, BUY XAUUSD.s tester), re-arm (H-2/H-4/O-1/O-2), dormancy (D-1 observed),
H-6 SL re-anchor (SELL x4 exact; BUY reasoning + direction-signed), X-2/X-3 abort
(reasoning), K-1/K-2/K-3 restart (LIVE demo kill+reconcile), C-1/C-2/H-1, P1
no-fire byte-identity, M-1 whole-basket stand-down (observed: sequence AvgTP
banked +2500 vs Tier1 +500, validated (A) over (B) on the anchor-sole-loser case),
gate zero b36. Build E4-b36 sha256_16 7e14479c83d672a4 / 4483 lines. E4 (Drawdown
Reduction Tier 1) is CLOSED. Deploy to MT5 tree is Jeff's manual step.

2026-07-24 E5 T2-O0 TIER 2 = SEPARATE DEFAULT-OFF TIER (Gate 1 LOCKED; matrix +
plan still required before any code). E7 R1 reference run delivered this session
(docs/STM Drawdown Reduction Tier2 Logs.txt; analysis in
docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md), unblocking E5. Decision: Tier 2 is
adopted as its OWN mechanism, gated by a NEW input InpEnableTier2 (default FALSE,
mirroring InpEnableTier1), REUSING Tier 1's sealed close machinery (group select,
far-side derivation, close-with-retry, TP recompute, recovery refresh). Tier 2
differs from Tier 1 in ONE thing only: the TRIGGER METRIC - group P/L in MONEY
must clear ProfitPercent% of the account reference base, vs Tier 1's group VWAP
clearing MinProfitPoints per lot. Both tiers may be enabled independently.
  OBSERVED BASIS (single Tier 2 fire, 2026.07.02 15:30, recomputed to match the
  log): trigger line "Basket P&L: 31.40 | Required (1.0% of 3026.14): 30.26";
  1.0% x 3026.14 = 30.26 (base = ACCOUNT BALANCE post-realized, proven = 3000 +
  Tier 1's +26.14 realized, NOT equity). "Basket P&L" is the CLOSE-GROUP total
  (anchor #3 -85.68 AUD + profitables #21 +40.32 + #22 +91.65 = +46.29 AUD ->
  31.40 USD), NOT the whole underwater basket. Group rule, anchor-first Shadow
  order (TRTM inverts per O5), SELL->Ask far-side, F3 close-deal defect, and
  count-reindex (TRTM keeps C3) all IDENTICAL to Tier 1.
  RATIONALE: Tier 2 is not redundant - Tier 1's points bar is account-independent;
  Tier 2's 1%*balance bar FALLS as the account draws down, so it eases mid-
  drawdown (mildly pro-cyclical harvest Tier 1's metric cannot express). Separate
  default-off tier keeps E4's seal boundary intact (no re-touch of the sealed
  trigger code), matches Shadow's own structure, and is the cleanest unit to
  matrix/verify.
  Rejected: (unified trigger w/ metric selector) - re-touches just-sealed E4
  trigger code and blurs the seal boundary for less input surface; (decline/park
  Tier 2) - forfeits the account-relative harvest.
  OPEN (resolve next, one at a time): T2-O1 reference base (balance/equity/fixed);
  T2-O2 lock "close-group P/L" naming; T2-O3 percent semantics; T2-O4 Tier1/Tier2
  coexistence + same-tick precedence (UNOBSERVED - fired on different days);
  T2-O5 inherit E4 O5 close order; T2-O6 inherit E4 O4 far-side (BUY lap
  unobserved); T2-O7 cross-currency P/L valuation (NEW money path vs Tier 1;
  collapses to identity on USD-quote symbols like XAUUSD.s).

2026-07-24 E5 T2-O1 REFERENCE BASE = ACCOUNT BALANCE (Gate 1 LOCKED; matrix +
plan still required before any code). Tier 2's percent is taken of AccountBalance:
threshold = InpTier2ProfitPercent% x AccountInfoDouble(ACCOUNT_BALANCE). Matches
the OBSERVED Shadow base (3026.14 = realized balance, proven not equity).
  RATIONALE: balance is stable tick-to-tick (moves only when trades realize), so
  the bar is not perturbed by the very drawdown Tier 2 manages; it scales the
  harvest to account SIZE, giving a predictable account-proportional threshold.
  Rejected EQUITY (balance+floating): the bar shrinks as the basket deepens
  (fires more eagerly mid-drawdown) BUT is tick-volatile and can shrink toward
  zero in a very deep basket -> runaway harvesting on trivial group profit;
  unstable trigger. Rejected FIXED money amount: drops the percent/account-
  relative character, functionally Tier 1 in money units - adds nothing new.
  RIDER for T2-O7: the group P/L (Gate B left side) is in account currency, so
  the same-currency comparison is clean; cross-currency conversion is a valuation
  concern handled in T2-O7, not here.

2026-07-24 E5 T2-O2 MEASURED P/L = CLOSE-GROUP (Gate 1 LOCKED; matrix + plan
still required before any code). Gate B tests the P/L of the GROUP actually being
closed - oldest anchor + ALL currently-profitable positions, valued at the
far-side price - against the T2-O1 bar. Same group selection as Tier 1.
  OBSERVED: the log's "Basket P&L: 31.40" is this close-group total (anchor #3
  -85.68 AUD + prof #21 +40.32 + #22 +91.65 = +46.29 AUD -> 31.40 USD), NOT the
  whole 15-position basket (deeply negative floating at that tick). TRTM must NAME
  it close-group P/L, never "basket P/L" (Shadow's misleading label).
  RATIONALE: consistent with T2-O0 (reuse Tier 1's group-close machinery) and
  preserves the HARD invariant - a positive percent bar guarantees the group nets
  >= 0, so the group can never close at a combined loss (only the anchor realizes
  a loss, covered by the profitables).
  Rejected WHOLE-BASKET floating P/L: a different mechanism (global basket TP)
  that collides with the sequence's own AvgTP and the E4 M-1 whole-basket stand-
  down; not observed. Rejected PROFITABLES-ONLY: breaks parity with the group
  that actually closes and overstates the harvest vs the group net.

2026-07-24 E5 T2-O4 TIER PRECEDENCE = TIER 2 FIRST, FALL THROUGH TO TIER 1
(Gate 1 LOCKED; matrix + plan still required before any code). When both tiers
are enabled, each tick evaluates Tier 2 (percent) FIRST; if its gate passes,
fire + credit Tier 2. Else evaluate Tier 1 (points); if it passes, fire + credit
Tier 1. Both tiers select the IDENTICAL group and reuse the SAME fire-then-return
close, so exactly ONE fire per tick and the group that closes is identical
regardless of precedence - this is an ATTRIBUTION/logging choice, money-neutral.
E4 M-1 whole-basket stand-down applies to BOTH tiers (a whole-basket group defers
to the sequence AvgTP no matter which gate passed).
  EVIDENCE (both Shadow fires, recomputed - reproduces this exact rule): at the
  Tier 2 fire (07/02 15:30) Tier 1's gate was ALSO satisfied (group VWAP 1.93113,
  margin vs Ask 1.92931 = 181.6 pts >= 150) yet Shadow credited TIER 2 -> Tier 2
  has precedence. At the Tier 1 fire (06/30 14:16) Tier 2's gate FAILED (group
  ~26.6 USD < 1% x 3000 = 30.00) so it fell through and fired TIER 1. One
  both-pass observation, arithmetic unambiguous. Shadow = reference; TRTM matches
  its precedence deliberately (no money reason to diverge).
  CORRECTION 2026-07-25 (F5, E5 Gate 4 recompute): the EVIDENCE above is WRONG on the
  both-pass claim. The Tier-2-fire margin consistent with the logged 31.40 USD group
  P/L is 149.3 pts (VWAP 1.9308032 = 0.5985490/0.31, confirmed by the group-P/L
  identity 46.29/(0.31*1e5)), BELOW 150 - so Tier 1's gate was NOT met at the 07/02
  15:30 fire (matrix had mis-stated VWAP 1.93113 / margin 181.6, a /0.31 slip). That
  fire evidences ONLY that Tier 2 fired, NOT precedence. The DECISION (Tier-2-first)
  is UNCHANGED - it stands on merit + money-neutrality (T2-PR4). But there is NO
  reference both-pass observation: T2-PR1 must be verified LIVE via a constructed
  both-gates-pass tick. docs/E5_MATRIX.md (WORKED REFERENCE / G-PR / T2-PR1) carries
  the same correction; code correctly implements Tier-2-first (unaffected).
  Rejected TIER 1 FIRST (diverge): money-identical, but does not match the
  reference and there is no reason to flip attribution. Rejected fully-independent
  evaluators: risks a double-close attempt on the shared group without an explicit
  single-fire guard.

2026-07-24 E5 T2 GATE A = OWN INPUT InpTier2MinTrades, DEFAULT 4 (Gate 1 LOCKED;
matrix + plan still required before any code). Tier 2 eligibility requires open
position count >= InpTier2MinTrades (default 4, = Shadow InpPC2_MinTrades),
a SEPARATE input from InpTier1MinTrades. Same count-based semantics as Tier 1
Gate A: Tier 2 is DORMANT while open count < InpTier2MinTrades and re-activates
as recovery rebuilds the count; count is always REMAINING open positions (post
any fire).
  RATIONALE: separate input keeps the tiers independently tunable (T2-O0 separate-
  tier) and matches Shadow's separate PC2 param; the count gate confines Tier 2 to
  a basket deep enough to be under real drawdown pressure, same as Tier 1.
  Rejected SHARE InpTier1MinTrades: couples the tiers, contradicts separate-tier.
  Rejected NO count gate: could fire on a shallow basket not under drawdown
  pressure; diverges from Shadow.

2026-07-24 E5 T2-O5 + T2-O6 = INHERIT E4 CLOSE MECHANICS VERBATIM (Gate 1 LOCKED;
matrix + plan still required before any code). Tier 2 reuses Tier 1's sealed close
machinery unchanged:
  O5 CLOSE ORDER: profitables-first, anchor-last, abort-the-anchor on ANY
    profitable-leg failure after bounded retries, via the sealed close-with-retry
    routine (E4 O5). Realizes the anchor loss only after the covering profit is
    banked; worst partial outcome is a safe deferral, never a realized combined
    loss - preserves the T2-O2 >=0 group invariant.
  O6 FAR-SIDE/CLOSE PRICE: direction-derived (SELL basket -> Ask, BUY -> Bid;
    E4 O4 platform invariant). Trigger margin measured on the SAME side the close
    executes. BUY lap validated against the invariant + arithmetic (Tier 2 BUY
    fire UNOBSERVED, same as Tier 1).
  RATIONALE: money-safety rules TRTM already settled deliberately for Tier 1;
  reusing them (T2-O0) keeps ONE close path and one set of proven invariants.
  Rejected reopening the close order (e.g. Shadow's observed anchor-first for
  Tier 2): re-litigates a settled money-safety rule for no gain.

  --- E5 GATE 1 STATUS 2026-07-24: locked = T2-O0 (separate default-off tier
  InpEnableTier2), T2-O1 (base=balance), T2-O2 (measured=close-group), T2-O4
  (precedence Tier2-first/fall-through, shared group, 1 fire/tick, M-1 both),
  Gate A (InpTier2MinTrades=4 + count dormancy), T2-O5/O6 (inherit E4 close).
  Gate B = close-group P/L(money, acct ccy) >= InpTier2ProfitPercent% x balance.
  PLAN-TIME RIDERS (resolve at Gate 3 plan, like E4 O2's default): (a) T2-O3
  InpTier2ProfitPercent DEFAULT (Shadow 1.0%) - a percent, symbol-agnostic, but
  confirm the shipped default on merit; (b) T2-O7 cross-currency group-P/L
  valuation to account currency - collapses to identity on USD-quote symbols
  (XAUUSD.s), so TRTM's gold evidence surface will NOT exercise the conversion;
  the matrix needs a cross-currency reasoning row. GATE 2: docs/E5_MATRIX.md
  SEALED rev 1 by Jeff 2026-07-24 (30 rows, 12 groups; 23 NEW Tier-2 rows +
  INHERIT-E4 rows). GATE 3 plan docs/E5_PLAN_2026-07-24_gate3.md CONFIRMED by Jeff
  2026-07-24 (shared-dispatcher; TP-1..TP-7 incl. display-only DASHBOARD "DD Reduce"
  row). BUILT E5-b37 2026-07-24 (sha256_16 73dda148c79f1b27 / 4568 lines, +85 vs
  b36; CRLF+ASCII clean, brace delta -1 pre-existing baseline). EvaluateTier1 ->
  shared FormBasketGroup + FireGroupClose + EvaluateBasketClose dispatcher (Tier 2
  first). Matrix amended rev 2 (+G-DS/DS-1 dashboard). COMPILED clean + DEPLOYED
  (runtime == repo) + VERIFIED (all 34 rows) + SEALED by Jeff 2026-07-25 (seal entry below).

2026-07-24 E5 GATE 3 PLAN-TIME RIDERS RESOLVED (Jeff 2026-07-24; matrix already
sealed, plan + confirmation still required before any code):
  T2-O3 InpTier2ProfitPercent DEFAULT = 1.0% (matches Shadow InpPC2_ProfitPercent;
    percent-of-balance is symbol-AGNOSTIC so no forex/gold split; on merit a
    sensible round harvest bar, and the value the reference evidence was captured
    at). Rejected 0.5% (fires too eagerly, consumes ladder) and 2.0% (fires rarely).
  T2-O7 GROUP P/L VALUATION = SUM of members' POSITION_PROFIT (account currency,
    close-side valued, PRICE-ONLY - excludes swap/commission). Reproduces Shadow's
    31.40 and handles cross-currency + far-side by construction (no manual FX).
    GROUNDED IN TIER 1 CONSISTENCY, not Shadow-matching: the log CANNOT settle
    Shadow's swap handling (the reported "Basket P&L" back-solves the FX rate, so
    swap vs AUD/USD-drift is inseparable; ~1.7% gap between the 06/30 balance-
    implied rate 0.6667 and the 07/02 line-implied 0.6783 could be either). TRTM's
    sealed Tier 1 threshold is price-only (points distance), so price-only Tier 2
    keeps one basis + the >=0 invariant clean; swap remains a separate realized
    cost (C1 accepts the swap-heavy anchor). Rejected INCLUDE-SWAP (splits basis
    from Tier 1, can push a fired group below the bar) and MANUAL price+FX
    (reinvents POSITION_PROFIT, reintroduces the G-V2 cross-currency bug).

2026-07-25 E5-b37 SEALED by Jeff. Full evidence-audited verification complete (see
docs/E5_VERIFY_CHECKLIST.md). All 34 matrix rows (SEALED rev 2) recomputed to the cent /
confirmed. XAUUSD.s money paths (tester): SELL fire x5 + BUY fire x2 (group P/L = sum
POSITION_PROFIT; bar = InpTier2ProfitPercent% x live ACCOUNT_BALANCE - balance chain proven,
NOT equity), anchor oldest-transfer, profitables-first/anchor-last close, SELL@Ask / BUY@Bid
far-side, tick/mid-bar timing, lot-weighted survivor TP, SL re-anchor BUY x2 (+ a real
broker-SL hit that capped the basket), preserved-index re-arm, dormancy (5 fire->dormant->
rebuild cycles), must-nots, M-1 whole-basket stand-down (observed), Tier-2-off byte-inert
(R1), Tier-2-on recovery-unchanged (R2), no persisted field (R3 - self-test PASS), V1/V2/V3
gold identity. PRECEDENCE (T2-PR1..PR4): Tier-2-first credit+return + Tier-1 fall-through x4,
both live-recomputed. K1/K2 restart/kill: LIVE BTCUST demo (symbol-agnostic per the
2026-07-18 seal amendment) - unclean-kill lock re-assert + reconcile rebuilt the 2-level
basket from live positions, NO orphan Tier 2 state (Tier 2 persists nothing). DS-1 dashboard
4 states: Jeff visual-confirmed. Gate zero clean; runtime == repo 73dda148c79f1b27 / 4568.
E5 (Drawdown Reduction Tier 2) is CLOSED. Deploy done (Jeff's manual step); E5-b37
UNCOMMITTED (Jeff's call - E4-b36 committed-not-pushed, E1 pushed origin/main @ 864effe).
  STRUCTURAL INSIGHT (deepens F5): group money P/L = margin_pts x SUM(group lots). The Tier 1
  (points) and Tier 2 (%-money) metrics therefore cross the SAME group margin only at a single
  point (Sumlot = bar/T1), so on a SMOOTH retrace the lower-threshold gate fires first and both
  gates are essentially never "just met" on one tick - a literal both-gates-pass is JUMP-ONLY.
  This is the real reason F5's reference smooth both-pass was an arithmetic artifact. The
  Tier-2-first tie-break (when both pass) is CODE-GUARANTEED (dispatcher checks Tier 2 before
  Tier 1). Live PR evidence this session supersedes the (corrected) reference for T2-PR1.
  F5 remains annotated in docs/E5_MATRIX.md (WORKED REFERENCE / G-PR / T2-PR1 / Status), the
  T2-O4 block above, and the findings register - evidence-only; the DECISION is unchanged.
  Optional-only (NOT blocking, deferred): a literal forced both-gates-pass jump (fragile,
  data-dependent) and an XAUUSD.s live-demo K1/K2 touch (BTCUST already covers symbol-agnostic).

2026-07-23 E1 ANCHOR BASIS = LOT-WEIGHTED, ALL THREE PATHS (Gate 1
LOCKED; matrix + plan still required before any code). Decision: replace
the SIMPLE-average sequence anchor (g_curAvgEntry, TRTM.mq5 line 1091,
"locked structural") with the LOT-WEIGHTED AVERAGE of open entries
(sum(lot_i*entry_i)/sum(lot_i)), applied to EVERY path that reads the
anchor - NOT TP alone. SCOPE FENCE: E1 changes ONLY the exit/protection
anchor. It does NOT touch Recovery - not level lot sizing (ComputeLevelLot
line 1755, sealed closed-form, untouched) and not level spacing (the
anchor + N*interval ladder does not read g_curAvgEntry). Recovery stays
byte-identical. TERMINOLOGY: this lot-weighted average is the same formula
E4 later calls "VWAP"; E1 uses the plainer name to keep the two features
distinct. E1 is a basis swap on three existing paths; E4 (Tier 1 basket
close) is a separate feature that happens to read the same lot-weighted
average of its own close-group. The anchor feeds three money paths,
confirmed by grep of g_curAvgEntry: (1) avg-TP computed = anchor +
InpAvgTPPts (line 1106, levelCount>1 branch only); (2) BE stop = anchor +
InpBEOffsetPts [+ CostCoverPoints] (BEStopPrice line 1183, trigger test
line 1208); (3) trail activation + trigger = anchor + InpBEOffsetPts +
InpTrailDistPts (TrailActivationPrice line 1191, trigger line 1253). All
three move to lot-weighted together.
  SCOPE CORRECTION 2026-07-23 (found reading code before the matrix):
  there is a FOURTH averaging site the "three paths" wording missed -
  ComputeProjection (line 1848) recomputes sumPrice/counted independently
  (line 1871) to drive the DASHBOARD "Proj at TP/SL" row (line 3338) and
  the displayed avg-entry. Also the TP site (1106) recomputes
  sumPrice/counted INLINE, not via g_curAvgEntry. So E1 must convert
  every place the average is COMPUTED - g_curAvgEntry (1091), the TP
  inline (1106), AND ComputeProjection (1871) - or the panel would
  project/display a simple-mean average while the engine runs
  lot-weighted: the exact display-vs-engine drift b26/S8-25 fixed and
  locked. Jeff confirmed 2026-07-23: align EVERYTHING anchored to the
  average, dashboard included. Does NOT reopen Option A (still
  lot-weighted, all exit/protection paths); it extends the fence to the
  projection/display site so display never drifts from engine. Not a new
  money path - a display-consistency requirement.
  RATIONALE: lot-weighted is the financially correct basket break-even;
  simple average only coincides when all lots are equal. One anchor, one
  basis, everywhere it is read = internally consistent AND consistent
  with E4, whose Tier 1 trigger already computes from the same lot-
  weighted average of its close-group (leaving the E1 anchor simple would
  put two averaging bases in one money
  path - the section-7 consistency break the E1 amendment exists to
  close). MONEY EFFECT ACCEPTED (Jeff, eyes open): when later/deeper lots
  are larger (normal martingale), lot-weighting pulls the anchor toward
  them (BUY: higher), pushing TP, BE, and trail activation all FURTHER
  away, so BE arms slightly later and TP is slightly harder to reach than
  today. Simple average currently errs early/profitable; lot-weighted
  trades that small early-exit bias for correctness. Worked example (live
  0.02/0.02/0.03 BUY, entries 4018.20/4018.30/4018.53): simple avg
  4018.3433 vs lot-weighted 281.28671/0.07 = 4018.3843, +4.1 pts; avg-TP(+300)
  4021.3433->4021.3843, BE stop(+30) 4018.6433->4018.6843, all shift the
  same +4.1 pts.
    Rejected B (lot-weighted TP ONLY, BE/trail stay simple): creates a
    NEW internal split - TP on a different basis than BE/trail - and is
    still mismatched with E4. A fresh inconsistency to buy a smaller diff.
    Rejected C (keep simple everywhere): E4 then forces two bases in one
    money path (the flagged break); rejects the 2026-07-23 E1 amendment.
  MATRIX REQUIREMENTS carried forward: (a) MUST include an UNEQUAL-LOT
  sequence - under the sealed closed-form stall (base 0.01/mult 1.5 ->
  L3-L6 all 0.02) simple and weighted coincide across a stalled band, so
  a stall-only row proves nothing. (b) must-NOT-fire rows proving the
  equal-lot case is bit-identical to today (lot-weighted == simple mean
  when all lots equal). (c) all three paths (TP, BE trigger/stop, trail
  activation/trigger) exercised, both BUY and SELL laps (anchor is
  direction-signed at the consumer sites). E4 remains blocked until E1
  lands (E4 MUST NOT land first).

2026-07-16 Deferred-TP RE-EXAMINED AND CLOSED, zero code delta:
Choice 1 (bank at market when computed TP already exceeded) STANDS.
b20 race gate made broker-held-TP riding technically trustworthy but
does not change give-back risk; "TP is a MINIMUM acceptable exit"
principle reaffirmed. Alternatives rejected: ride old broker TP
(unbounded give-back, the exact R8 pain), hybrid buffer (complexity
for a guessed input). Jeff confirmed.
2026-07-16 Stage 8 design session, all locked (see STAGE8_MATRIX.md):
no policy selector; removals always reverted; asymmetric manual
lifetime (TP releases on structural events, SL persists); conflict
adopts nothing; engines own once armed; adoption persisted w/ death-
window reconcile rules. Policy A retired with b24.
2026-07-21 Stage 10 observability batch (see STAGE10_MATRIX.md):
D1 Guard-blocked file log = WARN, not INFO. Rejected INFO: splits log
   from the amber dashboard row and understates an operational-
   availability event (EA silently won't enter); the "protective ->
   INFO" rule is about market-risk direction, a different axis. Keying:
   one-shot per reason, re-announce on reason switch, re-arm on clear.
D2 A2 = BOTH touches (init sibling WARN + flag-aware 10027). Rejected
   init-only. SUPERSEDED by D6 (see below) on live evidence.
D6 (2026-07-21, supersedes D2's init-sibling half): DROP the init
   sibling; MQL_TRADE_ALLOWED is proven unreliable at OnInit (true with
   the F7 box off) though correct at TRADE time. Move the cause hint to
   a shared helper called from BOTH send paths (E7 market + P6 pending).
   D2's flag-aware-10027 half stands and is proven (S10-15 PASS); only
   the init-detection premise was wrong.
D3 Cover Guards A/B/C, not A alone. Rejected A-only: B/C share the
   identical dashboard-only block; fixing one leaves a known-identical
   silent path.
D4 A6 (manual-SL-refused throttle) PARKED. Rejected inclusion: no
   observed log spam; a throttle for a theorized repeat violates
   terminal-is-truth. Re-opens only on real repeat evidence.
D5 A3/A4/A5 verified as ONE folded regression row (Jeff). Pure log
   text/emission, money-neutral.
2026-07-21 MARTINGALE COMPOUNDING BASIS - CLOSED, zero code delta.
Jeff's live-raised recursive request WITHDRAWN by Jeff after reviewing
the numeric tradeoff (GATE1_martingale_basis.md). CLOSED-FORM (current)
STANDS as the meaning of the multiplier: level = base * mult^tier,
normalized per level (ComputeLevelLot line 1752/1776; normalizer 1798
round-to-nearest). Confirmed behavior on base 0.01 / mult 1.5 / step 2:
L3-L6 hold at 0.02 (0.0225 rounds down - the "stall"), first step-up at
L7 (0.03375 -> 0.03), then L9 0.05, etc. Jeff verified and accepts the
stall as the honest geometric curve.
  Rejected R-a (deterministic recursive on last-normalized lot): gives
  the climbing 1,1,2,2,3,3 ramp AND stays stateless/restart-safe, but is
  RISK-INCREASING - drifts above mult^n and accelerates (~+33% margin by
  tier2, more at depth). Jeff declined the added risk for no offsetting
  gain; the stall is cosmetic-expectation only, not a math error.
  Rejected R-b (recursive seeded from executed lot): also risk-
  increasing AND breaks statelessness (needs realized last lot ->
  persisted field, uninit-field trap, self-test + backward-compat
  change). No mid-sequence input-adaptation requirement exists to
  justify it.
  Scope untouched by this decision: plain RM_MARTINGALE, RM_MANUAL,
  incremental / deferred-incremental all remain as-is. No matrix, no
  build - nothing was changed.
  RE-OPEN CONDITION: only if a live requirement for a per-tier climbing
  ramp appears; then R-a is the implementation to cost, as a fresh
  Gate 1 with its own matrix and explicit risk-drift acknowledgement.

2026-07-21 STAGE 9 STEP 2 - tester pending-line adjust = NUDGE (Gate 1
locked; matrix pending). Problem: visual tester creates the pending
placement line at ask/bid but chart drag is dead there, so the line
cannot leave the market band and CONFIRM (pollable) always hits the
stops-level refusal - the pending flow is reachable but unusable in
tester. Decision: add two TESTER-ONLY polled buttons (B_PUP/B_PDN) that
shift PLINE OBJPROP_PRICE by +/- InpTesterNudgePts per click; the SEALED
confirm path (ComputeEntryLot, Guard C pre-screen, EntrySLRealizable/
Guard B, stops-level band, place) is read+validated UNCHANGED.
  Rejected OFFSET (declarative input placing the line at ref+/-offset):
  non-interactive (edit input + re-run to change price) and a fixed
  per-run offset is really a Stage 9 Step 3 auto-entry seed - building it
  here duplicates Step 3 and gives no interactive-flow value. Offset held
  in reserve for Step 3.
  Sub-decisions carried into the matrix (seal or correct there):
   - Buttons created + polled in TESTER ONLY (MQL_TESTER-gated), so the
     LIVE panel stays byte-identical (live already has native drag).
   - Step = input InpTesterNudgePts, default 50, clamp >=1.
   - NO band clamp on movement (REVERSED from the Gate 1 brief's clamp
     rec): the line may legitimately sit either side of market (buy-limit
     below / buy-stop above; order type inferred at confirm). Clamping at
     the band would block legitimate cross-market placement. Movement is
     free; CONFIRM remains the sole authority and already refuses+keeps
     the line for re-nudge. Each nudge logs the new line price (INFO;
     placement price, not a live money change).
  NO code yet - matrix must seal first (STAGE9_STEP2_MATRIX.md).

2026-07-22 CLAUDE CODE TRANSITION - compile/deploy boundary (see
docs/CLAUDE_CODE_TRANSITION_v2.md). Decision: compile AND deploy stay
MANUAL and MT5-side, Jeff's responsibility; NO automated compile gate in
the repo. Git is the SOURCE OF TRUTH for TRTM.mq5 - on any repo-vs-MT5
mismatch, Git wins. Quick-verify which build is loaded: the TRTM_BUILD
tag is shown on the chart panel and the Experts-log init line; compare to
STATE.md build:. sha256_16 (resume protocol) is the byte-level backstop.
  Rejected automated gate zero (compile_gate.py, built + verified this
  session then dropped): it shelled MetaEditor64.exe from the repo, which
  re-couples Claude Code to the MT5 toolchain - the exact thing the repo
  separation exists to avoid. Verified once that the b33 repo copy
  compiles clean (0 errors / 0 warnings) before dropping it.
  Verified gotchas (for anyone who ever revisits CLI compile): MetaEditor
  /log is UTF-16, and its process EXIT CODE is not pass/fail (returned 1
  on a clean 0/0 build) - parse the "Result:" line, never $?.

2026-07-25 E6 T3-O0 ADOPT TIER 3 = YES, DEFAULT-OFF (Gate 1 LOCKED; matrix +
plan still required before any code). Tier 3 (Drawdown Reduction Tier 3 -
PARTIAL-lot close) is adopted as a DISTINCT third trigger alongside sealed
Tier 1 (points) and Tier 2 (percent-of-balance), behind a new default-off
input InpEnableTier3 (same opt-in pattern as InpEnableTier1/Tier2). E6 now
opens its remaining Gate 1 sub-decisions T3-O1..O9 one at a time.
  EVIDENCE (E7 R2, docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md, two fires
  recomputed to the cent from docs/STM Drawdown Reduction Tier3 Logs.txt):
  Tier 3 SLICES the oldest anchor (closes ClosePercent of its lots, floored
  to lot step, anchor >= MinLots) and closes all profitables FULLY, then tests
  the CLOSING group's VWAP - {anchor SLICE being closed} + profitables, i.e.
  the anchor counted at its SLICE vol (the lots being closed), NOT its
  remainder - against MinProfitPoints (200). Structurally identical to Tier 1
  (which gates on {full anchor} + profitables); Tier 3 just substitutes the
  anchor's slice for its full volume, the remainder surviving untouched. This
  lets Tier 3 fire in the deep-drawdown regime
  Tier 1/Tier 2 are structurally locked out of: at FULL anchor both observed
  groups were at/below break-even (fire 1 06/25 +80.1 pts, ~+10 USD; fire 2
  07/02 -77.4 pts, a net LOSS), so T1 (needs 150) and T2 (needs ~+30 USD) both
  failed - only the sliced-anchor reframing cleared 200 (both fires ~+206 pts).
  So Tier 3 is a genuine, non-redundant deeper pressure valve, not a duplicate
  of T1/T2. It is POINTS-based like Tier 1, so it needs NO cross-currency FX
  path (unlike Tier 2's T2-O7).
  RATIONALE for adopt: the reference demonstrates a real capability gap the
  sealed tiers cannot cover (harvesting profit while a deep anchor loss keeps
  the full-basket gate underwater), and default-off keeps it strictly opt-in
  with zero behavior change to any existing chart until Jeff enables it.
  Rejected DECLINE/PARK: judged premature to forgo the capability given clean
  two-fire evidence; the cost (a new partial-lot primitive + a C3-ladder
  interaction) is real but is exactly what the remaining T3-O sub-decisions
  and the matrix exist to bound - not a reason to skip Gate 1.
  Rejected ADOPT-WITH-SCOPE-CAVEAT-FIRST: no scope constraint is foundational
  enough to precede the primitive (T3-O1) and gate (T3-O2) definitions; any
  such constraint (slice-only, drawdown-floor gating) is cleaner to lock as
  its own T3-O row once the mechanism is defined, not bolted onto O0.
  UNOBSERVED / carried into later T3-O rows (NOT decided here): the partial-
  close primitive itself (O1), MinLots eligibility + sub-MinLots anchor
  behavior (O3), slice rounding mode (O4 - floor observed, 0.015->0.01),
  sliced-anchor vs C3 preserved-index ladder (O5), 3-way T1/T2/T3 precedence
  (O6 - the tiers never competed in the run; T3 only fired when T1/T2 failed),
  close order + partial-fill on the slice leg (O7), BUY lap (O8 - all Shadow
  data SELL), post-fire TP + recovery refresh (O9). NO code, NO matrix yet.

2026-07-25 E6 T3-O2 FIRE CONDITION = FIXED-PERCENT SLICE + SLICED-ANCHOR VWAP
GATE (Gate 1 LOCKED; matrix + plan still required before any code). Tier 3's
trigger: (1) slice = ClosePercent of the OLDEST anchor's lots (anchor must be
>= MinLots to be eligible; rounding + minimum deferred to T3-O4); (2) form the
CLOSING group = {the anchor SLICE being closed, i.e. the anchor counted at its
slice vol NOT its remainder} + ALL currently-profitable positions; the
remaining anchor survives and is NOT in the gate group; (3) FIRE iff that
group's lot-weighted VWAP clears MinProfitPoints per lot in front of the
direction-derived far-side price (SELL->Ask, BUY->Bid). Structurally = Tier 1
(anchor slice substituted for full anchor); the gate is measured over the
ACTUALLY-CLOSED lots, same as Tier 1's group gate.
  ARITHMETIC PROOF the gate uses SLICE not remainder (fire 2, anchor #4 full
  0.03 / slice 0.01 / remaining 0.02, logged header VWAP 1.92888): slice 0.01
  -> (0.01*1.88917+0.13*1.93219+0.12*1.92861)/0.26 = 1.92888 MATCHES; remaining
  0.02 -> /0.27 = 1.92741 does NOT; full 0.03 -> /0.28 = 1.92605 does NOT. Fire
  1 (slice==remaining==0.01) cannot disambiguate; fire 2 forces slice.
MinProfitPoints is Tier 3's OWN threshold (Shadow ran 200; TRTM default set in
a later row). POINTS-based like Tier 1 => NO cross-currency valuation path
(Tier 2's T2-O7 does NOT recur).
  BASIS: recomputed exact on both Shadow fires (docs/ENHANCEMENT_INPUT_2026-
  07-25_tier3.md OBSERVED-1/6): sliced-anchor VWAP 1.90990 (fire 1) and 1.92888
  (fire 2), both ~+206 pts vs the 200 gate. The sliced framing is what lets
  Tier 3 fire where T1/T2 cannot (full-anchor +80.1 / -77.4 pts).
  Rejected THRESHOLD-SOLVED MINIMAL SLICE (close only the smallest slice that
  makes the group clear MinProfitPoints): more anchor-preserving in principle,
  but at TRTM's 0.01 lot step it COLLAPSES to the same 1-step slice (fire 2:
  max clearing slice <= 0.0104 -> 0.01, identical to fixed-percent-floored), so
  it buys nothing at TRTM's lot regime while adding non-reference math and extra
  matrix rows. Re-open only if TRTM ever trades large enough anchors that the
  two diverge materially.
  Rejected FULL-ANCHOR GATE + PARTIAL EXECUTION (gate like Tier 1 on the full
  anchor, execute a partial close): can NEVER fire when Tier 1 doesn't, so it
  forfeits the entire deep-drawdown capability that is Tier 3's whole reason to
  exist - both observed fires would not have fired. Recorded rejected.

2026-07-26 E6 T3-O3 MinLots = ANCHOR-ELIGIBILITY FLOOR; SUB-MinLots ANCHOR ->
TIER 3 STANDS DOWN (Gate 1 LOCKED; matrix + plan still required before any
code). The oldest anchor must have full volume >= MinLots (>= 2 lot steps) to
be Tier-3-eligible, so a >= 1-step slice always leaves >= 1 step alive (Tier 3
is a PARTIAL close by definition - it must never zero the anchor). When the
oldest anchor is BELOW MinLots (e.g. it is already at the 0.01 lot floor, or a
prior Tier 3 fire reduced it below MinLots), Tier 3 STANDS DOWN for that basket
- it does NOT slice, does NOT fall through to a full close - and the full-close
tiers (Tier 1 points / Tier 2 percent) cover that basket if THEY qualify.
  BASIS (Jeff 2026-07-26, and the reason all three tiers were enabled in the
  E7 R2 run): "Tier 3 could not fire if the anchor is already 0.01 - nothing to
  slice." A 0.01 anchor sliced by any amount is a FULL close, which is Tier 1's
  job, not Tier 3's. MinLots exists precisely to guarantee slice-ability with a
  surviving remainder. Shadow ran MinLots=0.02 (TRTM default set in a later
  row); at TRTM's 0.01 base lot MinLots=0.02 means "anchor must be at least the
  2nd rung's size", which the martingale ladder reaches quickly.
  EVIDENCE the stand-down is real, not theoretical: fire 1 left anchor #3 at
  0.01 (< MinLots 0.02); it was never sliced again - the next Tier 3 fire (fire
  2) sliced the NEW oldest eligible anchor #4 (0.03) after #3 had left the book.
  COUPLING to T3-O6 (precedence, still open): "stands down, Tier 1/2 cover it"
  presumes Tier 1/2 are ENABLED and may fire on the same basket - so the 3-way
  precedence/coexistence decision (O6) must state what happens to a
  sub-MinLots-anchor basket when Tier 1/2 are DISABLED (then no tier fires; the
  basket rides to its sequence TP - acceptable, but must be stated).
  Rejected SLICE-THEN-FULL-CLOSE FALLBACK (Tier 3 closes a sub-MinLots anchor
  FULLY itself): duplicates Tier 1's close mechanics inside Tier 3, blurs the
  tier boundary (Tier 3 = partial ONLY), and forces Tier 3 to own a full-anchor
  loss-realization path it was designed to avoid. If a full close of a tiny
  anchor is wanted, that is Tier 1's role - enable Tier 1. Re-open only if a
  Tier-3-standalone (Tier 1/2 off) config becomes a real requirement AND tiny
  anchors must still be harvested.

2026-07-26 E6 T3-O4 SLICE NORMALIZATION = FLOOR TO LOT STEP, CLAMPED PARTIAL
(Gate 1 LOCKED; matrix + plan still required before any code).
    slice = floor(anchorLot * ClosePercent / lotStep) * lotStep
    slice = max(1 lotStep, min(slice, anchorLot - 1 lotStep))
FLOOR (not round, not ceil); a lower clamp of 1 lot step so a small ClosePercent
still slices something; an upper clamp of anchorLot - 1 step so the slice is
ALWAYS partial (never zeroes the anchor - Tier 3 is partial by definition, a
full close is Tier 1's job). With T3-O3 (anchor >= MinLots >= 2 steps) the
clamps are always satisfiable.
  BASIS: matches Shadow exactly (fire 1: floor(0.02*0.5)=0.01; fire 2:
  floor(0.03*0.5=0.015)=0.01, NOT 0.02). Because the gate is measured over the
  CLOSED lots (T3-O2), a LARGER slice puts MORE anchor loss into the closing
  group and makes the gate HARDER: fire 2 under round-half-up (slice 0.02) gives
  group VWAP (0.02*1.88917+0.13*1.93219+0.12*1.92861)/0.27 = 1.92741, margin 59
  pts < 200 -> would NOT have fired. So FLOOR is simultaneously (a) the reference
  behavior, (b) the least loss realized per fire (gentler valve), and (c) the
  only rounding under which both observed fires actually clear the gate.
  NOTE the realized close fraction DIVERGES from nominal ClosePercent when floor
  bites (fire 2: 0.01/0.03 = 33%, not 50%); at TRTM's 0.01 base lot the floor
  makes the slice effectively 1 lot step for any anchor of 0.02-0.03, so
  ClosePercent only bites materially on larger anchors. Documented, not a defect.
  Rejected ROUND-HALF-UP and CEIL: realize more anchor loss per fire, diverge
  from Shadow, and (round-up) would have blocked a real observed fire.

2026-07-26 E6 T3-O5 SLICED ANCHOR = RESIDUAL SURVIVOR; C3 + E4 O1 INHERITED,
NOTHING STORED (Gate 1 LOCKED; matrix + plan still required before any code).
After a Tier 3 slice, the anchor remains a SINGLE open position at its
UNCHANGED entry price / ladder address, at reduced volume (full - slice). It is
treated as an ordinary smaller open position:
  - Rungs ABOVE the anchor keep their C3 preserved-index addresses (a rung is
    an ADDRESS with a DERIVED lot = ComputeLevelLot(N)); the profitables that
    Tier 3 closed re-arm by the sealed E4 O1 unrestricted-refill rule (recovery
    re-adds above the top survivor as price moves adverse). Tier 3 changes
    NOTHING about that path.
  - The anchor (the FAVOURABLE extreme) NEVER re-arms - inherit E4 O1's
    direction-reality: the ladder extends adverse-only, above the top survivor,
    never back down to the anchor. A sliced anchor therefore just stays smaller
    until basket TP / SL / a further slice (if still >= MinLots).
  - The residual volume is NOT a new persisted field. TRTM already LIVE-READS
    open position volumes on reconcile; the broker position's volume IS the
    state. C3's derived-only / nothing-stored invariant is preserved.
  - All money math reads the ACTUAL reduced volume: lot-weighted VWAP/TP (E1
    basis) correctly shifts when the anchor shrinks; the SL anchor price is the
    anchor's ENTRY, unchanged by slicing volume; ComputeLevelLot governs only
    the NEXT rung to ADD (by Level counter), never the anchor's current lot, so
    the SEALED martingale path is untouched.
  MATRIX REQUIREMENT: must-NOT-fire rows proving the sealed martingale / ladder
  / SL-anchor output is BIT-IDENTICAL to E5-b37 when Tier 3 is disabled or does
  not fire, plus a row proving a post-slice basket's VWAP/TP recompute reads the
  reduced anchor volume (fire 1 recompute: survivor VWAP 1.89921 over 0.34 with
  anchor at its remaining 0.01 - already confirmed in the E7 R2 input doc).
  Rejected RE-ARM ANCHOR TO FULL DERIVED LOT: contradicts sealed E4 O1 (anchor
  never re-arms; adverse-only extension). Rejected PERSIST RESIDUAL AS NEW STATE
  FIELD: breaks C3 derived-only, adds uninit-field / backward-compat / self-test
  burden, and is redundant because position volume is already live-read.

2026-07-26 E6 T3-O6 PRECEDENCE = T2 -> T1 -> T3, SINGLE-FIRE PER TICK (Gate 1
LOCKED; matrix + plan still required before any code). Extend E5's sealed
EvaluateBasketClose dispatcher (Tier 2 percent FIRST, then Tier 1 points) with
Tier 3 LAST: evaluate Tier 2, else Tier 1, else Tier 3; the FIRST tier that
qualifies fires and returns; NO other tier fires that tick (a later tick
re-evaluates the smaller basket). Tier 3 (partial) is the last-resort valve,
reached only when the FULL-close tiers do not qualify - the deep-drawdown case
it exists for.
  RATIONALE: T1/T2 are FULL closes (relieve the whole anchor + all profitables,
  banking profit on the entire group); T3 is PARTIAL (slices the anchor, leaves
  it alive). When both a full tier and T3 qualify on one tick, the full close
  relieves more exposure for the same guaranteed-positive harvest, so full is
  preferred - T3 last. Note T1 (150) and T3 (200) can each qualify independently
  (T3's slice-group margin > T1's full-group margin, but T3's threshold is
  higher), so both-qualify and only-one-qualify ticks all occur; last-place T3
  is correct in every case.
  UNOBSERVED: the tiers NEVER competed in the E7 R2 run (T3 fired only when
  T1/T2 failed at full anchor). MATRIX MUST carry a CONSTRUCTED tick where T1
  (full) AND T3 (slice) both qualify, proving the dispatcher fires T1 and skips
  T3; plus a T2+T3 both-qualify tick.
  Rejected T3-FIRST: a more-permissive partial pre-empts a qualifying full
  close, leaving more anchor exposure alive for less relief. Rejected MULTI-FIRE
  (>1 tier per tick): E5 is single-fire by design; overlapping groups on one
  tick risk double-acting on shared positions and break the per-fire tested
  arithmetic.
  SPUN OUT -> E8 (Jeff's idea 2026-07-26, ADOPTED as a separate item, NOT folded
  into E6): after a full T1/T2 close banks net +P, spend up to a fraction f of P
  to ALSO slice the NEW anchor (next-oldest, deepest remaining loser), combined
  tick staying net >= (1-f)*P >= 0. Distinct from the three self-funding tiers
  because it realizes a PURE loss on a loser funded by external harvest - a
  directional tail-risk lever that bets AGAINST the basket's own mean-reversion
  recovery thesis (nets neutral at the instant; buys reduced future tail
  variance + a VWAP nudge toward TP). Given the risk-changing character it gets
  its own Gate 1, not E6's reference-derived scope. See E8 backlog entry.

2026-07-26 E6 T3-O7 CLOSE ORDER = PROFITABLES-FIRST, ANCHOR-SLICE LAST (inherit
E4 O5) (Gate 1 LOCKED; matrix + plan still required before any code). The Tier 3
group closes in this order: (1) close every profitable member FULLY, descending
ticket; (2) slice the anchor LAST via the partial-close primitive. Failure rule:
if ANY profitable leg fails, ABORT the whole fire BEFORE the anchor is touched -
the loss leg never opens, so no half-closed group exists. If the anchor SLICE
itself fails or short-fills, the covering profit is ALREADY banked (net positive
secured), so accept + log, NO retry - the anchor simply stays at a larger volume,
which is safe (it is a survivor either way and re-qualifies on a later tick).
  BASIS: identical reasoning to sealed E4 O5 - realize the loss leg only after
  the covering profit is banked, so a mid-group failure can never leave the tick
  net-negative. Here the loss leg is a PARTIAL close, which only strengthens the
  case (the anchor remaining larger on a failed slice is harmless). DIVERGES
  from Shadow's OBSERVED anchor-slice-first order (E7 R2 OBSERVED-4), exactly as
  T1 diverged. Market-close slippage vs the gate-tick margin is accepted as in
  T1/T2.
  PRIMITIVE NOTE (feeds T3-O1): the anchor leg uses a PARTIAL close
  (CTrade::PositionClosePartial-class) of the slice volume; the profitables use
  the existing full-close path. Partial-close broker constraints (min partial
  lot, lot step) are an O1 detail; a broker rejection of the partial leg falls
  into the accept+log branch above.
  Rejected ANCHOR-SLICE-FIRST (Shadow): realizes the anchor loss before the
  cover is banked; a mid-group profitable failure leaves net-negative. Rejected
  SLICE-LAST-WITH-RETRY: adds retry logic T1 lacks for marginal benefit (a failed
  slice leaves a harmless larger survivor).

2026-07-26 E6 T3-O1 / T3-O8 / T3-O9 = INHERIT SEALED BEHAVIOR (Gate 1 LOCKED;
matrix + plan still required before any code). The three near-certain inherits,
confirmed by Jeff 2026-07-26. These COMPLETE E6 Gate 1 (T3-O0..O9 all locked).
  T3-O1 PARTIAL-CLOSE PRIMITIVE = native CTrade::PositionClosePartial(ticket,
  sliceVol) through the EXISTING sealed order-send wrapper + retcode handling.
  Slice volume already normalized by T3-O4. MT5 keeps the SAME ticket at reduced
  volume, so the anchor keeps its identity / ladder address (supports T3-O5
  live-read; no new persisted state). Broker min-partial-lot / lot-step rejection
  routes to T3-O7's accept+log branch. Rejected EMULATION (close full + re-open
  remainder): new ticket / new entry / lost identity (breaks T3-O5), double
  spread, worse re-entry price.
  T3-O8 FAR-SIDE = DIRECTION-DERIVED (inherit E4 O4): SELL closes at Ask
  (OBSERVED both fires: 1.90784, 1.92682), BUY at Bid (platform invariant). Matrix
  carries BOTH laps; the BUY lap is validated against the platform invariant +
  arithmetic (Tier 3 BUY fire is UNOBSERVED - all Shadow data SELL). Rejected
  SELL-ONLY: leaves the known direction-only defect class E4 O4 exists to prevent
  (a fixed Bid/Ask read passes SELL, breaks on the first live BUY basket).
  T3-O9 POST-FIRE = E1 LOT-WEIGHTED TP + C3 PRESERVED-INDEX (inherit): recompute
  sequence TP as the lot-weighted VWAP over survivors INCLUDING the reduced
  anchor at its remaining volume (OBSERVED exact, fire 1: avg 1.89921 / vol 0.34 /
  count 7, TP = VWAP - offset); REJECT Shadow's count-based re-index in favour of
  C3 preserved-index (Level from the highest surviving rung's address);
  RefreshRecoveryState ATOMIC with fire completion (E4 O3). Rejected SHADOW
  COUNT RE-INDEX: leaves the basket permanently lighter at the top, degrading TP
  (already rejected for T1/T2).

2026-07-26 E6 T3-GATE A = OWN INPUT InpTier3MinTrades, DEFAULT 4 (Gate 1 LOCKED;
matrix + plan already carry it). Flagged by Jeff 2026-07-26: Tier 3 must have its
own "Min Trades to Activate" input, SIMILAR TO Tier 1 (InpTier1MinTrades) and
Tier 2 (InpTier2MinTrades) - it had been carried in the input surface but never
locked as its own decision (the E5 log has an explicit "GateA" entry; E6's did
not). DECISION: Tier 3 has its OWN count-based Gate A input InpTier3MinTrades
(default 4, matching Shadow InpPC3_MinTrades and both other tiers); Tier 3 is
eligible only when openCount >= InpTier3MinTrades, independent of Tier 1/Tier 2's
own MinTrades. TIER-3 NUANCE (documented, not a divergence): a Tier 3 fire
reduces the open count only by the PROFITABLES closed - the anchor SURVIVES the
slice and stays counted - so the count falls more slowly per fire than a full-
close tier. Dormancy/re-activation rows G-D3 (T3-D1/D2) already reflect this.
  Rejected SHARE a single MinTrades across all three tiers: each tier is an
  independent valve with its own thresholds (Shadow ships PC1/PC2/PC3 MinTrades
  separately); a shared gate would couple their activation. Rejected NO Gate A
  (fire at any depth): loses the shallow-basket dormancy guard T1/T2 have.
  NO code/matrix change - InpTier3MinTrades (default 4) is already in
  docs/E6_MATRIX.md (input surface + G-T3/G-D3) and the Gate 3 plan (TP-1/TP-5a);
  this entry records the previously-implicit decision.

## E6 (Tier 3) GATE 1 COMPLETE - 2026-07-26
All ten sub-decisions + Gate A locked (T3-O0 adopt/default-off; O1 native
partial-close primitive; O2 fire condition = fixed-percent slice + SLICED-anchor-
VWAP gate; O3 MinLots eligibility + sub-MinLots stand-down; O4 slice = floor,
clamped partial; O5 sliced anchor = residual survivor, C3 + E4 O1 inherited,
nothing stored; O6 precedence T2->T1->T3 single-fire; O7 profitables-first /
slice-last / abort-before-slice; O8 direction-derived far side, both laps; O9 E1
VWAP TP + C3 index; GATE A = own InpTier3MinTrades default 4, mirroring T1/T2).
Jeff's profit-funded follow-on slice SPUN OUT to E8 (own Gate 1).
GATE 2: docs/E6_MATRIX.md SEALED rev 1 by Jeff 2026-07-26 (13 row-groups, 36
rows; both reference fires recomputed to the cent; slice-vs-remainder
disambiguated by FIRE 2; floor requirement proven; T2->T1->T3 precedence rows
UNOBSERVED -> verify LIVE; must-NOT-fire byte-identity + SL-not-re-anchored
rows). GATE 3: docs/E6_PLAN_2026-07-26_gate3.md DRAFTED 2026-07-26 (8 touch
points, all in src/TRTM.mq5; +70/95 lines est.). EXTENDS E5-b37's shared
dispatcher / FormBasketGroup / FireGroupClose - adds SliceLegAtMarket
(PositionClosePartial sibling, NO MarkEAClosed since the anchor survives),
ComputeSlicedAnchorVWAP (gate on the SLICE vol), an anchorSliceVol param on
FireGroupClose (default 0 => T1/T2 byte-identical), a 3rd dispatcher branch
(T2->T1->T3), 5 inputs, the DD-Reduce dashboard extension. THREE findings REMOVE
code: F-a SL-not-re-anchored is FREE (re-anchor keyed on anchor LEVEL, unchanged
by a slice); F-b survivor TP self-corrects (ComputeTargets reads live volume);
F-c F3 impossible (OnTradeTransaction is EMPTY - attribution poll-based). NO new
persisted field. PLAN CONFIRMED by Jeff 2026-07-26.
BUILD: E6-b38 IMPLEMENTED 2026-07-26 (repo src src/TRTM.mq5, f7766c859e4d3c7a /
4674, +106 lines). All 8 touch points done: TRTM_BUILD E6-b38; 5 Tier 3 inputs
(InpEnableTier3 default off, MinTrades 4, MinProfitPts 200, MinLots 0.02,
ClosePercent 50); ComputeSlicedAnchorVWAP (gate on slice vol); SliceLegAtMarket
(PositionClosePartial, NO MarkEAClosed); FireGroupClose +anchorSliceVol=0.0
(T1/T2 unchanged); Tier 3 dispatcher branch (T2->T1->T3); DD-Reduce dashboard
+T3; call-site + tag. Hygiene clean (0 bare LF, ASCII, brace -1 baseline, no new
global/persisted field).

GATE ZERO PASSED - 2026-07-26. Compiled in Jeff's terminal 12:34:12, **0 errors,
0 warnings** (metaeditor.log), on a source byte-identical to the repo manifest
(f7766c859e4d3c7a / 4674). TRTM.ex5 rebuilt 12:35:02; EA re-initialized as E6-b38
on XAUUSD.s + BTCUST with self-test PASS + Reconcile FLAT. An earlier compile of
the same source at 01:48:22 was also 0/0; Jeff's call was to re-witness gate zero
inside the session rather than accept the reconstructed log line, so the 12:34
compile is the one of record. DEPLOYED: runtime copy == repo, no deploy drift.

STATE CORRECTION - 2026-07-26 (bookkeeping, not a seal). This manifest previously
asserted E6-b38 was NOT compiled, NOT deployed, and UNCOMMITTED. All three were
false against disk + git at resume: the build had already been compiled (01:48:22),
deployed (runtime hash == repo), committed (8722fcc) and PUSHED (origin/main =
8722fcc, carrying E4-b36 and E5-b37 up with it) out-of-band between sessions. The
resume protocol did NOT trip a STOP, because the only STOP condition - repo src !=
f7766c859e4d3c7a / 4674 - held true throughout. Corrected here so "disk + git are
truth" is not contradicted by its own record. E6 remains UNSEALED at Gate 4.

BUILD-vs-PLAN DIVERGENCES (recorded, neither a money-path defect):
 (a) The build uses NormalizeDouble(sliceVol, 8) (TRTM.mq5:2415); the plan wrote
     NormalizeDouble(sliceVol, 2). The build is SAFER - 2 decimals would corrupt
     the slice on any symbol with a 0.001 lot step (0.005 -> 0.01). Identical on
     XAUUSD.s / GBPAUD.s (step 0.01), so money-neutral here and strictly better
     elsewhere. ACCEPTED as-is.
 (b) TP-6 dashboard built with direct string concatenation rather than the plan's
     parts[] array sketch. Functionally identical output. Cosmetic.
 (c) NIT, not yet fixed: the EvaluateBasketClose header comment (TRTM.mq5:2300-2308)
     still reads "Tier 2 FIRST, then Tier 1" / "Both share ONE group" - stale at
     three tiers. TP-7's call-site comment (4633) WAS updated. A comment-only edit
     re-bumps the manifest sha, so bundle it with the seal commit rather than
     dirtying a verified build.

## E6 (Tier 3) SEALED - 2026-07-26. GATE 4 CLOSED.
Jeff's explicit word, 2026-07-26. E6-b38 (f7766c859e4d3c7a / 4674) is the CURRENT
SEALED BUILD. Ten XAUUSD.s tester runs, nineteen Tier 3 fires, every money number
recomputed to the cent on two independent derivations.
KEY ROWS, all closed on LIVE evidence:
 - T3-6 gate-on-SLICE (the crux): Run C three-way at Ask 4202.38 - slice 0.01 ->
   4205.1978 (+281.8, FIRES); remainder 0.02 -> 4200.0360 (-234.4); full 0.03 ->
   4195.8127 (-656.7). Only the slice reproduces the logged VWAP, and BOTH alternatives
   are negative - a stronger demonstration than the Shadow reference gave.
 - T3-H3 SL byte-identical (the key divergence from T1/T2): Run E both laps, SELL
   4243.58 / BUY 4108.79 unchanged across every slice, ZERO "SL re-anchored" lines
   (E5's Tier 2 logged one per fire). The BUY stop was then HIT at 4108.77 - all eight
   legs including the twice-sliced anchor. A genuine broker-held stop fired.
 - T3-4 Gate B: blocked band RECOMPUTED from the entries (209.5 / 300.0 / 359.0 pts
   traversed with no fire) and the threshold predicts both fire prices to within one
   tick (4180.495 vs 4180.62; 4129.943 vs 4129.98).
 - T3-SL4 stand-down: absence across an 8-level (Run C) and 15-level (Run D1') rebuild.
 - T3-G2 invariant: held on all 19 fires, and INDEPENDENTLY confirmed against the
   ACCOUNT BALANCE in Run G (+56.84 realized -> balance 10056.84 -> Tier 2's bar 18.10).
   PositionClosePartial banks exactly what the sliced-VWAP math predicts.
DISPOSITIONS (not live evidence - recorded honestly):
 - T3-PR2 / T3-PR3 CODE-GUARANTEED. Both-qualify is JUMP-ONLY. Demonstrated across
   three constructions (F1 equal bars, F2 D2-derived, G1 T2-paired) with every
   counterfactual margin recomputed: the gap (sliced - full) moves with anchor volume
   and depth (134.2 / 289.4 / 915.8 observed), so the qualifying threshold pair differs
   at every candidate tick and each change rewrites the path it is trying to hit.
   Nearest approach: Run G 19:35:08, Tier 3 ELIGIBLE and 99.4 pts short while Tier 2
   fired. Same basis E5 used to seal T2-PR1, with better evidence.
 - T3-K1 / T3-K2 INHERITED, Run H NOT run (Jeff's call). Reconcile carries no Tier 3
   code, the "_lN_" level survives a partial close, nothing is persisted. RESIDUAL:
   never exercised against an actual sliced anchor across a restart - accepted; run
   opportunistically before live deployment.
 - T3-3 dose-response only (MinTrades 4/6/8 -> first fire at count 4/6/14, never below).
   A blocked-qualifying-tick recompute is structurally unobtainable: Tier 3 is last so a
   blocked tick logs nothing, and Tier 1 cannot witness it (locked out in Tier 3's regime
   by construction).
 - T3-DS1 display-only, code-verified, NOT visually confirmed. Non-blocking.

## LIVE INCIDENT 2026-07-27 - UNMANAGED RECOVERY POSITION ON VANTAGE (XAUUSD.sc)
NOT an E6 defect. The affected code (RegisterNewRecovery, RegisterButtonL1,
CancelOwnPendingOrders) is Stage 4/5 CORE, sealed long before E6; E6 touched none of it.
It is a latent assumption that has been present since Stage 4 and only surfaces on a
broker whose fills are ASYNCHRONOUS.
SYMPTOM (Jeff's live log, XAUUSD.sc, magic 725639, stops 20 / freeze 10):
  "L1 SELL OPENED via button: 0.01 lots @ 0.00 (deal 0)"
  "Recovery L2 OPENED: 0.02 lots SELL @ 0.00 (deal 0)"
  "RegisterNewRecovery: L2 order reported filled but position not found"
  "CTrade::OrderSend: cancel #459172826 [invalid request]" (10013)
DIAGNOSIS: price 0.00 + deal 0 => the server returned TRADE_RETCODE_PLACED - order
accepted, NOT yet executed, so no deal and no POSITION exist at that instant. Both send
sites (2170 recovery / 3274 button) accept PLACED as success and then IMMEDIATELY require
a position: RegisterNewRecovery scans PositionsTotal() for magic + "_lN_" and finds
nothing. The 10013 is the same race - CancelOwnPendingOrders walked OrdersTotal() and hit
the still-in-flight MARKET order, mistaking it for a pending.
WHY IT BECAME EXPOSURE, not just a noisy log: there is NO self-heal while a sequence is
live. CheckOwnPendingFillWhenFlat() is gated on levelCount == 0, and FindUntrackedOurL1()
skips lvl > 1 entirely. So an unregistered recovery level stays ORPHANED - no TP/SL, not
counted, invisible to liveness and to the basket-close tiers - until the sequence goes
flat or the EA restarts (RebuildLiveMap does pick it up by magic + comment).
COMPOUNDING RISK: g_state still held only L1, so ComputeRecoveryTrigger kept computing
from L1's entry and the trigger stayed satisfied - the EA would open ANOTHER 0.02 "L2" on
every subsequent M5 bar close. Duplicate stacking.
MITIGATION GIVEN: AutoTrading OFF to stop further opens, then re-attach the EA so
Reconcile/RebuildLiveMap rebuilds the sequence from live positions ("broker wins"), close
any duplicate _l2_ positions manually first.

## BROKER-COMPATIBILITY AUDIT 2026-07-27 (source grep, zero hits on all three)
  SetTypeFilling / ORDER_FILLING / SYMBOL_FILLING  -> 0 hits
  ACCOUNT_MARGIN_MODE / MARGIN_MODE_               -> 0 hits
  SYMBOL_TRADE_EXEMODE                             -> 0 hits
 ACTIVE  async fill (above).
 LATENT  NETTING ACCOUNTS. TRTM is structurally HEDGING-ONLY - the grid/martingale model
         needs multiple same-symbol same-direction positions. On a netting account L2
         MERGES into L1, PositionsTotal() shows one averaged position and the ladder /
         anchor model collapses SILENTLY. No guard exists. Vantage gave a hedging account
         so this is not biting now.
 LATENT  FILLING MODE. CTrade defaults to ORDER_FILLING_FOK and the EA never negotiates.
         Vantage accepted FOK on XAUUSD.sc (orders did fill), so not currently a problem;
         on an IOC/RETURN-only symbol it would be 10030 with no diagnostic.
 LATENT  COMMENT INTEGRITY - and this one intersects E6. Level tracking depends ENTIRELY
         on parsing "_lN_" from POSITION_COMMENT (10 call sites). Some brokers/bridges
         rewrite comments, notably ON PARTIAL CLOSES. If Vantage rewrites a SLICED
         anchor's comment then after a restart RebuildLiveMap logs "unparseable level
         comment - counted, level unknown" and assigns lvl = 0, which makes that position
         the ANCHOR under the lowest-level rule. That is exactly the T3-K1 scenario closed
         by INHERITANCE at the E6 seal. => RUN H IS NOW OVERDUE, and must be run on
         Vantage, not only on the Doo demo.

## b39 GATE 3 - DECISIONS TAKEN AT PLAN TIME (2026-07-29)
LOCKED DECISION E9-P1 (admission filter shape): ONE SHARED HELPER. Extract a single
  IsAdoptableOurPosition(ticket, &lvl) carrying RebuildLiveMap's exact admission filter,
  and route the watcher, RegisterNewRecovery's fast path and FindUntrackedOurL1 through
  it. WHY: W-1 says "identical filter to RebuildLiveMap (2471) - reuse, do not reinvent",
  and the three filters are NOT in fact identical today (see E9-P2). One admission truth.
  ACCEPTED COST: touches FindUntrackedOurL1 (Stage 5) and RegisterNewRecovery (Stage 4),
  both sealed - so R-1 must show the Doo Run A/C diffs are empty.
  REJECTED: standalone watcher filter leaving 1913/3141 untouched - smallest blast radius
  on sealed code, but keeps three copies of the filter and leaves the E9-P2 divergence
  live. Jeff's call 2026-07-29.

LOCKED DECISION E9-P2 (symbol comparator): NORMALIZED, matching RebuildLiveMap
  (NormalizeSymbol(POSITION_SYMBOL) == g_symbolNorm), NOT the raw != _Symbol used at 1919
  and 3146. FINDING BEHIND IT: NormalizeSymbol (354) strips separators and uppercases, so
  XAUUSD.sc / XAUUSD.s / XAUUSD all collapse to XAUUSD. The sealed startup path
  (RebuildLiveMap 2485) has therefore always been LOOSER than the two registration paths.
  Adopting the normalized comparator makes the watcher agree with Reconcile BY
  CONSTRUCTION. Divergence is nil on both evidence brokers - one gold chart per account,
  so normalized and raw select the same single position set, and Run A/C should diff empty.
  REJECTED: raw == _Symbol - trivially safe for R-1 and strictly narrower, but contradicts
  W-1's stated reuse target and would make startup and steady-state disagree PERMANENTLY
  about which positions are ours. Jeff's call 2026-07-29.

LOCKED DECISION E9-P3 (account switch): NO CODE IN b39; deferred to E9 with O3-O6.
  Jeff's question 2026-07-29 - what happens if the user switches MT5 account (Doo <->
  Vantage) rather than running both at once. ANSWER FROM CODE: DeriveMagic (375-384) hashes
  the NORMALIZED symbol ONLY - no account login, no server - and the state filename (4482)
  is state_<symbolNorm>_<magic>.json, so XAUUSD.s and XAUUSD.sc derive the SAME magic AND
  the SAME state file. On an account switch the new account re-inits onto the previous
  account's state file. It SELF-HEALS: Reconcile (2686) rebuilds the live map first and
  live-map-wins, PositionSelectByTicket fails on every foreign ticket, the live map comes
  back empty, the stale file is discarded at 2724-2736 and the EA lands FLAT.
  This is TRUE IN SEALED b38 TODAY - neither b39 nor E9-P2 creates it, and E9-P2 is
  PROTECTIVE here (the flat watcher then scans with the same comparator Reconcile just
  used, so a real our-magic tagged position on the new account is adopted rather than
  orphaned). Cross-broker position MIXING is impossible: one terminal shows one account.
  RESIDUAL, recorded as W-7: the stale-file inheritance is untested against a POPULATED
  file from a foreign account. Account-scoped identity (login/server in magic + filename)
  -> E9. Jeff's call 2026-07-29.

MATRIX AMENDMENT (Jeff's word 2026-07-29, Gate 2 was sealed - same status as the K-4
  addition): W-7 added to docs/B39_MATRIX.md as RECORD ONLY, group G-W. No code scope
  change. Verified opportunistically during Run H, which crosses the Doo -> Vantage
  account boundary anyway, so it costs no extra run.

LOCKED DECISION E9-P4 (Q-1, level 0 at STARTUP): OPTION (a) - RebuildLiveMap 2488-2494's
  lvl = 0 assignment is replaced by the same maxLvl+1 rule the adoption path uses, WARN
  kept. WHY: TP-2 alone would abolish level 0 on the ADOPTION paths only, leaving a restart
  into a comment-rewritten position still able to produce a level-0 anchor - L-3's exact
  hazard, on precisely the path Run H exercises (K-1 sliced anchor + K-4 partial-close
  comment integrity). The matrix calls L-3 "arguably the most valuable line in b39"; half-
  closing it was not worth the saving. ACCEPTED COST: touches the sealed Stage 1 rebuild
  that every init runs, so R-1's Doo regression must now include a RESTART. Risk low - the
  branch is unreachable unless a comment is genuinely unparseable, which neither evidence
  broker does today. NOTE: the map is built in ONE pass, so runningMax is the max over
  positions admitted SO FAR; an unparseable position can still land below a later-scanned
  higher level. Accepted - it can never be 0, so it can never seize the anchor from a real
  L1. REJECTED: (b) leave 2493 as-is - L-3 then only partially closed and unmarkable as
  PASS on the restart path. Jeff's call 2026-07-29.

LOCKED DECISION E9-P5 (counter-direction position under our magic): the watcher REFUSES it
  - LOG_ERROR, no adoption. Not contemplated by the sealed matrix; raised at plan time.
  WHY: RebuildLiveMap already treats mixed directions as an error (2509), and grafting a
  counter-direction leg would corrupt the VWAP anchor - the opposite of what b39 exists to
  do. A wrong-direction position is not a level of this sequence. REJECTED: adopt-and-warn
  (gives it exits, but at the cost of the anchor basis every sealed tier sits on).
  Jeff's call 2026-07-29.

## b39 GATE 3 CONFIRMED - 2026-07-29
docs/B39_PLAN_2026-07-29_gate3.md CONFIRMED by Jeff 2026-07-29. TEN touch points:
TP-1 IsAdoptableOurPosition (the one admission filter; magic gate lives here, W-3/N1);
TP-2 AdoptUntrackedLevel (the one entry into live g_state; no level 0, duplicates adopted
with WARN, counter-direction refused); TP-3 RegisterNewRecovery demoted to fast path
(ERROR 1939 -> INFO); TP-4 WatchUntrackedLevels (per-tick, live state); TP-5 flat rebuild
(orphan ERROR 3150 deleted - that branch IS the F-2 hole); TP-6 RegisterButtonL1 seedLvl
default arg; TP-7 order-book ORDER_TYPE split; TP-8 OnTick wiring before EnforceExits;
TP-9 stale EvaluateBasketClose comment 2300-2308; TP-10 RebuildLiveMap maxLvl+1 (Q-1=a).
NO NEW CODE NEEDED for A-4 (retcode gates 2170/3274 already reject non-DONE/PARTIAL/PLACED
before registration), A-5 (ComputeRecoveryTrigger derives nextLvl AND worst from g_state
alone, so adoption alone stops the M5 duplicate stacking) or R-4 (watcher silent when
everything is tracked). Verification must PROVE these, not assume them.
## b39 BUILT + GATE ZERO PASSED - 2026-07-29
b39 = 493302eccd8d3e0d / 4885 lines (+211 from b38's 4674). Compile 0 errors, 0 warnings.
All TEN touch points landed. Implementation notes worth keeping:
- TP-1 IsAdoptableOurPosition (2485) is the single admission truth; the MAGIC test lives
  there and nowhere else, so no b39 caller can reach a magic-0 position (W-3/N1 enforced
  structurally, not by convention). The three magic-0 ADOPTION scans (725, 784, 922) were
  audited and correctly left on the raw _Symbol comparator - they are the mirror-image
  path and are out of b39's scope.
- TP-2 AdoptUntrackedLevel (2504) is the single entry into a live g_state.
- TP-3 RegisterNewRecovery carries a sawLevel flag so "position not there yet" (async,
  INFO) is distinguished from "there and already tracked" (silent). Without it the fast
  path would emit a false "fill pending" line whenever it re-ran over a tracked ticket.
- TP-5 also fixed the BUTTON path's twin of the same defect at ExecuteMarketEntry (3477):
  it still logged ERROR on an async L1. That is matrix A-2, and it was missed on the first
  build pass - caught on the diff review, not by the compiler.
- FindUntrackedOurSeed originally ranked an unparseable tag with a TRTM_MAX_LEVELS+1
  sentinel. REJECTED AND REWRITTEN before compiling: ParseLevelFromComment returns
  whatever the comment holds, so a rewritten '_l99_' would have exceeded the sentinel and
  been silently reseeded to L1 - a level-identity bug. Now ranked on an explicit
  bestParsed flag; a parsed level is never compared against a sentinel.
- TP-10's runningMax is the max over positions admitted SO FAR (one-pass map), so an
  unparseable position can still land below a later-scanned higher level. Accepted and
  documented in-code: what matters is that it is never 0.
## b39 POST-BUILD AUDIT - REGRESSION FOUND AND FIXED (2026-07-29)
Jeff asked for confirmation that the functions were aligned and the bugs handled. The
audit that question forced found a REAL b39 REGRESSION against matrix F-3, which the
compiler could never have caught. Recorded in full because it is the second time the
first build pass was incomplete (the A-2 button path was the first).

DEFECT: the new flat-state L2+ seed branch STOLE THE ANCHOR FROM AN ADOPTABLE L1.
  CheckOwnPendingFillWhenFlat runs BEFORE TryAdopt in OnTick (4828-4831), and OnTick
  only calls TryAdopt while levelCount == 0. The b39 seed branch sets levelCount = 1,
  so on any flat tick where an adoptable magic-0 L1 AND an our-magic L2+ were both
  open, b39 seeded from L2 and TryAdopt never ran. Consequences: the magic-0 L1 sat
  UNMANAGED (the exact failure mode b39 exists to remove), the sequence anchored on L2,
  and baseLot was derived from a LADDER lot instead of the base lot. Reachable on a
  restart into a mixed mobile-L1 + EA-L2/L3 sequence with no state file - the very
  shape E9-N1 blesses. NOT reachable in b38: without the L2 branch the function fell
  through to TryAdopt and the L1 was adopted correctly.

LOCKED DECISION E9-P6 (fix, Jeff's call 2026-07-29): THE SEED YIELDS TO ADOPTION.
  New side-effect-free predicate AdoptionCandidateExists() mirrors BOTH TryAdopt
  branches (tagged magic-0 L1; MMT untagged fallback) with the same gates in the same
  order. When it returns true the seed branch stands down for the tick with a one-shot
  INFO: TryAdopt anchors on L1, and WatchUntrackedLevels adopts L2+ into that sequence
  on the SAME tick. The seed branch now fires only on a genuinely L1-less tick, which
  is the case F-2 is actually about.
  ACCEPTED COST: CheckOwnPendingFillWhenFlat now READS magic-0 positions (it still
  never adopts/closes/modifies one). Its header comment was corrected accordingly -
  the old text claimed our-magic-only and would have been a false statement on disk.
  MAINTENANCE HAZARD TO CARRY: AdoptionCandidateExists duplicates TryAdopt's admission
  logic and MUST be kept in step with it. Deliberately not refactored into one shared
  predicate in b39 - that would re-open TryAdopt, a sealed Stage 2 function with
  one-shot logging side effects, inside a hotfix. -> candidate for E9.
  REJECTED: (b) seed wins, L1 adopted later or never - simpler and needs no cross-magic
  read, but anchors on a ladder lot and the stale-tag gate would permanently lock out a
  legitimately adoptable L1 once the seeded sequence closed.

TP-11 (E9-P6): AdoptionCandidateExists() added above TryAdopt; the seed branch in
CheckOwnPendingFillWhenFlat gated on it; that function's header comment corrected.

## b39 GATE 4 - EVIDENCE LOG (opened 2026-07-29)
DEPLOYED 2026-07-29: MT5 runtime = repo = 12c69766c709bd0d / 4939, verified byte-identical.
EA re-initialized "=== TRTM b39 init ===" on XAUUSD.s (magic 715358), self-test PASS,
Reconcile FLAT.

RUN 1 - R-1/R-2 SYNC REGRESSION: **PASS**. tests/2026.07.29 123116.503.txt, Doo
XAUUSD.s M15 real ticks, deposit 3000 @ 1:500, all three tiers OFF - Run A's input set
exactly (tests/2026.07.26 125653.086.txt is the baseline). SELL ladder L1-L5.
  Compared line by line against Run A:
   - ladder depth L1-L5 .................... IDENTICAL
   - level lots 0.01/0.02/0.03/0.04/0.05 ... IDENTICAL
   - spacing 500 pts off the worst entry ... IDENTICAL
   - cumulative lots 0.03/0.06/0.10/0.15 ... IDENTICAL
   - projected at TP +75.00/+149.97/+250.01/+375.01 vs Run A's
     +75.01/+149.98/+250.02/+375.07 - agree to the cent given the different entry
   - AvgTP recomputed on every level add, propagated to every ticket ... IDENTICAL
   - exit: all five TP hit on one tick, sequence closed, flat marker ... IDENTICAL
  Entry time/price differ (07:45 @ 4176.77 vs 02:18 @ 4156.07) because the button click
  is manual - NOT a code difference; every derived number tracks the entry correctly.
  THE ONLY BEHAVIOURAL DELTA IS THE REGISTRATION LINE, which is TP-3 working:
     b38: "Recovery L2 registered: ticket 3"
     b39: "Recovery fast path: L2 REGISTERED ticket 3 0.02 lots @ 4181.78"
  Same tick, same ticket, same level; the new text adds volume + price (W-5).
  ZERO "Watcher:", ZERO "fill pending", ZERO "DUPLICATE", ZERO "unparseable" lines.
ROWS CLOSED BY RUN 1: R-1 (no regression on a sync broker), R-2 (money paths untouched -
no tier fired, ladder + AvgTP + projections all byte-consistent), R-3 (RunStateSelfTest
PASS), R-4 (watcher inert, no log noise on a healthy run), A-3 (sync fast path registers
immediately, exactly as b38).
NOTE - Run 1 did NOT exercise TP-10: Reconcile ran FLAT at init, so RebuildLiveMap's loop
body never executed. R-1 is NOT complete until a restart with live positions is run.

RUN 2 - R-1/R-2 TIER 3 VARIANT: **PASS**. tests/2026.07.29 124117.612.txt, same tester
setup as Run 1, Run C's three input deltas exactly (InpEntryLotSize=0.03,
InpAvgTPPts=5000, InpEnableTier3=true; baseline tests/2026.07.26 130728.662.txt).
SELL ladder L1-L6, TWO Tier 3 fires, anchor survived both.
  Ladder: lots 0.03/0.04/0.05/0.06/0.07/0.08 = baseLot 0.03 + 0.01x(N-1), incremental
  rule intact. Spacing 500 pts off the worst entry throughout.
  BOTH FIRES RECOMPUTED ON TWO INDEPENDENT DERIVATIONS (leg-by-leg AND the identity
  group P/L = marginPts x SUM(group lots); gold 1 pt on 1.00 lot = $1.00):
    FIRE 1 04:45 - anchor L1 4145.62 slice 0.01 of 0.03 + L6 4211.65 0.08, far 4201.01
      sliced VWAP  4204.31333 (logged 4204.31)   margin 330.3 pts (logged 330.3)
      identity +29.73  |  leg-by-leg +29.73 (anchor -55.39 + L6 +85.12)   AGREE
    FIRE 2 05:00 - anchor L1 now 0.02, slice 0.01 + L5 4200.82 0.07, far 4191.08
      sliced VWAP  4193.92000 (logged 4193.92)   margin 284.0 pts (logged 284.0)
      identity +22.72  |  leg-by-leg +22.72 (anchor -45.46 + L5 +68.18)   AGREE
  Both fires net POSITIVE while the anchor leg is a LOSS - the Tier 3 premise, working.
  Slice sizing correct: 0.03 x 50% = 0.015 floored to the 0.01 unit = 0.01 (remaining
  0.02); second fire slices the 0.02 anchor by 0.01 again (remaining 0.01).
  Anchor SURVIVED both fires; liveness pruned only the closed profitable leg; recovery
  then reopened L5/L6 at the same lots - level numbers reused after the prune, as sealed.
  ZERO Watcher / fill-pending / DUPLICATE / unparseable lines. ZERO WARN. ZERO ERROR in
  the whole run.
ROWS CLOSED/EXTENDED BY RUN 2: R-2 FULLY (E6 money path untouched -
ComputeSlicedAnchorVWAP, FormBasketGroup, FireGroupClose and the slice sizing all
reproduce the sealed E6 arithmetic exactly), R-1 extended (ladder/lots/AvgTP consistent
under a Tier-3-firing config), A-3 again, R-4 again.

RUN 3 - TP-10 RESTART WITH LIVE POSITIONS: **PASS**. tests/2026.07.29 145131.777.txt,
LIVE Doo XAUUSD.s demo chart (not the tester - tester inputs lock once a run starts and
a tester restart replays from the beginning, so it CANNOT produce a reconcile against
open positions; the live chart is the only route). BUY ladder L1-L3, EA removed and
re-attached with positions open.
  BEFORE restart: "Structure: 3 level(s), 0.06 lots | projected at TP +150.03"
  AFTER  restart: "Structure: 3 level(s), 0.06 lots | projected at TP +150.03"
                  "Reconcile complete: dir=BUY levels=3"
                  "Reconcile: flags restored (trailOverride=F beOverride=F
                   trailingActive=F beApplied=F)"
  The projection matching TO THE CENT is the decisive signal: it is derived from all
  three entries and volumes, so it can only match if every ticket, level and lot
  reconstructed identically.
  THIS IS THE RUN THAT FINALLY EXERCISED TP-10 - RebuildLiveMap's loop body ran over
  three real positions, parsed all three comments, assigned levels 1/2/3, and runningMax
  tracked correctly. Runs 1 and 2 both init'd FLAT, so the loop body never executed there.
  ABSENT AS REQUIRED: no "unparseable level comment"/"counted as L", no "Watcher:" line
  (the live map caught all three, leaving the watcher nothing to do), no "baseLot lost
  with state file" WARN (state file survived, so Reconcile's else-branch never ran), no
  level renumbering. ZERO WARN, ZERO ERROR across the restart.
  INCIDENTAL: InpMoneyMode was BALANCE RATIO on this run, not Fixed Lot ("Entry lot
  0.0157 normalized to 0.0100"). Does not invalidate the restart evidence and
  incidentally exercised the balance-ratio lot path with Guard A's round-down, which
  behaved correctly. Three clean open/close cycles preceded the test - incidental
  confirmation that the button path and liveness attribution are intact.
ROWS CLOSED BY RUN 3: TP-10 restart path (the R-1 gap Runs 1-2 could not reach); K-3 in
part (restart across a live sequence, no orphan); R-1 NOW COMPLETE.

=> THE SYNC-BROKER REGRESSION OBLIGATION (R-1/R-2/R-3/R-4) IS CLOSED ON EVIDENCE.
   E1/E4/E5/E6 are demonstrably unaffected by b39 on a synchronous-fill broker.

STILL OPEN: A-1/A-2/A-5 + W-1..W-6 (Vantage async reproduction - THE DEFECT b39 EXISTS
TO FIX, still entirely unverified), F-1..F-5 (flat-state rebuild), L-1..L-4, O-1..O-5,
K-1/K-2/K-4 (Run H on Vantage).
  [SUPERSEDED 2026-08-18 for A-1 and W-1..W-6 - see "WATCHER CAVEAT RETIRED" below.]

## WATCHER CAVEAT RETIRED - A-1 + W-1..W-6 CLOSED ON LIVE EVIDENCE (2026-08-18)
SEALED BY JEFF 2026-08-18. The single largest inspection-only hole in the sealed build is
closed. WatchUntrackedLevels HAS NOW ADOPTED A POSITION.

EVIDENCE: tests/2026.08.18 095950.169.txt - Vantage CENT LIVE, XAUUSD.sc, magic 725639,
build b40 (behaviourally identical to b39 - documentation-only delta, so this evidence
applies to the b39 seal without qualification). THE SAME ACCOUNT AND SYMBOL THAT PRODUCED
THE 2026-07-27 INCIDENT, which is what the caveat demanded.
NOT a designed test - it occurred unprompted during ordinary use. The timing tail that was
"not reproducible on demand" reproduced itself.

THE THREE-LINE RETIREMENT SIGNATURE, IN ORDER, WITHIN 97 ms:
  L42  10:35:01.229  "Recovery L2: order accepted but no position yet (asynchronous fill)
                      - the watcher will register it as soon as it appears"
  L43  10:35:01.326  "Watcher: L2 REGISTERED ticket 520795347 0.55 lots @ 4396.53"
  L46  10:35:01.352  "Exits applied to ticket 520795347: TP 4407.20 SL none"
The fast path MISSED (L42 is b39's INFO-on-miss demotion, not an ERROR - previously this
was the path that produced the unmanaged orphan). The watcher caught it. Exits landed.
The defined failure mode - "an orphan with NO watcher line is a b39 DEFECT" - did NOT occur.

ROW-BY-ROW:
  A-1 async fill registers ............ CLOSED ON EVIDENCE. Fast path missed, watcher
                                        registered, position managed.
  W-1 watcher runs while LIVE ......... CLOSED ON EVIDENCE. Sequence was live (L1 open
                                        since 10:02:35) when L2 was adopted.
  W-2 adopts own tagged untracked ..... CLOSED ON EVIDENCE. Ticket 520795347, our magic,
                                        level parsed correctly as L2.
  W-3 MUST-NOT: never adopts magic-0 .. CLOSED ON EVIDENCE. No foreign/magic-0 adoption
                                        anywhere in the run.
  W-4 MUST-NOT: never double-registers  CLOSED ON EVIDENCE. L2 appears exactly once; the
                                        Structure line reads 2 level(s) / 1.05 lots =
                                        0.50 + 0.55 EXACTLY. Zero DUPLICATE lines.
  W-5 logs ticket/volume/price ........ CLOSED ON EVIDENCE. L43 carries all three
                                        (the // W-5 comment at TRTM.mq5:2627).
  W-6 O(positions), no alloc, silent .. CLOSED **SPLIT** (Jeff's call 2026-08-18, on my
                                        recommendation, over closing it whole):
        - SILENCE/behaviour half: ON EVIDENCE. Zero watcher lines across the healthy
          synchronous cycles at 10:01:36, 10:01:48 and 10:02:35 - the watcher stayed
          silent when there was nothing to do (R-4's no-new-noise property).
        - COMPLEXITY half (O(positions), no allocation): REMAINS ON INSPECTION. It is a
          structural property of the loop and is NOT observable from a journal. Recorded
          as inspection-only rather than rounded up to a pass, to hold the honesty
          standard the b39 seal set for itself.

ARITHMETIC AUDIT (recomputed, not taken from the log):
  L1 0.50 @ 4402.40, L2 0.55 @ 4396.53. Lot-weighted avg entry =
  (0.50*4402.40 + 0.55*4396.53) / 1.05 = (2201.2000 + 2418.0915) / 1.05
  = 4619.2915 / 1.05 = 4399.3252.
  Computed TP reported 4401.83 => +250.8 pts above avg entry, consistent with the AvgTP
  target on this config. Structure line's level count and lot total both reconcile.

WHAT THIS DOES NOT CLOSE: A-2 (unchanged), F-1..F-5 (flat-state rebuild still never
triggered - this adoption was in the LIVE state, not the flat state), L-1..L-4,
K-1/K-2/K-4 (Run H still not run). Run H remains the top outstanding item.
  [SUPERSEDED 2026-08-18: RUN H IS DONE. See "RUN H - EXECUTED 2026-08-18" - K-1/K-2(b)
   PASS, K-4 FAIL, L-3 defended. F-1..F-5 and L-1/L-2/L-4 remain open as stated.]

INCIDENTAL FROM THE SAME LOG: the manual-TP re-adoption defect, parked as E9-M1 (see the
E9-M1 section near the head of this file). It is a SEALED-Stage-8 defect surfaced by this
run, NOT a b39/b40 regression, and it does not qualify any row closed above.

## EVIDENCE-BASE AMENDMENT - VANTAGE TEST ACCOUNT (2026-07-29)
Jeff created a VANTAGE STANDARD ECN **DEMO** account for b39 testing rather than risk the
live account. Correct call - b39 rewrites core registration and must not be first-run on
live money.
CONSEQUENCE THAT MUST BE HONOURED AT SEAL TIME: the 2026-07-27 incident occurred on the
VANTAGE CENT **LIVE** account (XAUUSD.sc), and TRADE_RETCODE_PLACED / price 0.00 / deal 0
is a property of THAT account's execution model (a bridge acknowledging before executing).
A Standard ECN DEMO is a different account type on a different server and commonly fills
SYNCHRONOUSLY. So:
  - If the demo reproduces the async fill -> A-1/A-2/A-5/W-1..W-6 close on real evidence.
  - If the demo fills SYNCHRONOUSLY (every level via "Recovery fast path", no "Watcher:"
    line) that is NOT a pass on the async rows. It is a THIRD sync-broker regression data
    point (useful - b39 correct on another broker) and the async rows STAY OPEN.
MUST-NOT: marking A-1 or any watcher row closed off a run in which the async condition
never occurred. Absence of the trigger is not evidence of the fix.

RUN 4 - VANTAGE STANDARD ECN DEMO: **SYNC FILL - ASYNC ROWS NOT CLOSED**.
tests/2026.07.29 222348.119.txt, live Vantage Standard ECN DEMO chart, symbol XAUUSD+.
The predicted outcome above occurred: the demo fills SYNCHRONOUSLY. Every level
registered via "Recovery fast path" on the send tick. NO "fill pending", NO "Watcher:"
line, no TRADE_RETCODE_PLACED. Three sequences run (SELL L1; BUY L1-L2; BUY L1-L3), all
clean, zero WARN, zero ERROR.
  => A-1, A-2, A-5, W-1..W-6 REMAIN ENTIRELY UNVERIFIED. The async condition did not
     occur, so this run says nothing about them.
  => Counts as a THIRD sync-broker regression data point: b39 correct on Doo XAUUSD.s,
     the Doo tester, and now Vantage XAUUSD+.
VALUABLE RESULT - FIRST LIVE EXERCISE OF E9-P2 (the normalized symbol comparator):
  symbol is "XAUUSD+" (raw), normalizing to "XAUUSD" - a suffix form NEITHER evidence
  broker had. All five registrations admitted correctly through IsAdoptableOurPosition's
  NORMALIZED comparator. Through b38 the registration paths compared RAW != _Symbol
  (which would also have worked here); b39 routes them through the normalized form, and
  this run proves that change admits correctly on a previously untested suffix. E9-P2 is
  no longer theory-only.
W-7 NARROWED BY EVIDENCE: magic here is 758105, derived from "XAUUSD"; Doo XAUUSD.s
  derives 715358 from "XAUUSDS". DIFFERENT normalized symbols -> different magics ->
  different state files. The account-switch collision W-7 describes requires both
  brokers' gold to normalize IDENTICALLY; XAUUSD+ and XAUUSD.s do NOT. Jeff's two
  accounts CANNOT collide. W-7 stays recorded for E9 but its reachability is now known
  to be narrower than drafted.
BROKER FACT ON RECORD: Vantage Standard ECN Demo XAUUSD+ stops level 20 pts, freeze 0
  (vs Doo XAUUSD.s 100 pts) - consistent with the matrix evidence-base note.

RUN 5 - VANTAGE CENT **LIVE** (XAUUSD.sc, magic 725639 set EXPLICITLY via InpMagicNumber
to avoid the W-7 state-file collision): **ASYNC RETCODE REPRODUCED; ASYNC MISS DID NOT**.
tests/2026.07.29 235916.412..txt. Jeff's call to run the defect's own account at minimum
size (0.01) with InpMaxRecoveryTrades=2 as a hard runaway cap, watched throughout.
  THE ASYNC SIGNATURE IS PRESENT ON ALL THREE SENDS - the 2026-07-27 shape exactly:
     "L1 BUY OPENED via button: 0.01 lots @ 0.00 (deal 0)"
     "Recovery L2 OPENED: 0.02 lots BUY @ 0.00 (deal 0)"
     "Recovery L3 OPENED: 0.03 lots BUY @ 0.00 (deal 0)"
  price 0.00 / deal 0 = TRADE_RETCODE_PLACED. This IS the asynchronous-fill broker.
  BUT ALL THREE REGISTERED VIA THE FAST PATH, each with a REAL entry price:
     L1 ticket 469006561 @ 4015.51 | L2 ticket 469012846 @ 4012.19 (fast path)
     L3 ticket 469022910 @ 4009.20 (fast path)
  MEANING: the broker acknowledges BEFORE executing, but executed within the same tick,
  so the position existed by the time the fast path scanned. That is why b38 "got lucky"
  on L1 on 2026-07-27. The async RETCODE is routine here; the async registration MISS is
  the rarer, worse case and did not occur in this run.
ROWS CLOSED BY RUN 5:
  A-3 / R-1 ON THE ASYNC BROKER - a PLACED send whose position lands in time registers
    via the fast path exactly as b38 did. No behaviour change on the common async case.
  A-5 (duplicate stacking) - L2 and L3 each opened ONCE. The trigger recomputed off each
    new worst entry (4015.51 -> 4012.19 -> 4009.20, 300 pts apart). On 2026-07-27 the EA
    opened a duplicate EVERY M5 BAR because L2 was never tracked. Closed on evidence.
  O-3 / O-4 - NO 10013, no "cancel ... [invalid request]", no spurious pendingLive, on
    the very account that produced that error. The ORDER_TYPE split works.
  K-3 / TP-10 again - init RECONCILED A LIVE 2-LEVEL SEQUENCE from a previous session
    ("levels=2", +75.00) on the async broker. RebuildLiveMap's loop clean, no WARN.
STILL OPEN AFTER RUN 5: A-1 and W-1..W-6. The watcher never fired because the fast path
  never missed. Closing them needs a fill slow enough that no position exists when the
  fast path looks - rarer than the PLACED retcode itself.
INCIDENTAL (not a b39 row, but useful): Jeff dragged the TP twice mid-sequence; b39
  adopted 4020.06 then 4019.42 and RELEASED correctly on the L3 add ("Manual TP 4019.42
  RELEASED - level add (L3)"). Sealed b24/b28 manual-ownership semantics survive b39's
  new registration path - that is TP-2 step 7 (ReleaseManualTP inside AdoptUntrackedLevel)
  exercised LIVE.
COSMETIC, PRE-EXISTING, NOT b39: close prices also return 0.00 on this broker
  ("Closed L1 ticket 468953350 @ 0.00").

## b39 SEAL DECISION - A-1/W-1..W-6 CLOSED ON INSPECTION, NOT EVIDENCE (Jeff, 2026-07-30)
DECISION: seal b39 WITH THIS CAVEAT RECORDED. The Cent account is LIVE with real money;
Jeff will not run further tests there to chase a timing tail. Run 5 already bought the
expensive evidence (async retcode reproduced, A-5/O-3/O-4 closed on that very account).
WHY THE WATCHER COULD NOT BE REPRODUCED: Run 5 established that on Vantage the PLACED
retcode is ROUTINE but the fill still lands within the tick, so the fast path never
misses. The registration MISS that caused the 2026-07-27 incident is a rarer TIMING TAIL,
not the everyday case. It cannot be summoned on demand on any available account:
  - Doo (tester + live): synchronous, no PLACED at all.
  - Vantage Standard ECN DEMO: synchronous.
  - Vantage Cent LIVE: PLACED routine, fill lands in time - miss did not occur in 3 sends.
WHAT IS AND IS NOT PROVEN:
  PROVEN - b39 does not break anything. 3 brokers, 3 symbol suffixes (.s / + / .sc),
    tester + live, restart with open positions, two Tier 3 fires recomputed to the cent.
    R-1/R-2/R-3/R-4, A-3, A-5, O-3, O-4, K-3, TP-10, E9-P2 all closed on EVIDENCE.
  NOT PROVEN [AS OF THE b39 SEAL 2026-07-30 - NO LONGER TRUE, SEE THE AMENDMENT BELOW] -
    WatchUntrackedLevels has never adopted a position. A-1 and W-1..W-6 close
    on CODE INSPECTION only. What is inspected-but-unexercised is narrow: the DISPATCH
    from WatchUntrackedLevels. Its admission filter (IsAdoptableOurPosition) and its
    adoption body (AdoptUntrackedLevel) are BOTH exercised on every run - every single
    "Recovery fast path: L<n> REGISTERED" line in Runs 1-5 went through the same
    AdoptUntrackedLevel, and every registration on 3 brokers went through the same
    IsAdoptableOurPosition. The untested part is the per-tick loop that calls them.
  AMENDMENT 2026-08-18: THE DISPATCH LOOP IS NOW EXERCISED. The one narrow gap named
    directly above closed on live evidence - WatchUntrackedLevels adopted L2 on Vantage
    Cent LIVE (tests/2026.08.18 095950.169.txt). A-1 + W-1..W-5 on evidence, W-6 split.
    The "NOT PROVEN" heading above is retained as the record of the seal-time position;
    it is NOT the current status. See "WATCHER CAVEAT RETIRED" for the full audit.
RISK POSTURE ACCEPTED: b39 on the Cent account is strictly SAFER than b38 today. Worst
  case the watcher never fires and behaviour equals b38; best case it saves a position
  from going unmanaged. b38's behaviour in that scenario is KNOWN-BAD (2026-07-27).
PARKED, NOT ABANDONED - IF IT HAPPENS AGAIN: the journal now makes the miss visible and
  self-documenting. Look for this sequence on the Cent account:
     "Recovery L<n>: order accepted but no position yet (asynchronous fill)"   <- INFO
     "Watcher: L<n> REGISTERED ticket <t> <vol> lots @ <price>"                <- next tick
     "Exits applied to ticket <t>: TP <x> ..."
  If those three appear, A-1 and W-1..W-6 close on live evidence and this caveat is
  retired - update this entry and the checklist. If instead an orphan appears with NO
  watcher line, that is a b39 DEFECT and the log is the reproduction: capture it and
  reopen. Either way the evidence arrives for free during normal use.
NOT DONE (deliberately, no code written): the [TESTER]-gated forced-miss switch that
  would have exercised the watcher synthetically. Rejected as needing a new build (b40)
  plus Gate Zero for test-only code that proves the watcher works but NOT that a real
  broker triggers it. Remains available if certainty is ever wanted.
NOTE ON L-2/L-3/TP-10's WARN branch: unreachable on both evidence brokers without a
DELIBERATELY corrupted comment - decide before seal whether those rows close on evidence
or on code inspection.

## E9 / b39 - GATE 1 OPEN (2026-07-27)
LOCKED DECISION E9-S1 (scope): SPLIT. A narrow gated hotfix build b39 covering ONLY
  O1 (deferred registration on PLACED) + O2 (live-sequence orphan watcher) - the two that
  produce unmanaged positions - followed by a separate E9 for O3-O6 hardening. Full gate
  order applies to b39, just a small matrix and plan. Run H rides along on b39.
  REJECTED: (a) one E9 covering all six - cleaner record and the broker-negotiation pieces
  do interact, but it leaves the live exposure open until the whole thing lands;
  (b) O1+O2 only with no follow-on E9 - accepts netting/filling/exemode/comment risk
  permanently, defensible only if Vantage stays the sole additional broker.
  Jeff's call 2026-07-27.
DEFERRED TO E9 (not in b39): O3 filling-mode negotiation from SYMBOL_FILLING_MODE;
  O4 margin-mode guard (refuse/config-block on netting); O5 execution-mode awareness +
  init guidance in the LogBrokerExitGeometry idiom; O6 comment-integrity detection and
  fallback.
LOCKED DECISION E9-O1/O2 (registration model): WATCHER-PRIMARY, single mechanism. A
  live-sequence orphan watcher runs each tick and adopts ANY our-magic position carrying a
  _lN_ tag that is not currently tracked, at its comment level - the same admission filter
  RebuildLiveMap (2471) already uses and which has been sealed since Stage 1.
  RegisterNewRecovery is demoted to a FAST PATH: when it misses it logs INFO ("fill
  pending"), not ERROR, and the watcher completes registration on the next tick. NO new
  persisted state - consistent with E4/E5/E6 keeping everything derived per tick.
  WHY: O2 strictly subsumes O1's failure case. A watcher covers async fill AND a crash
  between send and register AND causes not yet seen, whereas deferred registration only
  covers the send path it was watching. In the 2026-07-27 incident a watcher would have
  adopted L2 on the next tick and NONE of the downstream damage (duplicate stacking,
  unmanaged position) would have occurred.
  ACCEPTED COST: up to one tick unmanaged before EnforceExits dresses the position.
  REJECTED: (a) register-on-send primary with a deferred queue keyed on the order ticket -
  more precise and can name the order that never filled, but needs new in-memory state, is
  a second path doing what the watcher does anyway, and still misses a crash between send
  and queueing; (b) BOTH - maximum coverage, but two mechanisms can race on one position
  so the matrix must prove they cannot double-register, which is real verification surface
  for a hotfix build. Jeff's call 2026-07-27.

LOCKED DECISION E9-O2b (unparseable tag): ADOPT AT maxLvl + 1, loud WARN naming the
  ticket. It gets TP/SL and is counted; being the HIGHEST level it can never seize the
  anchor. This ALSO replaces RebuildLiveMap's existing lvl = 0 path (2488), which is a
  live hazard today: FormBasketGroup picks the LOWEST level as anchor, so 0 wins and an
  unidentified position inherits both the SL anchoring (ComputeTargets) and Tier 3's slice
  target. Removing that is arguably the most valuable line in b39.
  SCOPE NARROWED BY EVIDENCE (Jeff, 2026-07-27): the ONLY way to get an our-magic position
  with an unreadable tag is the broker rewriting a comment WE wrote - the mobile/adoption
  path cannot produce one (see E9-N1 below). Jeff confirmed Vantage leaves comments INTACT
  on live XAUUSD.sc positions, so this case has no observed probability on his platform.
  That evidence changed the recommendation: open-time inference was recommended first
  (it correctly re-identifies a comment-stripped SLICED ANCHOR) but is added complexity in
  a hotfix for something now evidenced not to occur here.
  REJECTED: (a) open-time inference - deferred to E9-O6, still the right answer IF a
  broker is found that rewrites comments; (b) quarantine without adopting - matches the
  "notify never auto-close" idiom but leaves the position with NO TP and NO SL, which is
  the exact exposure b39 exists to remove. Jeff's call 2026-07-27.

NOTE E9-N1 (why the watcher cannot collide with ADOPTION - Jeff's question, 2026-07-27):
  The two paths are separated by the MAGIC NUMBER and it is enforced explicitly.
  Adoption handles magic-0 (external) positions - TryAdopt refuses ours outright
  ("if(POSITION_MAGIC == g_magic) continue"), and the untagged mobile fallback demands
  magic EXACTLY 0 ("if(POSITION_MAGIC != 0) continue"). The watcher's filter is the mirror
  image: magic == g_magic AND a parseable _lN_ tag. A mobile trade has NEITHER, so the
  watcher is blind to it. This is structural, not incidental: MT5 cannot modify
  POSITION_MAGIC, so an adopted L1 stays magic 0 for life and is restored by ticket from
  the state file in Reconcile, never by any scan. Mixed sequences (mobile L1 at magic 0 +
  EA-opened L2/L3 at our magic) work: the watcher considers only L2/L3.

LOCKED DECISION E9-O2d (order-book type split): CancelOwnPendingOrders and
  CountOwnPendingOrders must distinguish a GENUINE PENDING from an IN-FLIGHT MARKET order
  by ORDER_TYPE. Only BUY_LIMIT / BUY_STOP / SELL_LIMIT / SELL_STOP are pendings;
  ORDER_TYPE_BUY / SELL sitting in the book are fills in progress and must be left alone.
  WHY: the async fill caused THREE defects, all visible in Jeff's 2026-07-27 log, all with
  this one root. (1) the registration miss (O1/O2); (2) CancelOwnPendingOrders tried to
  OrderDelete the in-flight market order -> "cancel #459172826 [invalid request]" 10013;
  (3) CountOwnPendingOrders counts in-flight market orders as pendings, spuriously setting
  pendingLive - which HIDES the BUY/SELL buttons and trips the P7 "cancel the pending
  first" refusal. Minimal fix, removes an ERROR Jeff is seeing live. Jeff 2026-07-27.

LOCKED DECISION E9-O2e (order accepted but NEVER filled): NO TIMEOUT IN b39; escalation
  deferred to E9. The system degrades gracefully - if the order never becomes a position
  the level simply does not exist, the recovery trigger still computes from the old worst
  entry, and the signal re-fires on a later bar. If the first order fills very late the
  watcher adopts both and O2a tolerates the duplicate with a WARN. Not silent either: the
  send logs INFO and every adoption logs, so a send with no matching adoption is visible.
  Preserves the no-new-state property of watcher-primary and keeps b39 a hotfix.
  REJECTED: (a) track order tickets for a timeout - reopens the no-new-state decision and
  adds the second mechanism we rejected as O1; (b) infer from the order book via the O2d
  split - zero new state and composes well, but infers intent from the book rather than
  from what we sent, so it cannot tell our stuck order from a slow server clear. Both
  remain candidates for E9. Jeff's call 2026-07-27.

LOCKED DECISION E9-O2a duplicate-level collision: ADOPT BOTH and tolerate
  duplicate level numbers, with a loud WARN naming the tickets. Rationale: the positions
  EXIST and must be managed - refusing one recreates the exact orphan we are fixing; and
  the level is an ADDRESS for lot sizing and anchor ordering, not a unique key. Checked
  downstream: ComputeRecoveryTrigger takes maxLvl+1 (fine), the lot-weighted VWAP includes
  both (financially correct), ComputeLevelLot keys off baseLot (fine). EDGE TO RECORD: if
  duplicates ever occur at the LOWEST level, FormBasketGroup's "first lowest wins" makes
  the anchor arbitrary and "oldest" ambiguous - only reachable if L1 itself duplicates.
  REJECTED: refuse-the-second (leaves an unmanaged position); renumber-to-next-free (the
  comment would then disagree with the tracked level and a restart would undo it).

LOCKED DECISION E9-O2c (watcher scope): RUNS IN BOTH STATES, flat and live. While FLAT,
  finding our-magic _lN_ positions rebuilds a sequence from them - the same thing
  Reconcile already does at startup, reusing that sealed path rather than inventing a
  second one. SUPERSEDES CheckOwnPendingFillWhenFlat's L1-only scan.
  WHY: the flat state has the SAME orphan hole as the live state, and it is the one Jeff
  is closest to hitting. His L2 is untracked right now; if L1 closes first (it carries a
  manual TP at 4090.59) then liveness prunes L1, levelCount hits 0, state resets, and the
  0.02 L2 is left open with NO TP and NO SL - with the only trace being the one-shot
  orphan ERROR at 3147, which skips lvl > 1 and never manages it. Closing the hole in one
  direction only would leave that intact.
  ACCEPTED COST: an our-magic position left open from a previous session will now START a
  sequence rather than sit idle. Arguably correct - it is ours and should carry exits -
  but it sets adoptionTime to now and derives baseLot from what it finds.
  Adoption of magic-0 trades is untouched (E9-N1). Jeff's call 2026-07-27.

## b39 GATE 2 SEALED - 2026-07-27
docs/B39_MATRIX.md SEALED rev 1 by Jeff 2026-07-27. 7 groups, 29 rows
(A-1..5, W-1..6, L-1..4, F-1..5, O-1..5, R-1..4, K-1..4).
MUST-NOT rows: A-4, W-3, W-4, L-3, F-3, O-3, O-4.
CRITICAL rows: L-3 (level-0 anchor hazard - present in SEALED b38 TODAY, independent of
Vantage: RebuildLiveMap 2488 assigns lvl=0 on an unparseable comment and FormBasketGroup
picks the LOWEST level as anchor, so an unidentified position inherits both the SL
anchoring and Tier 3's slice target); R-1/R-2 (no regression on a synchronous-fill
broker - b39 touches core registration, which every sealed enhancement sits on, and the
E6 Run A / Run C logs are the diff baseline); A-5 (duplicate-stacking path closed);
F-2 (flat-state orphan hole).
NEW ROW ADDED AT DRAFT TIME - K-4: confirm Vantage preserves comments across a PARTIAL
CLOSE. Jeff verified they survive on OPEN positions (2026-07-27) but the partial-close
case is the one that matters for E6 and is still unverified. A rewrite there would make
L-2/L-3 active rather than defensive and would escalate E9-O6.
NEXT: Gate 3 - draft the b39 code plan from this sealed matrix. PRIORITISED FOR THE NEXT
SESSION (Jeff, 2026-07-27), ahead of E8.

## b39 GATE 1 COMPLETE - 2026-07-27
All sub-decisions locked: S1 (scope split), O1/O2 (watcher-primary registration),
O2a (duplicate levels: adopt both), O2b (unparseable tag: maxLvl+1, also fixes the
lvl=0 anchor hazard), O2c (watcher runs flat AND live, supersedes
CheckOwnPendingFillWhenFlat), O2d (order-book type split), O2e (no never-filled timeout).
Plus note N1 (magic separates the watcher from adoption).
NEXT: Gate 2 - draft the b39 matrix. Expected shape, small: async-fill registration
(recovery + button paths), watcher admission filter, duplicate levels, unparseable tag,
flat-state rebuild, order-type split, and MUST-NOT rows (never adopt magic-0; never
double-register; never let an unidentified position become the anchor; byte-identical
behaviour on a synchronous-fill broker so E1/E4/E5/E6 are unaffected).
b39 SCOPE ALSO INCLUDES: Run H (T3-K1/K2) on VANTAGE, not only the Doo demo - overdue per
the comment-integrity risk, and b39 changes the very code that rebuilds a sequence.
REGRESSION OBLIGATION: b39 touches core registration, which every sealed enhancement sits
on. The matrix must carry a row proving behaviour on a SYNCHRONOUS-fill broker
(DooTechnology XAUUSD.s) is unchanged - the E6 Run A/C logs are the baseline to diff.

## (superseded) GATE 4 IN PROGRESS log
GATE 4 IN PROGRESS: docs/E6_VERIFY_CHECKLIST.md DRAFTED 2026-07-26 (36 matrix rows
mapped; 8 live runs A-H specified). THREE RUNS GREEN so far, all XAUUSD.s tester,
every money number recomputed to the cent and cross-checked against the identity
group P/L = marginPts x SUM(group lots):
 - Run A (tests/2026.07.26 125653.086.txt) T3-R1 PASS: all tiers off, ZERO Tier lines,
   4 AvgTP recomputes + 4 projections exact. Calibration finding -> Run C settings.
 - Run C (tests/2026.07.26 130728.662.txt) base 0.03, Tier 3 only. TWO fires.
   T3-6 PROVEN LIVE: slice 0.01 -> 4205.1978 (+281.8 pts, fires); remainder 0.02 ->
   4200.0360 (-234.4); full 0.03 -> 4195.8127 (-656.7). Both alternatives NEGATIVE -
   stronger than the reference. Closed T3-1/5/6/SL1/SL2/SL3/SL4/SL5/A1/G1/G2/G3/X1/X2/
   P1/P2/H1/H2/H4/D1/D2/R2/M1.
 - Run E (SELL tests/2026.07.26 131938.427.txt, BUY tests/2026.07.26 132224.767.txt)
   InpStopLossPts=8000. FOUR more fires. T3-2 BUY lap PROVEN (Bid-side, O8 direction-
   derived - no reference existed). T3-H3 PROVEN BOTH LAPS: SELL SL 4243.58 / BUY SL
   4108.79 unchanged across every slice, ZERO "SL re-anchored" lines (contrast E5 Run 3,
   which logged one per Tier 2 fire) - confirms F-a, zero code. BONUS: the BUY lap's
   unchanged SL was HIT at 4108.77, all 8 legs including the twice-sliced anchor - a
   genuine broker-held stop fired, not merely an unchanged value.
 Tightest fire verified: BUY fire 2 cleared the 200-pt bar by 0.125 pts (200.125) and
 still reproduced to the cent. All eight fires satisfy the G2 invariant on BOTH
 derivations.
 TESTER CAVEAT: these runs used "calculate profit in pips". Harmless for Tier 3 (pure
 price arithmetic; POSITION_PROFIT used only for the membership SIGN test) but it makes
 Tier 2's Gate B meaningless - MUST be turned OFF before Run G (T3-PR3).
 REMAINING: T3-3/T3-4 (Run D), T3-PR2/PR3 precedence (Runs F/G, UNOBSERVED), T3-K1/K2
 (Run H), T3-X4 (opportunistic), T3-DS1 (Jeff visual). Reference audit result: E6_MATRIX rev 1 is
arithmetically CLEAN - both fires reproduce to the cent and were corroborated
against the RAW Shadow log lines 506-532 / 927-953, not re-derived from the
matrix's own intermediates (the method that caught F5 in E5). No F5-class error.
Three checklist findings worth carrying into the runs:
 - TEST-DESIGN BLOCKER: L1 is always the anchor while it lives, and L1 ==
   InpEntryLotSize (L(N>=2) = baseLot + (N-1) x InpIncrementStep). At the DEFAULT
   0.01 the anchor is below InpTier3MinLots 0.02 AND below 2 x unit, so Tier 3 can
   NEVER fire on a default-entry-lot ladder. Every fire run raises InpEntryLotSize
   (0.03 mirrors FIRE 2 and is the T3-6 crux). Same fact = Run D's T3-SL4 evidence.
 - ANCHOR DEPTH: the slice-vs-full margin gap scales with the anchor's depth
   relative to the profitables' margins. A 4-level ladder still clears Tier 1 on
   the FULL anchor, proving nothing. The regime needs ~8 levels at a 500-pt
   interval then a retrace greening only the top 2 - worked to the cent in the
   checklist's Run C target (slice 300.0 pts / remainder 152.4 / full 18.2).
 - STRUCTURAL RELATION: with the anchor as the group's worst leg, marginPts(slice)
   >= marginPts(full) ALWAYS. This is why Tier 3 fires where Tier 1 cannot, and it
   dictates the PR2/PR3 construction: make Tier 1 qualify by setting
   InpTier1MinProfitPts LOW (~50), never by raising Tier 3's bar (which can never
   produce a both-pass tick).
 - Slice sizing swept for float drift across ClosePercent x anchorVol (13 x 19
   combinations at unit 0.01): ZERO drift cases; the clamp holds
   unit <= slice <= anchorVol - unit throughout.

## LIVE FINDINGS 2026-09-23 (AUDNZDS, account 709170, magic 709170, b41)
SOURCE: trtm_logs/log_AUDNZDS_709170_2026091[89].log, ..._20260921/22/23.log.
NOT the Doo XAUUSD terminal - a DIFFERENT account/instrument from every prior run. Raised
by Jeff from the live logs, not from a planned verification run.

FINDING 1 - FALSE-FLAT RECONCILE WIPED adoptedL1 (-> E9-Q2). CONFIRMED.
  2026.09.18 08:41:02 restart: "Reconcile: restored adopted L1 ticket 2940935091 from state
    file", structure 9 levels / 0.58 lots. CORRECT.
  2026.09.18 23:54:59 restart (deinit reason 9): "recorded adopted L1 ticket 2940935091 no
    longer exists - closed while EA was offline" THEN "file claims 9 level(s) but broker is
    flat" THEN "Reconcile complete: FLAT".
  THE POSITION WAS NEVER CLOSED. It reappears 2026.09.21 00:00:00 as "UNMANAGED MANUAL
    TRADE: ticket 2940935091", and all EIGHT magic-owned levels reappear and re-register as
    L2..L9 in the same second. Nothing had closed; the broker was NOT flat.
  MECHANISM (code-confirmed, TRTM.mq5 2976 + 3001): Reconcile trusts PositionsTotal() /
    PositionSelectByTicket UNCONDITIONALLY at init. At a Friday-rollover init the terminal
    returned an EMPTY position list; RebuildLiveMap found 0 magic positions and the L1
    select failed, so Reconcile concluded "closed while offline" and called StateReset ->
    StateSave, OVERWRITING the state file with a flat marker and destroying the adoptedL1
    record PERMANENTLY.
  The 8 magic-owned levels SELF-HEALED on 09-21 via b39/F-2 orphan rebuild. The adopted
    L1 (magic 0) has NO such path - the state file was its only record. It ran UNMANAGED
    (no TP/SL, no recovery) from 09-18 23:54 until Jeff closed it manually on 09-23.
  RELATION TO E9-M4: M4 said adoptedL1 is unrecoverable "on state-file loss". The file was
    not lost - it was OVERWRITTEN BY THE EA on a false reading. M4 understates the exposure.

FINDING 2 - TIER 3 SLICE DID NOT EXECUTE, AND THE ERROR LINE WAS FICTION (-> E9-Q3 + Q4).
  2026.09.22 09:25:18 "Tier 3 FIRE: SELL group 3 leg(s) (anchor L2 slice 0.02 of 0.05 +
    2 profitable) | sliced-VWAP 1.24151 far 1.23951 margin 200.3 pts >= 200/lot"
    then "Closed L9 2963521986", "Closed L8 2961928246",
    then "[ERROR] Partial close FAILED on ticket 2942227144 (retcode 10009: done at 0.00000)"
    then the X-3/O7 WARN (anchor stays FULL, realized = pure profit).
  RETCODE 10009 IS TRADE_RETCODE_DONE - SUCCESS. An "ERROR ... FAILED (retcode: done)" line
    is self-contradictory and is the tell.
  ARITHMETIC PROVES THE SLICE NEVER SENT (recomputed here, not taken from the log):
    pre-fire structure 8 levels / 0.56 lots.
    slice executed  => 0.56 - 0.08 - 0.09 - 0.02 = 0.37
    slice not sent  => 0.56 - 0.08 - 0.09        = 0.39
    log reads "Structure: 6 level(s), 0.39 lots" -> 0.39. THE ANCHOR STAYED FULL AT 0.05.
  ROOT CAUSE (verified against the MT5 Include tree, Trade.mqh 599-641):
    CTrade::PositionClosePartial has FOUR early return(false) paths. ClearStructures() is
    called only AFTER the first two, so those two return false WITHOUT writing m_result -
    and ResultRetcode() then reports the PREVIOUS order retcode. The previous order was
    the successful full close of L8. THAT is where 10009 came from.
    ELIMINATION by the observed retcode:
      IsStopped()             -> writes 10027. RULED OUT.
      !IsHedging()            -> NO write. candidate.
      !PositionSelectByTicket -> NO write. candidate.
      !FillingCheck()         -> writes 10030/10011. RULED OUT.
    NETTING IS DISPROVEN: eight distinct SELL tickets coexist on AUDNZDS at different entry
      prices (09-21 00:00:00), plus magic-0 ticket 2940935091 alongside them. Netting merges
      same-symbol positions into one, so the account IS HEDGING and IsHedging() is true.
    THEREFORE: PositionSelectByTicket(2942227144) returned FALSE INSIDE CTrade, one line
      after the O7 caller at 2421 called PositionSelectByTicket(anchorTk) and got TRUE.
      The terminal position cache changed answer between two adjacent calls.
  CORRECTION ON THE RECORD: an earlier read this session attributed this to a NETTING
    account and cited E9-O4 as evidenced. WRONG - disproven by the coexisting tickets above.
    E9-O4 stays parked on its own merit, NOT evidenced by this incident.
  CORRECTION ON THE RECORD (2): the 09-23 02:12:58 "unparseable level comment ''" WARN on
    2942227144 is NOT K-4. No slice ever touched the position. Its comment was blanked on
    09-21 00:06:33 by the orphan-rebuild path ("replaced user-set TP"); it entered the
    sequence via b39/F-2 orphan adoption with no _lN_ tag to begin with. K-4 IS NOT
    IMPLICATED by this log.
  NO MONEY WAS LOST: X-3/O7 handled the failed slice correctly - realized was pure profit.
    But Tier 3 slice is defeated whenever this race occurs, and the log actively misnames
    the cause.

THE UNIFYING DEFECT (three incidents, one mechanism): the EA reads terminal state, gets a
  wrong answer, and reports a CONFIDENT SPECIFIC CAUSE IT NEVER VERIFIED.
    2026-08-19  frozen quote, ok=Y            -> "spread pushes entry inside the interval"
    2026-09-18  empty position list at init   -> "closed while EA was offline" (wiped L1)
    2026-09-22  PositionSelectByTicket false  -> "retcode 10009: done" (stale, prior order)
  E9 items Q1..Q4 are this family. They are NOT delivered as one build - see E9-Q3-D1.

LOCKED DECISION E9-Q3-D1 (retcode validity, Jeff call 2026-09-24): OPTION B - RE-DERIVE
  THE PRECONDITION AT THE CALL SITE, PLUS AN INIT-TIME MARGIN-MODE CHECK.
  THE RULE: g_trade.Result*() is meaningful ONLY when CTrade actually reached OrderSend.
  Before a close/slice/modify call the EA tests the same precondition CTrade will test
  (PositionSelectByTicket); if it fails, log "no order sent" and NEVER read the retcode.
  Only when the precondition held is ResultRetcode() treated as real.
  EXPOSURE MAP (verified against Trade.mqh, NOT assumed - the K-4 lesson):
    1511 CloseLegAtMarket  PositionClose        EXPOSED via !PositionSelectByTicket
    1565 SliceLegAtMarket  PositionClosePartial EXPOSED via !IsHedging AND !PositionSelect
    1893 exits loop        PositionModify       EXPOSED via !PositionSelectByTicket
    3650 L1 button         PositionOpen         CLEAN - ClearStructures() runs FIRST
    3753 pending orders    BuyLimit/SellStop/.. CLEAN - volume guard writes; OrderOpen clears
  THREE sites are exposed, not five. The entry paths were never lying.
  WHY THIS MATTERS MOST - THE 10036 SILENT PATH: the benign-race checks at 1512 and 1567
  return TRUE ("already closed, benign") on a possibly-STALE 10036. A stale 10036 left in
  m_result by an earlier genuine race would make a REAL close failure report success, and
  the EA would believe a position closed when it had not. Under B those checks are only
  reachable when the precondition held, converting a latent silent path into a correct one.
  This is the strongest argument for the build and it is a section 7 silent-path defect.
  REJECTED (A) clear m_result before each call: NOT AVAILABLE. ClearStructures() is
    protected and CTrade exposes NO public method that zeroes m_result without sending an
    order. Verified in Trade.mqh before proposing - recorded so it is not re-proposed.
  REJECTED (C) track ResultDeal/ResultOrder across the call and treat "unchanged" as stale:
    does not discriminate. ClearStructures() zeroes m_result on the paths that DO reach it,
    so a genuine post-clear failure also shows deal 0 - indistinguishable from a stale zero,
    and the test inverts depending on which path fired.
  REJECTED (D) never print a retcode on a false return: honest and one line, but discards
    the retcodes that ARE valid and useful (10030 invalid fill, 10027 autotrading off).
    b27 already proved a wrong/absent hint costs a real investigation (the fixed "broker min
    distance" suffix printed on a 10027). D trades a known-good diagnostic for safety we get
    from B anyway.
  MARGIN-MODE CHECK: read ACCOUNT_MARGIN_MODE once at init and log it. Two lines. Removes
    !IsHedging as an unknown permanently and settles the netting question for every future
    session. It is a PROBE, not a guard - E9-O4 netting GUARD stays parked and out of scope.
  EXPLICITLY OUT OF SCOPE (flagged per CLAUDE.md section 7, not folded in): Q2 reconcile fix,
    Q4 slice-race retry policy, E9-O4 netting guard behaviour, Q1 stale-quote guard.
  NO MONEY-PATH LOGIC CHANGES. The EA refuses in exactly the cases it already refuses; what
  changes is the reason text and the trustworthiness of the 10036 branches.

## b42 BUILT 2026-09-24 - E9-Q3 RETCODE VALIDITY. GATE ZERO NOT RUN, NOT DEPLOYED.
IDENTITY: 9209dbe131c9d651 / 5112 lines (+49 from b41's 5063).
GATES CLEARED SO FAR: Gate 1 (E9-Q3-D1 locked 2026-09-24), Gate 2 (docs/Q3_MATRIX.md
  SEALED rev 1 2026-09-24), Gate 3 (docs/Q3_PLAN_2026-09-24_gate3.md CONFIRMED by Jeff).
  NEXT: Gate Zero (Jeff compiles), then Gate 4 verification, then seal on Jeff's word.

THE SIX TOUCH POINTS AS BUILT:
  TP1  1521  NEW HELPER TradeTargetLive(ticket) - returns PositionSelectByTicket. The one
             named place that answers "will CTrade be able to act on this ticket?". Placed
             above all three callers (1536/1596/1935) per the helper-before-caller rule.
  TP2  1536  CloseLegAtMarket - gate before PositionClose. Returns FALSE (unchanged
             disposition), so FireGroupClose's X-2 abort still sees false (B-3).
  TP3  1596  SliceLegAtMarket - gate before PositionClosePartial. THE 2026-09-22 SITE.
             Returns FALSE; the O7 caller's X-3/O7 accept-and-log is untouched (that is Q4).
  TP4  1935  Exits loop - gate before PositionModify. THE MATRIX'S CRITICAL FINDING: the
             loop's own select at 1862 is STALE by the modify call (two PositionGetDouble
             reads, the tolerance compare, HasAppliedExits and up to two Log() calls sit
             between them, and CTrade re-selects internally at Trade.mqh 370).
             D-3 AS BUILT: a no-send sets anyApplied=false and continues, but does NOT
             increment g_modifyFails and does NOT arm the >=10 Alert.
  TP5  1140  LogBrokerExitGeometry - ACCOUNT_MARGIN_MODE probe. Placed here because this
             function is ALREADY called on BOTH init paths (config-blocked 4900, normal
             4924), so the probe inherits both with no new call site.
  TP6  51    TRTM_BUILD "b41" -> "b42". THE ONLY DELETION IN THE ENTIRE DIFF.

VERIFIED AGAINST THE MT5 INCLUDE TREE BEFORE AND AFTER THE BUILD (the K-4 lesson):
  ACCOUNT_MARGIN_MODE_RETAIL_HEDGING / _RETAIL_NETTING / ACCOUNT_MARGIN_MODE_EXCHANGE all
  exist - confirmed in Include/Trade/AccountInfo.mqh 159-165 and Include/Expert/
  ExpertBase.mqh 135/141. AccountInfoInteger(ACCOUNT_MARGIN_MODE) cast to the enum is the
  canonical accessor and is exactly what CTrade itself uses (Trade.mqh 95 SetMarginMode).
  NOTHING IN THIS BUILD WAS PLANNED AGAINST AN UNVERIFIED SIGNATURE.

DIFF DISCIPLINE: `git diff -U0` filtered to non-comment lines shows ONLY the six touch
  points. Exactly ONE deletion in the whole file (the build tag). Every other change is a
  pure INSERTION - no existing statement was altered, which is what A-4 and D-5 require.

HYGIENE (recomputed on the built file, not assumed):
  5112 lines, 5112 CRLF pairs, 0 bare LF, 0 non-ASCII bytes.
  brace delta -1 - IDENTICAL to b41's baseline (a brace inside a string literal, documented
  in .claude/rules/mql5-traps.md). paren delta 0, bracket delta 0.

LINE-DELTA NOTE, ON THE RECORD: the Gate 3 plan estimated +39 and the build is +49. The
  10-line difference is ALL comment, at TP4, where the D-3 rationale was written into the
  source rather than left only in the plan. No unplanned code was added. Recorded because an
  unexplained delta overrun is exactly the kind of thing a later reader should be able to
  settle without re-deriving it.

OBSERVATION WORTH CARRYING (not acted on, scope): .claude/rules/mql5-traps.md says "all
  position selection goes through the existing wrapper" (the POSITION_IDENTIFIER trap). NO
  SUCH WRAPPER EXISTS - the codebase calls PositionSelectByTicket directly in 39 places.
  The rule describes an aspiration, not the code. TradeTargetLive is now the closest thing
  to that wrapper; if the POSITION_IDENTIFIER trap ever bites, it is the single place to fix
  it. NOT widened in b42 - that would be scope drift on a verification build.

WHAT b42 DOES NOT CHANGE (the UNCHANGED list, as built):
  - PositionOpen path 3650 and the pending-order path 3753 + its b27 retcode-hint ladder.
    VERIFIED CLEAN (ClearStructures runs first). Zero edits. D-1/D-2.
  - All Tier 1/2/3 arithmetic, FormBasketGroup, EvaluateBasketClose. D-5.
  - The MarkEAClosed asymmetry (CloseLegAtMarket marks, SliceLegAtMarket does not). A-5/A-6.
  - The 10036 branches' text and disposition - unchanged, but now UNREACHABLE on a no-send,
    which is the single behavioural delta in the build and the reason it exists. B-1/B-2.
  - Reconcile / StateLoad / StateSave / schema 5 (Q2). EvaluateRecovery and every quote read
    (Q1). RebuildLiveMap / O2b / BuildLevelTag / ParseTag (K-4).

THE ONE BEHAVIOURAL DELTA, STATED PLAINLY: a STALE 10036 can no longer fake a successful
  close. Before b42, a 10036 left in m_result by an EARLIER genuine race could make a REAL
  close failure return TRUE - for CloseLegAtMarket that return feeds FireGroupClose's X-2
  abort, so a tier could proceed to the anchor believing a profitable leg was banked. It can
  only turn a wrong TRUE into a correct FALSE, never the reverse. CLAUDE.md section 7 silent
  path, reachable today, never observed firing.

STILL OPEN ON b42:
  GATE ZERO - Jeff compiles. I cannot compile MQL5.
  QQ1 - A-1 needs a ticket selectable to the caller and NOT to CTrade, which cannot be
    summoned on demand. Plan section 6 carries option (b): a temporary probe calling
    CloseLegAtMarket on a known-closed ticket, expect the TP2 no-send WARN and NO retcode
    token, then revert to byte-identical b42 with an EMPTY git diff (the 2026-08-19 quote-
    probe pattern). Jeff confirmed the plan; he has NOT separately confirmed (b) over (a).
  VERIFICATION - Groups A/B close on inspection + a live run; C-1/C-2 on the init line;
    C-3/C-4 and all of D on inspection + filtered diff.
  WATCH ITEM FOR THE RUN: an elevated count of "NO ORDER SENT" lines would mean the race is
    more common than the single 09-22 observation suggests. That is information E9-Q4 needs,
    and it is a reason to run b42 for a while before opening Q4.

## b42 GATE ZERO PASSED 2026-09-24 - GROUP C CLOSED ON EVIDENCE
COMPILE: clean. INIT EVIDENCE - USDCAD.s H1, symbol USDCADS, magic 708972, 08:48:14:
  "=== TRTM b42 init ===" / "Instance lock acquired" / "State persistence self-test: PASS"
  / "Reconcile complete: FLAT" / "Account margin mode: HEDGING" / broker geometry / "Init
  complete - b42 (adoption, exits, recovery active)".

GROUP C DISPOSITION (the margin-mode probe):
  C-1 PASS - "Account margin mode: HEDGING" logged ONCE at init, in plain words, in the
      planned position (head of LogBrokerExitGeometry, immediately before the broker
      geometry line). Both init paths inherit it because that function is already called
      on both (4900 config-blocked, 4924 normal) - no new call site, as planned.
  C-2 PASS, ON STRONGER EVIDENCE THAN THE ROW ASKED FOR. The row expected confirmation on
      AUDNZDS 709170; this came from USDCADS 708972 - a DIFFERENT symbol and magic. That
      is better evidence, not weaker: it shows the HEDGING reading is not an artifact of
      one symbol's state.
      IT ALSO INDEPENDENTLY CLOSES THE MATRIX ELIMINATION. !IsHedging() was one of the two
      surviving no-write candidates for the 2026-09-22 line. The terminal now states
      HEDGING outright, so that branch CANNOT fire, leaving !PositionSelectByTicket as the
      sole explanation - exactly what the matrix argued from ticket coexistence. TWO
      INDEPENDENT ROUTES, SAME ANSWER. The root cause in E9-Q3-D1 is now doubly evidenced.
  C-3 CLOSED ON INSPECTION (must-NOT: the probe changes no behaviour). mmName is logged
      and stored in NO variable any decision reads; filtered diff confirms the only other
      changes are the three gates and the build tag.
  C-4 PASS - one line, once per init, no per-tick cost.

INCIDENTAL, NOT A Q3 FINDING, BUT ON THE RECORD: the same init logged
  "AutoTrading is OFF (toolbar Algo Trading button) - every entry, pending, and exit write
   will be rejected with 10027 until it is enabled".
  That is b27 guidance working correctly, but it means THIS INSTANCE CANNOT TRADE until the
  toolbar button is enabled. Harmless for a compile/init smoke test; blocking for any
  verification run. Named here so a later reader does not mistake it for a b42 defect.

ORDERING NOTE: the margin-mode line prints BEFORE the AutoTrading warning, because the probe
  sits at the head of LogBrokerExitGeometry. Both correct; cosmetic, recorded not churned.

STILL OPEN ON b42 - GROUPS A, B, D (the verification run):
  A-1 no-send logs "NO ORDER SENT" and prints NO retcode. THE ROW THE 09-22 INCIDENT
      FAILED. Needs a ticket selectable to the caller and not to CTrade -> QQ1 probe, or
      the free route below.
  A-2 a genuine broker rejection still prints its OWN true retcode (proves B is not D).
  A-3 gate adjacent to the call at all three sites - inspection, done at build.
  A-4/A-5/A-6 must-NOTs - inspection + filtered diff, done at build.
  B-1 10036 unreachable on a no-send path - inspection.
  B-2 a GENUINE 10036 race still returns true and logs INFO (discriminator, not suppression).
  B-3 CloseLegAtMarket's false still drives FireGroupClose's X-2 abort.
  D-1..D-6 regression - inspection + filtered diff + hygiene, done at build.
  FREE A-1 ROUTE WORTH WATCHING FOR FIRST: manually close a TRACKED level while the EA is
  running. CheckSequenceLiveness may not have pruned it yet, so EnforceExits can reach
  TP4's gate on REAL code with no probe build at all. Not guaranteed (it is a race), but it
  costs nothing to watch for during the normal run, and it closes A-1 with zero probe risk.

## b42 A-1 CLOSED ON LIVE EVIDENCE 2026-09-24 (probe built, run, REVERTED same day)
QQ1 OPTION (b) EXECUTED. Probe build 13aa1a504ce1d59b / 5125 lines - THREE lines added to
OnInit calling the REAL CloseLegAtMarket on ticket 2963521986 (the L9 closed 2026-09-22 on
AUDNZDS). No other change. NOT deployed to any live-trading purpose; init only.

EVIDENCE - USDCAD.s H1, symbol USDCADS, magic 708972, 2026.09.24 10:12:46.711, VERBATIM:
  "*** A-1 PROBE (TEMPORARY DIAGNOSTIC) - calling CloseLegAtMarket on a known-closed
   ticket. No order is sent. ***"
  "Market close on ticket 2963521986: NO ORDER SENT - position not selectable at the close
   call (it vanished between the caller's check and this one). No retcode is available;
   the previous order's is NOT this call's."
  "*** A-1 PROBE END - the line above must say NO ORDER SENT and carry no retcode. ***"

A-1 PASS - EVERY ACCEPTANCE CRITERION, CHECKED INDIVIDUALLY:
  (1) the line APPEARS, between the two probe markers, same millisecond 10:12:46.711;
  (2) it says NO ORDER SENT verbatim;
  (3) *** IT CARRIES NO RETCODE TOKEN *** - this is the ABSENCE the row is about, and the
      absence was checked explicitly, not assumed. No "retcode", no number, anywhere;
  (4) the ticket renders correctly through %I64u as 2963521986 (a runtime format defect
      would have compiled clean and shown garbage here - that is WHY inspection alone was
      rejected for this row);
  (5) the gate returned BEFORE any CTrade call - nothing was sent, no broker contact;
  (6) logged at WARN, as every refusal path must be.
  UNDER b41 THIS IDENTICAL CALL WOULD HAVE PRINTED "Market close FAILED ... (retcode NNNNN:
  ...)" carrying a number belonging to some EARLIER order. That is the whole defect, and
  this line is the proof it is fixed.
  INCIDENTAL CORROBORATION: "Reconcile complete: FLAT" logged immediately before, so the
  probe ran against a genuinely absent position - no ambiguity about why the select failed.

REVERT PROVEN BYTE-EXACT, SAME SESSION:
  sha256_16 9209dbe131c9d651 / 5112 lines - IDENTICAL to the pre-probe b42.
  `grep -ci` for "temporary diagnostic" / "remove before any seal" / "A-1 PROBE" returns 0.
  NOTE ON METHOD: the revert is proven by the SHA, NOT by an empty `git diff` - b42 is
  uncommitted, so git diff compares against b41 and would be misleading here. The
  2026-08-19 quote-probe precedent used git diff because that build WAS committed.

THE THREE-LAYER PROBE GUARD IS NOW PROVEN END TO END, NOT JUST DESIGNED:
  The check_hygiene hook REFUSED the probe build (exit 2) naming both markers and pointing
  at this banner; the override was deliberate and recorded; the banner was flipped to
  PROBE IN TREE for the duration; the hook PASSES (exit 0) on the reverted file. The wall
  caught a REAL probe, not only the synthetic fixture it was tested against.
  HONEST NOTE ON THE TESTING: the first attempt to test the hook reported a FALSE PASS -
  the harness fed invalid JSON (printf backslash escaping), the hook's parse failed, the
  file path came back empty and it exited 0 early. That was the TEST HARNESS, not the hook.
  Retested by feeding real JSON from a file, both directions. Recorded because a wall that
  silently does not fire is precisely the failure being guarded against, and it nearly
  passed unnoticed.

CORRECTION ON THE RECORD: earlier this session a "free A-1 route" was suggested - manually
  closing a tracked level so TP4's gate would fire on real code with no probe. THAT DOES
  NOT WORK and was withdrawn before any time was spent on it. CheckSequenceLiveness runs at
  OnTick 5062, BEFORE EnforceExits at 5069, in the SAME tick: a manually closed ticket is
  pruned from g_state and never reaches the modify gate. It produces "Liveness: ... closed
  externally", not "NO ORDER SENT". A-1 was therefore strictly a probe row, as QQ1 assumed.

b42 DISPOSITION AFTER THIS:
  CLOSED: A-1 (live), A-3/A-4/A-5/A-6 (inspection + filtered diff, at build),
          B-1/B-3 (inspection), C-1/C-2/C-4 (Gate Zero init), C-3 (inspection),
          D-1/D-2/D-5/D-6 (inspection + filtered diff + hygiene).
  STILL OPEN, both needing ORDINARY running rather than a staged test:
    A-2  a GENUINE broker rejection still prints its OWN true retcode. This broker throws
         10018 (market closed) at rollover - it will present itself.
    B-2  a GENUINE 10036 race still returns true and logs INFO (discriminator, not blanket
         suppression).
  NEITHER needs a special run. Deploy b42 and they close from normal operation.
  WATCH ITEM: an elevated count of "NO ORDER SENT" lines would mean the race is more common
  than the single 2026-09-22 observation suggests - information E9-Q4 needs.

## b42 GATE ZERO PASSED ON GENUINELY CLEAN b42 - 2026-10-02 13:14:52
XAUUSD.s H4, symbol XAUUSDS, magic 715358. Compiled by Jeff from the LIVE runtime path.
EVIDENCE: "=== TRTM b42 init ===" / lock acquired / self-test PASS / "Reconcile complete:
FLAT" / "Account margin mode: HEDGING" / stops level 50 pts / "Init complete - b42".
TWO ABSENCES CARRY THE PROOF, and both were PRESENT 5 minutes earlier at 13:09:14:
  (1) NO "A-1 PROBE" lines -> the probe is gone from the compiled binary;
  (2) NO AutoTrading-OFF WARN -> AutoTrading is ON for this run.
RUNTIME VERIFIED BYTE-IDENTICAL AFTER THE RECOMPILE: the FA_EA copy hashes
  9209dbe131c9d651 / 5112 - the same as the repo - with 0 probe markers, .ex5 stamped
  13:14. Repo and the REAL runtime are aligned on clean b42 for the first time.
C-1 / C-2 re-confirmed on a THIRD instance (XAUUSDS 715358, after USDCADS 708972 and the
  AUDNZDS deduction). HEDGING on every account tested.

## *** THE PROBE THAT ALMOST SHIPPED - 2026-10-02. READ THIS. ***
WHAT HAPPENED: at 13:09:14 an init logged all three A-1 PROBE lines under build b42, eight
days after the probe was supposedly reverted. The repo was clean the whole time
(9209dbe131c9d651, 0 markers - verified). The probe survived in a copy nobody was watching.
ROOT CAUSE: A SECOND TERMINAL. Jeff compiles and runs from
  Terminal\55DBD2FC8CD1E66E27FFA0EC4DDFAAEB\MQL5\Experts\FA_EA\TRTM.mq5
but CLAUDE.md section 0 named
  Terminal\D0E8209F77C8CF37AD8BF550E51FF075\MQL5\Experts\TRTM.mq5
as "the MT5 runtime copy". That second file is b41 from Aug 19 and is NOT what runs. On
2026-09-24 the probe source was copied into the FA_EA folder and compiled there; the repo
revert never touched it, and today's F7 recompiled the probe.
CONSEQUENCE FOR THE RESUME PROTOCOL: every alignment check this session hashed a file
nobody uses and reported "runtime b41, expected" - technically true of that copy, and
completely blind to the live one. CLAUDE.md section 0 CORRECTED 2026-10-02: the live path
is named, both stale copies are named as stale, and the protocol now ALSO greps the runtime
copy for the probe markers. A 4th terminal appearing means ASK, never guess.

WHY THE THREE-LAYER PROBE GUARD DID NOT CATCH IT - STATED PLAINLY, NOT EXCUSED:
  The check_hygiene hook fires only on writes Claude makes, inside the repo. The STATE.md
  banner and the section 0 step both describe the REPO. None of the three layers could see
  a copy in a terminal tree Claude did not know existed - and the MT5 boundary (correctly)
  forbids Claude writing there, so Claude could not have cleaned it either.
  THE GUARD IS NOT BROKEN. ITS SCOPE WAS NARROWER THAN CLAIMED. The claim on 2026-09-24
  that this "cannot be forgotten" was OVERSTATED and is withdrawn. What is true: the guard
  covers the repo completely, and as of today the resume protocol covers the live runtime too.
  The 13:09:14 init is what caught this - the EA's own logging, not the guard.
LESSON FOR THE LEDGER: a revert is only as wide as the set of copies you know about. Hash
  the file that RUNS, and grep it for probe markers, not just the one a doc names.

STILL OPEN - A-2 and B-2 (Gate 4 completion). UNCHANGED by today:
  A-2  a GENUINE broker rejection under b42 prints its OWN true retcode. The b41 run on
       2026-09-28 10:16 produced exactly this shape on XAUUSDS (ten consecutive
       "PositionModify FAILED ... retcode 10027: auto trading disabled by client - fail #N"),
       which proves the path is alive and correct on this broker - but it was b41, so it
       does NOT close the row. Easiest deliberate trigger under b42: with a sequence live,
       toggle AutoTrading OFF ~10s, let it fail a few times, toggle back ON (expect the
       fail ladder then "Exit modification recovered after N failure(s)").
  B-2  a GENUINE 10036 race still returns true and logs INFO "broker exit filled first".
       Cannot be summoned; needs a broker TP/SL fill in the same instant as an EA close.
       Standing recommendation: close on inspection if no natural race appears before seal
       (text and disposition provably unchanged by filtered diff; the branch is now only
       REACHABLE when the precondition held). The b41 matrix closed A-6 the same way.

## b42 A-2 + D-3 CLOSED ON LIVE EVIDENCE 2026-10-02
EVIDENCE FILE: tests/2026.10.02 132150.229.txt - XAUUSD.s M5, symbol XAUUSDS, magic 715358,
ticket 887205930, 1 level / 0.01 lots, InpStopLossPts = 0 (no SL this sequence, deliberate).
METHOD: AutoTrading disabled 13:21:54, TP edited (ADOPTED 4192.44), then TP DELETED at
13:26:04 to force a modify, AutoTrading re-enabled 13:26:19.440.

A-2 PASS - a GENUINE broker rejection prints its OWN true retcode. VERBATIM, x4:
  "CTrade::OrderSend: modify position #887205930 XAUUSD.s (sl: 0.00, tp: 4192.44)
   [auto trading disabled by client]"
  "PositionModify FAILED on ticket 887205930 (retcode 10027: auto trading disabled by
   client) - fail #1, retrying in 5s"
  BETTER EVIDENCE THAN THE ROW ASKED FOR: CTrade's OWN OrderSend line is interleaved, so the
  send is PROVEN to have reached OrderSend rather than inferred. 10027 is therefore this
  call's own retcode by construction - it cannot be a stale value from a prior order,
  because this call wrote m_result itself.
  THIS IS THE ROW THAT PROVES B IS NOT D: b42 preserves useful retcodes instead of
  discarding them. The 10027 and its description survive the build unchanged.

D-3 PASS (the Gate-3 working assumption, now evidenced not assumed):
  fail #1 -> #2 -> #3 -> #4, MONOTONIC, exactly ONE increment per genuine broker rejection.
  No skips, no double counts, nothing polluted the counter.
  "Exit modification recovered after 4 failure(s)" at 13:26:24.189 - the counter read
  EXACTLY 4, matching the four rejections. The >= 10 Alert correctly never armed.
  => g_modifyFails still means "the BROKER rejected us", which is what D-3 protects.

BACKOFF PROVEN BY TIMESTAMPS (recomputed here):
  13:26:04.480 -> 08.990 = 4.510s
  13:26:08.990 -> 13.991 = 5.001s
  13:26:13.991 -> 18.983 = 4.992s
  g_nextModifyTry = TimeCurrent() + 5 holding at ~5s per pass, as sealed.

RECOVERY SEQUENCE CORRECT, AND IT PROVES b24 OWNERSHIP SURVIVED:
  AutoTrading enabled 13:26:19.440 -> next pass 13:26:23.980 logs the removal WARN once more
  -> "Exits applied to ticket 887205930: TP 4192.44 SL none" at .189.
  THE RESTORED VALUE IS 4192.44 (the ADOPTED MANUAL TP), NOT the computed 4191.17. Manual
  ownership survived four failed passes AND the recovery. b24's contract is intact under b42.

WHY THE FIRST TWO ATTEMPTS PRODUCED NO LADDER - RECORDED SO IT IS NOT RE-DERIVED:
  (1) AutoTrading off with a STEADY-STATE sequence logs NOTHING. EnforceExits is idempotent
      (1871): broker already holds the wanted TP and wants no SL, so PositionModify is never
      called, so there is no rejection to report. That is D-4 working, and it is why b42 adds
      zero modify traffic.
  (2) EDITING the TP to a new non-zero value does NOT force a modify either - the b24 Stage 8
      classifier ADOPTS it ("Manual TP 4192.44 ADOPTED (was 4191.17)"), so want == broker and
      idempotence short-circuits again. Adoption is the DESIGNED behaviour for a non-zero edit.
  (3) Only a REMOVAL forces the modify: wantTP = (tp > 0 && placeable) ? tp : curTP (1902),
      so curTP = 0 != wantTP, idempotence fails, PositionModify fires. Removals are never
      adopted (1920). THE LEVER FOR ANY FUTURE RETCODE TEST IS A TP DELETION, NOT AN EDIT.

ACCEPTED COSMETIC, RECORDED NOT FIXED (CLAUDE.md section 4 / mql5-traps observability rule):
  the "Manual TP REMOVAL ... reverted to 4192.44" WARN repeats on EVERY retry pass (5x here).
  Each instance is TRUTHFUL - the broker genuinely still shows TP 0 because every revert
  failed - but it is noise during a failure episode. Not churned into a verification build.
  Candidate for a one-shot-per-episode throttle in a later build if it ever annoys.

ENVIRONMENT NOTE: a second EA (TradingToolkit TK-B001) is attached to the same chart. It does
  not share TRTM's magic so it cannot affect tracking, but it is the first other candidate if
  an unexplained position change ever appears on XAUUSD.s.

b42 DISPOSITION NOW - ONE ROW LEFT:
  CLOSED ON LIVE EVIDENCE: A-1 (09-24 probe), A-2 + D-3 (today), C-1/C-2/C-4 (Gate Zero).
  CLOSED ON INSPECTION + FILTERED DIFF: A-3, A-4, A-5, A-6, B-1, B-3, C-3, D-1, D-2, D-4
    (D-4 also corroborated live today - the silent steady-state passes), D-5, D-6.
  STILL OPEN: B-2 only - a GENUINE 10036 race still returns true and logs INFO "broker exit
    filled first". Cannot be summoned; needs a broker TP/SL fill in the same instant as an EA
    close. STANDING RECOMMENDATION: close on inspection if no natural race appears before
    seal (text and disposition provably unchanged by filtered diff, and the branch is now
    only REACHABLE when the precondition held - which is the B-1 improvement). The b41 matrix
    closed A-6 the same way and recorded it honestly as inspection-closed.

## b42 B-2 CLOSED ON INSPECTION 2026-10-02 (Jeff's call) - RECORDED HONESTLY AS SUCH
B-2 asks: a GENUINE 10036 benign race still returns true and logs INFO, i.e. the fix is a
discriminator and not a blanket suppression. It is a MUST-NOT row - it proves b42 did not
BREAK a working path - and it cannot be summoned (it needs a broker TP/SL fill in the same
instant as an EA close). Jeff elected inspection closure rather than waiting indefinitely.

THE TWO THINGS INSPECTION HAD TO PROVE, AND THE PROOF:

(1) THE 10036 BRANCHES ARE UNCHANGED. Verified by DIFF against the committed b41, not by
    reading: `diff` of every line matching "ResultRetcode() == 10036 | broker exit filled
    first | benign race" between `git show HEAD:src/TRTM.mq5` (b41) and the b42 working file
    produced NO OUTPUT. BYTE-IDENTICAL at both sites (CloseLegAtMarket 1543-1546,
    SliceLegAtMarket 1603-1606). The test, the INFO text and the `return true` are the sealed
    b20 behaviour, untouched.

(2) A NO-SEND CANNOT REACH THEM. Structural, by line order in CloseLegAtMarket:
      1536  if(!TradeTargetLive(ticket))
      1539     return false;            <- no-send exits HERE
      1541  if(!g_trade.PositionClose(ticket))
      1543     if(ResultRetcode() == 10036)   <- unreachable from a no-send
    Same shape at the slice site. So the ONLY way to reach the benign-race branch is a real
    OrderSend that the broker answered 10036 - which is exactly what B-2 asserts must still
    work, and exactly what B-1 improved (a STALE 10036 can no longer fake a successful close).

WHY INSPECTION IS SUFFICIENT HERE AND WAS NOT FOR A-1 - the distinction matters:
  A-1 was a NEW log line with a NEW StringFormat and a %I64u. A malformed format string
  compiles clean and produces garbage at RUNTIME; Gate Zero would not catch it. That residual
  risk is why A-1 got a probe build and live evidence.
  B-2 is the OPPOSITE: no new code at all. The claim is "this existing, sealed, previously
  exercised branch is unchanged and still reachable only by the real thing" - and a diff plus
  line order answers that completely. There is no runtime-only failure mode left to hide.

RESIDUAL, STATED PLAINLY: no b42 run has yet OBSERVED a genuine 10036. If one occurs it
  should log "broker exit filled first (10036) - benign race, liveness attributes it" at INFO
  and the caller should treat the leg as closed. If it ever logs anything else, that is a
  FINDING against this closure and B-2 reopens. Worth watching for, not worth blocking on.

## *** b42 SEALED BY JEFF 2026-10-02 *** E9-Q3 RETCODE VALIDITY. GATE 6 CLOSED.
IDENTITY: 9209dbe131c9d651 / 5112 lines. Repo, manifest and LIVE runtime all aligned.
ALL SIX GATES CLEARED IN ORDER:
  Gate 1  E9-Q3-D1 locked 2026-09-24 (Option B + init margin-mode probe), rejected
          alternatives A/C/D recorded with reasons.
  Gate 2  docs/Q3_MATRIX.md SEALED rev 1 2026-09-24. 18 rows, 12 of them must-NOT.
  Gate 3  docs/Q3_PLAN_2026-09-24_gate3.md CONFIRMED. Six touch points.
  Gate 0  PASSED twice - 2026-09-24 08:48 (USDCADS) and, on GENUINELY clean b42 after the
          probe incident, 2026-10-02 13:14:52 (XAUUSDS).
  Gate 4  COMPLETE. Live: A-1, A-2, D-3, C-1, C-2, C-4. Inspection + filtered diff: A-3,
          A-4, A-5, A-6, B-1, B-2, B-3, C-3, D-1, D-2, D-4, D-5, D-6.
  Gate 6  SEALED on Jeff's explicit word 2026-10-02.
DELTA: +49 lines (5063 -> 5112). NO new input, NO new global, NO new persisted field, state
  schema UNCHANGED at 5. Exactly ONE deletion in the whole diff: the build tag.
HYGIENE: 5112 CRLF pairs, 0 bare LF, 0 non-ASCII, brace delta -1 (baseline-preserved),
  paren 0, bracket 0.

WHAT b42 ACTUALLY CHANGES, IN ONE LINE: g_trade.Result*() is now read ONLY when CTrade
  actually reached OrderSend. Three sites gated (CloseLegAtMarket, SliceLegAtMarket, the
  exits-loop modify). A no-send says "NO ORDER SENT" and prints NO retcode.
THE ONE BEHAVIOURAL DELTA: a STALE 10036 can no longer fake a successful close. Before b42 a
  10036 left in m_result by an earlier race could make a REAL close failure return TRUE - and
  for CloseLegAtMarket that return feeds FireGroupClose's X-2 abort, so a tier could proceed
  to the anchor believing a profitable leg was banked. It can only turn a wrong TRUE into a
  correct FALSE, never the reverse. CLAUDE.md section 7 silent path, closed.

ROOT CAUSE THIS BUILD FIXED (for the cold reader): on 2026-09-22 09:25:18 a Tier 3 slice that
  NEVER SENT logged "Partial close FAILED ... (retcode 10009: done)". 10009 is DONE - success.
  It was the retcode of the PRECEDING successful L8 close, still sitting in m_result because
  CTrade's PositionClosePartial returns false at !PositionSelectByTicket BEFORE its own
  ClearStructures(). The arithmetic proved the slice never happened: 0.56 - 0.08 - 0.09 = 0.39
  and the log read 0.39, not the 0.37 a completed slice would have left.

PRIOR SEALED BUILD: b41 (d2354c4c1269874e / 5063, 2026-08-19).
E9 REMAINS OPEN with: Q1 stale-quote guard, Q2 false-flat reconcile (a REAL unmanaged-position
  defect, evidenced 2026-09-18), Q4 slice-selection race (why the anchor became unselectable -
  b42 NAMES the event, it does not explain or retry it), K-4 + O6, M4, M2, O3, O4, O5, O2e,
  W-7, P6. See the live-findings block for Q2/Q4 provenance.

## LOCKED DECISION E9-Q2-D1 (record management, Jeff's call 2026-10-02): DIRECTIONAL RECORD
## MANAGEMENT INSIDE THE EXISTING STATE FILE. Jeff's own design, refined against the code.

THE RULE, IN JEFF'S WORDS: deletion goes MT5 -> file; reconciliation goes file -> MT5.
  A ticket leaves the record ONLY when MT5 affirmatively states it is gone.
  A ticket is restored by proposing it FROM the file and having MT5 CONFIRM it by ticket.
WHY THAT ASYMMETRY IS THE WHOLE FIX: the 2026-09-18 failure went file -> "broker is flat"
  and then DELETED. That is deletion driven by an ABSENCE. Under this rule an absence can
  never delete anything.

MECHANISM. At init, for each ticket the file claims, reconcile asks TWO INDEPENDENT questions:
    (1) PositionSelectByTicket  - is it in the position list?
    (2) HistorySelectByPosition - does it have a CLOSING DEAL?
  select OK              -> ALIVE   -> restore to the sequence
  select FAIL + deal     -> CLOSED  -> delete from the record, log the reason (TP/SL/SO/manual)
  select FAIL + NO deal  -> UNKNOWN -> KEEP THE RECORD, WRITE NOTHING, one-shot WARN
  The third row IS 2026-09-18. THE KEY TECHNICAL FACT: HistorySelectByPosition is a DIFFERENT
  DATA SOURCE from PositionsTotal() and they fail INDEPENDENTLY. An unpopulated position cache
  says NOTHING about history. History is therefore the affirmative evidence that separates
  "closed" from "I cannot see it yet" - the distinction the EA collapsed on 09-18.

THE 90-DAY UNKNOWN EXPIRY (Jeff's call): an UNKNOWN record is deleted once it is older than
  90 days, AGED FROM THE FILE'S EXISTING lastSaved FIELD - NO new per-ticket timestamp, NO
  schema bump, schema STAYS AT 5.
  WHY lastSaved IS THE RIGHT CLOCK: it refreshes on every write, so a record holding a LIVE
  sequence never ages - correct, nothing should expire while the EA is actively managing it.
  A record untouched for 90 days is STRANDED by definition, which is exactly the case the
  expiry exists to clean.
  ACCEPTED BEHAVIOUR DIFFERENCE, ON THE RECORD: if a sequence has live tickets AND an UNKNOWN
  one, the UNKNOWN never ages out because the live siblings keep the file fresh. Jeff and I
  agree this is DESIRABLE, not a shortcut - an unknown ticket alongside live siblings is the
  case most deserving of a standing WARN rather than silent deletion.

SCOPE IS ONE SITE. All StateReset/StateSave sites were enumerated and classified:
    744  AdoptPosition      - builds a record after an adoption.      SAFE, untouched.
    991  CheckSequenceLiveness - per-ticket, MT5 -> file, already uses ClosingDealReason.
         SAFE, untouched - AND IT IS THE MODEL FOR THIS FIX. It has never misfired.
    3463 RegisterButtonL1   - builds a record after a registration.   SAFE, untouched.
    3060 Reconcile flat branch - StateReset + StateSave on live.levelCount == 0 at init.
         *** THIS IS THE DEFECT. ONE LINE IS THE WHOLE BUG. ***

FIXES: E9-Q2 completely. E9-M4's OVERWRITE case completely.
DOES NOT FIX - A DOCUMENTED DESIGN LIMIT, NOT A GAP: E9-M4's true file-LOSS case. If the
  state file is deleted, or the terminal/data folder changes, a magic-0 adopted position has
  NO magic (invisible to RebuildLiveMap), NO reliable tag (see the C rejection), and NO
  record. IT IS UNRECOVERABLE IN CODE. This is to be DOCUMENTED, never pretended away.
  CORRECTION ON THE RECORD: an earlier framing this session called Q2 and M4 "the same defect
  at different widths". WRONG. Q2 is fixable; M4's file-loss case is a design limit. Said
  plainly so the next reader does not expect M4 to close.

REJECTED (D) write our magic onto the adopted position at adoption time: NOT AVAILABLE.
  MT5 CANNOT MODIFY POSITION_MAGIC - stated in the source header at TRTM.mq5 636 and the
  reason adopted L1s stay magic-0 forever. Verified before proposing, not assumed.
REJECTED (C) re-derive adoption from the comment tag at reconcile (STATE.md's own candidate
  (b), and MY recommendation until Jeff refuted it): UNSAFE, not merely incomplete.
  JEFF'S OBJECTION, CONFIRMED IN CODE ON BOTH COUNTS:
    (i)  a MOBILE adoption never had a tag. AdoptPosition records adoptedL1 + the ticket but
         stores NOTHING distinguishing tagged from untagged - the `untagged` flag only reaches
         the log line and the Alert. There is nothing to match on.
    (ii) FormBasketGroup picks the LOWEST LEVEL as anchor with NO magic check, so an adopted
         L1 is ALWAYS the Tier 3 slice anchor while it lives - and K-4 blanks the surviving
         anchor's comment (Run-H-proven; ticket 2942227144 kept its ticket across two slices
         on 09-10/09-11 while losing its comment entirely, visible in the 09-23 O2b WARN).
    THE COMPOUND FAILURE THAT KILLS IT: a BLANKED tagged adoption becomes indistinguishable
    from an untagged one, so C would fall through to the untagged fallback - which adopts THE
    OLDEST magic-0 position, not necessarily the right one. That is a WRONG-POSITION ADOPTION
    ON A MONEY PATH, and it would fail silently. C is withdrawn.
REJECTED (A) simply decline to write on an unconfirmed read: strictly WEAKER than the locked
  option. A declines to decide; the locked option DECIDES CORRECTLY using history. A was my
  recommendation when the goal was an urgent hotfix; Jeff chose a permanent fix instead, which
  is the better call and makes A redundant.
REJECTED per-ticket unknownSince[] array with schema 5 -> 6: the bump costs what it is meant
  to protect. StateLoad DISCARDS the file on a schema mismatch (610), destroying the adoptedL1
  record - THE EXACT DEFECT UNDER REPAIR. b41 absorbed that with deploy-on-flat (b41-C1) for
  ONE instance; there are now EIGHT live instances, so it would mean eight flat-sequence
  windows or eight discards. Precision not worth that.
REJECTED aging from the ticket's own POSITION_TIME: unavailable by construction - if the
  position cannot be selected, its open time cannot be read.

TICKET NUMBER IS THE ONLY DURABLE IDENTITY, and the state file already stores it. A slice
  preserves the ticket while destroying the comment (evidence above). The fix therefore is
  NOT "find a better identity" but "STOP DESTROYING THE RECORD THAT HOLDS THE TICKET".

## b43 BUILT 2026-10-02 - E9-Q2 DIRECTIONAL RECORD MANAGEMENT. GATE ZERO NOT RUN.
IDENTITY: 88fa5ce0cbea7920 / 5210 lines (+98 from b42's 5112: 58 code, 47 comment).
GATES CLEARED: Gate 1 (E9-Q2-D1 locked 2026-10-02), Gate 2 (docs/Q2_MATRIX.md SEALED rev 1,
  22 rows, 16 must-NOT, QQ1 resolved in-matrix), Gate 3 (docs/Q2_PLAN_2026-10-02_gate3.md
  CONFIRMED). NEXT: Gate Zero (Jeff compiles), then Gate 4, then seal on Jeff's word.

THE SIX TOUCH POINTS AS BUILT:
  TP5  173  NEW CONSTANT TRTM_UNKNOWN_MAX_AGE_SEC = 7776000 (90 days). A #define, not an
            input (B-4). Comment explains WHY it ages from lastSaved and not a new field.
  TP1  937  ClosingDealReason CONTRACT WIDENED. Two of its three `return 0` sites become
            `return -1`:
              history unavailable      -> -1  NO EVIDENCE
              no DEAL_ENTRY_OUT found  -> -1  NO EVIDENCE
              default (deal EXISTS)    ->  0  GENUINELY CLOSED (manual) - still deletes
            The header comment was rewritten: the old one said "0 unknown/manual", which
            CONFLATED the two opposite meanings and WAS the defect. A comment that lies is
            worse than none (b40's lesson).
  TP2  969  NEW HELPER TicketConfirmedClosed(ticket, reason, closePx) -> bool. The ONE place
            that answers "has MT5 AFFIRMED this ticket is gone?". Returns true only when a
            closing deal exists. VERIFIED AFTER THE BUILD: ClosingDealReason is now called
            from NOWHERE ELSE - all three consumers go through this helper, so no path can
            read -1 as a close (A-6, and the E9-P6 anti-duplication lesson).
  TP3  997  CheckSequenceLiveness - the UNKNOWN gate. On -1 the ticket is KEPT, the arrays
            are NOT shifted, nothing is saved, and a ONE-SHOT-per-ticket WARN fires via the
            existing AlreadyLogged registry (C-2 - liveness runs every tick; unthrottled
            would flood). WITHOUT THIS SITE THE RECONCILE FIX IS DEFEATED IN ONE TICK.
  TP4a 3095 Reconcile's adoptedL1 restore branch - THE FIRST LINE OF THE 09-18 LOG. It used
            to assert "no longer exists - closed while EA was offline" purely because the
            select failed. Now classifies first and names TP/SL/stop-out when a deal exists.
  TP4b 3118 Reconcile FLAT BRANCH - *** THE 09-18 SITE. *** Classifies EVERY ticket the file
            claims before writing. Any UNKNOWN -> keep the record, carry it into g_state,
            RETURN WITHOUT StateReset OR StateSave. All CONFIRMED -> genuine flat, resets
            exactly as before.
  TP6  51   TRTM_BUILD "b42" -> "b43".

A-5 VERIFIED BY INSPECTION AFTER THE BUILD - THE ONE WAY THIS COULD HAVE BROKEN SOMETHING:
  a genuine flat still falls through to StateReset -> g_state.lastCloseTime = lastClose ->
  StateSave, byte-unchanged. The stale-tag gate anchor survives. Had this regressed, a stale
  tagged L1 would silently become adoptable again - which is why A-5 is a must-NOT row with
  its own live-evidence requirement rather than an inspection row.
  ALSO VERIFIED: the `if(haveFile && file.levelCount > 0)` guard is unchanged, so a genuinely
  first run (no file) or a flat marker with levelCount 0 skips the entire new block. And the
  B-1 expired branch deliberately FALLS THROUGH to the same reset - correct, an expired
  UNKNOWN should be discarded.

DIFF DISCIPLINE - every deletion in the whole file, and why:
  TRTM_BUILD "b42"                             -> "b43"
  `return 0;` x2                               -> `return -1;` (the no-evidence paths)
  `default: return 0;`                         -> same + comment (a REAL close, still deletes)
  `int reason = ClosingDealReason(...)`         -> the TicketConfirmedClosed gate
  "no longer exists - closed while EA was offline"      -> classified, NO false cause
  "broker is flat - sequence closed while EA was offline" -> classified, NO false cause
  THE LAST TWO STRINGS ARE THE POINT OF THE BUILD. They are the two lines that lied on 09-18.

HYGIENE (recomputed on the built file): 5210 lines, 0 bare LF, 0 non-ASCII, brace delta -1
  IDENTICAL to baseline, paren 0, bracket 0.
LINE-DELTA NOTE: plan estimated +74, build is +98. The 24-line overrun is COMMENT-weighted
  (47 of the 98 are comment) - provenance markers and the 09-18 explanation written into the
  source, the same pattern as b42's TP4. No unplanned code. Recorded so a later reader does
  not have to re-derive it.

WHAT b43 DOES NOT TOUCH (the UNCHANGED list, as built):
  - The three SAFE StateReset sites: AdoptPosition, liveness' genuine all-closed reset,
    RegisterButtonL1. (D-1)
  - b20 attribution text/levels for TP/SL/stop-out/EA-closed. Only the no-evidence branch
    changed. (D-2)
  - b39/F-2 orphan rebuild, FindUntrackedOurSeed, CheckOwnPendingFillWhenFlat. (D-3)
  - Every lastCloseTime write and the stale-tag gate. (D-4)
  - All 20 `if(!PositionSelectByTicket(...)) continue;` guards - a KEPT-but-unselectable
    record is INERT to ComputeTargets, FormBasketGroup, EnforceExits and the projections.
    This pre-existing defensiveness is what makes "keep the record" safe. (D-5)
  - StateToJson / StateLoad field lists; TRTM_STATE_SCHEMA stays 5; the self-test. (D-6)
  - ReconcileManualExits and b41's lastAppliedTP/SL discriminator. (D-7)
  - b42's TradeTargetLive and all three no-send gates. Q3 is sealed and untouched.
  - Adoption, the panel, the instance lock, all three tiers, every quote read.

RISK, STATED PLAINLY AND HIGHER THAN b42: this build changes what the EA DOES, not only what
  it says. b42 changed reason text and a branch's reachability; b43 changes WHETHER A RECORD
  IS DELETED. THE DIRECTION IS BENIGN - every change makes the EA delete LESS. A false UNKNOWN
  keeps a record that should have gone: a stale ticket, inert per D-5, surfaced by a WARN, and
  expired at 90 days. The failure it prevents is the opposite and far worse - a record deleted
  while the position is ALIVE, which cost five days of an unmanaged money path on 09-18.
  WATCH ITEM FOR THE RUN: the COUNT of UNKNOWN WARNs during normal running. If they appear on
  healthy restarts the classifier is too eager and something in the history read is unreliable
  on this broker. That would be a FINDING, not noise.

GATE 4 PLAN - what needs live evidence vs inspection:
  LIVE/FORCED: A-1 + B-1 + B-2 via the fabricated-ticket fixtures already staged at
    scratchpad/q2_fixtures/ (ticket 999999999; lastSaved at 0d / 89d / 91d). Jeff copies each
    over MQL5/Files/TRTM/state_XAUUSDS_715358.json on the FLAT XAUUSDS chart and re-inits.
    NO probe build, NO code change, nothing temporary in the source - this deliberately avoids
    the probe hazard that bit b42 (see the 2026-10-02 probe incident).
  LIVE: A-5 (a sequence genuinely closed at the broker, then a restart - expect the flat
    marker AND lastCloseTime set), A-2/D-2 (a real TP or SL close, attribution unchanged),
    A-3 (any normal restart over a live sequence).
  INSPECTION + FILTERED DIFF: A-4, A-6, B-3, B-4, C-1, C-3, C-4, D-1..D-8.
  OPTIONAL BEFORE/AFTER, Jeff's call: running the A-1 fixture against SEALED b42 FIRST would
    reproduce the defect on the record for contrast. One extra init, not required by any row.

## *** b43 GATE 4 FAIL 2026-10-03 - FOUND BY JEFF ON THE FIRST FIXTURE RUN ***
## A-1's CORE ASSERTION PASSED. A SECOND DEFECT, MINE, WAS EXPOSED BY THE SAME RUN.

JEFF'S OBSERVATION, VERBATIM: "I'm not sure if it's seeing the 999999 ticket". He was right,
and chasing it found a real defect that the row itself would not have caught.

WHAT PASSED - A-1's substance, on evidence (tests/ the 2026-10-03 00:13:45 + 00:17:38 inits):
  "Reconcile: file claims 1 level(s) and the broker reads EMPTY, but 1 ticket(s) #0 have NO
   closing deal in history - MT5 has NOT confirmed they closed. The record is KEPT and
   NOTHING is written (E9-Q2 A-1). No cause is asserted. Record age 0 of 90 days."
  NO "Reconcile complete: FLAT". NO "closed while EA was offline". The reconcile path did
  exactly what the matrix demands, on BOTH inits. Under b42 that fixture would have been
  wiped on the spot. The CLASSIFIER AND THE RECONCILE KEEP-PATH ARE PROVEN CORRECT.

WHAT FAILED - the ticket printed as #0, and the FIXTURE FILE ON DISK WAS REWRITTEN TO
  {"tickets":[0],"levels":[0], ... "lastSaved":1790968657}
  The fixture as generated and VALIDATED held tickets:[999999999], levels:[1]. The parser was
  cleared of blame by emulating JsonGetArray against the exact fixture bytes: it returns
  (true, [999999999]). The file the EA read on the SECOND init was already corrupt, written
  by the FIRST instance.

ROOT CAUSE - MINE, AND IT IS A DESIGN ERROR NOT A TYPO:
  The keep path does `g_state = file; return;` (3145). That leaves g_state.levelCount = 1
  holding a ticket the EA has just decided is UNKNOWN. The EA therefore treats an
  UNCONFIRMED record as a LIVE SEQUENCE:
    (1) OnDeinit runs `if(g_state.levelCount > 0) StateSave(g_state);` and logs "state saved
        (sequence alive)" - SO THE NEXT DEINIT REWRITES THE FILE. The matrix row says
        "NOTHING is written"; OnDeinit violates that one deinit later.
    (2) the whole OnTick engine chain runs against it every tick;
    (3) liveness re-evaluates it forever - visible at 00:13:45.103 as
        "Liveness: L0 ticket 0 is NOT selectable and has NO closing deal..."
  THE L0 IN THAT LINE IS ITS OWN HAZARD: level 0 is exactly what b39's L-3 rule forbids,
  because FormBasketGroup picks the LOWEST level as anchor and a level-0 entry would seize
  the Tier 3 anchor. The corruption propagates into anchor selection.

HONESTY NOTE ON THE DIAGNOSIS: I could not pin the exact statement that zeroed the arrays
  while leaving levelCount at 1 - `g_state = file` is a struct copy, StateToJson writes
  tickets[i]/levels[i] for i < levelCount, and scope is valid at the assignment, so the
  round-trip SHOULD have preserved 999999999. The decisive first-init evidence was
  overwritten before capture. I stopped drilling because OPTION A REMOVES THE WRITE
  ENTIRELY, which makes the question moot rather than unanswered. If the zeroing mechanism
  matters later, the reproduction is: fresh fixture, ONE init, capture, then read the file
  BEFORE any deinit.

LOCKED DECISION E9-Q2-D2 (keep-path semantics, Jeff's call 2026-10-03): OPTION A - AN
  UNKNOWN RECORD IS NEVER LOADED INTO g_state.
  "Keep the record" means PRESERVE THE FILE UNTOUCHED - it does NOT mean resurrect the
  record as a live sequence. On the UNKNOWN path reconcile logs, leaves the file alone, and
  leaves g_state FLAT. The record survives ON DISK for a later reconcile, and the EA does
  not pretend to manage a ticket it cannot see.
  CONSEQUENCE, ACCEPTED: OnTick's flat-state paths then run (CheckOwnPendingFillWhenFlat,
  TryAdopt). That is CORRECT - the EA genuinely has no confirmed sequence. b39/F-2 still
  re-adopts any magic-owned orphan, which is the self-heal path that saved the eight levels
  on 2026-09-21.
  ALSO REQUIRED: OnDeinit must not write a flat g_state over a kept record. With g_state
  flat its `levelCount > 0` guard is already false, so it writes nothing - but the plan must
  VERIFY that rather than assume it, because that guard is the thing that corrupted the
  fixture.
  REJECTED (B) load it but mark it inert with a new flag: needs schema 5 -> 6, which Gate 1
  already rejected on the grounds that a schema bump DISCARDS the file and destroys the very
  adoptedL1 record under repair - with eight live instances that is eight deploy windows.

MATRIX CONSEQUENCE: this is a Gate 4 FAIL, so per CLAUDE.md it becomes ROWS, not a silent
  fix. Jeff must re-open the Q2 matrix seal to add them. Proposed:
    A-7  MUST-NOT: an UNKNOWN record is NEVER loaded into g_state. After an UNKNOWN keep,
         g_state.levelCount == 0 and the EA reports itself flat.
    A-8  MUST-NOT: OnDeinit writes NOTHING after an UNKNOWN keep. Evidence: the state file
         is byte-identical before and after a full init + deinit cycle on the A-1 fixture.
         THIS IS THE ROW THE 2026-10-03 RUN FAILED.
    A-9  MUST-NOT: no level-0 entry ever reaches g_state (b39 L-3 holds). Evidence: no
         "L0 ticket" line in any log.
  FIXTURE PROCEDURE AMENDED: read the state file BEFORE any deinit, and restore/delete it
  between tests - a corrupt fixture silently invalidates the next run (it is what produced
  the #0 that Jeff spotted).

## b44 GATE ZERO PASSED + A-1 / A-4 / A-7 / A-8 / A-9 CLOSED ON LIVE EVIDENCE 2026-10-03
XAUUSD.s M5, symbol XAUUSDS, magic 715358. Fixture: A1_fresh_unknown.json, ticket 999999999
(a number that NEVER existed, so unselectable AND no history = a faithful UNKNOWN),
adoptedL1 true, levels [1], age 0 of 90 days. NO probe build, NO code change, NO temporary
diagnostic - a test fixture only, which is why this avoided the b42 probe hazard entirely.

GATE ZERO: clean compile, "=== TRTM b44 init ===", self-test PASS.

A-1 PASS - 00:42:06.055, BOTH classifier lines fired, in order, naming the REAL ticket:
  "Reconcile: recorded adopted L1 ticket 999999999 is NOT selectable and has NO closing deal
   in history - MT5 has not confirmed it closed, so the record is KEPT (E9-Q2). No cause is
   asserted."                                                        <- TP4a, adoptedL1 branch
  "Reconcile: file claims 1 level(s) and the broker reads EMPTY, but 1 ticket(s) #999999999
   have NO closing deal in history - MT5 has NOT confirmed they closed. The record is KEPT
   and NOTHING is written (E9-Q2 A-1). No cause is asserted. Record age 0 of 90 days."
                                                                     <- TP4b, flat-branch
  Non-overlapping and both correct, as the plan predicted.

A-4 PASS (absence) - NO "Reconcile complete: FLAT" from the keep path.
C-1 PASS (absence) - NO "closed while EA was offline". No cause asserted anywhere.
A-9 PASS (absence) - NO "L0 ticket" line. The level-0 remnant that existed in the b43 run is
  gone; nothing level-0 ever reached g_state.

A-7 PASS - ON THE DASHBOARD, which is the only place this row is observable. The panel read
  "TRTM b44 / XAUUSDS", Direction: FLAT, and the ENTIRE LIVE SEQUENCE block "-" (Positions /
  lots, Floating PnL, Avg entry, TP, SL, Proj at TP/SL all empty). Entry buttons green and
  clickable, i.e. the EA correctly believes it has no confirmed sequence.
  UNDER b43 THIS PANEL WOULD HAVE SHOWN "BUY - L1" WITH A 0.01-LOT STRUCTURE. This is the
  D2 decision proven on screen: the UNKNOWN record was kept ON DISK and never loaded into
  g_state. CAPTURED BEFORE DETACHING - PanelDestroy() removes the only evidence for this row.

A-8 PASS - THE ROW b43 FAILED. State file sha256_16 across a FULL init + deinit cycle:
    fixture baseline   904eefc1bc4b15df
    after the init     904eefc1bc4b15df
    after the DEINIT   904eefc1bc4b15df   IDENTICAL
  tickets [999999999] and levels [1] intact; lastSaved never advanced from 1790967639.
  Deinit logged "Deinit (reason 1) - state clean (flat)" - the EXACT INVERSE of b43's
  "state saved (sequence alive)", which is the line that rewrote the fixture to [0].

b43 -> b44 COMPARISON ON THE SAME CORRUPT INPUT (the 00:35:31 b44 run, before the fixture
landed, is a free A/B against the 00:13:45 b43 run):
    behaviour                        b43        b44
    reconcile keep                   yes        yes
    "Liveness: L0 ticket 0"          PRESENT    ABSENT
    "Deinit - state saved (alive)"   PRESENT    ABSENT
  Both regressions are closed by the single D2 statement change.

## PROCESS FINDINGS FROM THIS RUN - BOTH COST A CYCLE, BOTH WORTH KEEPING
(1) THE FIXTURE COPY SILENTLY DID NOT LAND on the first b44 attempt (00:35:31). The EA read
    the OLD corrupt file and printed "#0" again. DIAGNOSED BY TIMESTAMP, not by guessing:
    the live file carried adoptionTime 1790931849 while the regenerated fixture carried
    1790967639 - different files, provably. THE EA MUST BE FULLY REMOVED (not just
    re-initialised) before overwriting the state file, and the copy MUST BE VERIFIED on disk
    before the run. A fixture that does not land invalidates the whole test silently.
(2) READ/HASH THE FILE BEFORE ANY DEINIT. The 2026-10-03 b43 run was invalidated because the
    deinit-save happened before the file was captured, so the decisive first-init evidence
    was destroyed. Hash BEFORE attach, after init, and after detach.
(3) Jeff should NOT be asked to run certutil by hand - Claude can READ the MT5 tree (only
    WRITING is denied by section 3a), so Claude hashes the file and Jeff only copies and
    attaches. Fewer steps, no transcription risk.

STILL OPEN ON b44:
  B-2 (85d UNKNOWN -> KEEP) and B-1 (95d UNKNOWN -> DELETE + expiry WARN). Fixtures already
    regenerated with FIVE-DAY margins either side of the 90-day bound, so a delayed run
    cannot flip a verdict. Same procedure: remove EA, copy, verify, attach, capture, detach.
  A-2 (a CONFIRMED closed ticket is still deleted and still names TP/SL/stop-out/manual),
    A-3 (a normal restart over a live sequence), A-5 (a GENUINE flat still writes the flat
    marker AND lastCloseTime - the stale-tag gate anchor; the one way b44 could introduce a
    NEW defect), D-2 (b20 attribution text unchanged on a real TP/SL close).
  INSPECTION: A-6, B-3, B-4, C-2, C-3, C-4 (C-4 already corroborated at b43 Gate Zero),
    D-1, D-3..D-8.

## b44 B-2 + B-1 + A-5 CLOSED ON LIVE EVIDENCE 2026-10-03 (same fixture method)
B-2 PASS (UNDER the bound, 00:53:41) - fixture age 85 days, 5 days inside the 90-day bound:
  "Reconcile: ... 1 ticket(s) #999999999 have NO closing deal in history ... The record is
   KEPT and NOTHING is written (E9-Q2 A-1). No cause is asserted. Record age 85 of 90 days."
  FILE UNTOUCHED ACROSS INIT + DEINIT: sha256_16 832fe07f6236aff2 both sides, tickets
  [999999999] / levels [1] intact, lastSaved never advanced. Deinit: "state clean (flat)".
  The age arithmetic is correct and the keep path holds right up to the bound.

B-1 PASS (PAST the bound, 00:58:46) - fixture age 95 days, 5 days past:
  "Reconcile: 1 claimed ticket(s) #999999999 are NOT selectable and have NO closing deal,
   and this record is 95 days old (bound 90) - EXPIRED, discarding it (E9-Q2 B-1)."
  "Reconcile complete: FLAT"
  FILE CORRECTLY CHANGED (the ONLY row where a change is the pass condition):
    b7032bb6e133e165 -> ff390d9df434b7f4
  Discard is COMPLETE: levelCount 0, tickets [], levels [], adoptedL1 false.
  NOTE the adoptedL1 WARN still fires first (TP4a classifies before TP4b decides) - correct
  and non-overlapping, same as A-1/B-2.

A-5 PASS, CLOSED BY THE SAME RUN - THE ROW THAT MATTERED MOST FOR REGRESSION RISK:
  after the B-1 discard the flat marker carries lastCloseTime = 1782759639, i.e. the expired
  record's OWN lastSaved, carried through by the UNCHANGED `if(lastClose < file.lastSaved)`
  logic. THE STALE-TAG GATE ANCHOR IS SET AND NON-ZERO.
  WHY THIS CLOSES A-5: the expiry path falls through to the SAME StateReset ->
  lastCloseTime = lastClose -> StateSave sequence a genuine all-confirmed-closed flat uses.
  Exercising the expiry therefore exercises A-5's code verbatim. Had this regressed,
  lastCloseTime would be 0 and all three stale-tag gates (`lastCloseTime > 0 && ...`) would
  STAND DOWN, making every tagged magic-0 position adoptable including stale ones. That was
  named at Gate 3 as the one way b44 could introduce a NEW defect; it did not.

b44 DISPOSITION NOW:
  LIVE EVIDENCE: A-1, A-4, A-5, A-7, A-8, A-9, B-1, B-2, C-1, plus C-4 (b43 Gate Zero).
  STILL OPEN, and these need a REAL SEQUENCE rather than a fixture:
    A-2  a CONFIRMED closed ticket is still DELETED and still names TP/SL/stop-out/manual.
    A-3  a normal restart over a LIVE sequence restores it exactly as before.
    D-2  b20 attribution text/levels unchanged on a real TP or SL close.
  INSPECTION + FILTERED DIFF: A-6, B-3, B-4, C-2, C-3, D-1, D-3..D-8.

## b44 A-2 + A-3 + D-2 CLOSED ON A REAL SEQUENCE 2026-10-03 (the rows a fixture cannot reach)
EVIDENCE: tests/2026.10.03 005846.362.txt - XAUUSD.s M5, XAUUSDS 715358, a REAL 0.01-lot BUY
opened via the panel (ticket 890591787 @ 4141.51, deal 554930992). These three rows need a
genuine closing deal in history, which a fabricated ticket cannot produce.

A-3 PASS - restart over a LIVE sequence (01:02:21 deinit -> 01:02:28 init):
  "Deinit (reason 1) - state saved (sequence alive)"   <- CORRECT HERE, and this is the point
  "Reconcile: flags restored (trailOverride=F beOverride=F trailingActive=F beApplied=F)"
  "Structure: 1 level(s), 0.01 lots | projected at TP +3.00 | at SL n/a"
  "Reconcile complete: dir=BUY levels=1"
  Restored IDENTICALLY, and *** NO UNKNOWN WARN *** - the ticket was selectable so the new
  classifier correctly never fired. THAT ABSENCE IS THE ROW: b44's path does not intrude on
  healthy operation.
  INSTRUCTIVE CONTRAST: "state saved (sequence alive)" is CORRECT here and was the DEFECT at
  2026-10-03 00:13:45 under b43. Same line, opposite verdict - because here a live sequence
  genuinely exists. The fix was never about suppressing that line; it was about not reaching
  it with an unconfirmed record.

A-2 PASS - a CONFIRMED close is still DELETED (01:03:36.512, manual close in the Trade tab):
  "Liveness: L1 ticket 890591787 closed externally (manual/unknown) - removed from sequence"
  "Sequence fully closed - back to FLAT, overrides reset to input defaults, flat marker saved"
  THE TICKET WAS DELETED. History carried a real closing deal, so ClosingDealReason returned
  0 (a REAL close) and NOT -1, and TicketConfirmedClosed let the removal proceed. This is the
  discriminator proven in the opposite direction from A-1: b44 deletes on evidence and keeps
  on absence. WITHOUT THIS ROW the fix could have been blanket suppression.

D-2 PASS - verified by DIFF, not by eye: all five b20 attribution strings (TP hit / SL hit /
  STOP-OUT / closed externally / closed by EA) are BYTE-IDENTICAL between committed b42 and
  b44. Only the no-evidence branch changed.

A-5 CONFIRMED A SECOND TIME, ON A GENUINE CLOSE: the final state file carries
  lastCloseTime = 1790971416, set from the REAL close at 01:03:36 - not an expiry fallback.
  B-1 exercised A-5's code via the EXPIRY path; this exercised it via the path A-5 actually
  describes (every claimed ticket confirmed closed). BOTH AGREE. The stale-tag gate anchor is
  armed in both routes to the flat marker.

STEP-4 RESTART (01:04:03) - a clean flat marker reloads with "Reconcile complete: FLAT" and
  NO UNKNOWN WARN, because levelCount 0 means the classification block is skipped entirely by
  the unchanged `if(haveFile && file.levelCount > 0)` guard. C-4 corroborated a third time.

*** b44 GATE 4 IS NOW COMPLETE. ALL 25 MATRIX ROWS DISPOSED. ***
  LIVE EVIDENCE (13): A-1 A-2 A-3 A-4 A-5 A-7 A-8 A-9 B-1 B-2 C-1 C-4 D-2
  INSPECTION + FILTERED DIFF (12): A-6 B-3 B-4 C-2 C-3 D-1 D-3 D-4 D-5 D-6 D-7 D-8
  Awaiting Jeff's explicit word to seal (Gate 6).

## E9-Q2 TRIGGER RECURRED 2026-10-01 ON EURAUDS - SECOND OCCURRENCE, 13 DAYS AFTER 09-18
RAISED BY JEFF (he flagged this file on 2026-10-02 as "evidence I want to check with you
later on"; parked then, read 2026-10-05). EVIDENCE: tests/2026.09.30 174332.508.txt.

2026.10.01 21:03:38.168, EURAUD.s H1, symbol EURAUDS, magic 764490, b41 - THE EXACT 09-18
SIGNATURE, same two lines in the same second:
  "Reconcile: recorded adopted L1 ticket 2059016696 no longer exists - closed while EA was
   offline"
  "Reconcile: file claims 1 level(s) but broker is flat - sequence closed while EA was offline"
An ADOPTED L1 (magic-0, no b39/F-2 self-heal path) declared closed, record destroyed.

VERDICT ON THIS INSTANCE: PROBABLY A GENUINE CLOSE, NOT A FALSE FLAT. The discriminator is
reappearance, and it is decisive:
  EURAUDS 2059016696 appears EXACTLY ONCE in the whole capture - the declaration itself.
  AUDNZDS 2940935091 (the 09-18 case) appears across NINE daily logs, INCLUDING AFTER its
    false declaration. That reappearance is what PROVED the EA wrong.
  No such proof exists here.
THREE CORROBORATING SIGNS it really had closed:
  (1) the EA opened a NEW L1 eighteen seconds later (21:03:56 BUY ARMED -> 21:03:58 OPENED).
      Jeff would not manually open a fresh position on a symbol he believed already held one.
  (2) "Log cleanup: 2 file(s) older than 14d deleted" - this instance had been running long
      enough to accumulate history, and this is the FIRST EURAUD line in the capture, so the
      prior sequence closed during a genuine offline gap.
  (3) 09-18 had NINE positions vanish simultaneously (the cache-empty signature). Here only
      the single adopted L1 was claimed and RebuildLiveMap found no magic-owned levels either
      - consistent with a genuinely flat account rather than an unpopulated cache.

*** WHY IT IS A FINDING ANYWAY, AND THE STRONGEST ARGUMENT YET FOR THE ROLLOUT: ***
  b41 COULD NOT TELL THE DIFFERENCE. It asserted "closed while EA was offline" on ZERO
  affirmative evidence - it only knew PositionSelectByTicket had failed - and then destroyed
  the record. IT HAPPENED TO BE RIGHT THIS TIME. On 09-18 it was wrong and that cost five
  days of an unmanaged position. THE LOG LINE IS IDENTICAL IN BOTH CASES. That identity IS
  the defect.
  Under b44 this same init would have read history, found a closing deal, and logged
  "...CONFIRMED closed while the EA was offline (closing deal found in history)" - the same
  outcome STATED ON EVIDENCE. Had history been empty, the record would have SURVIVED.
  SO: the adopted-L1-declared-closed path fires in NORMAL OPERATION, not only on a
  Friday-rollover accident. Two occurrences, 13 days apart, on two different symbols, both
  on instances that are STILL RUNNING b41. This retires any notion that 09-18 was a one-off.

OTHER WARNS IN THE SAME CAPTURE, all benign and recorded so they are not re-investigated:
  GBPUSD.s 15:30 + 20:00 - "Recovery L3 FORFEITED: fill-side price ... does not satisfy
    trigger ... (spread pushes entry inside the interval)". The b2 entry-side guard working
    as designed; the fill price genuinely sat inside the interval both times.
    NOTE: this is the WARN whose wording misdirected the 2026-08-19 stale-quote investigation
    (it asserts SPREAD as the cause without checking). E9-Q1 would replace that claim with a
    measured one. Here the claim happens to be true - the prices differ by 0.6 and 1.7 pips.
  GBPUSD.s 20:03:48 and EURAUD.s 21:29:00 - "Liveness: L<n> ticket <t> closed externally
    (manual/unknown)". Normal manual closes; under b44 these still delete (A-2 proved it).

## *** E9-R1 (NEW, 2026-10-05): DRAWDOWN AUTO CLOSE IS NOT IMPLEMENTED - AN INERT INPUT
## THAT THE README DOCUMENTS AS WORKING. RAISED BY JEFF. ***
JEFF'S REPORT: "I enabled it once and expected the positions will be closed at 2% drawdown
but it did not fire." He was looking for a cause in the 09-30 log. THERE IS NO CAUSE IN THE
LOG - the feature does not exist.

CODE EVIDENCE, DEFINITIVE: InpEnableDDClose, InpMaxDDPercent and InpMaxDDUSD appear EXACTLY
ONCE EACH in the whole 5224-line file - their declarations at 145-147. They are never read
by any code path. Corroborated three ways:
  - `grep -n "InpEnableDDClose\|InpMaxDDPercent\|InpMaxDDUSD"` returns ONLY lines 145-147.
  - NO ACCOUNT_EQUITY read anywhere in the file; there is no equity/drawdown evaluator at all.
  - ZERO "DD" references inside OnTick's engine chain.
  Every other "Drawdown" hit in the file is the DRAWDOWN REDUCTION tiers (E4/E5/E6), which
  are a DIFFERENT FEATURE ENTIRELY - a partial basket valve, not an account-level stop.
  The 248-line 09-30 capture across EIGHT instances contains no DD line of any kind, which is
  the expected ABSENCE, not a missing trigger.

ROOT CAUSE: a Stage 1 placeholder that never got its stage. The INPUTS header (80-83) states
the convention: "all inputs are declared so the dialog layout is locked now. Inputs owned by
later stages are INERT until that stage lands." These three sit under
"=== Filters & Safety (Stage 7) ===", and Stage 7 SEALED as "SafetyLayer + instance lock +
log retention". The lock and retention shipped. Drawdown auto-close did not. The inputs
stayed in the dialog and nothing ever flagged the gap.

WHY IT WAS INVISIBLE TO JEFF - TWO COMPOUNDING FAILURES, AND THE SECOND IS THE WORSE ONE:
  (1) NO LOG LINE. Ticking the box produces NOTHING - no confirmation, no warning, no
      "not implemented". The EA is silent because there is no code to speak. CLAUDE.md
      section 7 lists "any silent path: code that fails/skips/blocks without logging" as a
      FLAG-IMMEDIATELY item; this is worse than a silent skip, because there is no code at all.
  (2) *** THE README DOCUMENTS IT AS FUNCTIONAL. *** README.md 227-228:
        | `InpEnableDDClose` | Master switch for drawdown auto-close. |
        | `InpMaxDDPercent` / `InpMaxDDUSD` | Close everything past this drawdown. 0 = off. |
      That table tells the reader to tick the box and set a percentage. Nothing hints the
      code is absent. A user following the documentation would reasonably believe the account
      had a drawdown stop when it had none.
      THE SAFETY INVERSION: this is not a feature that silently does nothing. It is a feature
      that silently does nothing WHILE THE DOCS PROMISE A LOSS CAP. Anyone relying on it was
      running without the protection they thought they had.

IMMEDIATE ACTION TAKEN 2026-10-05: README corrected so the documentation stops lying (see the
  b45 entry if a build followed). NO CODE WRITTEN. A drawdown auto-close decides when EVERY
  position on the account is closed - that is a money path and CLAUDE.md section 8 forbids
  code before a confirmed plan, a plan before a sealed matrix, and a matrix before locked
  decisions. It gets its own Gate 1.

OPEN QUESTIONS FOR THAT GATE 1 (recorded now so they are not re-derived):
  - DRAWDOWN OF WHAT? Account equity vs balance, or only THIS instance's sequence? With EIGHT
    instances on one account, an account-level equity stop on one chart would close positions
    the other seven own. That is the central decision and it is not obvious.
  - CLOSE WHAT? Only this magic's positions, or everything? The EA has never touched a
    position outside its own magic; doing so would be a first.
  - THE NOTIFY-NEVER-AUTO-CLOSE PRECEDENT (b19, locked): "a config error must not cost an
    open, exit-protected position money". An auto-close is the opposite posture and must be
    reconciled with that decision rather than quietly overriding it.
  - PERCENT AND USD TOGETHER: whichever trips first, or is one a master? Both default to 0.
  - INTERACTION with the sealed E4/E5/E6 tiers, BE, trailing, and the SL-exceeded backstop.

## FULL INPUT AUDIT 2026-10-05 - 52 INPUTS, 4 DEAD. Jeff's question after E9-R1:
## "can you tell what other inputs we have that does not have a corresponding functionality?"
METHOD: mechanical, not by eye. Every `input <type> <Name> =` declaration was extracted, then
each name was counted across the whole file EXCLUDING its own declaration line. Zero
references outside the declaration = DEAD. Then the 48 live ones were re-checked for a
subtler failure: referenced ONLY in ValidateInputs / PanelRefresh / display helpers and never
in an engine. NONE of the 48 failed that second test - all reach a real decision path.

*** THE FOUR DEAD INPUTS ***
  InpEnableDDClose     145  [Filters & Safety (Stage 7)]   E9-R1, already recorded
  InpMaxDDPercent      146  [Filters & Safety (Stage 7)]   E9-R1
  InpMaxDDUSD          147  [Filters & Safety (Stage 7)]   E9-R1
  InpTrailMode         118  [Exit Rules (Stage 3 / Stage 6)]  *** NEW: E9-R2 ***

## E9-R2 (NEW, 2026-10-05): InpTrailMode IS DEAD - AND IT IS WORSE THAN THE DD TRIO
`input ENUM_TRAIL_MODE InpTrailMode = TRAIL_FIXED_DISTANCE; // Trail Stop Mode`
ZERO references outside the declaration. The enum offers a CHOICE THAT DOES NOT EXIST:
    enum ENUM_TRAIL_MODE { TRAIL_FIXED_DISTANCE = 0, TRAIL_PREV_CANDLE = 1 };
  TRAIL_PREV_CANDLE appears EXACTLY ONCE in the file - in that enum declaration. Never read.
  ApplyProtectiveEngines has ONE trail-candidate computation (1487):
      double cand = NormalizePrice(evalPx - dir * InpTrailDistPts * _Point);
  That is ALWAYS fixed-distance. There is no previous-candle branch anywhere.
WHY IT IS WORSE THAN E9-R1: the DD inputs do NOTHING, which is at least inert. This one does
  SOMETHING OTHER THAN WHAT THE USER SELECTED, silently, ON A LIVE STOP-LOSS PATH. Select
  "Previous Candle High/Low" and you get Fixed Distance with no warning.
  README 211 documents the choice as real: "| `InpTrailMode` | Fixed Distance or Previous
  Candle High/Low. |" - the SAME documentation-promises-what-code-lacks failure as E9-R1.
SEVERITY vs E9-R1: lower exposure in practice because InpEnableTrailing defaults false AND
  the sealed test-design rules REQUIRE trailing off for verification runs - so the wrong mode
  has likely never been in force. But it is a money path (it sets the SL), so it is a real
  finding, not a cosmetic one.
NOT FIXED HERE. Like E9-R1 it needs its own Gate 1: implementing a previous-candle trail is a
  new money-path behaviour (which candle, which timeframe, how it interacts with the sealed
  ratchet floor and min-step), and REMOVING the input is also a decision because the Stage 1
  convention deliberately froze the dialog layout.

WHAT THE AUDIT DID *NOT* FIND - stated so the clean result is on the record:
  - No input is referenced only in validation/display while being advertised as behavioural.
  - The three low-reference-count inputs that looked suspicious are all genuinely live:
    InpMagicNumber (OnInit, magic derivation), InpRunSelfTest (OnInit gate),
    InpTesterNudgePts (OnInit clamp -> g_nudgePts).
  - InpSpreadFilter / InpMaxSpreadPts reach EvaluateRecovery; InpDeviationFilter /
    InpMaxDeviationPts reach EvaluateRecovery, CloseSequenceAtMarket and FireGroupClose. The
    OTHER three Filters & Safety inputs are therefore fine - only the DD trio is dead.
  - 48 of 52 inputs reach a real engine decision.

PATTERN WORTH NAMING: both dead-input findings are Stage 1 placeholders whose stage never
  landed, and in BOTH cases the README documents the feature as working. The Stage 1
  convention ("inputs owned by later stages are INERT until that stage lands") is sound, but
  nothing ever reconciled the input list against delivered functionality, and the README was
  written from the input list rather than from the code. RECOMMENDATION FOR ANY FUTURE STAGE:
  when a stage seals, diff its input group against what the stage actually implemented.

## ============================================================================
## E9 OPEN REGISTER - CONSOLIDATED 2026-10-05. THE SINGLE LIST OF WHAT IS LEFT.
## ============================================================================
Built because the parked items were scattered across 4000+ lines of STATE.md and could only
be reassembled by archaeology. THIS IS NOW THE INDEX; the detailed entries stay where they
are and are cited by their anchor text. Update this register whenever an item opens or closes.
Ranked by LIVE EXPOSURE, not by age or effort.

--- TIER 1: EVIDENCED DEFECTS / MISSING SAFETY -------------------------------
R1  DRAWDOWN AUTO CLOSE NOT IMPLEMENTED.                        [NEW 2026-10-05, Jeff]
    InpEnableDDClose + InpMaxDDPercent + InpMaxDDUSD - ONE FEATURE, THREE INPUTS, clubbed as
    a single work item per Jeff 2026-10-05. Declared at 145-147, read by NOTHING.
    Jeff enabled it expecting a close at 2% and it did not fire, because there is no code.
    README documented it as working until 2026-10-05 (now carries an explicit warning).
    WHY TIER 1: it is a SAFETY feature whose absence was invisible. Anyone relying on it was
    running with no account-level loss cap while the docs promised one.
    NEEDS ITS OWN GATE 1. Open questions already recorded under the E9-R1 entry: drawdown of
    WHAT (account equity vs this sequence - with EIGHT instances on one account an equity
    stop on one chart would close positions the other seven own); close WHOSE positions (the
    EA has never touched a position outside its own magic); how it reconciles with the LOCKED
    b19 notify-never-auto-close precedent; percent vs USD precedence; interaction with the
    sealed E4/E5/E6 tiers, BE, trailing and the SL-exceeded backstop.

Q1  STALE-QUOTE GUARD.                                          [2026-08-19 incident]
    73 minutes of a frozen quote read as truth; recovery silently dead; the forfeit WARN
    blamed SPREAD and misdirected the whole investigation. The incident itself was NOT a TRTM
    defect (a terminal restart cleared it) but the GAP is real: a MqlTick.time vs
    TimeCurrent() check would have named it on the first forfeit. Own Gate 1, own matrix.
    Jeff's stated top priority before Q2/Q3 jumped the queue on live evidence.

--- TIER 2: KNOWN DEFECTS, CONTAINED OR LOW EXPOSURE -------------------------
R2  InpTrailMode IS DEAD - "Previous Candle High/Low" DOES NOT EXIST. [NEW 2026-10-05]
    Separate work item from R1 per Jeff 2026-10-05. Line 118, zero references.
    TRAIL_PREV_CANDLE appears once, in the enum. ApplyProtectiveEngines always computes
    fixed-distance. Selecting the other mode SILENTLY gives Fixed Distance on a live SL path.
    README corrected 2026-10-05.
    LOWER EXPOSURE than R1: trailing defaults OFF and the sealed test-design rules require it
    off for verification runs, so the wrong mode has likely never been in force.
    TWO DECISIONS, NOT ONE: (a) BUILD the previous-candle trail - new money-path behaviour
    (which candle, which timeframe, interaction with the sealed ratchet floor and min-step);
    or (b) REMOVE the input - also a decision, because the Stage 1 convention deliberately
    froze the dialog layout. Gate 1 picks one.

Q4  SLICE-SELECTION RACE.                                       [2026-09-22 incident]
    b42 NAMES the event correctly ("NO ORDER SENT") but does not explain WHY the anchor
    became unselectable one call after being selectable, nor decide retry-vs-accept.
    WATCH ITEM: the frequency of "NO ORDER SENT" in normal running is the data Q4 needs.
    Own Gate 1.

K-4 + O6  SLICE BLANKS THE ANCHOR'S _lN_ COMMENT.               [Run H, 2026-08-18]
    Contained by b39's O2b (unparseable tag -> maxLvl+1, never 0), Run-H-proven. Residual: a
    restart scanning the sliced anchor AFTER other levels anchors FormBasketGroup on the
    wrong position (SL anchoring + next slice target). TP/PL arithmetic unaffected.
    Needs the second-close-path decision E4's X-4 rationale deliberately avoided.
    NOTE: K-4 is ALSO why the comment tag cannot be used as an identity - see the C rejection
    in E9-Q2-D1.

M4  adoptedL1 UNRECOVERABLE ON TRUE FILE LOSS.                  [NOT CLOSABLE IN CODE]
    b44 closed the OVERWRITE case completely. If the file is DELETED or the data folder
    changes, a magic-0 position has no magic, no reliable tag and no record. DOCUMENTED, not
    pretended away. Listed so nobody re-opens it expecting a fix.

--- TIER 3: HARDENING, NO KNOWN LIVE EXPOSURE -------------------------------
O3   filling-mode handling                                      [from the account-switch work]
O5   exemode init                                               [same family]
O2e  order accepted but NEVER filled - no timeout/escalation. Degrades gracefully today.
P6   AdoptionCandidateExists vs TryAdopt duplicate admission logic. A maintenance trap: two
     copies of the same judgement that MUST be kept in step. Not a bug today.
O4   netting guard. b42's probe proved every account is HEDGING, so UNREACHABLE on current
     accounts. Keep parked.
W-7  account-scoped identity. Evidence NARROWED it: XAUUSD.s -> XAUUSDS (715358) vs
     XAUUSD+ -> XAUUSD (758105), so Jeff's two accounts CANNOT collide. Keep parked.
M2   stale projection in the Structure: line. Cosmetic.

--- OPEN ON INSPECTION ONLY (untested paths, not known defects) --------------
L-1 / L-2 / L-4   need a deliberately corrupted comment to exercise.
F-1 .. F-5        flat-state rebuild never triggered in a verification run.
T3-K2 sub-case (a); T3-DS1 dashboard visual confirm.

--- BACKLOG (features, not defects) -----------------------------------------
E8  profit-funded follow-on slice. Unblocked since E6, own Gate 1 pending, never opened.
E2  draggable exit lines.    E3  auto-entry.

--- THE CROSS-CUTTING LESSON FROM R1 + R2 -----------------------------------
Both dead-input findings are Stage 1 placeholders whose stage never landed, and in BOTH the
README was written from the INPUT LIST rather than from the CODE. The Stage 1 convention
(freeze the dialog, mark later-stage inputs inert) is sound; what was missing is a
reconciliation step. STANDING RECOMMENDATION: when a stage seals, DIFF ITS INPUT GROUP
AGAINST WHAT THE STAGE ACTUALLY IMPLEMENTED, and correct the README from the code.
A full mechanical audit was run 2026-10-05: 52 inputs, 4 dead, 48 reaching a real engine
decision, and no input referenced only in validation/display. That audit is the baseline -
re-run it after any stage that adds inputs.

## LOCKED DECISION E9-R1-D1 (drawdown auto close - scope and trigger, Jeff 2026-10-05)

SCOPE: *** PER CHART / SYMBOL, NOT THE ACCOUNT. *** Jeff's call, and it is the decision the
  whole feature hinged on. The drawdown measured is THIS INSTANCE'S OWN TRACKED SEQUENCE.
  CONSEQUENCE THAT MAKES THE BUILD SAFE: the EA closes ONLY its own magic's positions, which
  is what every existing close path already does. NO NEW BOUNDARY IS CROSSED. An account-level
  equity stop would have had one instance closing positions the other SEVEN own - that hazard
  is now designed out rather than guarded against.

DENOMINATOR FOR THE PERCENT: OPTION A - PERCENT OF ACCOUNT BALANCE, applied to the SEQUENCE's
  floating P/L. Trigger: floatingPnL <= -(AccountBalance * InpMaxDDPercent / 100).
  This matches the input's EXISTING label ("Max DD in % of Balance") and Jeff's stated
  expectation ("expected the positions will be closed at 2% drawdown"), so nothing needs
  relabelling and nothing surprises the user later.
  REJECTED (B) percent of SEQUENCE EXPOSURE / cost basis: it has a hidden hazard - the
    threshold MOVES AS THE SEQUENCE GROWS, so a deepening recovery RAISES ITS OWN STOP-OUT
    BAR. That is the opposite of what a drawdown cap is for. Also needs a cost-basis
    definition that does not exist yet.
  REJECTED (C-alone) USD only, drop the percent: throws away an input the user already set
    and expects to work.

BOTH LIMITS ACTIVE, *** WHICHEVER IS LOWER WINS *** (Jeff 2026-10-05). The effective cap is
  the MINIMUM of the two POSITIVE limits; a limit set to 0 is OFF and excluded from the
  comparison. "Lower" = the TIGHTER cap, so it fires FIRST. Conservative by construction, and
  it reads naturally as "whichever limit I hit first".
  WORKED TABLE (balance 10,000, verified across every combination before locking):
    pct 2.0%  usd $150  -> pct=$200, eff $150   USD tighter
    pct 2.0%  usd $250  -> pct=$200, eff $200   percent tighter
    pct 2.0%  usd off   -> eff $200             percent only
    pct off   usd $150  -> eff $150             USD only
    pct 1.0%  usd $100  -> both $100, eff $100  TIE - same outcome, no ordering needed
    pct 5.0%  usd $50   -> pct=$500, eff $50    USD tighter
    pct off   usd off   -> NO CAP -> MUST REFUSE TO ARM, LOUDLY (see below)

THE BOTH-OFF CASE IS A GUARD, NOT A NO-OP. InpEnableDDClose true with BOTH limits at 0 must
  REFUSE to arm and SAY SO at init. Rationale: a silent no-op is EXACTLY the failure that
  created E9-R1 - the user believed a loss cap existed when none did. Both inputs default to
  0, so "enabled with no limit set" is the most likely misconfiguration and it must be the
  loudest.

b19 PRECEDENT CHECKED AND DOES NOT BLOCK THIS - recorded so it is not re-litigated:
  b19 reads "NOTIFY, never auto-close - a config error must not cost an open, exit-protected
  position money". In context that is about the EA closing positions because ITS OWN INPUTS
  WERE WRONG. A drawdown stop the trader DELIBERATELY ENABLES AND CONFIGURES is the opposite:
  an intentional risk instruction, not a config accident. No conflict.
  THE BOTH-OFF GUARD ABOVE IS b19-CONSISTENT: a misconfiguration refuses to arm rather than
  auto-closing on a meaningless threshold.

MACHINERY THAT ALREADY EXISTS AND IS SEALED - this build is mostly WIRING, not new engine:
  SequenceFloatingPnL() sums POSITION_PROFIT + POSITION_SWAP over tracked tickets. Per-symbol
    BY CONSTRUCTION, already used by the CLOSE SEQUENCE confirm preview.
  CloseSequenceAtMarket(reason) is the SEALED whole-sequence close, already used by the
    TP-exceeded and SL-exceeded rules, and it routes every leg through CloseLegAtMarket
    (the E4 X-4 shared path, with b42's no-send gate).
  => the fix adds an EVALUATOR and a GUARD, and reuses both sealed helpers unchanged.

STILL TO DECIDE AT GATE 2 (named now so the matrix covers them):
  - WHERE in the OnTick order does the check run? It must not fight the tiers or the
    TP/SL-exceeded rules, and the ordering decides who wins a tick where two could fire.
  - Does it include SWAP? SequenceFloatingPnL already does. Consistency says yes.
  - One-shot or re-armable after a close? (The sequence goes flat, so this may be moot.)
  - What the dashboard shows while armed, and the log line on fire (money numbers, per the
    observability rule: computed figures, never a bare "DD close fired").

## LOCKED DECISION E9-R1-D2 (how the cap is ENFORCED, Jeff 2026-10-05): CONVERT THE CAP TO
## AN SL PRICE THAT EVERY POSITION ADOPTS - NOT AN EA MARKET CLOSE.

JEFF'S TWO CLARIFICATIONS, BOTH ADOPTED:
  (1) When Drawdown Auto Close is enabled, InpStopLossPts CONCEDES - the DD-derived price
      becomes the stop. Two rules cannot both own the SL. On charts where InpStopLossPts = 0
      (which is most of Jeff's) the DD cap BECOMES the only stop, so it is load-bearing.
  (2) Rather than the EA closing at market, the cap is CONVERTED TO AN SL PRICE and written
      to every position in the sequence. The BROKER closes them when touched.

WHY (2) IS BETTER THAN THE EA-CLOSE DESIGN I PROPOSED, and it is not a close call:
  A market close only fires WHILE THE EA IS ALIVE AND TICKING. A broker-held SL fires even if
  MT5 is shut, the VPS drops, or the EA is detached. For a LOSS CAP that difference is the
  whole point - it is the same argument b27 makes about BE stops being broker-held rather
  than deferred. My original design would have left the cap unenforced exactly when it is
  most likely to be needed.

THE ARITHMETIC IS EXACT AND CLOSED FORM (verified before adopting): sequence P/L is LINEAR in
  price, so the boundary solves directly:
      SL = VWAP - dir * cap * point / (valuePerPointPerLot * totalLots)
  Worked example, 3 legs (4141.51/0.01, 4138.00/0.02, 4134.50/0.03), VWAP 4136.835,
  0.06 lots, cap $150 -> SL 4111.835, and PnL at that price checks to exactly -150.0000.

*** CORRECTION ON THE RECORD - I HAD THIS WRONG AND JEFF CAUGHT IT. ***
  I asserted "the DD stop must be RECOMPUTED on every structural change, because VWAP and
  total lots both move when a level opens". JEFF DISAGREED: that is TP logic, not SL logic.
  HE IS RIGHT, AND IT IS ALREADY A LOCKED DECISION IN THIS PROJECT (b24, Stage 8, in the code
  since then):
    SequenceState.manualSL: "PERSISTS across structure changes (locked: trader's risk
      statement + level budget); ends only on flat / re-edit / BE-trail supersession."
    ReleaseManualTP header: "Manual TP releases when the structure it was set against changes
      ... Manual SL has NO release path here by design (locked): it persists as the trader's
      risk statement and level budget."
    The adopt line: "tighter; note it also CAPS RECOVERY DEPTH (level budget)."
  WHY I WAS WRONG: a TP is a TARGET - when the structure moves the arithmetic behind the
  target moves, so it recomputes. An SL is a BOUNDARY - a price beyond which the trader has
  decided they are done. Recomputing it as levels open would mean THE LIMIT MOVES BECAUSE YOU
  ADDED RISK, which makes it not a limit; it would also silently extend the level budget every
  time, since the boundary is precisely what caps how deep recovery can go.

THEREFORE: the DD cap sets the SL price ONCE, WHEN IT ARMS, and that price PERSISTS across
  level adds like every other SL in this EA. New recovery levels ADOPT the same boundary.

CONSEQUENCE STATED PLAINLY SO IT IS OWNED DELIBERATELY: once levels are added below the
  boundary, the REALISED loss at that price EXCEEDS the original cap - more lots crossing the
  same distance. The boundary caps HOW FAR PRICE CAN GO AGAINST THE SEQUENCE, not the currency
  amount at the moment it is hit. That is the same property every anchored SL here already
  has, and it is exactly what "level budget" means: the boundary limits how many levels can be
  afforded. Jeff's framing: "SL is a boundary which tells that you can only create new
  positions until this price and if the market reached it that's our limit."

DISSOLVED BY THIS DECISION - no longer needs deciding: my question about what to do when the
  computed DD stop is UNPLACEABLE (inside the broker stops level). That hazard only arose from
  the recompute-every-level version, where the boundary could be dragged toward price. A
  boundary set ONCE, far from price, does not land inside the band. The existing deferral
  logic remains as the generic safety net.

SUPERSEDES the "(i) fire and forget" sub-decision: there is no EA-initiated fire at all now.
  The sequence closes because the BROKER filled the SL, and liveness attributes it as an SL
  hit via the sealed b20 ClosingDealReason path - no new close path, no new state.

## LOCKED DECISION E9-R1-D3 (WHERE the boundary goes, Jeff 2026-10-05) - SUPERSEDES the
## boundary-placement half of D2. THE SL IS DERIVED FROM THE FULL ANTICIPATED GRID.

JEFF'S CORRECTION: "There should be no new levels below the boundary." I had been solving the
boundary from the positions that EXIST NOW. Jeff solves it from the FULL ANTICIPATED RECOVERY
GRID: project every level the current settings will produce, find the level at which
CUMULATIVE drawdown reaches the cap, and place the SL there.
THE BOUNDARY IS NOT A LINE THAT LEVELS HAPPEN TO SIT ABOVE - IT IS PLACED AT THE EXACT LEVEL
WHERE THE BUDGET RUNS OUT. The ladder is DETERMINISTIC from InpRecoveryIntervalPts,
InpRecoveryMultMode, InpIncrementStep and InpDeferredStep, so the whole grid is computable at
arm time. (Jeff's external "Shadow Grid Visualizer & Drawdown Calculator" already does this.)

WORKED EXAMPLE, VERIFIED AGAINST JEFF'S SCREENSHOT (GBPJPY 4h, Vantage):
  SETTINGS: L1 lot 0.01, interval 37, Deferred Incremental, step 0.01, defer 2,
            DDClose ON, MaxDDPercent 2, MaxDDUSD 0.
  PROJECTED GRID (reproduced EXACTLY by recompute, all five prices and lots match):
    L1 208.663 0.01 | L2 208.293 0.01 | L3 207.923 0.02 | L4 207.553 0.02 | L5 207.183 0.03
    total 0.09 lots (screenshot: 0.09)
  DRAWDOWN OF L1..L4 WHEN PRICE REACHES L5's PRICE 207.183:
    L1 (207.183-208.663)*100000*0.01 = -1480.0 JPY
    L2 (207.183-208.293)*100000*0.01 = -1110.0 JPY
    L3 (207.183-207.923)*100000*0.02 = -1480.0 JPY
    L4 (207.183-207.553)*100000*0.02 =  -740.0 JPY
    TOTAL -4810.0 JPY ; at USDJPY ~158 that is -$30.44 = EXACTLY the screenshot's
    "Total DD: $-30.44 (-2%)", i.e. 2% of a ~$1,522 balance. ARITHMETIC CONFIRMED.
  => SL GOES AT 207.183 (L5's price), because the moment the market touches it, L1..L4 are
     ALREADY at the 2% cap.

L5 IS THE EDGE CASE AND JEFF ALREADY NAMED THE FIX: L5 opens AT 207.183 contributing $0 loss
  (his tool's own column confirms "L5 ... DD@L5: $0 (0%)"), so it is technically affordable -
  but if the SL sits EXACTLY there, the L5 fill and the stop collide. JEFF: "If you want to be
  safe cause L5 is also in the exact price then we can move the SL 1 pip above it."
  ADOPTED, and it is conservative in the RIGHT direction: the stop fires BEFORE L5 opens, so
  the loss is capped at -$30.44 on FOUR positions rather than five. Exact offset is a Gate 2
  row (1 pip vs 1 point vs broker stops level).

THIS DISSOLVES THE CONSEQUENCE I FLAGGED UNDER D2. I wrote: "once levels are added below the
  boundary, the realised loss at that price EXCEEDS the original cap". THAT CANNOT HAPPEN
  under D3 - levels are never added below the boundary, because the boundary IS the bottom of
  the affordable ladder. The 2% is honoured PRECISELY, not approximately. My D2 caveat is
  WITHDRAWN as an artifact of the now-superseded now-positions-only derivation.

WHAT MUST BE REUSED, NOT REIMPLEMENTED (the E9-P6 duplication hazard):
  the projection MUST drive the ladder through the SEALED ComputeLevelLot() and the SEALED
  ComputeRecoveryTrigger() interval logic. A second copy of the ladder maths that drifts from
  the engine would place the boundary at a price the engine never actually trades to. This is
  the single biggest build risk in R1 and it gets its own must-NOT row.

OPEN FOR GATE 2 (named now):
  - HOW MANY levels to project when InpMaxRecoveryTrades = 0 (unlimited)? The grid must
    terminate; the cap itself is the natural terminator (project until cumulative DD >= cap),
    but a hard iteration bound is still needed against pathological settings.
  - WHEN is the boundary computed? At L1 registration/adoption (the ladder is knowable then),
    and does it RE-derive if the trader changes inputs mid-sequence?
  - Guard C interaction: b16 requires non-decreasing recovery lots. A config that violates it
    is already refused at init, so the projection can ASSUME non-decreasing - verify, do not
    assume.
  - The b27 broker stops-level check still applies to the final price.
  - What the dashboard shows: the boundary price, and ideally the level count it affords.

## E9-R1 OFFSET UNIT - RESOLVED 2026-10-05 (Jeff flagged it: "cause this is a GBPJPY which
## have different pip placing"). THE OFFSET IS EXPRESSED IN POINTS, NEVER IN PIPS.
JEFF'S POINT: GBPJPY is a 3-decimal pair, so "1 pip" there is NOT the same absolute distance
as on a 5-decimal FX pair or on 2-decimal gold. An offset written as "1 pip" would mean a
different thing on every symbol he runs.

RESOLVED BY WHAT THE EA ALREADY IS: there is NO pip concept anywhere in TRTM - "pip" appears
ZERO times in 5224 lines. Every distance input is in POINTS (InpRecoveryIntervalPts,
InpStopLossPts, InpTrailDistPts, InpBEOffsetPts, InpBETriggerPts, InpMinTrailStepPts,
InpMaxSpreadPts, InpMaxDeviationPts) and every calculation multiplies by _Point, which MT5
sets per symbol. Points therefore normalise automatically; pips would need special-casing.

CONVERSION TABLE across the instruments actually in use (verified):
  symbol      digits  _Point     1 pip      1 pip in POINTS
  GBPJPY      3       0.001      0.01       10
  XAUUSD.s    2       0.01       0.1        10
  AUDNZD.s    5       0.00001    0.0001     10
  USDCAD.s    5       0.00001    0.0001     10
  => "1 pip" == 10 POINTS on ALL of them. The _Point VALUE differs; the POINT COUNT does not.

DECISION: the Gate 2 row and any input must read "offset N POINTS above the limit level",
defaulting to 10 (= 1 pip on every symbol above). On Jeff's GBPJPY example: L5 at 207.183,
offset 10 points = 0.010, boundary 207.193 - 1 pip above L5, so the stop fires BEFORE L5
opens and the loss is capped on L1..L4 at -$30.44 as intended.
GATE 2 STILL DECIDES whether the offset is a CONSTANT or a new input. Leaning constant: R1
already has three inputs and the Stage 1 convention froze the dialog layout, so adding a
fourth needs justifying rather than assuming.

## LOCKED CONVENTION (Jeff 2026-10-05): ALL DISTANCE INPUTS ARE IN POINTS, NEVER PIPS.
JEFF: "all our input requirement should be in points not in pips so it can have wide coverage
of instruments." CONFIRMED AS AN EXISTING INVARIANT, not a new rule - the audit found ALL
ELEVEN distance inputs already in points, every one carrying the `Pts` suffix, and the word
"pip" appearing ZERO times in TRTM.mq5. Recorded now so it is never broken by a future stage.
  IN POINTS (11): RecoveryIntervalPts, InitialTPPts, AvgTPPts, StopLossPts, BETriggerPts,
    BEOffsetPts, TrailDistPts, MinTrailStepPts, Tier1MinProfitPts, Tier3MinProfitPts,
    MaxSpreadPts, MaxDeviationPts, TesterNudgePts.
  CORRECTLY OTHER UNITS (no Pts suffix): lots (EntryLotSize, FixedRecoveryLot, Tier3MinLots),
    percent (RiskPercent, Tier2ProfitPercent, Tier3ClosePercent, MaxDDPercent), multipliers
    (MartingaleMult, IncrementStep), counts (DeferredStep, MinTrades, MaxRecoveryTrades),
    days (LogRetentionDays).
WHY POINTS WIN: a pip is NOT constant across TRTM's instruments - GBPJPY 3-decimal, gold
  2-decimal, most FX 5-decimal - so a pip-denominated input would need per-symbol
  special-casing. A POINT is whatever MT5's _Point reports for that symbol, so points
  normalise automatically and the same number means the same thing everywhere.
WHERE IT IS ENFORCED: written into .claude/rules/mql5-traps.md, which is PATH-SCOPED to
  **/*.mq5 and therefore auto-loads whenever EA source is edited. A convention buried in a
  4000-line state file gets missed; one that loads at edit time does not.
APPLIES TO E9-R1: the boundary offset is "N POINTS above the limit level", default 10
  (= 1 pip on GBPJPY, XAUUSD.s, AUDNZD.s and USDCAD.s alike).

## LOCKED DECISION E9-R1-D4 (Jeff 2026-10-05): THE BOUNDARY RE-DERIVES ON EVERY STRUCTURAL
## CHANGE. It is NOT frozen at L1. Jeff chose this AGAINST my recommendation, and he was right
## about the reason - he cited the two features my freeze proposal had not accounted for.

JEFF: "In consideration with other features like Bar close recovery entry and Drawdown
  Reduction, I'm leaning towards Re-derive on every structural change."
BOTH FEATURES VERIFIED PRESENT AND SEALED (I checked before describing anything):
  InpBarCloseEntry (line 104, DEFAULT TRUE) - recovery entries confirm on bar close.
  Drawdown Reduction Tiers E4/E5/E6 (lines 20-22, 123-133, dispatcher 2525) - these CLOSE
    LEGS, and Tier 3 closes a PARTIAL slice of the anchor.

WHY FREEZE WAS WRONG - THE DD TIERS DECIDE IT. The reduction tiers are ROUTINE, EA-INITIATED
  structural changes, not rare manual edits. Under a frozen boundary every tier firing would
  leave the stop anchored to a grid that no longer exists, and it drifts TIGHTER as the valves
  work. Worked case: L1..L4 live, boundary 207.193 sized for 4 legs at $30.44. Tier 1 closes
  L2+L3 for +$8 realised. The surviving L1+L4 lose only ~$22 at 207.193, so the trader has
  BANKED profit, still has budget, and yet the stop sits where four legs' loss was. The stop
  would fire early and kill a sequence the risk budget could still carry - defeating the exact
  purpose the reduction tiers exist for. MY FREEZE RECOMMENDATION IS WITHDRAWN.
BAR-CLOSE ENTRY'S ROLE: it makes the ladder confirmation-gated, so levels arrive on bar closes
  rather than ticks. Re-derive therefore has a naturally LOW-FREQUENCY clock, not a per-tick one.

RE-DERIVE TRIGGER SET - STRUCTURAL ONLY, NEVER PER TICK:
  RE-DERIVE on: a level opens (registers/adopts) | any leg closes (manual, TP, or DD-tier) |
    a Tier 3 PARTIAL close (lots change, ticket survives) | an input edit mid-sequence.
  DO NOT re-derive on: a new tick | a price move | a new bar with no structural change.
THE COMPUTATION EACH TIME:
  1. realised = P/L already banked this sequence
  2. remainingBudget = effectiveCap - |realised|      (effectiveCap = MIN of the two positive limits, D1)
  3. project the ladder FORWARD from the WORST SURVIVING ENTRY using the engine's own anchor
     + InpRecoveryIntervalPts, lots from the SEALED ComputeLevelLot(levelN)
  4. walk levels until cumulative DD >= remainingBudget
  5. boundary = that level's price, offset 10 POINTS on the safe side (points, never pips)
  6. write to every live leg via PositionModify

*** BLOCKER FOUND AT GATE 2 AND IT IS THE D3 DUPLICATION HAZARD MADE CONCRETE. ***
  ComputeRecoveryTrigger() (line 2227) CANNOT BE LOOPED TO PROJECT A GRID. Verified by reading
  it: it returns ONLY the NEXT single level, and it derives the anchor from the worst
  SURVIVING LIVE entry via PositionSelectByTicket. With only L1 open it cannot tell you where
  L5 will be. So the projection MUST walk the interval itself - which is precisely the second
  copy of the ladder maths D3 named as "the single biggest build risk in R1".
  ComputeLevelLot(levelN) IS reusable as-is (line 2081): levelN is a free parameter and it
  reads g_state.baseLot, so projected lots come from the sealed engine unchanged.
  => GATE 3 MUST extract the interval step into ONE shared helper used by BOTH
     ComputeRecoveryTrigger and the projection, so the two can never drift. A must-NOT row
     tests that the projected L-n price equals the price the engine actually trades to.

## LOCKED DECISION E9-R1-D5 (Jeff 2026-10-05): PURE RE-DERIVE - THE BOUNDARY MAY MOVE EITHER
## WAY, INCLUDING LOOSER. Chosen against my "ratchet" recommendation.
I recommended a ratchet (adopt only if TIGHTER, never retreat). Jeff chose pure re-derive.
HIS CHOICE IS THE ARITHMETICALLY FAITHFUL ONE: after the DD tiers bank a profit the sequence
  GENUINELY has more room, so the stop has earned the right to retreat. The cap then means
  "exactly 2% of what is still at risk" at all times, rather than "2% of the deepest grid
  this sequence ever had".
ACCEPTED CONSEQUENCES, recorded so neither is a surprise later:
  (1) THE STOP IS NOT MONOTONIC. A trader watching the line will see it move AWAY from price
      after a profitable tier close. This is correct behaviour, NOT a bug - it needs a clear
      log line stating realised P/L and remaining budget so the move is explainable.
  (2) The worst case is always EXACTLY the full cap, never less. A ratchet would often have
      ended better than the cap; pure re-derive spends the whole budget by design.
REJECTED (ratchet): would often stop a sequence tighter than the declared cap, wasting budget
  the reduction tiers had just freed - the same objection that killed the freeze option.

## LOCKED DECISION E9-R1-D6 (Jeff 2026-10-05): WHEN DDClose IS ENABLED THE DD BOUNDARY OWNS
## THE SL OUTRIGHT AND OVERWRITES A MANUAL SL. Chosen against my "tighter of the two" option.
JEFF'S CHOICE IS CONSISTENT WITH HIS OWN D2 CLARIFICATION ("InpStopLossPts CONCEDES - the
  DD-derived price becomes the stop. Two rules cannot both own the SL."). D6 extends that same
  single-owner principle from the INPUT stop to a HAND-PLACED stop. The cap is then absolute:
  nothing can loosen it and nothing can silently disable it, which is the failure class that
  created E9-R1 in the first place.
REJECTED (tighter-of-the-two, my recommendation): would honour b24 AND the cap, but it makes
  SL ownership conditional and therefore harder to reason about on a live chart.
REJECTED (manual always wins): a hand edit could silently exceed the declared cap.

*** CONSEQUENCE I OWE JEFF BEFORE THIS REACHES CODE - D6 IS IN TENSION WITH b24. ***
  b24 locks: "manual TP releases on structural change; manual SL PERSISTS" - rationale
  "trader's risk statement + level budget". D6 says the DD boundary overwrites that manual SL.
  THE REAL COST IS NARROW BUT SHARP: if the trader hand-sets a TIGHTER stop (say 207.500 when
  the boundary is 207.193), D6 OVERWRITES IT WITH A LOOSER PRICE. The EA would be undoing a
  deliberate decision to risk LESS, and loosening a stop is the one direction that costs money.
  SCOPE OF THE TENSION: b24 is NOT globally overridden. D6 applies ONLY while
  InpEnableDDClose is true. With DDClose off, b24's manual-SL-persists rule is untouched.
  => GATE 2 CARRIES THIS AS AN EXPLICIT ROW so the behaviour is tested, visible, and Jeff can
     revisit it on evidence rather than discovering it live. It must also LOG LOUDLY whenever
     it overwrites a tighter manual stop - a silent loosening is unacceptable even when locked.

## E9-R1 GATE 2 DRAFTED 2026-10-05: docs/R1_MATRIX.md, 51 ROWS, 6 GROUPS, AWAITING JEFF'S SEAL.
NO CODE until sealed (CLAUDE.md section 2). Groups: A arming/config (9), B grid projection (10),
C writing the SL (9), D re-derive triggers (10), E restart/state (5), F observability +
must-NOT regressions (8). 12 absence-type / must-NOT rows. Every locked decision D1-D6 has at
least one row that FAILS if the decision were implemented backwards.
THE DECISIVE ROW IS B-3 (the D3 duplication hazard): the projected L-n price must EQUAL the
price the engine actually trades to, verified by comparing the projection against the engine's
live trigger as each level opens. Gate 3 must extract ONE shared interval helper.
FOUR OPEN ITEMS CARRIED TO THE SEAL: (1) the 200-level iteration bound for
InpMaxRecoveryTrades=0; (2) offset constant vs a fourth input (matrix assumes constant 10
points); (3) C-5 visibility, the row where D6 loosens a tighter manual stop; (4) whether the
boundary is persisted or derived-only (recommend derived-only - no schema bump, and D4
re-derives at init anyway per E-1).
MACHINERY CONFIRMED REUSABLE BY READING IT, not assumed:
  ComputeLevelLot(levelN) 2081 - levelN is a free parameter, reads g_state.baseLot => REUSABLE
    AS-IS for projected lots, including its VOLUME_MAX/step/min clamping (matrix B-7).
  ComputeRecoveryTrigger 2227 - NOT loopable (returns only the NEXT level, anchored on the
    worst SURVIVING live entry via PositionSelectByTicket) => the blocker recorded in D4.
  SequenceFloatingPnL 3753 - sums POSITION_PROFIT + POSITION_SWAP, per-symbol by construction.
  BrokerStopsLevelPts 3533 - reuse for the C-6 stops-level clamp.
  Tick-value idiom (SYMBOL_TRADE_TICK_VALUE / TICK_SIZE with a tickSz<=0 -> _Point fallback,
    pattern at 2176-2179) - reuse for money-per-point; NO new money maths needed.
  Guard C VERIFIED enforced in three places (init 4808/4850, door 3389, per-level 2374), so
    matrix B-8 may assume non-decreasing lots - D3 said verify, do not assume. Verified.

## E9-R1 GATE 2 SEALED by Jeff 2026-10-05 ("sealed"). docs/R1_MATRIX.md rev 1, 51 rows.
FOUR OPEN ITEMS CARRIED ON THE STATED RECOMMENDATIONS (Jeff sealed without redirecting them),
now BINDING: (1) hard 200-level iteration bound when InpMaxRecoveryTrades=0, REFUSE TO ARM if
hit rather than truncate - a truncated grid puts the boundary where the engine would trade
straight through; (2) offset is a CONSTANT 10 points, NOT a fourth input; (3) C-5 stands as
locked per D6; (4) the boundary is DERIVED-ONLY, never persisted - no v5 schema bump.

## E9-R1 GATE 3 DRAFTED: docs/R1_PLAN_2026-10-05_gate3.md, target b45, +200..+240 lines.
*** THE CENTRAL FINDING: THE EA ALREADY HAS A STRUCTURAL-CHANGE CONCEPT AND IT ALREADY FIRES AT
EXACTLY THE EVENTS D4 NEEDS. *** b24's ReleaseManualTP(trigger) is called at level REGISTER
(2777), at the liveness PRUNE behind the `changed` flag (1028), and at the death-window offline
close (2906). The re-derive hook RIDES THAT EXISTING PATH rather than inventing a parallel one,
which makes matrix D-2 (no per-tick re-derive) and D-3 (no per-bar) true BY CONSTRUCTION instead
of by a guard that could be forgotten.

*** THE ONE GAP, AND IT IS ROW D-6 - FOUND BY READING THE SLICE PATH, NOT ASSUMED. ***
A TIER 3 PARTIAL CLOSE PASSES THROUGH NEITHER CHOKEPOINT. At 1645 PositionClosePartial
succeeds, the TICKET SURVIVES, levelCount is UNCHANGED, and NO ReleaseManualTP fires. Riding the
b24 hook alone would SILENTLY MISS D-6: the boundary would keep using PRE-SLICE lots, sit TOO
FAR from price, and UNDER-ENFORCE the cap - a loss cap quietly WIDER than the declared 2%.
=> Tier 3 gets its OWN explicit hook at 1656 (verified: that line is the post-success log and
the ticket is still selectable there). This is the single most important line in the plan.

B-3 ANTI-DUPLICATION MECHANISM (the biggest build risk, D3): extract the interval step from
ComputeRecoveryTrigger (lines 2256-2257, verified) into ONE shared helper NextLadderPrice(dir,
fromPrice), and REWRITE ComputeRecoveryTrigger to call it. Engine and projection then cannot
drift because only ONE copy of the interval maths exists.

VALIDATION SCOPE DECISION recorded: the A-6/A-7 refusal does NOT set g_configBlocked. b17's
config-block is a FULL TRADING FREEZE; a misconfigured DD cap must not freeze a live sequence
that other rules still protect. It refuses to ARM, loudly. b19-consistent.

## *** CORRECTION 2026-10-05: THE D3 WORKED EXAMPLE RECORDED THE INTERVAL IN THE WRONG UNIT.
## FOUND BY RECOMPUTING THE FIXTURE DURING THE b45 BUILD, NOT BY INSPECTION. ***
D3 records Jeff's GBPJPY settings as "Recovery Interval = 37" and claims the grid was
"reproduced EXACTLY by recompute". IT WAS NOT. Recomputing from 37 POINTS gives:
  L1 208.663 L2 208.626 L3 208.589 L4 208.552 L5 208.515, total DD L1..L4 = $3.04
versus the screenshot's L2 208.293 / L5 207.183 and -$30.44. WRONG BY EXACTLY 10x in BOTH
price spacing AND money - the signature of a points/pips unit error.
RECOMPUTED AT 370 POINTS (= 0.370 on a 3-digit pair) - EXACT MATCH ON EVERY FIGURE:
  L1 208.663 | L2 208.293 | L3 207.923 | L4 207.553 | L5 207.183   (all five, to the digit)
  lots 0.01 / 0.01 / 0.02 / 0.02 / 0.03, total 0.09
  DD L1..L4 at 207.183 = $30.4430 and 4810.0 JPY -> matches "Total DD: $-30.44" and the
  -4810.0 JPY intermediate EXACTLY.
WHAT ACTUALLY HAPPENED: "37" came from Jeff's external Shadow Grid Visualizer, which is
PIP-denominated. 37 pips on GBPJPY = 370 POINTS. The EA's InpRecoveryIntervalPts is in POINTS,
so to reproduce that grid the EA input must read 370, NOT 37.
*** THIS IS A LIVE INSTANCE OF THE EXACT HAZARD THE POINTS CONVENTION EXISTS TO CATCH, and it
reached a SEALED locked-decision document. *** It is also why the convention is enforced in a
path-scoped rules file rather than only in prose: the number looked plausible and survived a
seal. The arithmetic caught it; reading did not.
NO CODE CONSEQUENCE IN b45: the EA has always been points-only and NextLadderPrice multiplies
InpRecoveryIntervalPts by _Point, so the engine and the projection were both already correct.
THE ERROR WAS IN THE RECORDED EXAMPLE, NOT IN THE CODE OR THE DESIGN.
*** OPERATIONAL CONSEQUENCE FOR JEFF - CHECK THE LIVE CHARTS: *** if any instance has
InpRecoveryIntervalPts set from a pip-denominated figure, its ladder is 10x TIGHTER than
intended on 3- and 5-digit symbols. On GBPJPY, 37 would space levels 3.7 pips apart instead of
37. b45's Gate 4 must confirm the GBPJPY instance reads 370.
MATRIX IMPACT: B-1's expected boundary of 207.193 STANDS (207.183 + 10 points = 207.193), but
it holds only with the interval input at 370. The B-1 row now states the unit explicitly.

## b45 BUILT 2026-10-05 - GATE ZERO PENDING (Jeff compiles). 5659 lines, e5516ee1ce06dcde.
LINE DELTA +435 vs b44's 5224, against a Gate 3 ESTIMATE of +200..+240. I UNDERSHOT BY ~2x
and the reason is worth keeping: the estimate counted CODE and not the COMMENT BLOCKS. The R1
block carries the full D1-D6 rationale inline (why a broker-held SL beats an EA close, why the
projection must not own ladder maths, why the A-6 guard must not set g_configBlocked), plus the
D-6 Tier 3 explanation at its hook. That is deliberate - the next person to touch EnforceExits
must not have to find STATE.md to learn that the DD boundary owns the SL on purpose - but
future estimates should count comment lines explicitly rather than treating them as rounding.
WHAT WAS BUILT, 12 touch points as planned:
  1 NextLadderPrice()        2309 - THE single copy of the interval step (B-3). ComputeRecoveryTrigger
      was REWRITTEN to call it, so engine and projection cannot drift. This is the whole B-3 mitigation.
  2 DD_OFFSET_PTS 10 / DD_MAX_PROJECT 200 - constants, resolved at seal (not a 4th input).
  3 EffectiveDDCap()         3877 - MIN of the positive limits, 0.0 = not armed (A-2..A-5).
  4 MoneyPerPointPerLot()    3897 - the EXISTING tick-value idiom, no new money maths.
  5 SequenceRealisedLoss()   3914 - banked P/L from deal history since adoptionTime, filtered on
      magic + symbol. A net PROFIT returns negative, which WIDENS the budget - that IS D5.
  6 DDBoundaryPrice()        3945 - the projection. Anchors on the WORST SURVIVING entry (D-4),
      lots from SEALED ComputeLevelLot (B-2/B-7), spacing from NextLadderPrice (B-3), terminators
      input-cap (B-4) / budget / 200-bound-refuses (B-5), wrong-side guard (B-6), offset signed
      per direction (B-10), closeNow for a spent budget (D-9).
  7 AnnounceDDBoundary()     4072 - observability only, NO writes. Called from the FOUR structural
      sites and never from OnTick, which is what makes D-2/D-3 true BY CONSTRUCTION.
  8 EnforceExits injection   ~1838 - *** THE DESIGN CHANGE vs THE PLAN, AND IT IS A SIMPLIFICATION.
      The plan proposed a separate ApplyDDBoundary() writer. Reading the sealed modify loop showed
      it ALREADY does everything that writer needed: per-ticket idempotence (C-8), the
      TradeTargetLive no-send gate (C-7/E-4), min-distance deferral (C-6), retry+backoff, and the
      SL-exceeded market close. So the boundary is INJECTED INTO `sl` upstream of all of it and the
      SEALED loop writes it. One writer owns the SL, which is literally what D2/D6 demand ("two
      rules cannot both own the SL"), and ~60 lines of duplicated write/retry logic never existed.
      A second writer would also have FOUGHT the first one for the SL every tick.
  9 ValidateInputs guard     ~5265 - A-6/A-7. DELIBERATELY does not touch `ok`, so a bad DD cap
      does NOT set g_configBlocked (a full trading freeze) on a sequence other rules still protect.
 10 Dashboard "DD Cap SL" row ~4518 - boundary price + cap + levels afforded (F-1); absent when
      disabled (F-2); shows "NOT ARMED (no limit set)" for the A-6 case, making E9-R1 VISIBLE.
 11 README rewritten - the "you did not have a loss cap" warning replaced with shipped behaviour,
      including both surprises stated plainly (it overwrites a manual SL; the stop can retreat).
 12 Manifest + this record.
SELF-AUDIT BEFORE HANDING OVER (each checked, not assumed):
  ZERO Result*() reads in the entire R1 block -> no E9-Q3 exposure in new code.
  Both divisions are by _Point (MT5 guarantees non-zero); mpp is guarded before use; remaining<=0
    returns before any division (D-9).
  "pip" occurrences back to ZERO after rewording my own comment - the convention's own check
    stays usable.
  Brace delta -1 matches b44 EXACTLY (it is the `json += "}"` string literal, pre-existing).
  MQL5 is SINGLE-PASS: forward declarations added at 693 for AnnounceDDBoundary, EffectiveDDCap,
    SequenceRealisedLoss and DDBoundaryPrice, because EnforceExits (1838) calls all four from
    ABOVE their definitions. Without these the build does not compile.
  check_hygiene HOOK CAUGHT A REAL DEFECT: my edits wrote LF endings where MetaEditor needs
    CRLF. It failed (exit 2), I rebuilt the endings uniformly and matched b44's no-trailing-
    newline final byte exactly, and it now passes (exit 0). THE HOOK EARNED ITS KEEP - that
    would have been a compile failure on Jeff's machine, not a style nit.

## b45 GATE ZERO PASSED 2026-10-05 15:50:08 (Jeff compiled). XAUUSD.s M5, XAUUSDS, magic 715358.
"=== TRTM b45 init ===" so the bumped tag PROVES b45 is the file that ran. Self-test PASS (v5
schema round-trips, nothing broken). "Reconcile complete: FLAT" - genuine flat, no fixture, clean
baseline. Broker stops level 50 pts / freeze 0 (relevant to matrix C-6). NO ERROR, NO WARN.
TWO ROWS CLOSED ON THIS RUN, both absence-type:
  A-1 PASS - InpEnableDDClose is FALSE on this chart and there is NOT ONE DD log line. The
    feature is fully inert when off.
  F-7 PARTIAL - no per-tick DD traffic appeared.
AND ONE CORRECT SILENCE: AnnounceDDBoundary("init (restart re-derive)") is CALLED at OnInit but
  printed nothing, because the sequence is flat. That is the levelCount==0 guard working, NOT a
  missing call - worth recording so a future reader does not "fix" it.
*** SCOPE OF WHAT THIS PROVES: b45 LOADS AND DOES NO HARM. It verifies NOTHING about the cap
itself - DDClose is off and the chart is flat, so DDBoundaryPrice never executed. 49 of 52 rows
remain unverified. Do not let a clean init read as a working feature. ***

## b45 GATE 4 TEST PROCEDURE WRITTEN: docs/R1_TEST_PROCEDURE_b45.md (audience: Jeff at the
terminal). Four phases, ordered by RISK, cheapest and safest first:
  PHASE 1 - config guards, FLAT, ZERO RISK, no trades at all: A-6 (the E9-R1 failure itself),
    A-7 negative, A-2 percent only, A-3 USD only, A-4 both-lower-wins, A-5 tie, A-1 off.
  PHASE 2 - live sequence, real SL writes: B-1/B-2/C-1/C-3/F-1/F-3 on L1, C-2 concede,
    C-8+D-2+D-3 idempotence by absence, D-1/B-3 on L2, C-4/C-5 manual SL overwrite, D-10 flat.
  PHASE 3 - restart: E-1/E-2/E-4.
  PHASE 4 - the DD tiers: D-5/D-6/D-7. D-6 is the Gate 3 gap and the procedure says to report a
    MISSING Tier 3 line immediately - its absence means the cap is silently WIDER than set.
  BY INSPECTION (not Jeff's work): B-5, B-7, B-8, B-9, E-5, F-4, F-5, F-6.
TWO THINGS THE PROCEDURE PUTS FIRST, deliberately:
  (1) CHECK InpRecoveryIntervalPts ON THE LIVE GBPJPY CHART (matrix B-11). 37 would mean the
      ladder spaces levels 3.7 pips apart instead of 37 - a LIVE CONFIG issue independent of b45,
      and it would also make every GBPJPY boundary test read wrong.
  (2) Screenshots are MANDATORY on 1A/1C/1G and 2A: the DD Cap row is observable ONLY on screen
      and PanelDestroy() erases it on detach - the same lesson b44's A-7 taught.
PHASE 2 CARRIES AN EXPLICIT RISK STATEMENT rather than burying it: it opens a real position and
  lets the EA write a stop. Demo or minimum lot. InpStopLossPts is set to 300 ON PURPOSE so C-2
  can prove it concedes rather than being untested.

## b45 PHASE 1 RESULTS 2026-10-05 - A-6, A-4 and A-1 PASS ON LIVE EVIDENCE. Jeff ran 1A/1E/1G.
Source: the EA's OWN log, read directly from the live MT5 tree
(MQL5/Files/TRTM/log_XAUUSDS_715358_20261005.log). Jeff named a file I could not see, but the
EA writes its own, so no transcription was needed - Claude READS the MT5 tree, only WRITING is
denied. Worth keeping: the EA's own log is the better evidence channel for these phases.
XAUUSD.s M5, XAUUSDS, magic 715358, balance 2649.18. Four b45 inits in sequence, flat throughout,
NO position ever opened - zero risk, exactly as the procedure promised.

A-6 PASS (10:55:44) - THE E9-R1 DEFECT ITSELF, NOW LOUD. With InpEnableDDClose true and BOTH
  limits 0 the init printed, as LOG_ERROR:
    "Drawdown Auto Close is ENABLED but BOTH limits are 0 (Max DD in % of Balance = 0, Max DD in
     USD = 0) - there is NO cap to enforce, so NOTHING will fire. THE DRAWDOWN CAP IS NOT ARMED.
     Set Max DD in % of Balance (e.g. 2) or Max DD in USD."
  Correct LEVEL (ERROR, not INFO) and correct PLACEMENT - it lands BEFORE the self-test line,
  i.e. inside ValidateInputs, which is where the arming decision belongs.
  *** AND THE SCOPE DECISION IS PROVEN: "Init complete - b45 (adoption, exits, recovery active)"
  on the SAME run. The EA did NOT config-block. A misconfigured DD cap refuses to ARM and
  everything else keeps running - the deliberate choice recorded at Gate 3, now evidenced
  rather than asserted. THIS IS THE ROW THE WHOLE BUILD EXISTS FOR: on 2026-09-xx this exact
  configuration was SILENT and Jeff believed he had a 2% loss cap.

A-4 PASS (10:56:56) - BOTH LIMITS SET, LOWER WINS, AUDITED TO THE CENT:
    "Drawdown Auto Close ARMED: effective cap $20.00 (percent limit $52.98 (2.00% of balance
     2649.18) vs USD limit $20.00 -> the LOWER (tighter) wins). Enforced as a BOUNDARY SL every
     position adopts (broker-held, so it fires even if MT5 is closed). Stop Loss (points)
     concedes to this boundary while enabled."
  RECOMPUTED INDEPENDENTLY: 2649.18 * 0.02 = 52.9836 -> $52.98 as logged. MIN(52.98, 20.00) =
  20.00 as logged. The percent limit is genuinely the LOOSER one here (52.98 > 20.00), so this
  is a REAL test of the MIN rule and not a coincidence - a buggy "percent always wins" would
  have printed 52.98 and been caught. Both candidates named, the winner named, the reason named.
  A-2 (percent-only) and A-3 (USD-only) are NOT closed by this run - this is the both-set row.

A-1 PASS, absence (10:57:37) - InpEnableDDClose back to false: NOT ONE DD line in the whole
  init. Stronger than the Gate Zero instance because the row had been VISIBLE in the two runs
  immediately before, so this proves the feature goes fully inert again, not merely that it
  never started.

NOT YET VERIFIED and NOT to be inferred from the above: A-7 (negative limit), A-2, A-3, A-5
  (tie), and F-1/F-2 - the DASHBOARD rows. The dashboard is observable ONLY on screen and no
  screenshot arrived, so F-1/F-2 stay OPEN regardless of how the log reads.

## b45 F-1 and F-2 PASS ON SCREEN 2026-10-05 (Jeff's 1A and 1E dashboard screenshots).
These rows are observable ONLY on the dashboard - PanelDestroy() erases the panel on detach, so
they can never be closed from a log. Captured before detaching, the b44 A-7 lesson applied.

F-2 PASS (1A capture, both-limits-0) - "DD Cap SL   NOT ARMED (no limit set)" rendered in AMBER
  (COL_WARN), and *** THE FOUR ORDER BUTTONS ARE GREEN AND CLICKABLE *** - BUY, SELL, PEND BUY,
  PEND SELL all live. This is the A-6 scope decision VISIBLE ON SCREEN rather than inferred from
  a log line: the cap refuses to arm while trading stays fully enabled. Amber is the WARNING
  colour, not the disabled colour, which is the correct b14 language (gray = config-blocked, and
  nothing here is gray). The E9-R1 failure is now impossible to miss at a glance.
F-1 PASS (1E capture, pct 2 + usd 20) - "DD Cap SL   $20.00 cap (flat)" in GREEN (COL_BUY_ARM).
  The dashboard INDEPENDENTLY reports the same effective cap the log computed via
  MIN($52.98, $20.00) - two separate code paths (PanelRefresh's own EffectiveDDCap call vs
  ValidateInputs') agreeing on one number. The "(flat)" suffix is the levelCount==0 branch, which
  is correct: no sequence exists, so there is no boundary price to show yet.
RIDE-ALONG OBSERVATION, worth keeping: both captures show "Interval  300 pts - max -", i.e.
  XAUUSD.s reads 300 POINTS and the dashboard renders the unit explicitly. The points convention
  holds on screen, not just in the inputs. (This is XAUUSD.s, NOT the GBPJPY instance B-11 is
  about - that one is still unchecked.)
PHASE 1 DISPOSITION: A-1, A-4, A-6, F-1, F-2 CLOSED on live evidence (5 rows).
  STILL OPEN from Phase 1: A-2 (percent only), A-3 (USD only), A-5 (tie), A-7 (negative).
  None of these is implied by the rows above - A-4 exercises the BOTH-SET path only.

## *** LOCKED DECISION E9-R1-D7 (Jeff 2026-10-05): THE BOUNDARY IS SOLVED TO THE EXACT PRICE
## WHERE DRAWDOWN EQUALS THE CAP. It is NOT snapped to a projected level. ***
FOUND BEFORE PHASE 2 RAN, by precomputing what the XAUUSD.s boundary SHOULD be so Jeff could
check the EA against an independent number instead of taking its word. The precompute exposed
a defect in b45's own logic - the test design caught it, not the test.

THE DEFECT IN b45 AS BUILT: DDBoundaryPrice walks the ladder and stops at the FIRST level whose
cumulative DD >= the budget. When the budget runs out BETWEEN two levels, that level OVERSHOOTS.
  WORKED CASE, XAUUSD.s, cap $20, L1 BUY 0.01 @ 4000.00, interval 300 pts, Incremental +0.01
  (money per point per 1.00 lot = $1.00, so $0.01/pt on a 0.01 lot):
    L2 @ 3997.00 -> cumulative DD $3.00
    L3 @ 3994.00 -> cumulative DD $12.00    budget NOT yet spent
    L4 @ 3991.00 -> cumulative DD $30.00    <- b45 puts the boundary HERE
  => a $20 cap would realise a $30 LOSS. 50% over the declared number, and worse on wider
  intervals or steeper lot ladders. "Max DD in USD = 20" would not mean 20.

WHY D3's EXAMPLE NEVER EXPOSED IT: Jeff's GBPJPY grid spent its budget EXACTLY at a level
  (DD at L5's price = $30.44 = exactly 2%). A boundary snapped to that level IS the exact
  answer there, so level-snapping and exact-solving agree on that one fixture and disagree
  everywhere else. A worked example that lands on a boundary cannot test the general case.

D3 ALREADY DEMANDED OPTION C IN WORDS - this is a correction to the CODE, not to the decision:
  "the boundary IS the bottom of the affordable ladder. The 2% is honoured PRECISELY, not
  approximately." b45 honoured it approximately.

THE FIX: find the BRACKET (the last level whose DD is under budget, and the next one that would
  exceed it), then SOLVE the closed-form price inside that bracket over the legs open AT THAT
  DEPTH. The arithmetic is the one already recorded in D2 - sequence P/L is LINEAR in price
  between levels, because no new leg opens inside a bracket:
      price = bracketPrice - dir * (remainingAtBracket) / (mpp * lotsOpenInBracket) * _Point
  Worked on the case above: at L3 (3994.00) DD is $12, 0.03 lots are open, $8 of budget remains,
  $8 / (0.03 * $1.00/pt) = 266.67 pts -> 267 pts -> 3994.00 - 2.67 = 3991.33, then the 10-point
  offset -> 3991.43. Realised loss at that stop = EXACTLY $20.00.
REJECTED (B) snap to the PREVIOUS level (L3, $12): never exceeds the cap, simplest change, but
  leaves 40% of the budget unspent in this case and kills the sequence earlier than the risk
  statement requires.
REJECTED (A) keep b45 as built: the realised loss exceeds the number the trader set, which is
  the one direction a LOSS CAP must never err in.
EQUIVALENCE CHECK (required of the fix): on D3's GBPJPY fixture, where the budget lands exactly
  on L5, option C MUST still return 207.183 + 10 pts. If it does not, the solve is wrong.

## *** b46 2026-10-05: TWO REAL DEFECTS IN b45's PROJECTION, BOTH FOUND BEFORE PHASE 2 RAN. ***
Neither was found by running the test. They were found by PRECOMPUTING what the boundary SHOULD
be so Jeff could check the EA against an independent number. THE TEST DESIGN CAUGHT THEM, and
that is the whole argument for computing expected values before a live run rather than after.

DEFECT 1 - BOUNDARY SNAPPED TO A LEVEL AND OVERSHOT THE CAP (fixed per locked D7, option C).
  b45 stopped at the FIRST level whose cumulative DD >= budget. When the budget runs out BETWEEN
  levels that level overshoots: on XAUUSD.s with a $20 cap the stop landed where the loss was
  $30. Now SOLVED in closed form inside the bracket - P/L is linear between levels because no
  leg opens there - so the realised loss equals the cap EXACTLY.

*** DEFECT 2 - OFF-BY-ONE: EVERY PROJECTED LEG WAS OPENED AT THE PRICE OF THE LEVEL ABOVE IT. ***
  THE MORE SERIOUS OF THE TWO, and it would have been invisible without the D7 equivalence check.
  b45 did: open leg at px -> THEN step. So L2 was recorded at L1's entry, L3 at L2's, and so on.
  Entries too HIGH => losses OVERSTATED => the boundary sat TOO CLOSE TO PRICE and would have
  stopped the sequence out EARLY, far short of the budget the trader allocated.
  CAUGHT BY ARITHMETIC, not by reading: the b45 loop made the DD at GBPJPY L4's price read
  $28.10, where Jeff's own fixture proves it is $16.39. Nearly double.
  THE b45 LADDER vs THE TRUTH (GBPJPY fixture, DD at each level price):
      level price   b45 read    TRUTH (Jeff's fixture)
      208.293       $4.68       $2.34
      207.923       $14.05      $7.03
      207.553       $28.10      $16.39
      207.183       $49.18      $30.44   <- the recorded, screenshot-confirmed figure
  FIX: STEP FIRST, THEN OPEN. The engine opens L(n+1) only once price has TRAVELLED the
  interval, so the projection must do the same.

BOTH FIXES VERIFIED BY SIMULATING THE EXACT b46 LOOP AGAINST BOTH FIXTURES:
  GBPJPY (D7 equivalence, the REQUIRED check): DD walk now reads
    $0.00 -> $2.34 -> $7.03 -> $16.39 -> $30.44, MATCHING Jeff's fixture at every step, and
    solves to 207.1830 - D3's answer to the digit. Loss at that price $30.4430 = the cap.
    *** EQUIVALENCE HOLDS. *** This is exactly what D7 demanded of the fix.
  XAUUSD.s cap $20, interval 300, Incremental +0.01, L1 0.01 @ 4000.00:
    $0 -> $3 -> $12 -> $30, bracket solve -> 3992.0000, loss there EXACTLY $20.0000,
    boundary with the 10-point offset = 3992.10.

WHAT THIS SAYS ABOUT b45's GATE ZERO PASS: a clean compile and a clean init proved only that
  b45 LOADED. The projection never executed (flat chart, DDClose off), so neither defect could
  surface. The five rows closed in Phase 1 (A-1/A-4/A-6/F-1/F-2) are all CONFIG-path rows and
  REMAIN VALID - none of them touches DDBoundaryPrice. Nothing is withdrawn.
BUILD: b46, sha256_16 df5d2ae97c3137a7, 5701 lines (b45 was e5516ee1ce06dcde / 5659, +42).
  GATE ZERO PENDING - Jeff compiles.

## b46 GATE ZERO PASSED 2026-10-05 16:36:34. XAUUSD.s M5, XAUUSDS, magic 715358, balance 2649.18.
"=== TRTM b46 init ===" confirms the bumped tag ran. Self-test PASS (v5 schema intact after the
D7 changes). Reconcile FLAT, state file a clean flat marker (levelCount 0, tickets []). Cap
re-armed with IDENTICAL arithmetic to the b45 run: "$20.00 (percent limit $52.98 (2.00% of
balance 2649.18) vs USD limit $20.00 -> the LOWER (tighter) wins)". NO ERROR, NO WARN.
WHAT THIS DOES AND DOES NOT PROVE: it proves b46 compiles and loads and that the b46 edits did
NOT disturb the config path - A-4's arithmetic is byte-identical across both builds, which is
the regression check that matters most after touching DDBoundaryPrice. It proves NOTHING about
the projection: the chart is FLAT, so DDBoundaryPrice still has not executed once on live data.
B-12 and B-13 remain UNVERIFIED on the terminal; both are so far only proven by simulation.
