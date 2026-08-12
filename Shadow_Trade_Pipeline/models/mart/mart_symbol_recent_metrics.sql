{{
    config(
        materialized = 'table',
        schema = 'gold'
    )
}}

/*
  Mart model: mart_symbol_recent_metrics
  ────────────────────────────────────────
  Powers the Deep Dive view trend visuals.

  Returns the last 5 pip values and last 5 pip intervals per symbol
  as separate rows tagged by metric_type and occurrence number.

  metric_type = 'pip_value'    → from 5 most recent L1 closed trades
  metric_type = 'pip_interval' → from 5 most recent grid sequences

  occurrence = 1 is most recent, 5 is oldest
*/

with lifecycle as (

    select * from {{ ref('int_trade_lifecycle') }}

),

-- ── Last 5 pip values per symbol ─────────────────────────────────────────────
-- Derived from L1 closed trades (lots = 0.01) — same formula as mart_symbol_overview
-- but keeping the 5 most recent instead of just the latest
l1_trades as (

    select
        symbol,
        close_time,
        pip_size,
        open_price,
        close_price,
        profit_loss,
        lots,

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
        end as pip_value,

        row_number() over (
            partition by symbol
            order by close_time desc
        ) as recency_rank

    from lifecycle
    where trade_level = 1
      and not is_cancelled
      and close_price is not null
      and profit_loss != 0

),

recent_pip_values as (

    select
        symbol,
        close_time           as event_time,
        pip_value            as metric_value,
        recency_rank         as occurrence,
        'pip_value'          as metric_type
    from l1_trades
    where recency_rank <= 5
      and pip_value is not null

),

-- ── Last 5 pip intervals per symbol ──────────────────────────────────────────
-- Compute avg pip interval PER SEQUENCE directly from pip_interval_to_next.
-- Do NOT use latest_avg_pip_interval — that's a symbol-level denormalized
-- value that's the same for all sequences of a symbol.
sequences as (

    select * from {{ ref('int_trade_sequences') }}

),

-- One row per unique sequence (symbol + sequence_sl) with its own avg interval
-- Only sequences with at least 2 levels have a calculable pip interval
distinct_sequences as (

    select
        symbol,
        sequence_sl,
        round(avg(pip_interval_to_next), 1) as pip_interval,
        max(open_time)                       as sequence_latest_open
    from sequences
    where pip_interval_to_next is not null
    group by symbol, sequence_sl

),

ranked_sequences as (

    select
        symbol,
        sequence_latest_open        as event_time,
        pip_interval                as metric_value,
        row_number() over (
            partition by symbol
            order by sequence_latest_open desc
        )                           as occurrence,
        'pip_interval'              as metric_type
    from distinct_sequences

),

recent_pip_intervals as (

    select *
    from ranked_sequences
    where occurrence <= 5

)

-- ── Union both metric types ───────────────────────────────────────────────────
select * from recent_pip_values
union all
select * from recent_pip_intervals
order by symbol, metric_type, occurrence