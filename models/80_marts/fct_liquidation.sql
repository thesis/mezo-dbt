with
    liquidation as (
        select * from {{ ref("int_goldsky_musd_trove_manager__liquidation_graph") }}
    ),

    filtered_liquidation as (
        select
            id,
            transaction_hash as fk_transaction_hash,
            canonical_segment_id as fk_dim1__users,
            coll_gas_compensation,
            gas_compensation,
            liquidated_principal,
            liquidated_interest,
            liquidated_collateral,
            1 as liquidation_count,
            date(record_timestamp) as record_date
        from liquidation
    )

select *
from filtered_liquidation
