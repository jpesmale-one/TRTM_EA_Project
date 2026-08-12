{{
    config(
        materialized = 'table',
        schema = 'gold'
    )
}}

/*
  Mart model: mart_level_analysis
  ─────────────────────────────────
  Powers KPIs A and B in the Summary View dashboard.

  KPI A: Ticket counts grouped by level bucket
    (L1, L2-L4, L5-L10, L11-L15, L16-L20, L21-L25, L26-L30, L30+)

  KPI B: Win rate per individual level
    (every level we have data for, not grouped)

  One row per trade_level with all metrics pre-aggregated.
  Power BI can then filter/group to show either KPI A or KPI B.
*/

with trades as (

    select
        trade_level,
        level_bucket,
        level_bucket_sort,
        trade_result,
        is_win,
        is_loss,
        is_breakeven,
        is_cancelled,
        profit_loss,
        lots,
        close_time,
        close_date,
        close_month_label,
        close_week_label
    from {{ ref('mart_strategy_performance') }}

),

-- ── KPI B: Win rate per individual level ──────────────────────────────────────
level_stats as (

    select
        trade_level,
        level_bucket,
        level_bucket_sort,

        count(*)                                        as total_trades,
        sum(is_win)                                     as wins,
        sum(is_loss)                                    as losses,
        sum(is_breakeven)                               as breakevens,
        sum(is_cancelled::int)                          as cancelled,

        count(*) filter (where not is_cancelled)        as valid_trades,

        round(
            sum(is_win)::numeric
            / nullif(count(*) filter (where not is_cancelled), 0)
            * 100,
            1
        )                                               as win_rate_pct,

        round(sum(coalesce(profit_loss, 0)), 2)         as total_pnl,
        round(avg(coalesce(profit_loss, 0)), 2)         as avg_pnl_per_trade,
        round(max(coalesce(profit_loss, 0)), 2)         as best_trade_pnl,
        round(min(coalesce(profit_loss, 0)), 2)         as worst_trade_pnl

    from trades
    where not is_cancelled
    group by trade_level, level_bucket, level_bucket_sort

),

-- ── KPI A: Ticket counts by level bucket ─────────────────────────────────────
bucket_stats as (

    select
        level_bucket,
        level_bucket_sort,

        count(*)                                        as total_trades,
        sum(is_win)                                     as wins,
        sum(is_loss)                                    as losses,

        round(
            sum(is_win)::numeric
            / nullif(count(*) filter (where not is_cancelled), 0)
            * 100,
            1
        )                                               as win_rate_pct,

        round(sum(coalesce(profit_loss, 0)), 2)         as total_pnl

    from trades
    where not is_cancelled
    group by level_bucket, level_bucket_sort

)

-- ── Final: combine level stats with bucket stats ──────────────────────────────
select
    ls.trade_level,
    ls.level_bucket,
    ls.level_bucket_sort,

    -- KPI B columns (per individual level)
    ls.total_trades,
    ls.wins,
    ls.losses,
    ls.breakevens,
    ls.cancelled,
    ls.valid_trades,
    ls.win_rate_pct,
    ls.total_pnl,
    ls.avg_pnl_per_trade,
    ls.best_trade_pnl,
    ls.worst_trade_pnl,

    -- KPI A columns (per bucket — same value for all levels in the same bucket)
    bs.total_trades                                     as bucket_total_trades,
    bs.wins                                             as bucket_wins,
    bs.losses                                           as bucket_losses,
    bs.win_rate_pct                                     as bucket_win_rate_pct,
    bs.total_pnl                                        as bucket_total_pnl

from level_stats ls
left join bucket_stats bs
    on  ls.level_bucket      = bs.level_bucket
order by ls.trade_level