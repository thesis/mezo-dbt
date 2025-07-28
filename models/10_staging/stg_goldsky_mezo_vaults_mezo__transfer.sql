with
    source as (
        select *
        from {{ source("raw_goldsky", "raw_goldsky_mezo_vaults_mezo__transfer") }}
    ),

    renamed as (
        select
            block,
            block_number,
            transaction_hash,
            contract_id,
            `from` as sender,
            `to` as recipient,
            value as amount,
            _gs_chain,
            _gs_gid,
            timestamp_seconds(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select * except (amount), {{ format_musd_currency_columns(["amount"]) }}
        from renamed
    )

select *
from transformed_fields
