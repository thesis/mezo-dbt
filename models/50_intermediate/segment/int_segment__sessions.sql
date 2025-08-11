with
    segment_sessions as (select * from {{ ref("segment_web_sessions") }}),

    segment_graph as (
        select trait_value as anonymous_id, canonical_segment_id
        from {{ ref("stg_segment_profiles__user_identifiers") }}
        where id_type = 'anonymous_id'
    ),

    sessions_user_enriched as (
        select
            segment_sessions.*,
            {{ url_without_query_strings("segment_sessions.first_page_url") }}
            as landing_page_url_without_query_string,
            {{ url_without_query_strings("segment_sessions.last_page_url") }}
            as exit_page_url_without_query_string,
            coalesce(
                segment_graph.canonical_segment_id, segment_sessions.anonymous_id
            ) as canonical_segment_id_with_fallback
        from segment_sessions
        left join
            segment_graph on segment_sessions.anonymous_id = segment_graph.anonymous_id
    )

select *
from sessions_user_enriched
