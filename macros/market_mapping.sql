{% macro map_market_values(column_to_map) %}
    with market_map_source as (
        select * from {{ ref('musd_market_map') }}
    )
    
    select
        original_table.*,
        coalesce(market_map_source.name, original_table.{{ column_to_map }}) as mapped_{{ column_to_map }}
    from original_table
    left join market_map_source 
        on lower(original_table.{{ column_to_map }}) = lower(market_map_source.market_id)
{% endmacro %}

{% macro get_mapped_market_name(column_name, alias=none) %}
    {% if alias %}
        coalesce(market_map.name, {{ column_name }}) as {{ alias }}
    {% else %}
        coalesce(market_map.name, {{ column_name }}) as {{ column_name }}
    {% endif %}
{% endmacro %}

{% macro join_market_map_to_column(table_alias, column_name, map_alias='market_map') %}
    left join {{ ref('musd_market_map') }} as {{ map_alias }}
        on lower({{ table_alias }}.{{ column_name }}) = lower({{ map_alias }}.market_id)
{% endmacro %}
