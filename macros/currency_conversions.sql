{% macro format_currency(column_to_format, asset_column) %}
    (
        coalesce(safe_cast({{ column_to_format }} as numeric), 0) / case
            when {{ asset_column }} in ('usdc', 'usdt')
            then 1e6
            when {{ asset_column }} in ('wbtc', 'fbtc', 'cbbtc', 'swbtc')
            then 1e8
            else 1e18
        end
    )
{% endmacro %}

{% macro format_musd_currency_columns(columns) %}
    {% for column in columns %}
        coalesce(safe_cast({{ column }} as numeric), 0) / 1e18 as {{ column }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}
