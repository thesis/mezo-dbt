with
    twitter as (select * from {{ ref("twitter_ads", "twitter_ads__campaign_report") }}),

    add_unique_id as (
        select
            * except (campaign_id),
            'twitter' as referrer_source,
            'paid_social' as referrer_medium,
            concat('twitter_', campaign_id) as campaign_id
        from twitter
    )

select *
from add_unique_id
