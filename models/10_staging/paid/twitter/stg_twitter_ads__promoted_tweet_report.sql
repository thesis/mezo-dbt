with
    source as (select * from {{ source("twitter_ads", "promoted_tweet_report") }}),

    renamed as (
        select
            account_id,
            `date` as record_date,
            placement,
            promoted_tweet_id,
            _fivetran_synced,
            video_total_views,
            media_views,
            conversion_site_visits_metric,
            replies,
            card_engagements,
            video_15_s_views,
            video_cta_clicks,
            video_views_100,
            video_views_25,
            engagements,
            clicks,
            app_clicks,
            tweets_send,
            url_clicks,
            billed_engagements,
            video_content_starts,
            video_3_s_100_pct_views,
            impressions,
            auto_created_conversion_session,
            video_views_50,
            unfollows,
            video_6_s_views,
            likes,
            follows,
            auto_created_conversion_landing_page_view,
            conversion_site_visits_post_engagement,
            video_views_75,
            qualified_impressions,
            media_engagements,
            retweets
        from source
    )

select *
from renamed
