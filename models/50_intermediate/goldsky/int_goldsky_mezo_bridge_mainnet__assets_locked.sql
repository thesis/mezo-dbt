with
    assets_locked as (
        select * from {{ ref("stg_goldsky_mezo_bridge_mainnet__assets_locked") }}
    ),

    currency_lookup as (
        select
            * except (_dlt_load_id, _dlt_id),
            json_value(platforms, '$.ethereum') as ethereum_address
        from {{ ref("stg_coin_gecko__coins") }}
        union all
        select
            'swell' as id,
            'swbtc' as token_symbol,
            'Swell Restaked BTC' as names,
            null as platforms,
            '0x8db2350d78abc13f5673a411d4700bcf87864dde' as ethereum_address
    ),

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
            assets_locked.* except (amount),
            currency_lookup.symbol as token_symbol,
            currency_lookup.id as token_id,
            currency_lookup.name as token_name,
            {{ format_currency("amount", "currency_lookup.symbol") }} as amount
        from assets_locked
        left join
            currency_lookup
            on assets_locked.token_address = currency_lookup.ethereum_address
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
            on lookup_currency.token_id = most_recent_conversion.coin_id
    ),

    deduplicated as (
        select *
        from currency_conversion
        qualify
            row_number() over (
                partition by transaction_hash, sequence_number, _gs_gid
                order by currency_conversion_timestamp desc
            )
            = 1
    )

select *
from deduplicated
