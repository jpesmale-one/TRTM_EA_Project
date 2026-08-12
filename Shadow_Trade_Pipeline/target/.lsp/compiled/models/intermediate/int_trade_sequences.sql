

/*
  Intermediate model: int_trade_sequences
  ────────────────────────────────────────
  Identifies grid sequences and computes pip intervals between levels.

  A sequence = group of tickets sharing:
    - Same symbol
    - Same trade_type (BUY or SELL)
    - Same stop_loss (SL stays constant throughout a sequence;
      only TP gets updated as new levels are added)

  v3 fix:
    - latest_sequence_per_symbol now finds the most recent sequence
      that ACTUALLY HAS pip intervals (at least 2 levels), not just
      the most recently opened sequence. A solo L1 that closed quickly
      has no pip interval and should not be picked.
    - latest_pip_intervals no longer partitions by trade_type — it
      returns whichever direction has the most recent interval data.
      If BUY has intervals but SELL doesn't, we use BUY.
*/

with lifecycle as (

    select
        ticket,
        symbol,
        trade_type,
        lots,
        trade_level,
        pip_size,
        open_price,
        stop_loss,
        take_profit,
        open_time,
        close_time,
        is_cancelled,
        strategy_name
    from "shadowtradedb"."silver"."int_trade_lifecycle"
    where not is_cancelled
      and stop_loss is not null

),

-- ── Pre-compute earliest open_time per sequence group ────────────────────────
-- Needed because window functions can't be nested inside other window
-- function definitions in PostgreSQL.
sequence_min_times as (

    select
        symbol,
        trade_type,
        stop_loss,
        min(open_time) as sequence_start_time
    from lifecycle
    group by symbol, trade_type, stop_loss

),

-- ── Assign sequence IDs ───────────────────────────────────────────────────────
sequenced as (

    select
        l.*,
        dense_rank() over (
            partition by l.symbol, l.trade_type, l.stop_loss
            order by l.open_time
        ) as level_rank_in_sequence,

        dense_rank() over (
            partition by l.symbol, l.trade_type
            order by s.sequence_start_time
        ) as sequence_id

    from lifecycle l
    inner join sequence_min_times s
        on  l.symbol     = s.symbol
        and l.trade_type = s.trade_type
        and l.stop_loss  = s.stop_loss

),

-- ── Pip interval between consecutive levels ───────────────────────────────────
with_intervals as (

    select
        s.*,

        lead(open_price) over (
            partition by symbol, trade_type, stop_loss
            order by trade_level
        ) as next_level_open_price,

        round(
            abs(
                open_price - lead(open_price) over (
                    partition by symbol, trade_type, stop_loss
                    order by trade_level
                )
            ) / pip_size,
            1
        ) as pip_interval_to_next

    from sequenced s

),

-- ── Sequences that actually have pip intervals ────────────────────────────────
-- Only sequences with at least 2 levels have a calculable pip interval.
-- We pick the most recent such sequence per symbol (regardless of trade_type)
-- so a symbol with BUY intervals but no SELL intervals still gets a value.
sequences_with_intervals as (

    select
        symbol,
        trade_type,
        stop_loss,
        max(open_time)  as latest_open_in_sequence,
        round(avg(pip_interval_to_next), 1) as avg_pip_interval
    from with_intervals
    where pip_interval_to_next is not null
    group by symbol, trade_type, stop_loss

),

-- ── Most recent sequence per symbol that has pip interval data ────────────────
latest_sequence_per_symbol as (

    select distinct on (symbol)
        symbol,
        trade_type,
        stop_loss       as latest_sequence_sl,
        avg_pip_interval,
        latest_open_in_sequence
    from sequences_with_intervals
    order by symbol, latest_open_in_sequence desc  -- most recent sequence first

),

-- ── Final pip interval per symbol ─────────────────────────────────────────────
latest_pip_intervals as (

    select
        symbol,
        trade_type,
        avg_pip_interval,
        latest_open_in_sequence
    from latest_sequence_per_symbol

)

-- ── Final output ──────────────────────────────────────────────────────────────
select
    wi.ticket,
    wi.symbol,
    wi.trade_type,
    wi.trade_level,
    wi.sequence_id,
    wi.level_rank_in_sequence,
    wi.stop_loss            as sequence_sl,
    wi.open_price,
    wi.pip_size,
    wi.pip_interval_to_next,
    wi.next_level_open_price,
    wi.open_time,
    wi.close_time,
    lpi.avg_pip_interval    as latest_avg_pip_interval,
    lpi.trade_type          as latest_interval_direction,
    wi.strategy_name
from with_intervals wi
left join latest_pip_intervals lpi
    on wi.symbol = lpi.symbol