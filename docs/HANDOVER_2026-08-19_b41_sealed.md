# TRTM Handover - 2026-08-19 (b41 SEALED)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md's header (AUTHORITATIVE - not this file):
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT d2354c4c1269874e  (b41)
   - wc -l src/TRTM.mq5                      EXPECT 5063            (b41)
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   Report "repo and runtime aligned at b41" in one line. b41 was DEPLOYED 2026-08-19 on a
   FLAT sequence, so any mismatch is a real STOP.
   NOTE on wc -l: PowerShell's Measure-Object -Line UNDERCOUNTS this file. Count LF bytes
   (or use git/wc). The sha256 is the byte-level backstop and it is what settles disputes.
   (Prior identities: b40 = 2e902e9032d820a9 / 4974; b39 = 12c69766c709bd0d / 4939.)
2. E1, E4, E5, E6, b39, b40 and b41 are ALL SEALED. Do NOT re-open them.

## 2. WHERE THE PROJECT STANDS
- CORE + E1/E4/E5/E6 SEALED. b39 SEALED (its watcher caveat RETIRED 2026-08-18 on live
  evidence). b40 documentation-only. b41 SEALED 2026-08-19.
- NOT PUSHED: as of this handover there are ~18 local-only commits. origin/main was at
  854c077 before this session. Verify with `git log --oneline origin/main..HEAD`.
  PUSHING IS JEFF'S CALL - ask before doing it.
- RUN H IS DONE (2026-08-18). The oldest debt in the project is closed.

## 3. WHAT b41 IS
E9-M1: ReconcileManualExits adopted the EA's OWN last-applied TP as a trader edit after a
restart (found by Run H). Fixed by PERSISTING lastAppliedTP/SL (state schema 4 -> 5) so the
sealed b25/M7-8 discriminator can see across an init. The new test is inserted AFTER M7-8's
and never replaces it - order must not be swapped (matrix B-3).
  4974 -> 5063 lines (+89). NO new input, NO new global. TWO new persisted fields.

## 4. THE K-4 SCOPE CUT - READ THIS BEFORE TOUCHING TIER 3
b41 was PLANNED to also fix K-4 (a Tier 3 slice BLANKS the surviving anchor's _lN_ comment).
GATE ZERO REJECTED IT: CTrade CANNOT comment a close. PositionClosePartial's third parameter
is a ulong DEVIATION and the implementation never sets m_request.comment. The Gate 3 plan
asserted an overload existed and did not verify it - that was a planning error, and the
compile warning was the defect, not a nit.
  ROWS A-1..A-8 ARE NEITHER CLOSED NOR FAILED. They were not attempted.
  K-4 IS PARKED TO E9, with O6. The only fix route is a hand-built MqlTradeRequest +
  OrderSend - a SECOND close path, which the sealed E4 X-4 rationale avoided.
  WHY THAT IS ACCEPTABLE TODAY: b39's O2b already contains it (an unparseable tag gets
  maxLvl+1, never 0), proven by Run H's restart rebuilding correctly from a blank comment.
  RESIDUAL RISK: on a restart that scans the sliced anchor AFTER other levels it gets a HIGH
  level, so FormBasketGroup anchors on the wrong position (SL anchoring + next slice target).
  Volumes and entries are read live, so TP/PL arithmetic stays correct.
BuildLevelTag was KEPT - the eventual E9 fix will call exactly it.

## 5. b41 GATE 4 EVIDENCE (STATE.md holds the full record)
tests/2026.08.19 212941.548..txt, Doo XAUUSD.s, magic 715358, live M1.
  B-1 PASS - the row Run H failed. EA applied its own TP 4457.93 to four tickets, restarted
      26s later, and reconcile did NOT log "adopted as manual (M7-5)". Structure rebuilt
      identically (4 levels / 0.26 lots). Proven by the ABSENCE of the adoption line.
  B-2 PASS on EQUIVALENT evidence - a TP removal was REVERTED and a real edit ADOPTED, back
      to back, so the fix is a discriminator not blanket suppression. Qualified honestly:
      the edits were made LIVE, not offline as the row words it.
  D-1 PASS - Tier 3 fire recomputed INDEPENDENTLY: VWAP 845.5253/0.19 = 4450.1332 (log
      4450.13), margin 223.7 pts, and BOTH derivations agree at 0.42500000 to 8 decimals.
  C-1..C-5 closed at deploy. C-4's strengthened WARN fired verbatim ("found 4, expected 5").

## 6. OPEN ITEMS CARRIED FORWARD
1. E9-Q1 (NEW, 2026-08-19): a STALE-QUOTE GUARD. Own Gate 1. For 73 minutes TRTM read a
   dead quote as truth and the forfeit WARN MISDIAGNOSED it as spread, which misdirected a
   long investigation. A MqlTick.time vs TimeCurrent() check would have named it instantly.
   The incident itself was NOT a TRTM defect (a terminal restart cleared it) - see STATE.md
   "STALE-QUOTE INCIDENT". Three theories failed against evidence there; they are recorded
   as eliminated so they are not re-derived.
2. K-4 -> E9, with O6 comment-integrity detection (section 4).
3. E9-M4: adoptedL1 is restored FROM THE STATE FILE ONLY, so it goes unmanaged if the file
   is lost for any reason. Standing b40 property, not a b41 defect.
4. E9-M2: stale projection in the Structure: line (cosmetic).
5. E9 also holds O3 filling-mode, O4 netting guard, O5 exemode init, E9-O2e, W-7, E9-P6.
6. T3-K2 sub-case (a) still inherited. T3-DS1 dashboard visual confirm still not done.
   L-1/L-2/L-4 and F-1..F-5 still open on inspection.
7. E8 (profit-funded follow-on slice) unblocked, own Gate 1 pending. E2, E3 in the backlog.

## 7. TEST-DESIGN KNOWLEDGE ADDED THIS SESSION (cost real runs)
- InpTier3MinTrades MUST stay >= 4. At 2 the profitable group IS the whole basket, so M-1
  stands down ("no underwater survivor to valve") and Tier 3 can NEVER fire. Cost a sequence.
- InpEntryLotSize 0.05 is the right Run H anchor: 0.03 slices to a single lot step and is
  hard to read; at the 0.01 default Tier 3 cannot fire at all.
- InpEnableTrailing MUST be false for these runs. It killed sequences on 08-18 AND again at
  21:13:57 on 08-19 - opened and closed inside one second.
- AFTER SWITCHING ACCOUNTS in a running terminal, RESTART THE TERMINAL before trusting
  quotes. A chart refresh and an EA re-attach are NOT sufficient.
- The MT5 Include tree is the authority on CTrade signatures. VERIFY an overload before
  planning against it (section 4).

## 8. NEXT
Jeff's call. Ranked as of this seal:
  (a) PUSH the local-only commits - Jeff's decision, ask first.
  (b) E9-Q1 stale-quote guard - own Gate 1. Small, and this session is the argument for it.
  (c) K-4 fix inside E9 alongside O6 - needs the second-close-path decision.
  (d) E8 - profit-funded follow-on slice, own Gate 1, never opened.
Gate order applies from the top for all of them: locked decisions -> sealed matrix ->
confirmed plan -> build -> evidence-audited verification -> seal on Jeff's explicit word.
