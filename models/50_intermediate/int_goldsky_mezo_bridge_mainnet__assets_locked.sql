with
    assets_locked as (
        select * from {{ ref("stg_goldsky_mezo_bridge_mainnet__assets_locked") }}
    ),

    currency_lookup as (select * from {{ ref("stg_seed_token_map") }}),

    currency_conversion_values as (
        select coin_id, usd_value, last_updated_at
        from {{ ref("stg_coin_gecko__prices") }}
    ),

    most_recent_conversion as (
        select coin_id, usd_value, last_updated_at
        from currency_conversion_values
        qualify
            row_number() over (partition by coin_id order by last_updated_at desc) = 1
    ),

    lookup_currency as (
        select
            assets_locked.*,
            currency_lookup.token_symbol,
            currency_lookup.token_type,
            currency_lookup.token_name
        from assets_locked
        left join
            currency_lookup on assets_locked.token_adress = currency_lookup.token_adress
    ),

    currency_conversion as (
        select
            lookup_currency.*,
            most_recent_conversion.last_updated_at as currency_conversion_timestamp,
            round(
                lookup_currency.amount * most_recent_conversion.usd_value, 2
            ) as token_usd_value
        from lookup_currency
        left join
            most_recent_conversion
            on lookup_currency.token_name = most_recent_conversion.coin_id
    )

select *
from currency_conversion
