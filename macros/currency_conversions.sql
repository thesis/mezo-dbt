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