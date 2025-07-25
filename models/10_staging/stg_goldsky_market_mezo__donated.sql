with
    source as (
        select * from {{ source("raw_goldsky", "raw_goldsky_market_mezo__donated") }}
    ),

    market_mapping as (select * from {{ ref("stg_seed_musd_market_map") }}),

    renamed as (
        select
            block,
            block_number,
            transaction_hash,
            contract_id,
            donor,
            beneficiary_id,
            amount,
            _gs_chain,
            _gs_gid,
            lower(recipient) as recipient,
            timestamp_millis(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select * except (amount), {{ format_musd_currency_columns(["amount"]) }}
        from renamed
    ),

    mapp_markets as (
        select
            transformed_fields.* except (recipient),
            market_mapping.market_name as recipient
        from transformed_fields
        left join
            market_mapping
            on transformed_fields.recipient = lower(market_mapping.market_id)
    )

select *
from mapp_markets
