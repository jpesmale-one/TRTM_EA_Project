# TRTM Handover - 2026-07-30 (b39 SEALED, with one explicit caveat)
# Follow CLAUDE.md + the staged-delivery gates. This file + STATE.md are truth.
# Disk + git override conversation/auto-memory.

## 1. RESUME PROTOCOL (first actions, in order)
1. Run all four, compare to STATE.md header:
   - git status
   - sha256sum src/TRTM.mq5 | cut -c1-16   EXPECT 12c69766c709bd0d
   - wc -l src/TRTM.mq5                      EXPECT 4939
   - sha256sum the MT5 runtime copy (path in CLAUDE.md section 0)
   REPO and RUNTIME are ALIGNED at b39 (12c69766c709bd0d / 4939). Report
   "repo and runtime aligned at b39, sealed". Any mismatch on EITHER is a STOP.
2. E1, E4, E5, E6 and now b39 are all SEALED. Do NOT re-open them.

## 2. WHERE THE PROJECT STANDS
- CORE + E1 SEALED. E4 (Tier 1, points) SEALED at E4-b36. E5 (Tier 2, percent) SEALED
  at E5-b37. E6 (Tier 3, partial-lot anchor slice) SEALED at E6-b38 2026-07-26.
- b39 (async-fill registration hotfix) SEALED 2026-07-30 - WITH A CAVEAT, section 5.
- b39 is COMMITTED (aed4b26) but NOT PUSHED. origin/main is still at 8722fcc, so THREE
  commits are local-only: 37daf7e (E6-b38 seal), 09a0d77 (b39 Gate 1+2), aed4b26 (b39
  seal + evidence). Pushing is Jeff's call.
- The three drawdown-reduction valves stack T2 percent -> T1 points -> T3 partial slice,
  one fire per tick. All default OFF.

## 3. WHAT b39 IS
The 2026-07-27 live incident on Vantage XAUUSD.sc: the broker answers "order accepted"
BEFORE executing (TRADE_RETCODE_PLACED, price 0.00, deal 0), so no position exists when
the EA looks for one. A recovery level went UNMANAGED - no TP, no SL, invisible to
liveness - with a duplicate opening every M5 bar. NOT an E6 defect; the affected code is
Stage 4/5 CORE, latent since Stage 4, exposed only by an asynchronous-fill broker.

b39 makes registration a per-tick WATCHER that adopts our own tagged, untracked positions
in BOTH the flat and live states. RegisterNewRecovery is demoted to a fast path that logs
INFO on a miss instead of ERROR. The order book is read with an ORDER_TYPE split so
in-flight market orders are never mistaken for pendings. Level 0 is abolished as an
assignable level on BOTH the adoption and startup-rebuild paths.
  4674 -> 4939 lines (+265), ELEVEN touch points, Gate Zero 0/0.
  NO new input, NO new global, NO new persisted field, NO state-schema change.

KEY STRUCTURAL PROPERTY worth remembering: the MAGIC test lives in exactly one place
(IsAdoptableOurPosition). Adoption handles magic-0; the watcher handles our-magic. They
cannot collide - that is enforced by code, not convention (E9-N1).

## 4. SEAL EVIDENCE (STATE.md's Gate 4 log is the full record)
Five runs: Doo tester x2 (Run A + Run C configs), Doo live restart, Vantage Standard ECN
DEMO, Vantage Cent LIVE.
CLOSED ON EVIDENCE:
  R-1 R-2 R-3 R-4  no regression. Ladder, lots, spacing, AvgTP recomputes and projections
                   identical to the sealed E6 baselines. TWO Tier 3 fires recomputed on
                   BOTH derivations (leg-by-leg AND marginPts x sum lots) - agreed to the
                   cent, never disagreed.
  A-3              fast path registers immediately on sync AND async brokers.
  A-5 O-3 O-4      proven ON THE LIVE CENT ACCOUNT that produced the incident: no
                   duplicate stacking, no 10013, no spurious pendingLive.
  K-3 / TP-10      restart reconciled live sequences on Doo AND Vantage Cent. Note Runs
                   1-2 init'd FLAT, so RebuildLiveMap's loop body was ONLY exercised by
                   the restart runs - that is why the restart was mandatory.
  E9-P2            normalized symbol comparator exercised on THREE suffixes: .s / + / .sc

## 5. THE SEAL CAVEAT - READ BEFORE TRUSTING THE WATCHER
A-1 and W-1..W-6 are closed on CODE INSPECTION, NOT EVIDENCE.
WatchUntrackedLevels HAS NEVER ADOPTED A POSITION in any run.
WHY: Run 5 established that on Vantage the PLACED retcode is ROUTINE, but the fill still
lands within the tick, so the fast path never misses. The registration MISS behind the
incident is a TIMING TAIL, not the everyday case, and it is not reproducible on demand:
Doo is synchronous, the Vantage DEMO is synchronous, and Vantage Cent LIVE showed PLACED
on all three sends yet filled in time every time. Jeff will not run further tests on a
live-money account to chase it.
SCOPE OF WHAT IS UNTESTED IS NARROW: only the per-tick DISPATCH loop. Both functions it
calls - IsAdoptableOurPosition and AdoptUntrackedLevel - are exercised by EVERY
"Recovery fast path: L<n> REGISTERED" line in all five runs, on three brokers.
RISK POSTURE: b39 is strictly SAFER than b38 on the async account. Worst case the watcher
never fires and behaviour equals b38; b38's behaviour there is KNOWN-BAD.
IF IT RECURS, THE JOURNAL IS THE REPRODUCTION - look for:
    "Recovery L<n>: order accepted but no position yet (asynchronous fill)"
    "Watcher: L<n> REGISTERED ticket <t> <vol> lots @ <price>"
    "Exits applied to ticket <t>: TP <x> ..."
  Those three close A-1/W-1..W-6 on live evidence and RETIRE this caveat.
  An orphan with NO watcher line is a b39 DEFECT - capture the log and REOPEN.
ALSO OPEN ON INSPECTION: L-1..L-4 (need a deliberately corrupted comment - decide before
any future seal whether those close on evidence or inspection), F-1..F-5 (the flat-state
rebuild never triggered), K-1/K-2/K-4 (Run H not run).

## 6. OPEN ITEMS CARRIED FORWARD
1. RUN H (K-1/K-2) against an ACTUAL sliced anchor, ON VANTAGE - overdue since the E6
   seal and now doubly so: b39 rewrote the sequence-rebuild code it exercises. Plus K-4:
   do comments survive a PARTIAL CLOSE on Vantage? A rewrite there would make L-2/L-3
   ACTIVE rather than defensive and escalate E9-O6.
2. MAINTENANCE HAZARD (b39's own): AdoptionCandidateExists duplicates TryAdopt's
   admission logic and MUST be kept in step with it. Deliberately not unified inside a
   hotfix - that would re-open sealed Stage 2 code with one-shot logging side effects.
   -> E9.
3. T3-DS1 dashboard visual confirm (display-only, no state, no money path).
4. E9 now holds: O3 filling-mode negotiation, O4 netting guard (TRTM is structurally
   HEDGING-ONLY with NO guard today), O5 execution-mode init guidance, O6
   comment-integrity detection, PLUS b39's deferrals - E9-O2e (never-filled timeout),
   W-7 (account-scoped identity), and item 2 above.
5. E8 (profit-funded follow-on slice) - unblocked, own Gate 1 pending, never opened.
   E2 draggable exit lines, E3 auto-entry still in the backlog.
   Open findings: F3 (impossible in TRTM - empty OnTradeTransaction), F4 (design note),
   F5 (E5 evidence-only, resolved).

## 7. TEST-DESIGN KNOWLEDGE ADDED THIS SESSION (cost real runs to learn)
- TESTER INPUTS LOCK once a run starts, and a tester restart REPLAYS from the beginning.
  The tester therefore CANNOT produce a reconcile against open positions. Any
  restart-with-open-positions row must be run on a LIVE chart (remove EA -> re-attach).
- The tester's 10-second confirm window is WALL-CLOCK, not tester-clock. At high speed
  you have plenty of tester time but the chart redraw makes buttons hard to HIT. Slow the
  speed slider before clicking; the visual stutter is PanelRefresh's 500ms timer
  competing with per-tick rendering, not a defect.
- Run A's baseline is a STRATEGY TESTER run (XAUUSD.s M15 real ticks, 2026.06.22-07.10,
  deposit 3000 @ 1:500), not a live-chart wait - it is reproducible on demand.
  Run C differs from Run A in exactly THREE inputs: InpEntryLotSize 0.01->0.03,
  InpAvgTPPts 2500->5000, InpEnableTier3 false->true.
- A DEMO account of a different type is NOT a proxy for the live account's execution
  model. Vantage Standard ECN Demo fills synchronously; Vantage Cent LIVE does not.
- W-7 IS NARROWER THAN DRAFTED: magic derives from the NORMALIZED symbol, so XAUUSD+
  (-> XAUUSD, magic 758105) and XAUUSD.s (-> XAUUSDS, magic 715358) CANNOT collide.
  The hazard needs two brokers whose gold normalizes IDENTICALLY.
- Vantage Cent LIVE returns 0.00 for CLOSE prices too, not just opens. Cosmetic,
  pre-existing, not b39.

## 8. NEXT
Jeff's call. The ranked options as of this seal:
  (a) RUN H on Vantage - closes the oldest outstanding debt (K-1/K-2/K-4) and is the
      only item that touches money paths b39 rewrote. RECOMMENDED FIRST.
  (b) E9 - broker hardening, now the largest bucket. Needs its own Gate 1.
  (c) E8 - profit-funded follow-on slice; unblocked since E6, own Gate 1 pending.
Gate order applies from the top for (b) and (c): locked decisions -> sealed matrix ->
confirmed plan -> build -> verification -> seal.
