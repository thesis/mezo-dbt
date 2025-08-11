with
    twitter as (select * from {{ ref("twitter_ads", "twitter_ads__campaign_report") }}),

    add_unique_id as (
        select *, concat('twitter_', campaign_id, date_day) as id from twitter
    )

select *
from add_unique_id
