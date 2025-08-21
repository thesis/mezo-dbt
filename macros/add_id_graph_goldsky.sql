{% macro resolve_identities(source_ref, join_key) %}
    with
        goldsky as (select * from {{ source_ref }}),

        graph as (
            select *
            from {{ ref("stg_segment_profiles__user_identifiers") }}
            where id_type = 'wallet_address'
        ),

        joined as (
            select
                goldsky.*,
                graph.trait_value is not null as is_in_graph,
                coalesce(
                    graph.canonical_segment_id, goldsky.{{ join_key }}
                ) as canonical_segment_id
            from goldsky
            left join graph on lower(goldsky.{{ join_key }}) = lower(graph.trait_value)
        )

    select *
    from joined
{% endmacro %}
