with
    source as (
        select *
        from
            {{
                source(
                    "raw_goldsky", "raw_goldsky_mezo_bridge_mainnet__assets_locked"
                )
            }}
    ),

    currency_lookup as (select * from {{ ref("stg_seed_token_map") }}),

    renamed as (
        select
            block,
            block_number,
            transaction_hash,
            contract_id,
            sequence_number,
            recipient,
            token as token_adress,
            amount,
            _gs_chain,
            _gs_gid,
            timestamp_seconds(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select
            * except (amount), {{ format_currency("amount", "token_adress") }} as amount
        from renamed
    ),

    lookup_currency as (
        select
            transformed_fields.*,
            currency_lookup.token_symbol,
            currency_lookup.token_type
        from transformed_fields
        left join
            currency_lookup
            on transformed_fields.token_adress = currency_lookup.token_adress
    )

select *
from lookup_currency
