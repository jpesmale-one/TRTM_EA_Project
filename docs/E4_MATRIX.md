# E4 - Drawdown Reduction Tier 1 (point-based basket close) - SCENARIO MATRIX
# Status: SEALED rev 1 (Gate 2). Sealed by Jeff 2026-07-24.
# Base build: E1-b34 (aef5dc989609dc45 / 4307 lines).
# Target build: E4-bNN (label TBC by Jeff).
#
# ONE-LINE: when the basket is deep, close the OLDEST position together with
# every currently-profitable position, but only if that group's combined P/L
# clears a per-lot profit threshold. Tier 1 is a drawdown PRESSURE VALVE, not
# a mechanism that resolves a sequence (ref run B ended 0.48 lots deep, open).
#
# DEPENDS ON E1 (lot-weighted anchor) - SATISFIED (E1 sealed b34). E4's group
# VWAP reuses E1's lot-weighted formula (ComputeTargets, g_curAvgEntry now
# lot-weighted). A shared lot-weighted helper (drafted then removed as dead
# code in E1, deferred to E4) is REINTRODUCED here and consumed by BOTH the
# sequence anchor and the Tier 1 group VWAP - one basis, one code path (C-1).
#
# =====================================================================
# LOCKED DECISIONS (Gate 1, 2026-07-23 - see STATE.md locked-decisions log)
# =====================================================================
# CHOSEN (Jeff, in backlog):
#  C1  Anchor = OLDEST position, STRICTLY. Transfers to next-oldest when the
#      oldest closes. NO skip-to-affordable. Oldest = most swap-expensive;
#      failing to fire on an expensive anchor is acceptable, not a defect.
#  C2  >=1 profitable NOT mandatory; the threshold test alone governs.
#  C3  PRESERVED LADDER INDEX (diverges from Shadow's count re-index). A rung
#      is an ADDRESS: Level N always = (price from anchor + N*interval,
#      lot = ComputeLevelLot(N)). Nothing stored; both derived.
#  C4  Post-fire suppression -> resolved by O3 (none).
# OPEN, resolved this session:
#  O1  Rung re-arm = UNRESTRICTED refill (bar-close gate only; NO re-arm-travel,
#      NO per-rung stored state). Only HIGHER closed rungs re-arm; the anchor
#      (lowest closed) NEVER re-arms (structural).
#  O2  Threshold = FLAT MinProfitPoints (scaling parked). TWO-GATE trigger:
#      Gate A total OPEN COUNT >= MinTrades (new input); Gate B group combined
#      P/L >= MinProfitPoints/lot. HARD INVARIANT: a group NEVER closes at a
#      combined loss. Dormancy: count < MinTrades after a fire -> Tier 1
#      dormant until recovery rebuilds the count.
#  O3  Post-fire suppression = NONE. Bar-close-gated recovery entry + ATOMIC
#      post-fire state refresh; Shadow's 3s window never binds here.
#  O4  Far price = DIRECTION-DERIVED (SELL->Ask, BUY->Bid). Basis = platform
#      invariant (buy closes at Bid, already TRTM's sealed-core behavior).
#  O5  Group close = PROFITABLES-FIRST / ANCHOR-LAST + bounded retry +
#      ABORT-ANCHOR on any profitable-leg failure. Inverts Shadow's
#      anchor-first (fragile). Optional banked-profit guard named, not adopted.
#
# INPUT SURFACE (plan finalizes; matrix assumes these exist):
#  InpEnableTier1        bool  (Shadow InpEnablePartialClose1)   default false
#  InpTier1MinTrades     int   "Tier 1: Min Trades to Activate"  default 4
#  InpTier1MinProfitPts  int   Gate B threshold, POINTS          default TBD*
#  * MinProfitPoints is symbol-relative. Shadow's 150 was GBPAUD.s (5-digit);
#    on XAUUSD.s (_Point 0.01) 150 pts = a $1.50 move. GOLD default chosen at
#    plan time (O2 rider). NO suppression input (O3), NO scaling input (O2).
#
# =====================================================================
# ENVIRONMENT / EVIDENCE RULE
# =====================================================================
# LIVE evidence comes from XAUUSD.s only (CLAUDE.md). REFERENCE arithmetic is
# recomputed from Shadow Trade Manager PRO v3.21 tester logs (GBPAUD.s M15,
# DooTechnology-Demo, 2026.06.22-26). Shadow is REFERENCE, never spec. Every
# money row is recomputed to the cent at verify time on the live XAUUSD.s run.
#
# WORKED REFERENCE (Shadow run B, SELL, verified against the raw log):
#  Fire 1  2026.06.24 14:57:40  close Ask 1.90848
#    group = anchor #2 0.01@1.88135  +  profitables #11 0.10@1.91309,
#            #10 0.09@1.90975       (#3-#9 underwater, NOT in group)
#    sumVol 0.20 ; sum(lot*entry) 0.382000 ; VWAP 1.910008
#    margin = VWAP - Ask = 152.0 pts (>=150 -> FIRE); combined never < 0.
#    close ORDER in log: anchor #2 FIRST, then #11, #10 (Shadow anchor-first).
#  Fire 2  2026.06.25 15:48:48  close Ask 1.90698
#    group = anchor #3 0.02@1.88502 + #16 0.09@1.91286, #15 0.08@1.90957
#    sumVol 0.19 ; VWAP 1.9085442 ; margin 156.4 pts
#    per-leg -43.92 +52.92 +20.72 = +29.72 lot-pts = 0.19 x 156.4 (exact).
#    ANCHOR-COST ESCALATION: fire1 anchor 0.01 -26.99 lot-pts; fire2 anchor
#    0.02 -43.92 (+63%); surplus FELL 30.16 -> 29.72 despite a larger tail.
#  BUY lap: NO Shadow buy fire exists. BUY rows are validated by the platform
#  invariant (buy closes at Bid) + arithmetic, NOT against a Shadow reference.
#
# =====================================================================

## Group G-T - TRIGGER (Gate A count + Gate B margin, both laps, tick-based)
T-1   SELL, count == MinTrades, margin just clears -> FIRE          -> both gates pass on the first qualifying tick; VWAP + margin recomputed to the cent (ref: run B fire1, 152.0 pts). Fire fires.
T-2   BUY lap (platform invariant, no Shadow evidence)              -> group closes at BID; margin = BID - VWAP (VWAP sits BELOW Bid) >= MinProfitPoints. Far price DIRECTION-DERIVED (O4). Recompute by construction; mirror of T-1.
T-3   MUST-NOT: count < MinTrades, huge margin available            -> Gate A fails; Tier 1 does NOT fire regardless of profit. Prove absence.
T-4   MUST-NOT: count >= MinTrades, margin < MinProfitPoints        -> Gate B fails; no fire. Recompute margin just under threshold; prove absence.
T-5   TICK-BASED eval, NOT bar-gated                                -> Tier 1 evaluates every tick and fires MID-BAR (ref: 14:57:40 / 15:48:48, both off M15 boundaries) while recovery ENTRIES stay bar-close gated (InpBarCloseEntry). MUST-NOT: gate the fire on bar close.
T-6   MUST-NOT: count >= MinTrades but ZERO profitables (C2)        -> group = anchor alone, margin negative; Gate B fails; no fire. Threshold alone governs; no separate "need a profitable" rule.

## Group G-A - ANCHOR SELECTION (C1 - strict oldest, transfers)
A-1   Anchor = strict OLDEST (earliest POSITION_TIME / lowest ticket) -> in an additive ladder oldest = deepest = smallest-lot (coincide). Ref fire1 anchor = #2. Recompute; confirm the anchor is the oldest, not the cheapest-to-close.
A-2   Anchor TRANSFERS to next-oldest after a fire                  -> ref: fire2 anchor = #3 (next-oldest after #2 gone). No skip. Second fire selects the new oldest.
A-3   MUST-NOT: skip an expensive oldest to an affordable anchor    -> rejected skip-ahead. If the oldest's group does not clear the threshold, Tier 1 does NOT fire (acceptable, not a defect). Prove the oldest is always the anchor even when it makes the group fail.
A-4   Edge (named, not blocking): V/whipsaw where oldest is SHALLOWEST loser -> anchor still = oldest; rationale that holds is "oldest = most swap-expensive", not "deepest". Confirm selection is by AGE, not by depth.

## Group G-G - GROUP FORMATION + PROFIT INVARIANT (O2 Gate B)
G-1   Group = anchor + ALL currently-profitable positions           -> not a subset. Ref fire1: #2 + #11 + #10 (every profitable at that tick). Recompute membership at the fire tick.
G-2   Combined-P/L framing == VWAP framing                          -> 0.20 lots x 150.8 pts = 30.16 lot-pts = per-leg (-26.99 +45.90 +11.25). Show the two framings are the SAME test (lot-size-independent).
G-3   HARD INVARIANT MUST-NOT: group ever closes at combined loss   -> across every fire and every partial state the realized group P/L is strictly >= 0. The ANCHOR alone realizes a loss; the GROUP never does. (Enforced by Gate B + O5 abort; see G-X.)

## Group G-H - AUTO-HEAL / PRESERVED INDEX (C3) - touches SEALED martingale
H-1   MUST-NOT (no-heal): ComputeLevelLot output BIT-IDENTICAL to b34 -> when Tier 1 never fires, the closed-form ladder (lot + spacing) is byte-for-byte b34. Prove the C3 index-preserve change is inert on the no-fire path.
H-2   Preserved-index refill at a curve STEP (the real divergence)  -> ref run B after fire2: 16:30 re-entry at 1.90969. Under C3 that address is the level-8 rung -> lot = ComputeLevelLot(8); under Shadow's count re-index it was level-6 lot 0.07. Recompute; confirm TRTM refills at the ADDRESS's lot, not a re-counted lot.
H-3   MUST-NOT: site an H-row inside a STALL band                   -> base .01/mult 1.5 -> L3-L6 all 0.02; preserved-index and count-re-index are indistinguishable there. Any heal row MUST sit at a step, not a stall, or it proves nothing.
H-4   Only HIGHER closed rungs re-arm; anchor NEVER (O1 structural) -> recovery extends only in the adverse direction; the closed anchor sits at the favourable extreme, never re-added. Ref: fire closes L1(anchor)+top band, survivors are the middle; recovery re-arms the top addresses, never L1.
H-5   Post-fire state refresh is ATOMIC with fire completion (O3)   -> the closed group is marked (MarkEAClosed) and the liveness sweep reconciles g_state before any next bar-close evaluation. Next bar-close sees correct survivors/Level. No stale-state entry.
H-6   SL RE-ANCHOR when Tier 1 closes the OLDEST (the one sealed interaction) -> Tier 1's anchor (C1 = oldest = lowest-level) is the exact position the basket SL hangs on. Closing it must RE-ANCHOR the SL to the new lowest-level survivor (g_curAnchorLvl change handler ~1499). Prove: SL moves to the new oldest, is NEVER left referencing a closed ticket, and the basket is never briefly left unprotected/wrongly protected mid-fire. BUY + SELL laps (SL side is direction-signed). This is the only E4 path reaching sealed SL behavior - the lot/level refill math is already address-based (H-2) and not at risk.

## Group G-O - RE-ARM / REPEAT FIRE (O1 - unrestricted)
O-1   Whipsaw refill+close of the same rung, repeatedly             -> each cycle net-POSITIVE by construction (threshold). No re-arm-travel gate; the rung refills exactly as its first open. Prove repeated safe cycles.
O-2   Rate bounded by bar-close only; NO per-rung stored state      -> max 1 refill per M15 bar; no "armed"/last-closed flag anywhere. grep-confirm no new persisted rung state (C3 derived-only intact).
O-3   Ladder CONSUMPTION -> eventual dormancy                       -> repeated fires spend the oldest each time; when open count falls below MinTrades, Tier 1 goes dormant (-> G-D). 9 fires empties a 9-rung ladder.

## Group G-D - DORMANCY / RE-ACTIVATION (O2 Gate A, count-based)
D-1   MUST-NOT: fire drops open count below MinTrades, then fire again -> after a fire leaves < MinTrades open, Tier 1 is DORMANT and does not fire until recovery rebuilds the count. Prove absence while shallow.
D-2   RE-ACTIVATION once count rebuilds to >= MinTrades             -> a later recovery entry restores count; Tier 1 evaluates again. Count is always the REMAINING open positions, never the level index.

## Group G-X - EXECUTION / PARTIAL-FILL (O5 - profitables-first/anchor-last)
X-1   Happy path: close PROFITABLES first, ANCHOR LAST              -> one market order per leg via the sealed close routine; among profitables descending ticket. MUST-NOT be anchor-first (inverts Shadow). Ref fill side: SELL->Ask, BUY->Bid.
X-2   A profitable leg FAILS after retries -> ABORT anchor          -> stop; do NOT touch the anchor; leave it open. Realized = pure profit subset, strictly >= 0. Tier 1 re-evaluates next qualifying tick. Prove the invariant holds in this partial state.
X-3   Anchor close FAILS after all profitables closed              -> anchor stays open; realized = pure profit, strictly >= 0. Tier 1 targets it again next tick. Invariant holds.
X-4   Bounded retry via the SEALED close-with-retry routine         -> reuse CloseSequenceAtMarket's close path; NO new close path invented. Confirm retries exhaust before "failed".
X-5   MUST-NOT (F3 defect class): close deals route through the initial-entry branch -> Tier 1 close deals must NOT be mis-tagged as initial entries / report count 0. WasEAClosed/MarkEAClosed keep them on the EA-close path. Prove the transaction handler classifies them as closes.

## Group G-P - POST-FIRE SEQUENCE RECOMPUTE (E1 consistency on survivors)
P-1   Sequence TP recomputed across SURVIVORS on lot-weighted VWAP  -> after fire1 survivors #3-#9; ComputeTargets recomputes TP on the lot-weighted survivor VWAP (E1 basis), NOT simple mean. (Shadow's log shows a simple-avg recompute - TRTM DIVERGES to weighted.) Recompute survivor TP to the cent.
P-2   Dashboard / projection refreshed to survivors                -> ComputeProjection + the avg-entry row redraw on the survivor set; displayed avg == engine anchor (no b26/S8-25 display-vs-engine drift). Recompute.

## Group G-C - CONSISTENCY WITH E1 (the coupling that forced E1 first)
C-1   Tier 1 group VWAP and E1 sequence anchor use the SAME formula -> one shared lot-weighted helper; MUST-NOT reintroduce a second averaging basis in the money path (the section-7 break the E1 amendment closed). grep-confirm a single lot-weighted computation.
C-2   MUST-NOT: any Tier 1 arithmetic on SIMPLE average            -> group VWAP, margin, and post-fire recompute all lot-weighted. No simple-mean survivor anywhere in the E4 path.

## Group G-R - RECOVERY MUST-NOT (ladder untouched except the C3 index rule)
R-1   MUST-NOT: base lot / g_state.baseLot semantics unchanged      -> Auto-Heal locked base lot behavior byte-identical to b34.
R-2   MUST-NOT: level SPACING (anchor + N*interval) unchanged       -> recovery entry prices land as b34 on the no-fire path. C3 changes only WHICH lot a re-armed rung carries, never the spacing math.
R-3   MUST-NOT: RegisterNewRecovery / ComputeRecoveryTrigger / EvaluateRecovery flow unchanged on the no-fire path -> Tier 1 is additive; the sealed recovery loop is byte-identical when Tier 1 is disabled or never fires.

## Group G-K - RESTART / KILL (stateful safety spine)
K-1   RESTART (recompile / re-attach) mid-sequence with Tier 1 armed -> no persisted Tier 1 state; on re-init positions re-read, count/anchor/VWAP rebuilt from live positions. Tier 1 re-evaluates cleanly. Verify no orphan Tier 1 state key.
K-2   KILL mid-FIRE (group partially closed, OnDeinit skipped)      -> on restart the liveness sweep reconciles g_state from live positions; realized-so-far is pure profit or a completed group (invariant held); the surviving anchor (if abort/kill mid-group) is just an open position Tier 1 targets again. No combined-loss realized by the interruption.
K-3   State file SCHEMA unchanged (no new persisted key)            -> RunStateSelfTest byte-identical; MQL5 uninit-field trap N/A (no new struct field persisted). Tier 1 is fully DERIVED per pass.

## Group G-M - LIVE-FINDING AMENDMENTS (post-seal, verify-audited)
M-1   Whole-basket-in-group STAND-DOWN (live finding 2026-07-24, gold demo fire). -> When the group = the ENTIRE open basket (every non-anchor position profitable, so no underwater survivor would remain), Tier 1 STANDS DOWN instead of firing. Rationale: a full-basket close is NOT valving - it is the sequence's own exit's job (AvgTP-exceeded market close / BE / trail, all bank-at-market), and firing there pre-empts the sequence AvgTP at MinProfitPts < AvgTPPts, banking LESS than the sequence reaches unaided (observed live: fired +152.8 pts vs the +200 pt AvgTP). Guard = grp size >= openCount (grp always holds the anchor). MUST-NOT: fire when nothing underwater survives. MUST still fire when >=1 level stays underwater (a real partial valve - unchanged, all prior verified fires had grp < openCount). Invariant it protects: Tier 1 is ADDITIVE - never a worse exit than the baseline sequence. Decision (A) over (B) anchor-profitable-only: (A) also covers the anchor-sole-loser case (the likely live fire) and makes never-worse-than-baseline total. Build E4-b36.

## Out of scope
E5 (Tier 2, percent-based) + E6 (Tier 3, partial-lot) - ZERO observed, need
E7 R1/R2 first. E7 R3 (BUY sequence) SUPERSEDED for O4 (platform invariant).
E2 draggable exit lines. E3 auto-entry. CostCoverPoints internal math. E1
sequence-anchor basis (sealed b34; E4 only REUSES its lot-weighted formula).

## Status
SEALED rev 1 by Jeff 2026-07-24. Groups: G-T, G-A, G-G, G-H, G-O, G-D, G-X,
G-P, G-C, G-R, G-K. 36 rows, 11 groups.
AMENDMENT rev 2 SEALED by Jeff 2026-07-24: +G-M / M-1 (whole-basket stand-down,
live finding 2026-07-24). Implemented + VERIFIED in E4-b36 (stand-down observed,
sequence AvgTP owned the full close). 37 rows total. E4 CLOSED.
MUST-NOT / must-not-fire rows: T-3, T-4, T-6, A-3, G-3, H-1, H-3, D-1, X-5,
C-1, C-2, R-1, R-2, R-3, K-3.
BUY + SELL laps: T-1/T-2 (and O4 direction-derived across G-X).
SEALED-martingale guards (C3): H-1 (bit-identical no-heal), H-3 (step-not-stall).
SL re-anchor on anchor close: H-6 - the ONE E4 interaction reaching sealed SL
behavior (lot/level refill is already address-based, not at risk).
Partial-fill invariant: X-1..X-5 + G-3.
Gate 3 (code plan) is next. Live findings later become new M-rows.
