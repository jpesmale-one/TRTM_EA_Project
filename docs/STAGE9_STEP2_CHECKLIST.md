# Stage 9 Step 2 - Tester pending-line NUDGE - VERIFICATION CHECKLIST
# Build under test: Stage9s2-b33 (b732b80fddf75fda / 4296 lines).
# Pass/fail per item; live/tester LOG EVIDENCE required. [Nx] = matrix row.
# Compiler output is GATE ZERO - a clean compile precedes all items.
# Surfaces: TESTER = MT5 visual Strategy Tester; LIVE = demo chart.
# NOTE: money-number items (S10) must be recomputed to the cent = a b32
# confirm of the same line price. Absence items say what is NOT there.

## A. REGRESSION FIRST - nothing sealed may move
S1  [N3-2] MONEY: place a full pending order (create -> confirm -> fill)
    in TESTER at a nudged price. Every money number (lot, entry price, SL
    realizability, stops-band check) recomputes IDENTICAL to a b32 confirm
    of the same line price. MUST-NOT: any money figure moved. Emission +
    display only.
S2  [N3-1] LIVE panel byte-identical: attach b33 to a LIVE demo chart,
    start a pending placement. NO B_PUP/B_PDN objects exist (ObjectFind
    or the object list). CONFIRM+CANCEL occupy the row exactly as b32
    (bw2+40 CONFIRM). MUST-NOT: nudge buttons on a live chart. Verify
    absence explicitly.
S3  [N4-3] The 10 sealed Stage 9 poll buttons still dispatch + behave in
    tester (regression: BUY/SELL/CLOSE/PBUY/PSELL/PCONF/PCXL/CXLP/BE/
    TRAIL). Array grew to 12; first 10 unchanged.

## B. Nudge mechanics [TESTER, pending line placed]
S4  [N1-1] B_PBUY (poll) creates line at ask; click B_PUP once -> line
    price = ask + step; ONE INFO logs the new price.
S5  [N1-2] Click B_PDN once -> price down one step; back to prior; INFO.
S6  [N1-3] Click B_PUP 3x -> 3 steps up total; THREE INFO lines (one per
    click); no skipped/merged clicks.
S7  [N1-4] B_PUP + B_PDN latched in ONE tick -> dispatch in array order
    (up then down = net zero); each logs; no lost click, no crash.
S8  [N1-5] Set InpTesterNudgePts = 0 (or negative): init clamps to >=1
    (INFO shows effective step); a click still moves >=1 pt. MUST-NOT: a
    click that logs "nudged" while moving 0 pts. Verify the clamp line.
S9  [N1-6] Nudge a SELL placement line (B_PSELL) up/down: same behavior;
    g_pendDir unchanged (order type still inferred at confirm, P2).

## C. Nudge -> confirm integration (the payoff) [TESTER]
S10 [N2-1] Nudge WELL above market, B_PCONF -> places at the nudged
    price; recompute lot + price = a b32 confirm of that price.
S11 [N2-2] Nudge INTO the stops-level band, B_PCONF -> REFUSED with the
    existing band WARN (pts-from-market); line KEPT for re-nudge.
    MUST-NOT: nudge suppresses/alters the refusal.
S12 [N2-3] Nudge to a buy-LIMIT (line below market), confirm -> order
    type inferred unchanged; places/refuses per existing logic. (Proves
    G4 free-movement was required.)
S13 [N2-4] Guard B unrealizable at the nudged price, confirm -> existing
    EntrySLRealizable refusal vs the LINE price; line kept.
S14 [N2-5] Guard C (L1 vs fixed recovery) fails, confirm -> existing
    EntryLotRecoveryConsistent refusal; nudge irrelevant to lot path.

## D. Edges / MUST-NOT
S15 [N3-3] Click B_PUP/B_PDN with NO placement line -> ONE INFO "no
    pending line to move"; no crash, no object created.
S16 [N3-4] A nudge changes ONLY PLINE OBJPROP_PRICE. MUST-NOT: it must
    not create/destroy the line, flip g_pendDir, or trigger confirm/
    cancel. Verify state before/after (only price differs).
S17 [N3-5] With a pending order already live (P7), nudge -> one-pending-
    max enforcement at confirm unchanged; nudge does not bypass P7.

## E. RESTART / KILL last
S18 [N4-1] In TESTER, nudge the line, then restart (re-attach/recompile).
    Line is gone (non-persisted); no orphan PLINE, no stale price, no
    phantom nudge state. Re-create fresh via B_PBUY/PSELL.
S19 [N4-2] KILL/state: no persisted field added. Confirm the state file
    schema + self-test are byte-identical to b32 (no new key).
S20 [N4-4] On LIVE, the nudge buttons do NOT fire via OnChartEvent (they
    do not exist live, S2); the existing panel CLICK handling is
    unchanged. MUST-NOT: new live event behavior.

## Seal condition
SEALS when: compiler clean (gate zero); S1-S20 all PASS with pasted
log evidence; S10 money numbers recomputed to the cent = b32; absence
verified on S2, S8, S11, S16, S19, S20 (checked for what is NOT there,
stated explicitly). FAIL -> root cause from the log first, then fix +
new matrix row + hardened S-item, retain FAIL evidence.

## SEAL DISPOSITION
SEALED by Jeff 2026-07-21 at Stage9s2-b33 (b732b80fddf75fda / 4296).
Compiler clean (gate zero). Final tally:
- PASS (audited live/tester logs, every money number recomputed to the
  cent): S1 (full lifecycle entry->5 recovery->BE->SL-close; all Structure
  projections L1-L5, BE simple-avg 4183.07, BE SL 4182.77, realized
  +141.50 exact), S3, S4, S5, S6, S8, S9, S10, S11, S12, S16, S18.
- EQUIVALENCE (byte-identical sealed branch + bracketing evidence
  S10/S12): S13 (Guard B / EntrySLRealizable), S14 (Guard C /
  EntryLotRecoveryConsistent). ConfirmPendingOrder + both guards +
  ClampEntryVolume proven byte-identical b32==b33; confirm reads the
  nudged price (S10/S12 place at the exact nudged price).
- INSPECTION (named basis): S15 (nudge guard unreachable via UI - buttons
  exist only while a line does), S17 (pendingLive collapse observed live),
  S19 (no persisted field; 292 persistence lines identical b32==b33,
  schema still 4), S20 (no live nudge buttons per S2; live event path
  unchanged).
Must-NOT rows all verified by explicit absence (S2, S8, S11, S16, S19,
S20). Trail sub-leg of S1 not market-exercised (BE stop closed first);
credited by CARRY-FORWARD - trailing engine byte-identical to sealed b32,
delta is tester-input-only and provably cannot affect it.
No FAILs this stage. No new parked items.
