# TRTM CONTINUATION PROMPT - paste this to start the next session
# Regenerated 2026-08-19 after the b41 seal. Supersedes the b40-era version.

Resume TRTM. Run the section 0 resume protocol FIRST: git status + sha256_16
+ wc -l of src/TRTM.mq5 AND the MT5 runtime copy, all compared to STATE.md
(expect build b41, d2354c4c1269874e, 5063 lines). Repo and runtime are
ALIGNED and DEPLOYED - report "repo and runtime aligned at b41" in one line.
A mismatch on EITHER side is a real STOP. NOTE: PowerShell's Measure-Object
-Line UNDERCOUNTS this file; count LF bytes or use wc. The sha256 settles it.

Then read docs/HANDOVER_2026-08-19_b41_sealed.md and STATE.md. E1, E4, E5,
E6, b39, b40 and b41 are ALL SEALED - do NOT re-open them. Run H is DONE
(2026-08-18): T3-K1 and T3-K2(b) PASS on evidence, K-4 FAIL, L-3 DEFENDED.
b39's watcher caveat was RETIRED 2026-08-18 when WatchUntrackedLevels
adopted on the live Cent account, unprompted.

b41 SEALED 2026-08-19 fixes E9-M1 (reconcile adopted the EA's OWN last
applied TP as a trader edit after a restart) by PERSISTING lastAppliedTP/SL,
state schema 4 -> 5. B-1 - the row Run H failed - PASSES on evidence.

READ THIS BEFORE TOUCHING TIER 3: b41 was PLANNED to also fix K-4 (a Tier 3
slice BLANKS the surviving anchor's _lN_ comment). GATE ZERO REJECTED IT -
CTrade CANNOT comment a close; PositionClosePartial's third parameter is a
ulong DEVIATION and the implementation never sets m_request.comment. The
Gate 3 plan asserted an overload existed and did not verify it. Rows A-1..A-8
are NEITHER CLOSED NOR FAILED - not attempted. K-4 is PARKED TO E9 with O6.
Contained meanwhile by b39's O2b (unparseable tag -> maxLvl+1, never 0),
proven by Run H. Residual risk: a restart that scans the sliced anchor AFTER
other levels anchors FormBasketGroup on the wrong position; TP/PL arithmetic
is unaffected.

TOP PRIORITY THIS SESSION is E9-Q1 - the STALE-QUOTE GUARD - unless I say
otherwise. On 2026-08-19 TRTM read a FROZEN quote as truth for 73 minutes:
recovery was silently dead, and the forfeit WARN blamed SPREAD, which
misdirected the whole investigation. The incident itself was NOT a TRTM
defect (a terminal restart cleared it; three theories failed against evidence
and are recorded as eliminated in STATE.md - do not re-derive them). The GAP
is real: a MqlTick.time vs TimeCurrent() check would have named it on the
first forfeit. Own Gate 1, own matrix.

Gate order holds: locked decisions -> sealed matrix (money paths) ->
confirmed plan -> build -> evidence-audited verification -> seal on my
explicit word. One question per message, concrete numbers, your rec each;
record every decision + rejected alternatives in STATE.md's locked-decisions
log. No code before a confirmed plan; no matrix before locked decisions. Do
not touch the MT5 tree (deploy is my manual step); recompute every money
number before any PASS. VERIFY library signatures against the MT5 Include
tree before planning against them - that is what K-4 cost us.

Also carried forward:
(1) NOT PUSHED - roughly EIGHTEEN commits are local-only; origin/main was at
8722fcc, then 854c077 before the 2026-08-18/19 sessions. Verify with
`git log --oneline origin/main..HEAD`. Pushing is my call, ask before doing it.
(2) E9 now holds: Q1 stale-quote guard (NEW, top priority), K-4 slice comment
+ O6 comment-integrity, M4 (adoptedL1 unrecoverable on state-file loss), M2
(stale projection line), O3 filling-mode, O4 netting guard, O5 exemode init,
O2e never-filled timeout, W-7 account-scoped identity, P6 AdoptionCandidate-
Exists/TryAdopt duplication.
(3) STILL OPEN ON INSPECTION: L-1/L-2/L-4 (need a deliberately corrupted
comment), F-1..F-5 (flat-state rebuild never triggered), T3-K2 sub-case (a),
T3-DS1 dashboard visual confirm.
(4) TEST-DESIGN RULES THAT COST REAL RUNS: InpTier3MinTrades must stay >= 4
(at 2 the profitable group IS the whole basket, M-1 stands down, Tier 3 can
never fire); InpEntryLotSize 0.05 for Tier 3 runs; InpEnableTrailing MUST be
false for verification runs (it killed sequences twice); restart-with-open-
positions rows MUST be a LIVE chart, never the tester; after switching
accounts in a running terminal, RESTART THE TERMINAL before trusting quotes.
(5) E8 (profit-funded follow-on slice) unblocked since E6, own Gate 1 pending,
never opened. E2 draggable exit lines, E3 auto-entry still in the backlog.
