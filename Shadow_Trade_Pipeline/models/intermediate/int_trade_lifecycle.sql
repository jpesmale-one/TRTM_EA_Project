{{
    config(
        materialized = 'view',
        schema = 'silver'
    )
}}

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

    select * from {{ ref('stg_trade_logs') }}

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

        {{ get_level_from_lots('o.lots') }}     as trade_level,
        {{ get_pip_size('o.symbol') }}          as pip_size,

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
        max({{ get_level_from_lots('j.lots') }}) over (
            partition by j.symbol, j.trade_type, j.stop_loss
        ) as max_level_in_sequence

    from joined j
    where j.stop_loss is not null   -- only group tickets that have a resolved SL

    union all

    -- Solo trades with no SL (pre-fill pattern with missing SL, edge case)
    -- treat their own level as the max
    select
        j.*,
        {{ get_level_from_lots('j.lots') }} as max_level_in_sequence
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
            when {{ get_level_from_lots('w.lots') }} < w.max_level_in_sequence
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