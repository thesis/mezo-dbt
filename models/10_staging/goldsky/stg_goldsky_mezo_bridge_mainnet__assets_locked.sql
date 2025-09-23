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
            token as token_address,
            amount,
            _gs_chain,
            _gs_gid,
            timestamp_seconds(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    deduplicated as (
        select *
        from renamed
        qualify
            row_number() over (
                partition by sequence_number order by record_timestamp desc
            )
            = 1
    )

select *
from deduplicated
