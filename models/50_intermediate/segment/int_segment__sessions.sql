with
    segment_sessions as (select * from {{ ref("segment_web_sessions") }}),

    twitter_campaigns as (
        select distinct campaign_name, concat('twitter_', campaign_id) as campaign_id
        from {{ ref("twitter_ads_source", "stg_twitter_ads__campaign_history") }}
    ),

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
            cast(segment_sessions.session_start_tstamp as date) as session_start_date,
            coalesce(
                segment_graph.canonical_segment_id, segment_sessions.anonymous_id
            ) as canonical_segment_id_with_fallback
        from segment_sessions
        left join
            segment_graph on segment_sessions.anonymous_id = segment_graph.anonymous_id

    ),

    add_campaign_id_twitter as (
        select sessions_user_enriched.*, twitter_campaigns.campaign_id
        from sessions_user_enriched
        left join
            twitter_campaigns
            on sessions_user_enriched.utm_campaign = twitter_campaigns.campaign_name
            and sessions_user_enriched.utm_source = 'twitter'
            and sessions_user_enriched.utm_medium = 'paid_social'
    )

select *
from add_campaign_id_twitter
