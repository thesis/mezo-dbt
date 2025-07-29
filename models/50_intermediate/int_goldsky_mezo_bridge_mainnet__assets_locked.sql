with
    assets_locked as (
        select * from {{ ref("stg_goldsky_mezo_bridge_mainnet__assets_locked") }}
    ),

    currency_lookup as (select * from {{ ref("stg_seed_token_map") }}),

    lookup_currency as (
        select assets_locked.*, currency_lookup.token_symbol, currency_lookup.token_type
        from assets_locked
        left join
            currency_lookup on assets_locked.token_adress = currency_lookup.token_adress
    )

select *
from lookup_currency
