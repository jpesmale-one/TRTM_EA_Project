{{
    config(
        materialized = 'view',
        schema = 'silver'
    )
}}

/*
  Staging model: stg_trade_logs
  ─────────────────────────────
  Cleans and enriches raw bronze rows.

  Key transformations:
    1. Parses Notes field into:
         - strategy_name  (SHADOW, sXAUdow, etc.)
         - position_tier  (0 = first entry, 1/2/3... = scale-in)
         - close_price    (extracted from CLOSE rows only)
    2. Flags cancelled / rejected trades (ClosePrice = 0.00000)
    3. Flags trades where SL/TP was pre-filled at OPEN (no MODIFY needed)
    4. Normalises 0.00000 SL/TP to NULL for cleaner downstream logic
*/

with source as (

    select * from {{ source('bronze', 'trade_monitor_logs') }}

),

cleaned as (

    select
        -- ── Identity ──────────────────────────────────────────────────────
        id,
        ticket,
        event_type,
        symbol,
        trade_type,

        -- ── Timestamps ───────────────────────────────────────────────────
        server_time,
        local_time,
        broker_tz_offset,

        -- ── Price fields ─────────────────────────────────────────────────
        open_price,
        lots,

        -- Normalise 0.00000 SL/TP to NULL — zero is placeholder, not a
        -- real price level. Downstream models can use COALESCE safely.
        nullif(stop_loss,   0) as stop_loss,
        nullif(take_profit, 0) as take_profit,

        -- P&L only meaningful on CLOSE rows; zero on OPEN/MODIFY
        case
            when event_type in ('CLOSE', 'CLOSE [RESYNC]') then profit_loss
            else null
        end as profit_loss,

        -- ── Notes parsing ────────────────────────────────────────────────
        notes,

        -- Strategy name: everything after "| " on CLOSE rows,
        -- or the full notes string on OPEN/MODIFY rows.
        -- Strips the "#N" tier suffix to get the base strategy name.
        -- Examples:
        --   "ClosePrice=1.05807 | SHADOW #1"  → "SHADOW"
        --   "SHADOW #3"                        → "SHADOW"
        --   "sXAUdow"                          → "sXAUdow"
        trim(
            split_part(
                regexp_replace(
                    case
                        when notes ilike 'ClosePrice%'
                            then trim(split_part(notes, '|', 2))
                        else notes
                    end,
                    '\s*#\d+$', ''   -- strip trailing " #N"
                ),
                ' ', 1              -- take first word (handles any extra spaces)
            )
        ) as strategy_name,

        -- Position tier: the N in "SHADOW #N"
        -- 0 = first entry (no # suffix), 1/2/3... = scale-in positions
        coalesce(
            cast(
                nullif(
                    regexp_replace(notes, '^.*#(\d+).*$', '\1'),
                    notes           -- if no match, regexp_replace returns original
                ) as integer
            ),
            0
        ) as position_tier,

        -- Close price: extracted from CLOSE rows only
        -- "ClosePrice=1.05807 | SHADOW" → 1.05807
        case
            when event_type in ('CLOSE', 'CLOSE [RESYNC]')
                and notes ilike 'ClosePrice=%'
            then cast(
                nullif(
                    split_part(split_part(notes, '=', 2), ' ', 1),
                    '0.00000'
                ) as numeric(12, 5)
            )
            else null
        end as close_price,

        -- ── Derived flags ────────────────────────────────────────────────

        -- True when a CLOSE row has ClosePrice=0.00000
        -- Indicates a cancelled, rejected, or broker-voided trade
        case
            when event_type in ('CLOSE', 'CLOSE [RESYNC]')
                and (
                    notes ilike 'ClosePrice=0.00000%'
                    or profit_loss = 0 and notes ilike 'ClosePrice=%'
                )
            then true
            else false
        end as is_cancelled,

        -- True when SL/TP were already set at OPEN (no MODIFY needed)
        -- Used in dbt intermediate to skip MODIFY lookup for these tickets
        case
            when event_type in ('OPEN', 'OPEN [RESYNC]')
                and stop_loss  != 0
                and take_profit != 0
            then true
            else false
        end as is_prefilled_sltp,

        -- ── Pipeline metadata ─────────────────────────────────────────────
        ingested_at,
        source_file

    from source

)

select * from cleaned