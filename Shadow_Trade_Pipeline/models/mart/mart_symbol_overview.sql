{{
    config(
        materialized = 'table',
        schema = 'gold'
    )
}}

/*
  Mart model: mart_symbol_overview
  ─────────────────────────────────
  Powers KPI E (Pairs Overview table) in the Summary View
  and the Deep Dive View per-symbol metrics.

  One row per symbol containing:
    - pip_value         : derived from most recent L1 closed trade
    - avg_pip_interval  : average pip interval from the latest grid sequence
    - highest_level     : max trade_level ever reached for this symbol
    - total_trades      : total closed trades for this symbol
    - win_rate_pct      : overall win rate for this symbol
    - total_pnl         : total realised P&L for this symbol

  Pip Value formula:
    profit / (abs(close_price - open_price) / pip_size) / lots
    e.g. EURAUD: 0.63 / (0.001 / 0.0001) / 0.01 = 6.3

  Pip Interval:
    Average price distance (in pips) between consecutive entry levels
    within the most recent grid sequence for this symbol.
*/

with lifecycle as (

    select * from {{ ref('int_trade_lifecycle') }}

),

sequences as (

    select * from {{ ref('int_trade_sequences') }}

),

performance as (

    select * from {{ ref('mart_strategy_performance') }}

),

-- ── Pip value: from most recent L1 closed trade per symbol ────────────────────
-- L1 trades (lots = 0.01) give us the cleanest pip value signal
-- since there's no position sizing complexity
l1_trades as (

    select distinct on (symbol)
        symbol,
        pip_size,
        open_price,
        close_price,
        profit_loss,
        lots,
        close_time,

        -- Pip value calculation
        case
            when close_price is not null
             and profit_loss is not null
             and profit_loss != 0
             and abs(close_price - open_price) > 0
            then round(
                abs(profit_loss)
                / (abs(close_price - open_price) / pip_size)
                / lots,
                4
            )
            else null
        end as pip_value

    from lifecycle
    where trade_level = 1
      and not is_cancelled
      and close_price is not null
      and profit_loss != 0
    order by symbol, close_time desc     -- most recent L1 trade per symbol

),

-- ── Latest pip interval per symbol ───────────────────────────────────────────
-- int_trade_sequences already picked the most recent sequence that has
-- actual pip interval data (regardless of trade direction).
-- One row per symbol guaranteed since latest_avg_pip_interval is the same
-- value on every row for a given symbol.
latest_intervals as (

    select distinct on (symbol)
        symbol,
        latest_interval_direction   as trade_type,
        latest_avg_pip_interval     as avg_pip_interval
    from sequences
    where latest_avg_pip_interval is not null
    order by symbol

),

-- ── Highest level per symbol ─────────────────────────────────────────────────
highest_levels as (

    select
        symbol,
        max(trade_level)    as highest_level,
        max(lots)           as max_lots
    from lifecycle
    where not is_cancelled
    group by symbol

),

-- ── Overall symbol performance stats ─────────────────────────────────────────
symbol_stats as (

    select
        symbol,
        strategy_name,
        count(*)                                            as total_trades,
        sum(is_win)                                         as wins,
        sum(is_loss)                                        as losses,
        round(
            sum(is_win)::numeric / nullif(count(*), 0) * 100,
            1
        )                                                   as win_rate_pct,
        round(sum(coalesce(profit_loss, 0)), 2)             as total_pnl,
        round(avg(coalesce(profit_loss, 0)), 2)             as avg_pnl_per_trade,

        -- Deep dive: performance for past 5 market days
        round(
            sum(coalesce(profit_loss, 0))
            filter (
                where close_date >= (
                    select close_date
                    from (
                        select distinct close_date
                        from {{ ref('mart_strategy_performance') }}
                        where close_date <= current_date
                        order by close_date desc
                        limit 5
                    ) last5
                    order by close_date
                    limit 1
                )
            ),
            2
        )                                                   as pnl_last_5_days,

        min(close_date)                                     as first_trade_date,
        max(close_date)                                     as last_trade_date

    from performance
    where not is_cancelled
    group by symbol, strategy_name

)

-- ── Final output: one row per symbol ─────────────────────────────────────────
select
    ss.symbol,
    ss.strategy_name,

    -- ── Pip metrics ───────────────────────────────────────────────────────
    l1.pip_value,
    l1.pip_size,
    li.avg_pip_interval,
    li.trade_type           as pip_interval_direction,

    -- ── Level metrics ─────────────────────────────────────────────────────
    hl.highest_level,
    hl.max_lots,

    -- ── Performance metrics ───────────────────────────────────────────────
    ss.total_trades,
    ss.wins,
    ss.losses,
    ss.win_rate_pct,
    ss.total_pnl,
    ss.avg_pnl_per_trade,
    ss.pnl_last_5_days,

    -- ── Date range ────────────────────────────────────────────────────────
    ss.first_trade_date,
    ss.last_trade_date

from symbol_stats ss
left join l1_trades     l1 on ss.symbol = l1.symbol
left join latest_intervals li on ss.symbol = li.symbol
left join highest_levels hl on ss.symbol = hl.symbol
order by ss.symbol