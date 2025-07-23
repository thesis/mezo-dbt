{% macro format_currency(column_to_format, asset_column) %}
    (
        -- Step 1: Safely cast the raw column to a NUMERIC type.
        -- SAFE_CAST returns NULL if the conversion fails, preventing query errors.
        -- COALESCE then converts any NULLs (either from source or failed cast) to 0.
        COALESCE(SAFE_CAST({{ column_to_format }} AS NUMERIC), 0)

        /

        -- Step 2: Determine the correct scaling factor based on the asset symbol.
        -- This CASE statement mirrors the if/elif/else logic from the Python function.
        CASE
            WHEN {{ asset_column }} IN ('USDC', 'USDT') THEN 1e6
            WHEN {{ asset_column }} IN ('WBTC', 'FBTC', 'cbBTC', 'swBTC') THEN 1e8
            ELSE 1e18
        END
    )
{% endmacro %}

{% macro format_musd_currency_columns(columns) %}
    {% for column in columns %}
        -- Convert the column to a numeric type, coalesce NULL values to 0
        -- Then divide by 1e18 to normalize the currency value
        -- This replicates the Python function that divides by Decimal("1e18")
        COALESCE(SAFE_CAST({{ column }} AS NUMERIC), 0) / 1e18 AS {{ column }}

        {% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}