with
    assets_locked as (
        select * from {{ ref("int_goldsky_mezo_bridge_mainnet__assets_locked_graph") }}
    ),

    filtered_assets_locked as (
        select
            sequence_number as id,
            canonical_segment_id as fk__dim1_users,
            transaction_hash as fk_transaction_hash,
            token_id as fk__dim1_token,
            amount,
            token_usd_value,
            1 as asset_locked_count,
            date(record_timestamp) as record_date

        from assets_locked
    )

select *
from filtered_assets_locked
