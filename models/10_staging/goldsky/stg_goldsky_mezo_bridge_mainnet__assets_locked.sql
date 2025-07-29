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
    )

select *
from transformed_fields
