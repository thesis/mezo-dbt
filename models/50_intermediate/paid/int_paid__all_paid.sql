with
    twitter as (select * from {{ ref("twitter_ads", "twitter_ads__campaign_report") }}),

    add_unique_id as (
        select
            * except (campaign_id),
            concat('twitter_', campaign_id, date_day) as id,
            concat('twitter_', campaign_id) as campaign_id
        from twitter
    )

select *
from add_unique_id
