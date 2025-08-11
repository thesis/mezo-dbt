with
    liquidations as (
        select * from {{ ref("stg_goldsky_musd_trove_manager__liquidation") }}
    ),

    trove_liquidated as (
        select * from {{ ref("stg_goldsky_musd_trove_manager__trove_liquidated") }}
    ),

    liquidations_with_trove as (
        select liquidations.*, trove_liquidated.borrower, trove_liquidated.operation
        from liquidations
        left join
            trove_liquidated
            on liquidations.transaction_hash = trove_liquidated.transaction_hash
    )

select *
from liquidations_with_trove
