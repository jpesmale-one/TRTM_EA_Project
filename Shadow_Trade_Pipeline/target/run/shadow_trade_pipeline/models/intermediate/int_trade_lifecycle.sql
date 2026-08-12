
  create view "shadowtradedb"."silver"."int_trade_lifecycle__dbt_tmp"
    
    
  as (
    

/*
  Intermediate model: int_trade_lifecycle
  ────────────────────────────────────────
  Reconstructs one complete row per trade ticket by joining:
    - OPEN event  → entry details, strategy, position tier
    - Last MODIFY → final SL/TP
    - CLOSE event → exit price, P&L, duration

  v3 - Sequence-aware trade_result logic:
  ─────────────────────────────────────────
  Trade result is no longer based purely on profit_loss sign.
  Instead it reflects whether the strategy had to go deeper (open
  a higher level) before the sequence resolved.

  Rule:
    - CANCELLED : broker-voided trade (ClosePrice = 0)
    - LOSS      : a higher level was opened in the same sequence
                  (trade_level < max_level_in_sequence)
    - WIN       : this IS the highest level AND profit_loss > 0
    - LOSS      : this IS the highest level AND profit_loss < 0
    - BREAKEVEN : this IS the highest level AND profit_loss = 0

  Sequence key: (symbol, trade_type, stop_loss)
  All tickets sharing the same SL belong to the same grid sequence.
*/

with stg as (

    select * from "shadowtradedb"."silver"."stg_trade_logs"

),

opens as (

    select
        ticket,
        symbol,
        trade_type,
        lots,
        open_price,
        stop_loss           as open_sl,
        take_profit         as open_tp,
        is_prefilled_sltp,
        strategy_name,
        position_tier,
        server_time         as open_time,
        source_file         as open_source_file
    from stg
    where event_type in ('OPEN', 'OPEN [RESYNC]')

),

last_modify as (

    select distinct on (ticket)
        ticket,
        stop_loss           as final_sl,
        take_profit         as final_tp,
        server_time         as last_modify_time
    from stg
    where event_type in ('MODIFY', 'MODIFY [RESYNC]')
    order by ticket, server_time desc

),

closes as (

    select
        ticket,
        close_price,
        profit_loss,
        is_cancelled,
        server_time         as close_time,
        source_file         as close_source_file
    from stg
    where event_type in ('CLOSE', 'CLOSE [RESYNC]')

),

-- ── Join into one row per trade ───────────────────────────────────────────────
joined as (

    select
        o.ticket,
        o.symbol,
        o.trade_type,
        o.lots,
        o.strategy_name,
        o.position_tier,

        

case
    -- L1-L4: 0.01 lot increments
    when round(o.lots::numeric, 2) = 0.01 then 1
    when round(o.lots::numeric, 2) = 0.02 then 2
    when round(o.lots::numeric, 2) = 0.03 then 3
    when round(o.lots::numeric, 2) = 0.04 then 4
    -- L5-L30: 0.10 lot increments starting from 0.50
    when round(o.lots::numeric, 2) = 0.50 then 5
    when round(o.lots::numeric, 2) = 0.60 then 6
    when round(o.lots::numeric, 2) = 0.70 then 7
    when round(o.lots::numeric, 2) = 0.80 then 8
    when round(o.lots::numeric, 2) = 0.90 then 9
    when round(o.lots::numeric, 2) = 1.00 then 10
    when round(o.lots::numeric, 2) = 1.10 then 11
    when round(o.lots::numeric, 2) = 1.20 then 12
    when round(o.lots::numeric, 2) = 1.30 then 13
    when round(o.lots::numeric, 2) = 1.40 then 14
    when round(o.lots::numeric, 2) = 1.50 then 15
    when round(o.lots::numeric, 2) = 1.60 then 16
    when round(o.lots::numeric, 2) = 1.70 then 17
    when round(o.lots::numeric, 2) = 1.80 then 18
    when round(o.lots::numeric, 2) = 1.90 then 19
    when round(o.lots::numeric, 2) = 2.00 then 20
    when round(o.lots::numeric, 2) = 2.10 then 21
    when round(o.lots::numeric, 2) = 2.20 then 22
    when round(o.lots::numeric, 2) = 2.30 then 23
    when round(o.lots::numeric, 2) = 2.40 then 24
    when round(o.lots::numeric, 2) = 2.50 then 25
    when round(o.lots::numeric, 2) = 2.60 then 26
    when round(o.lots::numeric, 2) = 2.70 then 27
    when round(o.lots::numeric, 2) = 2.80 then 28
    when round(o.lots::numeric, 2) = 2.90 then 29
    when round(o.lots::numeric, 2) = 3.00 then 30
    -- L31+: fallback formula (0.50 base, 0.10 increments from L5)
    else (floor((round(o.lots::numeric, 2) - 0.50) / 0.10) + 5)::int
end
     as trade_level,
        

case
    when o.symbol ilike 'XAU%'  then 0.1     -- Gold
    when o.symbol ilike 'XAG%'  then 0.01    -- Silver
    when o.symbol ilike '%JPY%' then 0.01    -- JPY pairs
    else 0.0001                                          -- Standard forex
end
          as pip_size,

        o.open_time,
        o.open_price,

        case
            when o.is_prefilled_sltp then o.open_sl
            else m.final_sl
        end as stop_loss,

        case
            when o.is_prefilled_sltp then o.open_tp
            else m.final_tp
        end as take_profit,

        c.close_time,
        c.close_price,
        c.profit_loss,
        c.is_cancelled,

        extract(epoch from (c.close_time - o.open_time)) / 60.0
            as duration_minutes,

        -- Risk/reward price points
        case
            when o.trade_type = 'BUY'
            then o.open_price - coalesce(
                    case when o.is_prefilled_sltp then o.open_sl else m.final_sl end,
                    o.open_price
                 )
            when o.trade_type = 'SELL'
            then coalesce(
                    case when o.is_prefilled_sltp then o.open_sl else m.final_sl end,
                    o.open_price
                 ) - o.open_price
        end as risk_points,

        case
            when o.trade_type = 'BUY'
            then coalesce(
                    case when o.is_prefilled_sltp then o.open_tp else m.final_tp end,
                    o.open_price
                 ) - o.open_price
            when o.trade_type = 'SELL'
            then o.open_price - coalesce(
                    case when o.is_prefilled_sltp then o.open_tp else m.final_tp end,
                    o.open_price
                 )
        end as reward_points,

        o.is_prefilled_sltp,
        o.open_source_file,
        c.close_source_file

    from opens o
    inner join closes c on o.ticket = c.ticket
    left  join last_modify m on o.ticket = m.ticket

),

-- ── Sequence-aware max level ──────────────────────────────────────────────────
-- Find the highest level reached within each grid sequence.
-- Sequence key: (symbol, trade_type, stop_loss)
-- All tickets sharing the same SL are part of the same sequence.
-- stop_loss must be resolved first (from MODIFY if needed), which is
-- why this CTE comes after the join above.
with_sequence_context as (

    select
        j.*,

        -- Highest level opened in this sequence
        max(

case
    -- L1-L4: 0.01 lot increments
    when round(j.lots::numeric, 2) = 0.01 then 1
    when round(j.lots::numeric, 2) = 0.02 then 2
    when round(j.lots::numeric, 2) = 0.03 then 3
    when round(j.lots::numeric, 2) = 0.04 then 4
    -- L5-L30: 0.10 lot increments starting from 0.50
    when round(j.lots::numeric, 2) = 0.50 then 5
    when round(j.lots::numeric, 2) = 0.60 then 6
    when round(j.lots::numeric, 2) = 0.70 then 7
    when round(j.lots::numeric, 2) = 0.80 then 8
    when round(j.lots::numeric, 2) = 0.90 then 9
    when round(j.lots::numeric, 2) = 1.00 then 10
    when round(j.lots::numeric, 2) = 1.10 then 11
    when round(j.lots::numeric, 2) = 1.20 then 12
    when round(j.lots::numeric, 2) = 1.30 then 13
    when round(j.lots::numeric, 2) = 1.40 then 14
    when round(j.lots::numeric, 2) = 1.50 then 15
    when round(j.lots::numeric, 2) = 1.60 then 16
    when round(j.lots::numeric, 2) = 1.70 then 17
    when round(j.lots::numeric, 2) = 1.80 then 18
    when round(j.lots::numeric, 2) = 1.90 then 19
    when round(j.lots::numeric, 2) = 2.00 then 20
    when round(j.lots::numeric, 2) = 2.10 then 21
    when round(j.lots::numeric, 2) = 2.20 then 22
    when round(j.lots::numeric, 2) = 2.30 then 23
    when round(j.lots::numeric, 2) = 2.40 then 24
    when round(j.lots::numeric, 2) = 2.50 then 25
    when round(j.lots::numeric, 2) = 2.60 then 26
    when round(j.lots::numeric, 2) = 2.70 then 27
    when round(j.lots::numeric, 2) = 2.80 then 28
    when round(j.lots::numeric, 2) = 2.90 then 29
    when round(j.lots::numeric, 2) = 3.00 then 30
    -- L31+: fallback formula (0.50 base, 0.10 increments from L5)
    else (floor((round(j.lots::numeric, 2) - 0.50) / 0.10) + 5)::int
end
) over (
            partition by j.symbol, j.trade_type, j.stop_loss
        ) as max_level_in_sequence

    from joined j
    where j.stop_loss is not null   -- only group tickets that have a resolved SL

    union all

    -- Solo trades with no SL (pre-fill pattern with missing SL, edge case)
    -- treat their own level as the max
    select
        j.*,
        

case
    -- L1-L4: 0.01 lot increments
    when round(j.lots::numeric, 2) = 0.01 then 1
    when round(j.lots::numeric, 2) = 0.02 then 2
    when round(j.lots::numeric, 2) = 0.03 then 3
    when round(j.lots::numeric, 2) = 0.04 then 4
    -- L5-L30: 0.10 lot increments starting from 0.50
    when round(j.lots::numeric, 2) = 0.50 then 5
    when round(j.lots::numeric, 2) = 0.60 then 6
    when round(j.lots::numeric, 2) = 0.70 then 7
    when round(j.lots::numeric, 2) = 0.80 then 8
    when round(j.lots::numeric, 2) = 0.90 then 9
    when round(j.lots::numeric, 2) = 1.00 then 10
    when round(j.lots::numeric, 2) = 1.10 then 11
    when round(j.lots::numeric, 2) = 1.20 then 12
    when round(j.lots::numeric, 2) = 1.30 then 13
    when round(j.lots::numeric, 2) = 1.40 then 14
    when round(j.lots::numeric, 2) = 1.50 then 15
    when round(j.lots::numeric, 2) = 1.60 then 16
    when round(j.lots::numeric, 2) = 1.70 then 17
    when round(j.lots::numeric, 2) = 1.80 then 18
    when round(j.lots::numeric, 2) = 1.90 then 19
    when round(j.lots::numeric, 2) = 2.00 then 20
    when round(j.lots::numeric, 2) = 2.10 then 21
    when round(j.lots::numeric, 2) = 2.20 then 22
    when round(j.lots::numeric, 2) = 2.30 then 23
    when round(j.lots::numeric, 2) = 2.40 then 24
    when round(j.lots::numeric, 2) = 2.50 then 25
    when round(j.lots::numeric, 2) = 2.60 then 26
    when round(j.lots::numeric, 2) = 2.70 then 27
    when round(j.lots::numeric, 2) = 2.80 then 28
    when round(j.lots::numeric, 2) = 2.90 then 29
    when round(j.lots::numeric, 2) = 3.00 then 30
    -- L31+: fallback formula (0.50 base, 0.10 increments from L5)
    else (floor((round(j.lots::numeric, 2) - 0.50) / 0.10) + 5)::int
end
 as max_level_in_sequence
    from joined j
    where j.stop_loss is null

),

-- ── Sequence-aware trade_result ───────────────────────────────────────────────
final as (

    select
        w.*,

        case
            -- Cancelled trades always stay cancelled
            when w.is_cancelled
                then 'CANCELLED'

            -- Higher level was opened in this sequence before close
            -- → this ticket is a LOSS regardless of its own profit_loss
            when 

case
    -- L1-L4: 0.01 lot increments
    when round(w.lots::numeric, 2) = 0.01 then 1
    when round(w.lots::numeric, 2) = 0.02 then 2
    when round(w.lots::numeric, 2) = 0.03 then 3
    when round(w.lots::numeric, 2) = 0.04 then 4
    -- L5-L30: 0.10 lot increments starting from 0.50
    when round(w.lots::numeric, 2) = 0.50 then 5
    when round(w.lots::numeric, 2) = 0.60 then 6
    when round(w.lots::numeric, 2) = 0.70 then 7
    when round(w.lots::numeric, 2) = 0.80 then 8
    when round(w.lots::numeric, 2) = 0.90 then 9
    when round(w.lots::numeric, 2) = 1.00 then 10
    when round(w.lots::numeric, 2) = 1.10 then 11
    when round(w.lots::numeric, 2) = 1.20 then 12
    when round(w.lots::numeric, 2) = 1.30 then 13
    when round(w.lots::numeric, 2) = 1.40 then 14
    when round(w.lots::numeric, 2) = 1.50 then 15
    when round(w.lots::numeric, 2) = 1.60 then 16
    when round(w.lots::numeric, 2) = 1.70 then 17
    when round(w.lots::numeric, 2) = 1.80 then 18
    when round(w.lots::numeric, 2) = 1.90 then 19
    when round(w.lots::numeric, 2) = 2.00 then 20
    when round(w.lots::numeric, 2) = 2.10 then 21
    when round(w.lots::numeric, 2) = 2.20 then 22
    when round(w.lots::numeric, 2) = 2.30 then 23
    when round(w.lots::numeric, 2) = 2.40 then 24
    when round(w.lots::numeric, 2) = 2.50 then 25
    when round(w.lots::numeric, 2) = 2.60 then 26
    when round(w.lots::numeric, 2) = 2.70 then 27
    when round(w.lots::numeric, 2) = 2.80 then 28
    when round(w.lots::numeric, 2) = 2.90 then 29
    when round(w.lots::numeric, 2) = 3.00 then 30
    -- L31+: fallback formula (0.50 base, 0.10 increments from L5)
    else (floor((round(w.lots::numeric, 2) - 0.50) / 0.10) + 5)::int
end
 < w.max_level_in_sequence
                then 'LOSS'

            -- This IS the highest level in the sequence
            -- → result determined by actual profit_loss
            when w.profit_loss > 0  then 'WIN'
            when w.profit_loss < 0  then 'LOSS'
            when w.profit_loss = 0  then 'BREAKEVEN'

            else 'BREAKEVEN'
        end as trade_result

    from with_sequence_context w

)

select * from final
  );