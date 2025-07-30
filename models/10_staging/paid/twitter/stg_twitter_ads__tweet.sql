with
    source as (select * from {{ source("twitter_ads", "tweet") }}),

    renamed as (
        select
            id,
            name as tweet_name,
            account_id,
            created_at,
            full_text,
            truncated,
            source,
            in_reply_to_status_id,
            in_reply_to_user_id,
            in_reply_to_screen_name,
            retweet_count,
            favorite_count,
            favorited,
            retweeted,
            lang,
            tweet_type,
            media_key,
            card_uri,
            geo_type,
            geo_coordinates,
            coordinates_type,
            coordinates_coordinates,
            followers,
            user_id,
            _fivetran_synced
        from source
    )

select *
from renamed
