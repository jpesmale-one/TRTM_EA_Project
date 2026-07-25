# E5 - Drawdown Reduction Tier 2 (percent-of-balance basket close) - SCENARIO MATRIX
# Status: SEALED rev 1 (Gate 2). Sealed by Jeff 2026-07-24.
# Base build: E4-b36 (7e14479c83d672a4 / 4483 lines).
# Target build: E5-bNN (label TBC by Jeff).
#
# ONE-LINE: identical to Tier 1's close (oldest anchor + every currently-profitable
# position, closed as a group), but FIRED BY A MONEY TEST - the close-group's P/L
# in account currency must clear a PERCENT OF ACCOUNT BALANCE - instead of Tier 1's
# per-lot POINTS threshold. Tier 2 is a second, account-relative pressure valve.
#
# RELATIONSHIP TO E4 (Tier 1, SEALED E4-b36): Tier 2 REUSES Tier 1's sealed close
# machinery UNCHANGED - group formation, anchor selection (C1 oldest), far-side
# derivation (O4), profitables-first/anchor-last/abort close (O5), preserved-index
# re-arm (C3/O1), atomic post-fire refresh (O3/H-5), SL re-anchor (H-6), post-fire
# TP recompute on lot-weighted survivors (E1/P-1), and the M-1 whole-basket
# stand-down. Tier 2 changes ONE thing: the Gate B trigger metric. Rows that only
# re-assert an E4 behavior via code reuse are tagged [INHERIT E4 <row>]; rows that
# are NEW to Tier 2 are tagged [NEW].
#
# =====================================================================
# LOCKED DECISIONS (E5 Gate 1, 2026-07-24 - see STATE.md locked-decisions log)
# =====================================================================
#  T2-O0  ADOPT as a SEPARATE default-off tier (InpEnableTier2), reusing Tier 1's
#         close machinery. Not a metric-selector on Tier 1; not declined.
#  T2-O1  REFERENCE BASE = ACCOUNT BALANCE (AccountInfoDouble(ACCOUNT_BALANCE)),
#         NOT equity, NOT fixed. Stable, account-size-proportional.
#  T2-O2  MEASURED P/L = the CLOSE-GROUP (anchor + ALL profitables), account
#         currency, far-side valued - NOT whole-basket, NOT profitables-only.
#  T2-O4  PRECEDENCE = TIER 2 FIRST, fall through to Tier 1. Shared group, ONE
#         fire per tick, attribution-only (money-identical). M-1 applies to BOTH.
#  GateA  OWN input InpTier2MinTrades (default 4). Count-based dormancy, same
#         semantics as Tier 1 Gate A.
#  T2-O5  INHERIT E4 O5 close order (profitables-first / anchor-last / abort).
#  T2-O6  INHERIT E4 O4 far-side (SELL->Ask, BUY->Bid; direction-derived).
# PLAN-TIME RIDERS (resolve at Gate 3, matrix assumes they exist):
#  T2-O3  InpTier2ProfitPercent DEFAULT (Shadow 1.0%) - confirm on merit.
#  T2-O7  Cross-currency group-P/L valuation - see G-V2.
#
# INPUT SURFACE (plan finalizes; matrix assumes these exist):
#  InpEnableTier2         bool   (Shadow InpEnablePartialClose2)   default false
#  InpTier2MinTrades      int    Gate A min open count             default 4
#  InpTier2ProfitPercent  double Gate B percent of balance         default TBD*
#  * Shadow InpPC2_ProfitPercent=1.0. Percent is symbol-AGNOSTIC (money/balance),
#    unlike Tier 1's symbol-relative points - so no gold/forex split is needed;
#    the shipped default is chosen on merit at plan time (T2-O3 rider).
#
# =====================================================================
# ENVIRONMENT / EVIDENCE RULE
# =====================================================================
# LIVE evidence comes from XAUUSD.s only (CLAUDE.md). REFERENCE arithmetic is
# recomputed from the Shadow Trade Manager PRO v3.21 tester log (GBPAUD.s M15,
# DooTechnology-Demo, 2026.06.22->07.03, initial deposit 3000.00 USD;
# docs/STM Drawdown Reduction Tier2 Logs.txt; analysis in
# docs/ENHANCEMENT_INPUT_2026-07-24_tier2.md). Shadow is REFERENCE, never spec.
# Every money row is recomputed to the cent at verify time on the live XAUUSD.s run.
# NOTE: XAUUSD.s quote currency is USD, so the cross-currency conversion (G-V2)
# collapses to identity on TRTM's gold evidence surface - the GBPAUD Shadow
# arithmetic below is the only cross-currency worked example.
#
# WORKED REFERENCE (Shadow, SELL, verified against the raw log):
#  TIER 2 FIRE  2026.07.02 15:30:28  close Ask 1.92931  (log line 816-817)
#    group = anchor #3 0.02@1.88647 + profitables #22 0.15@1.93542, #21 0.14@1.93219
#            (#20@1.92861 and all lower entries are underwater at 1.92931 -> NOT in group)
#    sumVol 0.31 ; sum(lot*entry) 0.5985490 ; VWAP 1.9308032  [CORRECTED 2026-07-25
#      F5: was 1.9311258, a /0.31 division slip; 0.5985490/0.31 = 1.9308032. The
#      Tier-1-margin that follows (=> 149.3 pts, NOT 181.6) is below 150 - see the
#      PRECEDENCE EVIDENCE correction below.]
#    GROUP P/L (quote AUD): #3 (1.88647-1.92931)*0.02*1e5 = -85.68
#                           #21 (1.93219-1.92931)*0.14*1e5 = +40.32
#                           #22 (1.93542-1.92931)*0.15*1e5 = +91.65
#                           sum = +46.29 AUD  ->  31.40 USD  (implied AUD/USD 0.6783)
#    GATE B: 31.40 USD >= 1.0% x 3026.14 = 30.26  ->  FIRE (surplus +1.14 USD).
#    GATE A: open count 15 >= 4  ->  pass.
#    Base 3026.14 = initial 3000.00 + Tier 1's +26.14 realized on 06/30 = BALANCE
#      (proven not equity: 15 underwater sells were open -> equity << 3000).
#    Close ORDER in log: anchor #3 FIRST, then #22, #21 (Shadow anchor-first;
#      TRTM INVERTS to profitables-first/anchor-last per O5/T2-O5).
#  PRECEDENCE EVIDENCE - see CORRECTION 2026-07-25 (F5) before citing:
#    At THIS Tier 2 fire the matrix ORIGINALLY claimed Tier 1's gate was ALSO met
#      (VWAP 1.9311258, margin vs Ask = 181.6 pts >= 150) "proving" Tier-2-first.
#      CORRECTED (F5): the margin consistent with the logged 31.40 USD group P/L is
#      149.3 pts (VWAP 1.9308032; = 0.5985490/0.31, and = 46.29/(0.31*1e5)) - BELOW
#      150, so Tier 1's gate was NOT met at 07/02 15:30. This fire evidences only
#      that Tier 2 fired, NOT precedence. T2-O4 (Tier-2-first) STANDS on merit +
#      money-neutrality (T2-PR4); T2-PR1 has NO reference support and MUST be
#      verified LIVE via a constructed both-gates-pass tick. Code is unaffected.
#    At the earlier TIER 1 FIRE (06/30 14:16, close Ask 1.92011): Tier 2's gate
#      FAILED (group #2 -37.06 + #14 +61.75 + #13 +14.52 = +39.21 AUD ~= 26.6 USD
#      < 1.0% x 3000.00 = 30.00) so it fell through and fired TIER 1 (VWAP 1.92162,
#      margin 151 pts >= 150). One both-pass observation; arithmetic unambiguous.
#  BUY lap: NO Shadow buy fire exists (every Shadow fire is SELL). BUY rows are
#    validated by the platform invariant (buy closes at Bid) + arithmetic.
#
# =====================================================================

## Group G-T2 - TRIGGER (Gate A count + Gate B money-percent, both laps, tick-based)
T2-1  [NEW] SELL, count >= MinTrades, group P/L just clears %-of-balance -> FIRE   -> Gate B: close-group P/L(acct ccy) >= InpTier2ProfitPercent% x AccountBalance. Ref: 31.40 >= 30.26 (1.0% x 3026.14). Recompute group P/L and the bar to the cent.
T2-2  [NEW] BUY lap (platform invariant, no Shadow evidence)                       -> group closes at BID; group P/L in acct ccy computed from Bid-side close; bar = same %-of-balance. Far price DIRECTION-DERIVED (T2-O6). Mirror of T2-1, validated by invariant + arithmetic.
T2-3  [NEW] MUST-NOT: count < MinTrades, group P/L far exceeds the bar            -> Gate A fails; Tier 2 does NOT fire regardless of profit. Prove absence on a shallow basket.
T2-4  [NEW] MUST-NOT: count >= MinTrades, group P/L just under the bar            -> Gate B fails; no Tier 2 fire (may still fall through to Tier 1 - see G-PR). Recompute group P/L just below %-of-balance; prove absence of a Tier 2 fire.
T2-5  [NEW] TICK-BASED eval, NOT bar-gated                                        -> Tier 2 evaluates every tick and fires MID-BAR (ref 15:30:28, off the M15 boundary) while recovery ENTRIES stay bar-close gated. MUST-NOT gate the fire on bar close.
T2-6  [NEW] BASE = BALANCE, re-read live each eval (T2-O1)                         -> bar uses AccountInfoDouble(ACCOUNT_BALANCE) at the eval tick (3026.14 here, = post-06/30-realized), NOT equity, NOT a cached/init balance. MUST-NOT read equity (would shrink the bar mid-drawdown).
T2-7  [NEW] MUST-NOT: whole-basket group (M-1) even when Gate B clears            -> if the group is the entire open basket, Tier 2 STANDS DOWN and defers to the sequence AvgTP (G-M2). Gate B passing does NOT override M-1.

## Group G-A2 - ANCHOR SELECTION  [INHERIT E4 G-A / C1]
T2-A1 [INHERIT E4 A-1/A-2] Anchor = strict OLDEST, transfers to next-oldest       -> ref Tier 2 fire anchor = #3 (oldest survivor after 06/30 Tier 1 consumed #2). Same ComputeTier group-anchor code as Tier 1; no separate anchor rule. Recompute; confirm oldest, not cheapest.
T2-A2 [INHERIT E4 A-3] MUST-NOT skip an expensive oldest to an affordable anchor  -> if the oldest's group does not clear the %-bar, Tier 2 does NOT fire (acceptable). Prove the oldest is always the anchor.

## Group G-G2 - GROUP FORMATION + MONEY INVARIANT  [INHERIT E4 G-G, metric NEW]
T2-G1 [INHERIT E4 G-1] Group = anchor + ALL currently-profitable positions        -> SAME group-formation code path as Tier 1 (one definition, no drift). Ref: #3 + #21 + #22 (every profitable at 1.92931). Recompute membership at the fire tick.
T2-G2 [NEW] HARD INVARIANT MUST-NOT: group ever closes at a combined loss         -> a POSITIVE percent bar guarantees group P/L >= bar > 0, so the group nets strictly > 0; the anchor alone realizes a loss, the GROUP never does. (Enforced by Gate B + O5 abort, G-X2.) Prove across the fire and every partial state.
T2-G3 [NEW] MUST-NOT: Gate B measures WHOLE-BASKET or PROFITABLES-ONLY            -> the tested value is the CLOSE-GROUP total (anchor + profitables), not the whole basket floating (deeply negative here) nor profitables-only. Recompute: whole-basket P/L at the tick is < 0; the 31.40 figure is the group. Prove the code sums the group, not the basket.

## Group G-V2 - CROSS-CURRENCY VALUATION (T2-O7)  [NEW]
T2-V1 [NEW] Group P/L is in ACCOUNT currency before the %-comparison             -> use the platform's account-currency profit (PositionGetDouble(POSITION_PROFIT) / OrderCalcProfit), which already converts quote->account. Bar (balance) is account currency; comparison is same-currency. Worked cross-currency proof: GBPAUD group 46.29 AUD -> 31.40 USD (implied AUD/USD 0.6783).
T2-V2 [NEW] MUST-NOT: compare a QUOTE-currency P/L against an account-currency bar -> on a non-USD-quote symbol a raw price*lot*contract sum is in quote ccy; comparing it to a USD balance bar is a 1-conversion error (the O4-class defect, surfaced on cross-currency symbols only). Prove TRTM uses account-currency profit.
T2-V3 [NEW] IDENTITY on USD-quote symbols (XAUUSD.s)                              -> quote ccy == account ccy (USD) so the conversion is identity; live gold evidence exercises the SAME code with factor 1.0. Recompute a gold fire to the cent (the money path, minus the FX leg).

## Group G-PR - TIER PRECEDENCE / FALL-THROUGH (T2-O4)  [NEW]
T2-PR1 [NEW] Both enabled, Tier 2 evaluated FIRST                                 -> per tick: check Tier 2; if Gate A+B pass (and not M-1), fire+credit Tier 2 and RETURN. Ref: at 15:30 both gates passed, Tier 2 credited. [CORRECTED 2026-07-25 F5: the 15:30 fire did NOT have both gates pass - Tier 1 margin was 149.3 pts < 150. NO reference both-pass exists; verify LIVE via a constructed both-gates-pass tick.]
T2-PR2 [NEW] Fall-through: Tier 2 gate fails -> evaluate Tier 1                    -> Tier 2 Gate B fails -> Tier 1 (points) still evaluated same tick; if it passes, fire+credit Tier 1. Ref: 06/30 Tier 2 failed (26.6 < 30.00) -> Tier 1 fired (151 pts).
T2-PR3 [NEW] EXACTLY ONE fire per tick (shared group, fire-then-return)           -> both tiers select the identical group and reuse the same close; the first tier to fire closes it and returns. MUST-NOT double-close / re-enter the other tier same tick.
T2-PR4 [NEW] Attribution only - money-identical either order                      -> on a both-pass tick the group that closes is identical whichever tier is credited; only the journal label differs. Prove the realized deals match regardless of precedence.
T2-PR5 [NEW] MUST-NOT (F3 defect class): Tier 2 close deals tagged as initial entries -> like Tier 1 X-5, Tier 2 close deals route through MarkEAClosed/liveness, never the initial-entry branch. Ref log shows Shadow's F3 recurs ("Confirmed initial deal #23/#24/#25 ... count 0"); TRTM must not.

## Group G-X2 - EXECUTION / PARTIAL-FILL  [INHERIT E4 G-X / O5]
T2-X1 [INHERIT E4 X-1] Close PROFITABLES first, ANCHOR last                       -> reuse the sealed close-with-retry routine; among profitables descending ticket; anchor last. MUST-NOT be anchor-first (inverts Shadow's observed #3-then-#22-then-#21).
T2-X2 [INHERIT E4 X-2/X-3] Leg FAILS after retries -> ABORT anchor / anchor fails -> anchor stays open; realized = pure profit subset, strictly >= 0; Tier 2 re-targets next qualifying tick. Invariant (T2-G2) holds in the partial state.
T2-X3 [INHERIT E4 X-4] Bounded retry via the SEALED close path                    -> no new close path invented; retries exhaust before "failed".

## Group G-P2 - POST-FIRE SEQUENCE RECOMPUTE  [INHERIT E4 G-P / E1]
T2-P1 [INHERIT E4 P-1] Sequence TP recomputed across SURVIVORS on lot-weighted VWAP -> after the fire, ComputeTargets recomputes TP on the lot-weighted survivor VWAP (E1 basis). Ref survivors: 12 positions, Avg Entry 1.91337, AvgTP 1.91137 (Shadow's simple-avg recompute; TRTM DIVERGES to weighted). Recompute survivor TP to the cent.
T2-P2 [INHERIT E4 P-2] Dashboard / projection refreshed to survivors             -> ComputeProjection + avg-entry row redraw on the survivor set; displayed == engine (no display-vs-engine drift).

## Group G-H2 - PRESERVED INDEX / RE-ARM  [INHERIT E4 G-H / G-O, C3/O1]
T2-H1 [INHERIT E4 H-2/H-4] Preserved-index refill; only HIGHER closed rungs re-arm; anchor NEVER -> vacated non-anchor addresses refill at ComputeLevelLot(N) for their address N; the closed anchor (favourable extreme) is never re-added. Shadow re-indexes by count (log Refreshed State Level=11 for 12 survivors); TRTM keeps the ADDRESS.
T2-H2 [INHERIT E4 H-5/O3] Post-fire state refresh ATOMIC with fire completion     -> closed group marked, liveness reconciles g_state before the next bar-close eval. No stale-state window; no 3s timer needed (bar-close gated).
T2-H3 [INHERIT E4 H-6] SL RE-ANCHOR when Tier 2 closes the OLDEST                 -> Tier 2's anchor (oldest = lowest-level) carries the basket SL; closing it re-anchors SL to the new lowest survivor via the existing path. SL never references a closed ticket; never unprotected mid-fire. BUY + SELL laps (SL direction-signed).

## Group G-D2 - DORMANCY / RE-ACTIVATION (Gate A, own InpTier2MinTrades)  [NEW input]
T2-D1 [NEW] MUST-NOT: a fire drops open count below InpTier2MinTrades, then fire again -> Tier 2 DORMANT while count < InpTier2MinTrades; does not fire until recovery rebuilds the count. Prove absence while shallow. (Own input - independent of Tier 1's dormancy state.)
T2-D2 [NEW] RE-ACTIVATION once count rebuilds to >= InpTier2MinTrades            -> a later recovery entry restores count; Tier 2 evaluates again. Count is always the REMAINING open positions.

## Group G-R2 - NO-FIRE BYTE-IDENTITY (Tier 2 is additive, default off)
T2-R1 [NEW] MUST-NOT: InpEnableTier2=false -> EA byte-identical to E4-b36        -> with Tier 2 disabled the whole EA (incl. Tier 1) is byte-for-byte E4-b36. Prove the Tier 2 addition is inert when off (default false).
T2-R2 [NEW] MUST-NOT: Tier 2 enabled but never fires -> Tier 1 + recovery unchanged -> on ticks where Tier 2's gate fails, fall-through leaves Tier 1 and the sealed recovery loop byte-identical to E4-b36. Tier 2 only adds a pre-check that returns early on a fire.
T2-R3 [NEW] MUST-NOT: any new PERSISTED state for Tier 2                          -> Tier 2 is fully DERIVED per tick (count, anchor, group, group-P/L all live-read). RunStateSelfTest byte-identical; no new struct field; MQL5 uninit-field trap N/A.

## Group G-K2 - RESTART / KILL  [INHERIT E4 G-K]
T2-K1 [INHERIT E4 K-1] RESTART mid-sequence with Tier 2 armed                     -> no persisted Tier 2 state; on re-init positions re-read, count/anchor/group rebuilt from live positions; Tier 2 re-evaluates cleanly. No orphan Tier 2 key.
T2-K2 [INHERIT E4 K-2] KILL mid-FIRE (group partially closed, OnDeinit skipped)   -> on restart liveness reconciles g_state; realized-so-far is pure profit or a completed group (invariant held); a surviving anchor is just an open position Tier 2 targets again. No combined-loss realized by the interruption.

## Group G-M2 - WHOLE-BASKET STAND-DOWN (M-1 applies to Tier 2)  [INHERIT E4 M-1]
T2-M1 [INHERIT E4 M-1] Whole-basket-in-group STAND-DOWN                           -> when the Tier 2 group = the ENTIRE open basket (no underwater survivor), Tier 2 STANDS DOWN and defers to the sequence's own AvgTP (bank-at-market), same rationale as Tier 1: a full-basket close is the sequence exit's job, and firing pre-empts a better guaranteed exit. Guard = grp size >= openCount. MUST-NOT fire when nothing underwater survives; MUST still fire on a real partial valve (grp < openCount).

## Group G-DS - DASHBOARD (rev 2 amendment, Jeff scope-add 2026-07-24)  [NEW, display]
DS-1 [NEW, display-only] "DD Reduce" CONFIG row reflects the armed valve tiers    -> PanelRefresh CONFIG section shows which Drawdown Reduction tiers are enabled + each armed tier's threshold, so the user sees at a glance if anything is active. Four states: none -> "OFF" (dim); T1 only -> "T1 <pts>pts" (green); T2 only -> "T2 <pct>%" (green); both -> "T1 <pts>pts + T2 <pct>%" (green). DISPLAY ONLY - reads inputs (InpEnableTier1/2, InpTier1MinProfitPts, InpTier2ProfitPercent), NO state, NO money path; refresh-safe. Verify the four states render, and the inserted CONFIG row does not disturb the LIVE SEQUENCE rows or the button grid (panel bg height is dynamic - follows the button grid bottom).

## Out of scope
E6 (Tier 3, partial-lot) - ZERO observed, needs E7 R2 first. E2 draggable exit
lines. E3 auto-entry. Tier 1 internals (sealed E4-b36; Tier 2 only REUSES its
close machinery). InpTier2ProfitPercent default + gold-symbol behavior of the
%-bar are symbol-agnostic (money/balance), not a per-symbol split.

## Status
SEALED rev 1 by Jeff 2026-07-24 (Gate 2).
AMENDMENT rev 2 (Jeff scope-add 2026-07-24): +G-DS / DS-1 (display-only "DD Reduce"
dashboard row). Built in E5-b37. 13 groups, 31 rows.
CORRECTION 2026-07-25 (F5, E5 Gate 4 recompute; evidence-only, DECISIONS unchanged):
the Tier-2-fire (07/02 15:30) VWAP is 1.9308032 (was mis-stated 1.9311258) and the
Tier-1 margin at that tick is 149.3 pts, BELOW 150 - so Tier 1's gate was NOT met and
the fire does NOT evidence Tier-2-first precedence. Fixed in the WORKED REFERENCE,
G-PR PRECEDENCE EVIDENCE, and the T2-PR1 row above. The T2-O4 decision and the SEAL
stand; T2-PR1 must be verified LIVE (constructed both-gates-pass tick). See STATE.md
T2-O4 correction + F5, and docs/E5_VERIFY_CHECKLIST.md F5.
Groups: G-T2, G-A2, G-G2, G-V2, G-PR, G-X2, G-P2, G-H2, G-D2, G-R2, G-K2, G-M2,
G-DS (13 groups). Rows: 31 (T2-1..7, A1-2, G1-3, V1-3, PR1-5, X1-3, P1-2, H1-3,
D1-2, R1-3, K1-2, M1, DS-1).
NEW rows (Tier-2-specific): T2-1..7, G2, G3, V1-3, PR1-5, D1-2, R1-3 (23).
INHERIT-E4 rows (re-asserted by code reuse): A1-2, G1, X1-3, P1-2, H1-3, K1-2, M1 (12) minus overlap.
MUST-NOT / must-not-fire rows: T2-3, T2-4, T2-7, A2, G2, G3, V2, PR3, PR5, D1,
R1, R2, R3, M1.
BUY + SELL laps: T2-1/T2-2 (and O6 direction-derived across G-X2, G-V2, H3).
Cross-currency: G-V2 (identity on XAUUSD.s; GBPAUD Shadow arithmetic the only
FX worked example). Precedence/fall-through: G-PR (both fires reproduce it).
Money invariant (group never nets a loss): T2-G2 + G-X2.
Gate 3 (code plan) is next, AFTER Jeff seals this matrix.
