with
    source as (
        select * from {{ source("raw_goldsky", "raw_goldsky_market_mezo__donated") }}
    ),

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
            timestamp_seconds(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select * except (amount), {{ format_musd_currency_columns(["amount"]) }}
        from renamed
    )

select *
from transformed_fields
