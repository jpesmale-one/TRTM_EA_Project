# E6 - Drawdown Reduction Tier 3 (partial-lot anchor slice) - SCENARIO MATRIX
# Status: SEALED rev 1 (Gate 2). Sealed by Jeff 2026-07-26.
# Base build: E5-b37 (73dda148c79f1b27 / 4568 lines).
# Target build: E6-bNN (label TBC by Jeff).
#
# ONE-LINE: Tier 1's close, but the OLDEST anchor contributes only a SLICE
# (ClosePercent of its lots, floored, anchor >= MinLots) to BOTH the close AND
# the gate - the profitables still close FULLY, the anchor SURVIVES at reduced
# volume, and the gate is the SLICED-anchor group VWAP clearing MinProfitPoints
# (points). This lets Tier 3 fire in the deep-drawdown regime where the FULL-
# anchor tiers (T1 points / T2 percent) are locked out because the deep anchor
# loss sinks the full-basket gate.
#
# RELATIONSHIP TO E4 (Tier 1, SEALED) / E5 (Tier 2, SEALED E5-b37): Tier 3
# REUSES the sealed close machinery - group formation (anchor + every
# profitable), oldest-anchor selection, far-side derivation (E4 O4),
# profitables-first/anchor-last/abort close (E4 O5), preserved-index re-arm
# (C3/E4 O1), atomic post-fire refresh (E4 O3), post-fire TP recompute on
# lot-weighted survivors (E1). Tier 3 CHANGES three things and ADDS one:
#   (1) the anchor is SLICED not fully closed (new PARTIAL-close primitive);
#   (2) the gate is the SLICED-anchor group VWAP (points), not the full-anchor
#       group (this is what makes Tier 3 fire where T1/T2 can't);
#   (3) the anchor SURVIVES, so Tier 3 does NOT re-anchor the SL (KEY divergence
#       from T1/T2, which close the anchor and re-anchor SL);
#   plus MinLots eligibility + slice normalization as a new sizing stage.
# Rows re-asserting an E4/E5 behavior via code reuse are tagged [INHERIT];
# rows NEW to Tier 3 are tagged [NEW].
#
# Tier 3 is POINTS-based (per-lot VWAP margin, like Tier 1), so it does NOT
# introduce Tier 2's cross-currency group-P/L valuation path (no G-V analog).
#
# =====================================================================
# LOCKED DECISIONS (E6 Gate 1, 2026-07-25..26 - see STATE.md locked-decisions log)
# =====================================================================
#  T3-O0  ADOPT as a SEPARATE default-off tier (InpEnableTier3), a third valve
#         alongside sealed Tier 1 + Tier 2.
#  T3-O1  PARTIAL-CLOSE PRIMITIVE = native CTrade::PositionClosePartial(ticket,
#         sliceVol) via the sealed order-send wrapper; SAME ticket survives at
#         reduced volume (keeps anchor identity/address). NOT close-full+re-open.
#  T3-O2  FIRE CONDITION = fixed-ClosePercent slice + the SLICED-anchor group
#         VWAP clears MinProfitPoints per lot in front of the far side. The gate
#         is measured over the anchor's SLICE volume (lots being closed), NOT
#         the surviving remainder, NOT the full anchor. Structurally = Tier 1
#         with the anchor's slice substituted for its full lot.
#  T3-O3  MinLots = anchor-ELIGIBILITY floor (full anchor lot >= MinLots >= 2
#         lot steps). Oldest anchor < MinLots -> Tier 3 STANDS DOWN (no slice,
#         no full close); Tier 1/2 cover that basket if THEY qualify.
#  T3-O4  SLICE = floor(anchorLot * ClosePercent / step) * step, clamped
#         max(1 step, min(slice, anchorLot - 1 step)) so it is ALWAYS partial.
#  T3-O5  SLICED ANCHOR = residual survivor at UNCHANGED entry/address, reduced
#         volume; residual vol LIVE-READ (no new persisted field); C3
#         preserved-index + E4 O1 (anchor never re-arms) inherited.
#  T3-O6  PRECEDENCE = T2 -> T1 -> T3, SINGLE-FIRE per tick. Tier 3 last (the
#         partial valve is the last resort, after full closes fail to qualify).
#  T3-O7  CLOSE ORDER = profitables-first (full), anchor-slice LAST; abort
#         before the slice if any profitable leg fails; slice fail/short-fill ->
#         accept + log, no retry (profit already banked; anchor stays larger).
#  T3-O8  FAR-SIDE = direction-derived (SELL->Ask observed, BUY->Bid invariant);
#         BOTH laps in the matrix (E4 O4).
#  T3-O9  POST-FIRE = lot-weighted survivor VWAP TP (incl. the reduced anchor at
#         its remainder) + C3 preserved-index; REJECT Shadow count re-index.
#
# SPUN OUT -> E8 (own Gate 1): Jeff's profit-funded follow-on slice (spend part
# of a T1/T2 harvest to also slice the new anchor). NOT in E6 scope.
#
# PLAN-TIME RIDERS (resolve at Gate 3; matrix assumes they exist):
#  - InpTier3MinProfitPoints DEFAULT (Shadow 200). POINTS are symbol-RELATIVE
#    (like Tier 1's points, unlike Tier 2's symbol-agnostic percent) - so the
#    default + any gold/forex treatment mirrors Tier 1's MinProfitPoints, set on
#    merit at plan time.
#  - InpTier3ClosePercent default (Shadow 50.0); InpTier3MinLots default (Shadow
#    0.02); InpTier3MinTrades default (Shadow 4).
#
# INPUT SURFACE (plan finalizes; matrix assumes these exist):
#  InpEnableTier3          bool   (Shadow InpEnablePartialClose3)  default false
#  InpTier3MinTrades       int    Gate A min open count            default 4
#  InpTier3MinProfitPoints int    Gate B sliced-VWAP margin (pts)  default TBD*
#  InpTier3MinLots         double anchor slice-eligibility floor   default 0.02
#  InpTier3ClosePercent    double slice = % of anchor lots         default 50.0
#  * symbol-relative points; default/gold treatment mirrors Tier 1 (rider).
#
# =====================================================================
# ENVIRONMENT / EVIDENCE RULE
# =====================================================================
# LIVE evidence comes from XAUUSD.s only (CLAUDE.md). REFERENCE arithmetic is
# recomputed from the Shadow Trade Manager PRO v3.21 tester log (GBPAUD.s M15,
# DooTechnology-Demo, initial deposit 3000.00 USD; docs/STM Drawdown Reduction
# Tier3 Logs.txt; analysis docs/ENHANCEMENT_INPUT_2026-07-25_tier3.md). Shadow
# is REFERENCE, never spec. Point=0.00001, Digits=5, StopsLevel=25.0. Every
# money/point row is recomputed to the cent at verify time on the live XAUUSD.s
# run. Tier 3's gate is POINTS (per-lot), symbol-relative like Tier 1.
#
# WORKED REFERENCE (Shadow, SELL, verified to the cent against the raw log).
# The gate uses the anchor at its SLICE volume; FIRE 2 disambiguates slice vs
# remainder (they are equal in FIRE 1).
#
#  FIRE 1  2026.06.25 15:47:58  Bid/Ask 1.90756 / 1.90784  (log lines 506-532)
#    anchor #3 full 0.02 @1.88594 -> slice floor(0.02*0.50)=0.01, remaining 0.01
#    profitables #16 0.09 @1.91286, #15 0.08 @1.90957 (both > 1.90784 close)
#    CLOSING group = {#3 slice 0.01, #16 0.09, #15 0.08}; sumVol 0.18
#      sum(lot*entry) = 0.0188594 + 0.1721574 + 0.1527656 = 0.3437824
#      VWAP = 0.3437824 / 0.18 = 1.9099022 -> 1.90990 (log EXACT)
#    GATE B: margin = 1.90990 - 1.90784 = 0.0020622 = 206.2 pts >= 200 -> FIRE
#    GATE A: open count 9 >= 4 -> pass
#    Group P/L (AUD) at the slice: #3 (1.88594-1.90784)*0.01*1e5 = -21.90
#                                  #16 (1.91286-1.90784)*0.09*1e5 = +45.18
#                                  #15 (1.90957-1.90784)*0.08*1e5 = +13.84
#                                  group = +37.12 AUD (> 0 -> invariant holds)
#    WHY T1/T2 CANNOT fire here (full anchor 0.02): full VWAP =
#      0.3626418/0.19 = 1.9086411; full margin = 80.1 pts < 150 (T1 fails);
#      full group money = -43.80+45.18+13.84 = +15.22 AUD ~= +10 USD, < ~1% x
#      balance (~30 USD) (T2 fails). ONLY the sliced gate (206 pts) qualifies.
#    Post-fire survivors = 7 (#3 now 0.01, #4..#9); sumVol 0.34; lot-weighted
#      VWAP = 0.645730/0.34 = 1.899206 -> 1.89921 (log EXACT); TP = 1.89721
#      (=VWAP - 200 pts). Shadow count-reindex Level (rejected; TRTM keeps C3).
#    Close ORDER in log: anchor SLICE first (#17), then #16 (#18), #15 (#19)
#      (Shadow anchor-first; TRTM INVERTS to profitables-first / slice-last).
#
#  FIRE 2  2026.07.02 15:31:07  Bid/Ask 1.92653 / 1.92682  (log lines 927-953)
#    anchor #4 full 0.03 @1.88917 -> slice floor(0.03*0.50=0.015)=0.01 (NOT
#      0.02), remaining 0.02
#    profitables #31 0.13 @1.93219, #30 0.12 @1.92861
#    CLOSING group = {#4 slice 0.01, #31 0.13, #30 0.12}; sumVol 0.26
#      sum(lot*entry) = 0.0188917 + 0.2511847 + 0.2314332 = 0.5015096
#      VWAP = 0.5015096 / 0.26 = 1.9288831 -> 1.92888 (log EXACT)
#    SLICE-vs-REMAINDER PROOF (all three use the same profitables sum 0.4826179):
#      slice 0.01     -> (0.0188917+0.4826179)/0.26 = 0.5015096/0.26 = 1.92888 (YES)
#      remaining 0.02 -> (0.0377834+0.4826179)/0.27 = 0.5204013/0.27 = 1.92741 (NO)
#      full 0.03      -> (0.0566751+0.4826179)/0.28 = 0.5392930/0.28 = 1.92605 (NO)
#      Only slice 0.01 gives the logged 1.92888.
#    GATE B: margin = 1.92888 - 1.92682 = 0.0020631 = 206.3 pts >= 200 -> FIRE
#    ROUNDING PROOF (why FLOOR, T3-O4): round-half-up slice 0.02 ->
#      0.5392930/0.27 = 1.92741, margin 59.2 pts < 200 -> would NOT fire.
#    Group P/L (AUD) at the slice: #4 (1.88917-1.92682)*0.01*1e5 = -37.65
#                                  #31 (1.93219-1.92682)*0.13*1e5 = +69.81
#                                  #30 (1.92861-1.92682)*0.12*1e5 = +21.48
#                                  group = +53.64 AUD (> 0)
#    WHY T1/T2 CANNOT fire (full anchor 0.03): full margin = -77.4 pts (the
#      full group is NET NEGATIVE) -> T1 fails hard, T2 fails (group underwater).
#    ANCHOR TRANSFER: fire 1 anchor #3; fire 2 anchor #4 (after #3 left the
#      book) -> oldest-transfer confirmed. #3 had been left at 0.01 (< MinLots)
#      by fire 1 and was never sliced again (T3-O3 stand-down evidence).
#    Post-fire survivors = 11; sumVol 0.80; lot-weighted VWAP 1.91058 (log);
#      TP 1.90858 (=VWAP - 200 pts).
#
#  BUY lap: NO Shadow buy fire exists (all Shadow data SELL). BUY rows are
#    validated by the platform invariant (buy closes at Bid) + arithmetic.
#  TIERS NEVER COMPETED in the run: Tier 3 fired only when the FULL-anchor tiers
#    failed. The both-qualify precedence (G-PR3) is UNOBSERVED -> constructed +
#    verified LIVE.
#
# =====================================================================

## Group G-T3 - TRIGGER (Gate A count + Gate B sliced-VWAP points, both laps, tick)
T3-1  [NEW] SELL, count >= MinTrades, sliced-anchor group VWAP clears MinProfitPoints -> FIRE  -> Gate B: (VWAP_slice-group - closeAsk) >= InpTier3MinProfitPoints pts. Ref FIRE 1: 206.2 >= 200 (1.90990 vs 1.90784). Recompute slice, VWAP, margin to the cent.
T3-2  [NEW] BUY lap (platform invariant, no Shadow evidence)                                   -> group closes at BID; margin = (closeBid - VWAP_slice-group) >= MinProfitPoints. Far price DIRECTION-DERIVED (T3-O8). Mirror of T3-1, validated by invariant + arithmetic.
T3-3  [NEW] MUST-NOT: count < MinTrades, margin far exceeds threshold                          -> Gate A fails; Tier 3 does NOT fire regardless of margin. Prove absence on a shallow basket.
T3-4  [NEW] MUST-NOT: count >= MinTrades, sliced margin just UNDER MinProfitPoints             -> Gate B fails; no Tier 3 fire (may fall through - N/A, Tier 3 is LAST; nothing after it). Recompute a margin just below 200; prove absence.
T3-5  [NEW] TICK-BASED eval, fires MID-BAR                                                     -> ref 15:47:58 / 15:31:07 off the M15 boundary; recovery ENTRIES stay bar-close gated. MUST-NOT gate the fire on bar close.
T3-6  [NEW, CRITICAL] Gate uses the SLICE vol, NOT remainder, NOT full anchor                  -> FIRE 2 forces it: slice 0.01 -> 1.92888 (fires); remaining 0.02 -> 1.92741; full 0.03 -> 1.92605. MUST compute the gate VWAP with the anchor at its slice volume.

## Group G-SL - SLICE SIZING (NEW core: T3-O2/O3/O4)
T3-SL1 [NEW] slice = floor(anchorLot * ClosePercent / step) * step                            -> ref FIRE 1 floor(0.02*0.50)=0.01; FIRE 2 floor(0.03*0.50=0.015)=0.01. Recompute both; NOT round, NOT ceil.
T3-SL2 [NEW] Anchor eligibility: full anchor lot >= InpTier3MinLots (>= 2 lot steps)          -> ref both anchors 0.02 / 0.03 >= 0.02. Prove an anchor below MinLots is never sliced.
T3-SL3 [NEW] MUST-NOT: the slice ever zeroes/oversizes the anchor                              -> clamp max(1 step, min(slice, anchorLot - 1 step)); prove remaining >= 1 step ALWAYS (Tier 3 is partial by definition; a full close is Tier 1's job).
T3-SL4 [NEW, STAND-DOWN] Oldest anchor < MinLots -> Tier 3 does NOT fire                       -> no slice, no full close; Tier 1/2 cover the basket if they qualify. Ref: FIRE 1 left #3 at 0.01 (<0.02) -> never sliced again; FIRE 2 sliced the NEW oldest eligible #4. Prove absence when the oldest is sub-MinLots.
T3-SL5 [NEW] Realized close fraction DIVERGES from nominal ClosePercent when floor bites       -> FIRE 2: 0.01/0.03 = 33% (not 50%). Documented, not a defect. FLOOR is required: round-up (0.02) drops the gate to 59.2 pts < 200 -> would not fire. Prove floor via the FIRE 2 recompute.

## Group G-A3 - ANCHOR SELECTION  [INHERIT E4 G-A / C1]
T3-A1 [INHERIT E4 A-1/A-2] Anchor = strict OLDEST, transfers to next-oldest                    -> ref FIRE 1 #3, FIRE 2 #4 (after #3 left the book). SAME group-anchor code as Tier 1. NOTE: a SLICED anchor stays the oldest (survives) and is re-sliceable on later ticks until it drops below MinLots (then T3-SL4).
T3-A2 [INHERIT E4 A-3] MUST-NOT skip an expensive oldest to an affordable anchor               -> if the oldest's sliced group does not clear MinProfitPoints, Tier 3 does not fire (acceptable). Prove the oldest is always the anchor.

## Group G-G3 - GROUP FORMATION + MONEY INVARIANT  [INHERIT E4 G-G, gate metric NEW]
T3-G1 [INHERIT E4 G-1] Group = anchor(SLICED) + ALL currently-profitable positions            -> SAME group-formation path as Tier 1, anchor contributing its slice. Ref FIRE 1 {#3 slice, #16, #15}; FIRE 2 {#4 slice, #31, #30}. Recompute membership at the fire tick.
T3-G2 [NEW] HARD INVARIANT MUST-NOT: the closing group ever nets a combined loss              -> the sliced-VWAP >= MinProfitPoints gate guarantees group P/L > 0. Ref FIRE 1 group +37.12 AUD; FIRE 2 +53.64 AUD. Only the anchor SLICE realizes a loss; the GROUP never does. Prove across the fire and every partial state (with O7 abort).
T3-G3 [NEW] MUST-NOT: gate measures the WHOLE BASKET or the FULL-anchor group                 -> full-anchor margin FIRE 1 +80.1 / FIRE 2 -77.4 pts would FAIL; the whole-basket floating P/L is deeply negative. Prove the code sums the SLICE-group, not the basket, not the full anchor.

## Group G-PR3 - TIER PRECEDENCE (T3-O6, 3-way, single-fire)  [NEW]
T3-PR1 [NEW] Dispatcher order T2 -> T1 -> T3, first qualifying fires and RETURNS               -> extend E5's EvaluateBasketClose: Tier 2 (percent), else Tier 1 (points), else Tier 3 (sliced). Tier 3 reached only when the full-close tiers do not qualify.
T3-PR2 [NEW, UNOBSERVED -> verify LIVE] Constructed tick: T1 (full) AND T3 (slice) both qualify -> dispatcher fires TIER 1 (full close), Tier 3 SKIPPED that tick. Prove full close is preferred. No reference (tiers never competed); build a both-qualify tick live.
T3-PR3 [NEW, UNOBSERVED -> verify LIVE] Constructed tick: T2 (percent) AND T3 both qualify     -> dispatcher fires TIER 2, Tier 3 SKIPPED. Prove T2 precedence over T3.
T3-PR4 [NEW] EXACTLY ONE fire per tick                                                         -> MUST-NOT: a Tier 3 slice then a same-tick T1/T2 evaluation on the smaller basket. First qualifying tier fires and returns; the next tick re-evaluates.
T3-PR5 [NEW] Fall-through to Tier 3: T2 fails AND T1 fails AND T3 qualifies -> T3 fires         -> the OBSERVED case (both fires: full-anchor T1/T2 failed, sliced T3 cleared). Recompute both fires as the fall-through-to-T3 path.
T3-PR6 [NEW] MUST-NOT (F3 defect class): Tier 3 close/slice deals tagged as initial entries    -> like T1 X-5 / T2 PR5, route close AND partial-slice deals through MarkEAClosed/liveness, never the initial-entry branch. Ref log F3 recurs ("Confirmed initial deal #17/#18/#19 ... count 0"); TRTM must not.

## Group G-X3 - EXECUTION / PARTIAL-CLOSE PRIMITIVE + PARTIAL-FILL  (T3-O1/O7)  [INHERIT E4 O5 order]
T3-X1 [INHERIT E4 X-1] Close PROFITABLES first (full), ANCHOR SLICE last                        -> among profitables descending ticket; anchor slice last. MUST-NOT be anchor-first (inverts Shadow's observed #17-slice-then-#18-#19).
T3-X2 [NEW] Anchor leg = CTrade::PositionClosePartial(ticket, sliceVol)                         -> SAME ticket survives at reduced volume (supports T3-O5). Reuse the sealed order-send wrapper + retcodes; no new close path.
T3-X3 [NEW] Partial-fill / abort discipline                                                    -> a profitable leg fails after retries -> ABORT before the slice (loss leg never opens; invariant T3-G2 held). The anchor slice fails / short-fills -> profit already banked, accept + log, NO retry; the anchor stays larger (safe survivor), re-qualifies later.
T3-X4 [NEW] MUST-NOT: a broker partial-close rejection (min-partial-lot) loops or errors        -> a rejected slice routes to the T3-X3 accept+log branch, not a retry loop or a hard error. Prove graceful handling.

## Group G-P3 - POST-FIRE SEQUENCE RECOMPUTE  [INHERIT E4 G-P / E1]
T3-P1 [INHERIT E4 P-1] Sequence TP recomputed across SURVIVORS on lot-weighted VWAP            -> survivors INCLUDE the reduced anchor at its REMAINING volume. Ref FIRE 1: 7 survivors, avg 1.89921, vol 0.34, TP 1.89721. Recompute to the cent (anchor at remainder 0.01).
T3-P2 [INHERIT E4 P-2] Dashboard / projection refreshed to survivors                           -> ComputeProjection + avg-entry row redraw over the survivor set incl. the reduced anchor; displayed == engine (no drift).

## Group G-H3 - RESIDUAL SURVIVOR / PRESERVED INDEX / SL  (T3-O5)  [INHERIT C3 / E4 O1]
T3-H1 [INHERIT E4 H-2/H-4] Preserved-index refill; only HIGHER closed rungs (profitables) re-arm; anchor NEVER -> vacated profitable addresses refill at ComputeLevelLot(N); the anchor (favourable extreme) is never re-added. Shadow count-reindex (FIRE 2 Level over 11 survivors) rejected; TRTM keeps the ADDRESS.
T3-H2 [NEW] SLICED ANCHOR = residual survivor, SAME entry/address, reduced volume              -> residual volume is LIVE-READ on reconcile; NO new persisted field (broker position volume IS the state). Prove no state schema / self-test change.
T3-H3 [NEW, KEY DIVERGENCE from T1/T2] SL anchor UNCHANGED (anchor SURVIVES)                    -> because Tier 3 does NOT close the anchor, the basket SL stays anchored to the surviving anchor's ENTRY; Tier 3 does NOT re-anchor SL (T1/T2 DO). MUST-NOT modify/re-anchor SL on a Tier 3 fire; prove SL byte-identical across a slice. BUY + SELL laps.
T3-H4 [INHERIT E4 H-5 / O3] Post-fire state refresh ATOMIC with fire completion                -> closed profitables marked + reduced anchor reconciled before the next bar-close eval; no stale-state window; no 3s timer (bar-close gated).

## Group G-D3 - DORMANCY / RE-ACTIVATION (Gate A, own InpTier3MinTrades)  [NEW input]
T3-D1 [NEW] MUST-NOT: a fire drops open count below InpTier3MinTrades, then fire again          -> Tier 3 DORMANT while count < InpTier3MinTrades. NOTE: a Tier 3 fire reduces count by the # of PROFITABLES closed only (the anchor survives, still counted). Prove absence while shallow.
T3-D2 [NEW] RE-ACTIVATION once count rebuilds to >= InpTier3MinTrades                          -> a later recovery entry restores count; Tier 3 evaluates again. Count = REMAINING open positions (incl. the reduced anchor).

## Group G-R3 - NO-FIRE BYTE-IDENTITY (Tier 3 is additive, default off)
T3-R1 [NEW] MUST-NOT: InpEnableTier3=false -> EA byte-identical to E5-b37                       -> with Tier 3 disabled the whole EA (incl. T1/T2) is byte-for-byte E5-b37. Prove the Tier 3 addition is inert when off (default false).
T3-R2 [NEW] MUST-NOT: Tier 3 enabled but never fires -> T1/T2 + recovery unchanged             -> on ticks where Tier 3's gate fails, the sealed dispatcher + recovery loop stay byte-identical to E5-b37. Tier 3 only adds a trailing dispatcher branch that returns on a fire.
T3-R3 [NEW] MUST-NOT: any new PERSISTED state for Tier 3                                        -> Tier 3 fully DERIVED per tick (count, anchor, slice, group, group-VWAP all live-read; residual anchor is a live position). RunStateSelfTest byte-identical; no new struct field; MQL5 uninit-field trap N/A.

## Group G-K3 - RESTART / KILL  [INHERIT E4 G-K]
T3-K1 [INHERIT E4 K-1] RESTART mid-sequence with Tier 3 armed                                  -> no persisted Tier 3 state; on re-init positions re-read, count/anchor/slice/group rebuilt from live positions (the reduced anchor is just a smaller open position). Tier 3 re-evaluates cleanly; no orphan key.
T3-K2 [NEW] KILL mid-FIRE (OnDeinit skipped)                                                   -> two sub-cases: (a) killed after profitables closed but BEFORE the slice -> realized = pure profit subset (>= 0), anchor still full, invariant held, Tier 3 re-targets; (b) killed after the slice -> the reduced anchor is an ordinary smaller open position, liveness reconciles cleanly. No combined-loss realized by the interruption.

## Group G-M3 - WHOLE-BASKET STAND-DOWN (M-1 adapted to a surviving anchor)  [INHERIT E4 M-1]
T3-M1 [INHERIT E4 M-1, adapted] MUST-NOT fire when nothing underwater would survive             -> if every open position is the anchor or profitable AND the anchor itself is in profit (whole basket near TP), Tier 3 STANDS DOWN and defers to the sequence AvgTP - slicing a winning anchor to bank early pre-empts a better guaranteed exit. NOTE: normally the residual anchor is underwater (deepest loser) so Tier 3 leaves an underwater survivor by construction; this guard only bites when the whole basket has moved into profit. MUST still fire on a real deep-drawdown partial valve.

## Group G-DS3 - DASHBOARD (extend E5's DS-1 "DD Reduce" row)  [NEW, display]
T3-DS1 [NEW, display-only] "DD Reduce" CONFIG row reflects the THIRD armed tier                -> extend the E5-b37 DS-1 row so the enabled set now spans T1 (pts) / T2 (pct) / T3 (pts) in any combination, each armed tier showing its threshold. DISPLAY ONLY - reads inputs (InpEnableTier1/2/3 + thresholds), NO state, NO money path; refresh-safe. Verify the combinations render and the row does not disturb the LIVE SEQUENCE rows or the button grid (dynamic panel height).

## Out of scope
E8 (profit-funded follow-on slice) - Jeff's idea, own Gate 1, depends on E6.
E2 draggable exit lines. E3 auto-entry. Tier 1 / Tier 2 internals (sealed;
Tier 3 only REUSES the close machinery + extends the dispatcher). Cross-currency
group valuation (Tier 3 is points-based - no G-V analog). InpTier3MinProfitPoints
default + gold treatment = a plan-time rider (mirror Tier 1's points).

## Status
SEALED rev 1 by Jeff 2026-07-26 (Gate 2).
Groups (13): G-T3, G-SL, G-A3, G-G3, G-PR3, G-X3, G-P3, G-H3, G-D3, G-R3, G-K3,
G-M3, G-DS3.
Rows (36): T3-1..6 (6), SL1..5 (5), A1-2 (2), G1-3 (3), PR1-6 (6), X1-4 (4),
P1-2 (2), H1-4 (4), D1-2 (2), R1-3 (3), K1-2 (2), M1 (1), DS1 (1).
NEW rows (Tier-3-specific): T3-1..6, SL1..5, G2, G3, PR1..6, X2..4, H2, H3, D1-2,
R1-3, K2, DS1.
INHERIT rows (re-asserted by code reuse): A1-2, G1, X1, P1-2, H1, H4, K1, M1.
MUST-NOT / must-not-fire rows: T3-3, T3-4, T3-6, SL3, SL4, G2, G3, PR2, PR3,
PR4, PR6, X4, H3, D1, R1, R2, R3, M1.
CRITICAL correctness rows: T3-6 (gate on slice vol), SL4 (sub-MinLots stand-down),
SL5 (floor required), G2 (group never nets a loss), H3 (SL not re-anchored),
PR2/PR3 (precedence, UNOBSERVED -> live), R1/R3 (inert when off, no persisted state).
BOTH laps: T3-1 / T3-2 (and O8 direction-derived across G-X3, H3).
Precedence: G-PR3 (T2->T1->T3; both-qualify UNOBSERVED, constructed + verified LIVE).
Money invariant (group never nets a loss): T3-G2 + G-X3.
Worked reference: 2 fires recomputed to the cent (FIRE 1 / FIRE 2 above); slice-vs-
remainder disambiguated by FIRE 2; floor requirement proven by FIRE 2 round-up.
Gate 3 (code plan) is next, AFTER Jeff seals this matrix.
