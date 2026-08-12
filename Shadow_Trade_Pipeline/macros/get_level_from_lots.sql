{% macro get_level_from_lots(lots_column) %}
{#
    Converts a lot size to its corresponding trade level number.

    Current lot configuration:
        L1  = 0.01          L2  = 0.02      L3  = 0.03      L4  = 0.04
        L5  = 0.50          L6  = 0.60      L7  = 0.70      L8  = 0.80
        L9  = 0.90          L10 = 1.00      L11 = 1.10      L12 = 1.20
        L13 = 1.30          L14 = 1.40      L15 = 1.50      L16 = 1.60
        L17 = 1.70          L18 = 1.80      L19 = 1.90      L20 = 2.00
        L21 = 2.10          L22 = 2.20      L23 = 2.30      L24 = 2.40
        L25 = 2.50          L26 = 2.60      L27 = 2.70      L28 = 2.80
        L29 = 2.90          L30 = 3.00      L31+ = formula

    To update lot sizes (e.g. if strategy config changes):
        - Edit the explicit WHEN clauses below for L1-L30
        - Update the fallback formula for L31+ if the increment changes

    NOTE: Uses round() to handle floating point precision issues in Postgres.
    (e.g. 0.1 + 0.1 + 0.1 can return 0.30000000000000004 in float arithmetic)
#}
case
    -- L1-L4: 0.01 lot increments
    when round({{ lots_column }}::numeric, 2) = 0.01 then 1
    when round({{ lots_column }}::numeric, 2) = 0.02 then 2
    when round({{ lots_column }}::numeric, 2) = 0.03 then 3
    when round({{ lots_column }}::numeric, 2) = 0.04 then 4
    -- L5-L30: 0.10 lot increments starting from 0.50
    when round({{ lots_column }}::numeric, 2) = 0.50 then 5
    when round({{ lots_column }}::numeric, 2) = 0.60 then 6
    when round({{ lots_column }}::numeric, 2) = 0.70 then 7
    when round({{ lots_column }}::numeric, 2) = 0.80 then 8
    when round({{ lots_column }}::numeric, 2) = 0.90 then 9
    when round({{ lots_column }}::numeric, 2) = 1.00 then 10
    when round({{ lots_column }}::numeric, 2) = 1.10 then 11
    when round({{ lots_column }}::numeric, 2) = 1.20 then 12
    when round({{ lots_column }}::numeric, 2) = 1.30 then 13
    when round({{ lots_column }}::numeric, 2) = 1.40 then 14
    when round({{ lots_column }}::numeric, 2) = 1.50 then 15
    when round({{ lots_column }}::numeric, 2) = 1.60 then 16
    when round({{ lots_column }}::numeric, 2) = 1.70 then 17
    when round({{ lots_column }}::numeric, 2) = 1.80 then 18
    when round({{ lots_column }}::numeric, 2) = 1.90 then 19
    when round({{ lots_column }}::numeric, 2) = 2.00 then 20
    when round({{ lots_column }}::numeric, 2) = 2.10 then 21
    when round({{ lots_column }}::numeric, 2) = 2.20 then 22
    when round({{ lots_column }}::numeric, 2) = 2.30 then 23
    when round({{ lots_column }}::numeric, 2) = 2.40 then 24
    when round({{ lots_column }}::numeric, 2) = 2.50 then 25
    when round({{ lots_column }}::numeric, 2) = 2.60 then 26
    when round({{ lots_column }}::numeric, 2) = 2.70 then 27
    when round({{ lots_column }}::numeric, 2) = 2.80 then 28
    when round({{ lots_column }}::numeric, 2) = 2.90 then 29
    when round({{ lots_column }}::numeric, 2) = 3.00 then 30
    -- L31+: fallback formula (0.50 base, 0.10 increments from L5)
    else (floor((round({{ lots_column }}::numeric, 2) - 0.50) / 0.10) + 5)::int
end
{% endmacro %}
