
  
    

  create  table "shadowtradedb"."gold"."mart_strategy_performance__dbt_tmp"
  
  
    as
  
  (
    

/*
  Mart model: mart_strategy_performance
  ──────────────────────────────────────
  One row per trade with all analytics columns for Power BI.
  Primary table for dashboard Summary and Deep Dive views.

  v2 changes:
    - Added trade_level, level_bucket columns
    - Added pip_size, pip_value columns
    - Added planned_rr, actual_r
*/

with lifecycle as (

    select * from "shadowtradedb"."silver"."int_trade_lifecycle"

),

signal_groups as (

    select
        ticket,
        dense_rank() over (
            partition by strategy_name, symbol
            order by date_trunc('hour', open_time),
                     floor(extract(epoch from open_time) / 300)
        ) as signal_group_id
    from lifecycle
    where not is_cancelled

),

final as (

    select
        -- ── Identity ──────────────────────────────────────────────────────
        l.ticket,
        l.symbol,
        l.trade_type,
        l.lots,
        l.strategy_name,
        l.position_tier,
        l.trade_result,
        l.is_cancelled,

        -- ── Level ─────────────────────────────────────────────────────────
        l.trade_level,

        -- Level bucket for KPI A grouping
        case
            when l.trade_level = 1                    then 'L1'
            when l.trade_level between 2  and 4       then 'L2-L4'
            when l.trade_level between 5  and 10      then 'L5-L10'
            when l.trade_level between 11 and 15      then 'L11-L15'
            when l.trade_level between 16 and 20      then 'L16-L20'
            when l.trade_level between 21 and 25      then 'L21-L25'
            when l.trade_level between 26 and 30      then 'L26-L30'
            else                                           'L30+'
        end as level_bucket,

        -- Bucket sort order for correct Power BI ordering
        case
            when l.trade_level = 1                    then 1
            when l.trade_level between 2  and 4       then 2
            when l.trade_level between 5  and 10      then 3
            when l.trade_level between 11 and 15      then 4
            when l.trade_level between 16 and 20      then 5
            when l.trade_level between 21 and 25      then 6
            when l.trade_level between 26 and 30      then 7
            else                                           8
        end as level_bucket_sort,

        -- ── Pip metrics ───────────────────────────────────────────────────
        l.pip_size,

        -- Pip value per pip per standard lot (derived from actual P&L)
        -- Formula: profit / (price_distance / pip_size) / lots
        -- Only calculable when we have a valid close price and profit
        case
            when l.close_price is not null
             and l.profit_loss is not null
             and l.profit_loss != 0
             and abs(l.close_price - l.open_price) > 0
            then round(
                abs(l.profit_loss)
                / (abs(l.close_price - l.open_price) / l.pip_size)
                / l.lots,
                4
            )
            else null
        end as pip_value,

        -- ── Signal group ──────────────────────────────────────────────────
        coalesce(sg.signal_group_id, 0) as signal_group_id,

        -- ── Entry ─────────────────────────────────────────────────────────
        l.open_time,
        l.open_price,
        l.stop_loss,
        l.take_profit,

        -- ── Exit ─────────────────────────────────────────────────────────
        l.close_time,
        l.close_price,
        l.profit_loss,
        l.duration_minutes,
        round(l.duration_minutes / 60.0, 2)     as duration_hours,

        -- ── Risk metrics ──────────────────────────────────────────────────
        l.risk_points,
        l.reward_points,

        -- Planned R:R
        case
            when l.risk_points > 0
            then round(l.reward_points / nullif(l.risk_points, 0), 2)
            else null
        end as planned_rr,

        -- Actual R achieved
        case
            when l.risk_points > 0
            then round(
                (l.close_price - l.open_price)
                * case when l.trade_type = 'BUY' then 1 else -1 end
                / nullif(l.risk_points, 0),
                2
            )
            else null
        end as actual_r,

        -- ── Win/Loss flags ────────────────────────────────────────────────
        case when l.trade_result = 'WIN'       then 1 else 0 end as is_win,
        case when l.trade_result = 'LOSS'      then 1 else 0 end as is_loss,
        case when l.trade_result = 'BREAKEVEN' then 1 else 0 end as is_breakeven,

        -- ── Date parts ───────────────────────────────────────────────────
        l.open_time::date                       as open_date,
        l.close_time::date                      as close_date,
        extract(hour   from l.open_time)::int   as open_hour,
        extract(dow    from l.open_time)::int   as open_day_of_week,
        to_char(l.open_time, 'Dy')              as open_day_name,
        extract(week   from l.open_time)::int   as open_week,
        extract(month  from l.open_time)::int   as open_month,
        extract(year   from l.open_time)::int   as open_year,
        to_char(l.close_time, 'YYYY-MM')        as close_month_label,
        to_char(l.close_time, 'IYYY-IW')        as close_week_label,

        -- Numeric sort keys — guaranteed 1-to-1 with label columns
        extract(isoyear from l.close_time)::int * 100
            + extract(week from l.close_time)::int
                                                as close_week_sort,
        extract(year from l.close_time)::int * 100
            + extract(month from l.close_time)::int
                                                as close_month_sort,

        -- ── Cumulative P&L ────────────────────────────────────────────────
        round(
            sum(coalesce(l.profit_loss, 0)) over (
                partition by l.strategy_name
                order by l.close_time
                rows between unbounded preceding and current row
            ),
            2
        ) as cumulative_pnl_by_strategy,

        round(
            sum(coalesce(l.profit_loss, 0)) over (
                order by l.close_time
                rows between unbounded preceding and current row
            ),
            2
        ) as cumulative_pnl_total,

        -- ── Source tracking ───────────────────────────────────────────────
        l.open_source_file,
        l.close_source_file

    from lifecycle l
    left join signal_groups sg on l.ticket = sg.ticket

)

select * from final
order by close_time desc
  );
  