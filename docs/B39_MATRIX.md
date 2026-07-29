# b39 - ASYNC-FILL REGISTRATION HOTFIX - SCENARIO MATRIX
# Status: SEALED rev 1 (Gate 2). Sealed by Jeff 2026-07-27.
# Base build: E6-b38 (f7766c859e4d3c7a / 4674 lines), SEALED 2026-07-26.
# Decisions: STATE.md locked-decisions log, E9-S1 / O1-O2 / O2a-O2e / N1 (2026-07-27).
#
# ONE-LINE: a broker that answers "order accepted" BEFORE it executes (Market execution,
# TRADE_RETCODE_PLACED, price 0.00 / deal 0) leaves no position at the instant the EA
# looks for one. b39 stops assuming the fill is instantaneous: registration becomes a
# per-tick WATCHER that adopts any of our own tagged positions that are not yet tracked,
# in BOTH the flat and live states, and the order book is read with an ORDER_TYPE split
# so in-flight market orders are no longer mistaken for pendings.
#
# NOT an E6 defect. The affected code (RegisterNewRecovery 1913, RegisterButtonL1 3130,
# CancelOwnPendingOrders 3100, CountOwnPendingOrders 3078, FindUntrackedOurL1 3140) is
# Stage 4/5 CORE, sealed long before E6. E6 touched none of it. Latent since Stage 4;
# surfaced 2026-07-27 on Vantage XAUUSD.sc.
#
# =====================================================================
# LOCKED DECISIONS (Gate 1, 2026-07-27 - see STATE.md)
# =====================================================================
#  E9-S1   SPLIT scope. b39 = O1 + O2 only (the two that produce UNMANAGED positions).
#          O3-O6 (filling mode, margin mode, exemode guidance, comment integrity) -> E9.
#  E9-O1/2 WATCHER-PRIMARY registration, single mechanism, NO new persisted or in-memory
#          state. RegisterNewRecovery demoted to a fast path; on a miss it logs INFO
#          ("fill pending"), never ERROR, and the watcher completes next tick.
#  E9-O2a  DUPLICATE LEVELS -> adopt BOTH, tolerate the collision, loud WARN with tickets.
#          The level is an ADDRESS for lot sizing and anchor ordering, not a unique key.
#  E9-O2b  UNPARSEABLE TAG -> adopt at maxLvl + 1, loud WARN. Never level 0. This also
#          replaces RebuildLiveMap's lvl = 0 path (2488), a live hazard today.
#  E9-O2c  WATCHER RUNS IN BOTH STATES, flat and live. Supersedes the L1-only scan in
#          CheckOwnPendingFillWhenFlat.
#  E9-O2d  ORDER-BOOK TYPE SPLIT. Only BUY_LIMIT/BUY_STOP/SELL_LIMIT/SELL_STOP are
#          pendings. ORDER_TYPE_BUY/SELL in the book are fills in progress - leave alone.
#  E9-O2e  NO never-filled timeout in b39. Degrades gracefully; escalation -> E9.
#  E9-N1   MAGIC separates the watcher from ADOPTION and it is enforced in code. Adoption
#          is magic-0 only; the watcher is our-magic only. They cannot collide.
#
# =====================================================================
# EVIDENCE BASE
# =====================================================================
# ASYNC broker  = Vantage XAUUSD.sc (magic 725639, stops 20 / freeze 10). The 2026-07-27
#   live log is the reproduction: PLACED, price 0.00, deal 0, registration miss, 10013.
# SYNC broker   = DooTechnology-Demo XAUUSD.s (magic 715358, stops 100 / freeze 0). Fills
#   return DONE with a real price and deal. This is the REGRESSION baseline - the E6
#   Run A (tests/2026.07.26 125653.086.txt) and Run C (130728.662.txt) logs are the diff
#   targets, since b39 must not alter behaviour there.
# Money rows stay XAUUSD-only; registration/reconcile paths carry no symbol math, so the
# 2026-07-18 symbol-agnostic seal amendment applies to the restart/kill rows.

## Group G-A - ASYNC REGISTRATION (the defect)
A-1  [NEW] Recovery send returns PLACED (price 0.00, deal 0) -> the fast path misses and logs INFO "fill pending", NOT the current ERROR. No orphan is created; the watcher adopts on the next tick. Reproduce against the 2026-07-27 shape.
A-2  [NEW] BUTTON L1 send returns PLACED -> same handling via RegisterButtonL1's caller. Jeff's log shows L1 got lucky (the position appeared in time); b39 must not depend on luck.
A-3  [REGRESSION] Send returns DONE with a real deal (sync broker) -> the fast path registers IMMEDIATELY, exactly as b38 does, and the watcher finds nothing to do. Zero behaviour change.
A-4  [NEW] MUST-NOT: a genuine send FAILURE (not DONE/PARTIAL/PLACED) must still ERROR and must NOT leave the watcher waiting for a position that will never exist. Distinguish "not yet" from "never".
A-5  [NEW] The recovery TRIGGER must recompute once the level is adopted. In the incident g_state held only L1, so ComputeRecoveryTrigger kept using L1's entry and the trigger stayed satisfied -> another 0.02 "L2" on every M5 bar close. Prove the duplicate-stacking path is closed.

## Group G-W - WATCHER ADMISSION + BEHAVIOUR  (E9-O1/O2)
W-1  [NEW] ADMISSION FILTER: magic == g_magic AND symbol matches AND a parseable _lN_ tag AND not already tracked. Identical filter to RebuildLiveMap (2471), which is sealed - reuse, do not reinvent.
W-2  [NEW] Adoption completes within ONE tick; EnforceExits dresses the position with TP/SL on the same or next pass. Bound the unmanaged window and state it.
W-3  [NEW, MUST-NOT] The watcher MUST NEVER adopt a magic-0 position (mobile adoption, tagged manual, duplicate-tag warnings). E9-N1. Prove with a mixed sequence: mobile L1 at magic 0 + EA-opened L2/L3 at our magic -> only L2/L3 are ever considered.
W-4  [NEW, MUST-NOT] MUST NEVER double-register a ticket already in g_state - neither with the fast path nor across consecutive ticks.
W-5  [NEW] Every adoption logs ticket, level and volume, so a send with no matching adoption is visible in the journal (this is what carries E9-O2e's "not silent" argument).
W-6  [NEW] Watcher cost is bounded: it runs every tick, so the scan must be O(positions) with no allocation churn. Confirm no measurable tick-time regression.
W-7  [ADDED 2026-07-29 BY JEFF'S WORD - RECORD ONLY, NO b39 CODE] Magic and state-file identity derive from the NORMALIZED SYMBOL ONLY (DeriveMagic 375, stateFile 4482) - no account login, no server. So XAUUSD.s (Doo) and XAUUSD.sc (Vantage) collapse to XAUUSD and share BOTH the magic and the state file: an MT5 account switch re-inits onto the previous account's state. It self-heals (Reconcile rebuilds the live map first, foreign tickets fail PositionSelectByTicket, live-map-wins discards the stale file, EA lands FLAT) and cross-broker position mixing is impossible since one terminal shows one account. PRESENT IN SEALED b38; not created by b39 or by E9-P2. Observe during Run H, which crosses this boundary anyway. Account-scoped identity -> E9.

## Group G-L - LEVEL ASSIGNMENT EDGE CASES  (E9-O2a / O2b)
L-1  [NEW] DUPLICATE level -> both adopted, both managed, loud WARN naming both tickets. Downstream checked: ComputeRecoveryTrigger takes maxLvl+1; the lot-weighted VWAP includes both (financially correct); ComputeLevelLot keys off baseLot.
L-2  [NEW] UNPARSEABLE tag -> adopted at maxLvl + 1 with a loud WARN. Gets exits, is counted, and being highest can never be the anchor.
L-3  [NEW, MUST-NOT, HAZARD REMOVAL] Level 0 must never be assigned. TODAY RebuildLiveMap (2488) assigns lvl = 0 on an unparseable comment, and FormBasketGroup picks the LOWEST level as anchor - so 0 wins and an UNIDENTIFIED position inherits BOTH the SL anchoring (ComputeTargets 1128) and Tier 3's slice target. Prove the hazard is gone.
L-4  [NEW] EDGE, RECORD ONLY: if duplicates ever occur at the LOWEST level, FormBasketGroup's "first lowest wins" makes the anchor arbitrary and "oldest" ambiguous. Only reachable if L1 itself duplicates. Document; do not fix in b39.

## Group G-F - FLAT-STATE REBUILD  (E9-O2c)
F-1  [NEW] FLAT + untracked our-magic tagged positions -> a sequence is rebuilt from them, the same way Reconcile's live branch does. Reuse that sealed path.
F-2  [NEW, THE HOLE THIS CLOSES] An orphan L2+ while FLAT is now ADOPTED. Today FindUntrackedOurL1 (3140) skips lvl > 1 and only logs a one-shot ERROR, so a stray recovery level sits with NO TP and NO SL indefinitely. This is the state Jeff was one L1 close away from on 2026-07-27.
F-3  [NEW, MUST-NOT] Must not disturb the magic-0 adoption ordering: CheckOwnPendingFillWhenFlat -> TryAdopt. The stale-tag gate and the MMT-off notice must behave exactly as sealed.
F-4  [NEW] baseLot derivation on a flat rebuild: from L1 if present, else the existing smallest-volume fallback with its WARN. Prove recovery lot math is sane afterwards.
F-5  [NEW] ACCEPTED COST, verify it is benign: an our-magic position left open from a PREVIOUS session now STARTS a sequence rather than sitting idle. adoptionTime is set to now and baseLot derived from what is found.

## Group G-O - ORDER-BOOK TYPE SPLIT  (E9-O2d)
O-1  [NEW] CancelOwnPendingOrders deletes ONLY genuine pendings (BUY_LIMIT/BUY_STOP/SELL_LIMIT/SELL_STOP).
O-2  [NEW] CountOwnPendingOrders counts ONLY genuine pendings.
O-3  [NEW, MUST-NOT] No 10013 on an in-flight market order. Jeff's log: "cancel #459172826 [invalid request]" - the P8 guard tried to OrderDelete the market order that was about to become his L1.
O-4  [NEW, MUST-NOT] Spurious pendingLive must be gone: counting in-flight market orders as pendings HIDES the BUY/SELL buttons (b14 visibility rule) and trips the P7 "cancel the pending first" refusal.
O-5  [REGRESSION] P7 (one pending max) and P8 (cancel own pending when a sequence starts) semantics UNCHANGED for real pending orders. The Stage 5 pending flow is sealed.

## Group G-R - REGRESSION / NO-CHANGE ON A SYNCHRONOUS BROKER
R-1  [CRITICAL] On a SYNC-fill broker the EA behaves as b38 did. Diff against the E6 Run A (all tiers off) and Run C (Tier 3 firing) logs: same ladder, same lots, same AvgTP recomputes, same fires, same projections. b39 touches core registration, which EVERY sealed enhancement sits on.
R-2  [CRITICAL] E1 / E4 / E5 / E6 money paths untouched. No change to ComputeWeightedVWAP, ComputeSlicedAnchorVWAP, ComputeTargets, FormBasketGroup, FireGroupClose, the tier gates, or the slice sizing.
R-3  [NEW] NO new persisted field and NO state-schema change; RunStateSelfTest byte-identical. Consistent with E4/E5/E6 keeping everything derived per tick.
R-4  [NEW] Watcher inert when there is nothing to adopt - the common case. No log noise on a healthy sync-broker run.

## Group G-K - RESTART / KILL  (Run H rides on b39)
K-1  [E6 CARRY-FORWARD] Clean restart with a SLICED anchor, ON VANTAGE. Reconcile must rebuild with the anchor at its REDUCED volume and ORIGINAL level. This was closed by INHERITANCE at the E6 seal and never exercised against an actual sliced anchor - and b39 rewrites the very code that rebuilds a sequence.
K-2  [E6 CARRY-FORWARD] Kill mid-fire, both sub-cases: (a) after profitables closed but BEFORE the slice -> realized is a pure-profit subset, anchor still full; (b) after the slice -> the reduced anchor reconciles as an ordinary smaller position.
K-3  [NEW] Restart while an order is IN FLIGHT -> on re-init, Reconcile/RebuildLiveMap must pick the position up once it appears; the watcher then takes over. No orphan across the restart boundary.
K-4  [NEW] COMMENT INTEGRITY on Vantage, empirical: confirm comments survive a PARTIAL CLOSE. Jeff confirmed they survive on open positions (2026-07-27); the partial-close case is the one that matters for E6 and is still unverified. A rewrite here would activate L-2/L-3 for real and escalate E9-O6.

## Out of scope
E9-O3 filling-mode negotiation (SYMBOL_FILLING_MODE); E9-O4 margin-mode guard (netting
refusal); E9-O5 execution-mode awareness + init guidance; E9-O6 comment-integrity
detection and open-time reconstruction. Tier internals, the recovery ladder, exits, BE /
trail, and the panel - all sealed and untouched.

## GATE 4 OUTCOME (2026-07-29/30) - see STATE.md for the full evidence log
CLOSED ON EVIDENCE:
  R-1 R-2 R-3 R-4 ... Doo tester x2 (Run A + Run C configs) + live restart. No regression;
                      Tier 3 fires recomputed to the cent on both derivations.
  A-3 ............... fast path registers immediately on BOTH sync and async brokers.
  A-5 ............... no duplicate stacking, proven ON THE LIVE CENT ACCOUNT that produced
                      the 2026-07-27 duplicate-every-M5-bar failure.
  O-3 O-4 ........... no 10013, no spurious pendingLive, same account.
  K-3 / TP-10 ....... restart reconciled live sequences on Doo AND Vantage Cent.
  E9-P2 ............. normalized comparator exercised on 3 suffixes: .s / + / .sc
CLOSED ON INSPECTION ONLY - CAVEAT, READ BEFORE TRUSTING:
  A-1, W-1..W-6 ..... WatchUntrackedLevels HAS NEVER ADOPTED A POSITION. The async
                      registration MISS is a timing tail: on Vantage the PLACED retcode is
                      routine but the fill lands within the tick, so the fast path never
                      missed in any run. Not reproducible on demand on any available
                      account. NOTE the untested part is only the per-tick DISPATCH loop -
                      IsAdoptableOurPosition and AdoptUntrackedLevel are both exercised by
                      every "Recovery fast path" registration across all 5 runs.
  L-1..L-4 .......... unreachable without a deliberately corrupted comment.
  F-1..F-5 .......... flat-state rebuild never triggered (no orphan ever survived flat).
  K-1 K-2 K-4 ....... Run H not run.
IF THE MISS EVER HAPPENS, the journal is the reproduction - look for
  "order accepted but no position yet" -> "Watcher: L<n> REGISTERED" -> "Exits applied".
  Those three lines close A-1/W-1..W-6 on live evidence and retire this caveat.

## Status
SEALED rev 1 by Jeff 2026-07-27 (Gate 2). AMENDED rev 2 by Jeff's word 2026-07-29 at
Gate 3: W-7 added as RECORD ONLY (no code scope change) - same amendment status as K-4,
which was added at draft time. Groups (7): G-A, G-W, G-L, G-F, G-O, G-R, G-K.
Rows (30): A-1..5, W-1..7, L-1..4, F-1..5, O-1..5, R-1..4, K-1..4.
MUST-NOT rows: A-4, W-3, W-4, L-3, F-3, O-3, O-4.
CRITICAL rows: L-3 (level-0 anchor hazard - arguably the most valuable line in b39),
R-1 and R-2 (no regression on a sync broker), A-5 (duplicate stacking closed),
F-2 (the flat-state orphan hole).
Gate 3 (code plan) is next, AFTER Jeff seals this matrix.
