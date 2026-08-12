{% macro get_pip_size(symbol_column) %}
{#
    Returns the pip size for a given symbol column.

    Mapping:
        XAU* (Gold)          → 0.1
        XAG* (Silver)        → 0.01
        *JPY* pairs          → 0.01
        All other forex      → 0.0001

    To add a new symbol type, add a new WHEN clause here.
    Order matters — more specific patterns should come first.
#}
case
    when {{ symbol_column }} ilike 'XAU%'  then 0.1     -- Gold
    when {{ symbol_column }} ilike 'XAG%'  then 0.01    -- Silver
    when {{ symbol_column }} ilike '%JPY%' then 0.01    -- JPY pairs
    else 0.0001                                          -- Standard forex
end
{% endmacro %}
