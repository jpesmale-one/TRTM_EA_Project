# Stage 8 Step 1 - DEMO VERIFICATION CHECKLIST (build Stage8-b28)
# Pass/fail per item, live log evidence required. Evidence: XAUUSD.s.
# (S) = repeat as SELL spot-check after BUY passes.
# Matrix row references in [brackets].

## A. Regression first (nothing existing may move)
S8-1   Fresh L1 via button: computed TP/SL applied, no adoption logs,
       no [MANUAL] tag. [baseline]
S8-2   Recovery L2 fires: lots/interval math identical to b23 run;
       computed TP overwrite + SL re-anchor INFO as before. NO adoption
       WARN, no [MANUAL] tag - the b24 self-adoption bug (M5-6) must
       not reproduce: TP recomputes cleanly on EVERY level add with no
       trader edit present. FAILED on b24 live 2026-07-17; b25 fix.
       [baseline, M5-6]
S8-3   Self-test PASS in init log (now covers manualTP/manualSL). [M1-4]
S8-4   Old b23 state file loaded by b24: clean load, no ownership,
       no spurious logs. [M1-4]

## B. Adoption basics
S8-5   Edit TP on a 1-level seq (closer to price): adopted, INFO,
       dashboard TP shows [MANUAL], state file contains manualTP. [M2-1]
S8-6   Edit TP on MIDDLE ticket of 3-level seq: all 3 tickets carry the
       new TP within one pass. (S) [M2-2]
S8-7   Edit TP to exactly the computed value: NO adoption event, no log.
       [M2-3]
S8-8   Push TP farther from price: adopted with WARN naming pts moved.
       [M2-6]
S8-9   Re-edit while owning: latest value wins, re-propagated. [M2-5]
S8-10  Tighten SL: adopted, INFO (level-budget note). (S) [M3-1]
S8-11  Loosen SL: adopted, WARN with ~money impact + pts + lots. [M3-2]

## C. Protection (must-NOT rows)
S8-12  Delete TP: re-applied next tick, REMOVAL WARN (config wording).
       [M1-1]
S8-13  Delete SL: re-applied next tick, REMOVAL WARN. Verify NO pass
       leaves any ticket SL-stripped (check journal timing). [M1-2]
S8-14  Edit two tickets to different TPs quickly (mobile+desktop):
       nothing adopted, all reverted, single conflict WARN. Next clean
       edit adopts normally. [M4-1, M4-2]

## D. Lifetime
S8-15  Own TP, let recovery add a level: WARN "released - level add",
       computed re-asserted, [MANUAL] tag gone. Manual SL (if owned)
       UNTOUCHED - no re-anchor, no release WARN. (S) [M5-1, M3-4]
S8-16  Own TP, close worst level manually: WARN "released - level
       close"; if recomputed TP already exceeded -> market close
       (Choice 1). [M5-2, M5-4]
S8-17  Own TP, let trailing arm: WARN "released - trailing armed", TP
       removed. [M5-3]
S8-18  Manual SL survives S8-15's level add AND a level close. [M3-4]
S8-19  Tighten manual SL to inside the grid (above next trigger), let
       price hit it: broker fills ALL, sequence flat, trigger never
       fires. [M3-5]

## E. Engines own once armed
S8-20  BE applied: SL edit above BE adopted (INFO); SL edit below BE
       refused + WARN, reverted. [M6-1, M6-2]
       b27 additions: at BE trigger with manual SL owned -> supersede
       INFO + [MANUAL] tag drops; exceeded-close label names "BE
       floor" (not "manual") when the backstop closes at the BE price.
       At trail arm with manual SL owned -> supersede INFO.
S8-26  Init log shows broker exit geometry line (stops/freeze pts).
       With BE Trigger-Offset < broker min: geometry WARN at init
       names required Trigger. With Trailing Distance < broker min:
       trail geometry WARN. AutoTrading OFF at init -> WARN. Pending
       confirm with AutoTrading OFF -> 10027 reject names the toolbar
       button, no distance hint. [b27]
S8-21  Trailing: tighter SL adopted as ratchet floor (unchanged); looser
       SL reverted + WARN. [M6-3, M6-4]

S8-25  Own a TP: dashboard TP row shows the MANUAL value + [MANUAL],
       Proj at TP recomputes from it (changes visibly with the edit);
       Structure log projections use it. Same for owned SL on the SL
       side. On release, row and projection revert to computed and the
       tag drops. FAILED on b25 live 2026-07-17 (computed value shown
       with [MANUAL] tag, projection frozen); b26 fix. [M2-7]

## F. Exceeded rules under manual values
S8-22  All tickets carry manual TP, price reaches it: broker fills, NO
       redundant market close, no 10036, attribution = TP hit. [M4-4]
       (Gap-past mid-propagation [M4-3] verified opportunistically if
       market provides it - log evidence only, do not force.)

## G. Restart / kill
S8-23  Own TP+SL, param-change re-init AND terminal restart: both
       continue, INFO on resume, [MANUAL] tags intact. [M7-1, M7-2]
S8-24  Own TP+SL, HARD KILL (Details "End process" / taskkill /F -
       NOT Processes "End task", soft-kill trap!), relaunch:
       a) ownership continues, zero false WARNs [M7-3]
       b) close one position while dead -> resume releases TP (WARN),
          keeps SL; survivors' stale broker TP must NOT re-adopt:
          M7-8 INFO present, NO "adopted as manual (M7-5)" line,
          computed re-asserted to survivors. FAILED on b27 live
          2026-07-18 (self re-adoption); b28 fix. [M7-4, M7-8]
       c) edit TP while dead -> adopted on resume [M7-5]
       d) two tickets edited differently while dead -> conflict WARN,
          computed re-asserted [M7-6]
       e) kill immediately after editing 1-of-3 SL, relaunch ->
          propagation completed + stale-ticket WARN [M7-7]

## Seal condition
All items PASS with log evidence (S8-22 gap case excepted). SELL spot-
checks on S8-6, S8-10, S8-15. Then Stage 8 Step 1 SEALED; Step 2
(draggable lines) becomes the only parked TRTM item.
