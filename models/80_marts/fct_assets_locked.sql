with
    assets_locked as (
        select * from {{ ref("int_goldsky_mezo_bridge_mainnet__assets_locked") }}
    ),

    filtered_assets_locked as (
        select
            sequence_number as id,  -- check -->
            -- if it should be sequence_number or transaction_hash
            transaction_hash as fk_transaction_hash,
            recipient as fk_dim1__recipient,
            token_adress as fk_token_adress,
            amount,
            token_usd_value,
            1 as total_assets_locked_count,
            date(record_timestamp) as record_date

        from assets_locked
    )

select *
from filtered_assets_locked
