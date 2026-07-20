# Stage 8 Step 1 - Manual Exit Adoption - SCENARIO MATRIX (rev 2)
# Base build: Stage7-b23 (05edfc4dbe79b774). All rows demo XAUUSD.s.
# BUY-worded; direction-symmetric. Evidence BUY, SELL spot-checks (S).
#
# REV 2: policy selector DROPPED (Jeff 2026-07-16). There is no Policy
# A/B input - manual exit adoption is THE exit policy. Rationale:
# adjustments are the trader's responsibility (trader knows the risk of
# pushing/pulling exits); the EA's job is to REVERT REMOVALS (fat-
# finger stripping protection) and to INFORM on risk, not to police
# intent. DEPLOY NOTE: this is a live-behavior change on every chart
# in the fleet - flagged and accepted.
#
# Locked decision set (final):
# D1 (amended) no selector; adoption always on. Removals always
#    reverted. Risk-informing logs on adoption (see LOG SPEC).
# D2 (amended) ASYMMETRIC lifetime:
#    TP: owns until structural event (level add / close / trail-arm);
#        structure change invalidates the idea behind the edit.
#    SL: persists until flat / re-edit / BE-trail arm. No structural
#        release (release-on-add rejected: recompute past price would
#        let b5 manufacture a forced max-loss close). Manual SL doubles
#        as chart-side level budget under unlimited recovery.
# D3 removal (TP or SL -> 0) ALWAYS reverted + WARN; config is the
#    place for deliberate no-TP.
# D4 manual substitutes as want-value; b3/b5 exceeded rules, b20 race
#    gates, stops-level deferral apply unchanged.
# D5 engines own once armed; tighter-SL-adopt only channel post-arm;
#    trail-arm is a TP release event.
# D6 propagate to all tickets; >1 distinct manual value in one pass =
#    adopt none, revert all, WARN.
# D7 manualTP/manualSL persisted; save at adoption (14th site);
#    reconcile composes D2/D6; death-window close releases TP only.
#
# LOG SPEC (adoption events):
#   Exposure-increasing (SL loosened, TP pushed farther): WARN with
#   risk note, e.g. "Manual SL 3985 adopted (was 4000) - max loss
#   widened ~$X; more recovery levels can open before stop".
#   Exposure-neutral/decreasing (SL tightened, TP pulled closer):
#   INFO, e.g. "Manual TP 4010 adopted (computed 4013)".
#   Dashboard: TP/SL rows show [MANUAL] tag while owned.

## Group M1 - removal protection (must-NOT-strip; replaces old A-suite)
M1-1  remove TP (0), pre-arm                        -> re-applied (manual if owned else computed), WARN "removal reverted - use config for no-TP".
M1-2  remove SL (0), any phase                      -> re-applied, WARN. Must NOT complete any pass with SL stripped.
M1-3  trailing active, TP re-add                    -> WARN+REMOVED (S7 behavior unchanged).
M1-4  state file with manualTP/manualSL keys absent -> loads clean, 0.0 = not owned. Backward compat.

## Group M2 - manual TP adoption (pre-arm)
M2-1  1-level seq, edit TP valid                    -> adopted, propagated, log per SPEC; state saved.
M2-2  3-level seq, edit TP on middle ticket         -> adopted; same TP written to other 2 same pass. (S)
M2-3  manual TP == computed (no-op)                 -> no adoption event, no log spam.
M2-4  manual TP inside stops level as price approaches -> propagation defers, existing stops-level WARN, retries. No new path.
M2-5  second edit while owning                      -> latest wins, re-propagated, log per SPEC.
M2-6  TP pushed FARTHER than computed               -> adopted + WARN risk note (later exit, larger float exposure at target).
M2-7  (b26, found live) DISPLAY TRUTH: dashboard TP/SL rows and Proj at
      TP/SL and the Structure log must show/project from the value
      actually in charge (manual when owned), not raw computed. b25
      showed computed value + [MANUAL] tag and froze the projection.

## Group M3 - manual SL adoption
M3-1  SL tightened vs computed anchor               -> adopted, propagated, INFO. (S)
M3-2  SL loosened vs computed anchor                -> adopted, propagated, WARN risk note (max loss widened; level budget increased). LOCKED.
M3-3  SL landing beyond price via gap               -> b5 SL-exceeded vs manual value: close at market (max acceptable loss met).
M3-4  SL owned, level add fires                     -> SL untouched. Must NOT re-anchor, must NOT WARN-release. (S)
M3-5  SL tightened inside grid (above next trigger) -> price hits SL first: broker fills all, flat, trigger never fires (SL = level budget). Gap-through: b5 keyed to manual SL.

## Group M4 - conflict / propagation window
M4-1  two tickets edited to different TPs, one pass -> adopt none, revert all to lastApplied, single WARN. Must NOT propagate either.
M4-2  conflict then clean single edit next tick     -> normal adoption; refusal not sticky.
M4-3  price gaps past manual TP mid-propagation     -> b20 gate does NOT stand down -> exceeded close at market keyed to manual TP; attribution names manual target.
M4-4  all tickets carry manual TP, price hits it    -> broker fills; gate stands down; must NOT fire redundant close (no 10036).

## Group M5 - TP structural release (D2)
M5-1  owning TP, recovery adds level                -> release, computed re-asserted, WARN "manual TP released - level add".
M5-2  owning TP, worst level closed                 -> release, WARN "level close". (S)
M5-3  owning TP, trail trigger arms                 -> trail removes TP incl. manual; WARN "released - trailing armed".
M5-4  release recompute lands TP already exceeded (R8 shape) -> Choice 1: close at market (Deferred-TP lock unchanged).
M5-5  re-edit after release                         -> fresh adoption; ownership per structural window.
M5-6  (b25, found live) structural recompute pass: tickets carrying the
      PREVIOUS computed value (== lastApplied) must NOT read as manual
      edits - they are the EA's own stale write awaiting rewrite. b24
      adopted its own value here (TP adopt/release oscillation per level
      add; SL variant would freeze a stale anchor). Candidate now
      requires delta from want AND from lastApplied. Known nuance: a
      trader re-setting EXACTLY the pre-recompute value in that one-pass
      window is reverted once - re-edit next pass adopts normally.

## Group M6 - BE / trail (post-arm)
M6-1  BE applied, manual SL above BE (tighter)      -> adopted (ratchet-adopt pattern), INFO.
M6-2  BE applied, manual SL below BE (looser)       -> refused, reverted, WARN. Must NOT lower BE floor.
M6-3  trailing, manual tighter SL                   -> ratchet floor adopt (Stage 6 D3, unchanged).
M6-4  trailing, manual looser SL                    -> refused, reverted, WARN.

## Group M7 - restart / kill / reconcile (D7)
M7-1  owning TP+SL, param-change re-init            -> both continue (state + broker match), INFO on resume.
M7-2  owning, terminal restart                      -> same via state file + re-assert.
M7-3  owning, HARD KILL (taskkill /F), relaunch     -> ownership continues; broker held values throughout; zero false WARNs.
M7-4  position closed while EA dead                 -> resume: TP releases (structural, WARN names death-window close); SL ownership CONTINUES.
M7-5  trader edited TP while EA dead                -> resume: broker != computed & != persisted -> fresh adoption, log per SPEC.
M7-6  two tickets edited differently while dead     -> conflict refusal on resume (M4-1 path), revert, WARN.
M7-7  KILL mid-propagation (1 of 3 tickets written)  -> resume: persisted manual completes propagation; WARN "manual SL propagation completed after restart - #t carried stale SL during downtime".

M7-8  (b28, found live 2026-07-18 K2) death-window release (M7-4) with
      survivors still carrying the released manual value -> must NOT
      re-adopt (M7-5 candidate requires delta from the released value);
      one-shot INFO names the stale write; computed re-asserted by
      enforcement. b27 re-adopted its own propagation as a trader edit.
      Nuance (mirrors M5-6): genuine dead-edit to exactly the old value
      is reverted once; re-edit live adopts normally.

## Out of scope (Step 1)
Draggable lines (Step 2, incl. drag-clamp). CONFIG-BLOCKED behavior
unchanged. Policy selector: does not exist (rev 2).

## Status
SEALED by Jeff 2026-07-16 (rev 2 + M7-7). 37 rows.
M7-8 added 2026-07-18 (K2 FAIL on b27, fix confirmed by Jeff). 38 rows. Next: b24 code plan.
