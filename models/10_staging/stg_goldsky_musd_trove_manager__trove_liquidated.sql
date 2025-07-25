with
    source as (
        select *
        from
            {{
                source(
                    "raw_goldsky", "raw_goldsky_musd_trove_manager__trove_liquidated"
                )
            }}
    ),

    renamed as (
        select
            vid,
            -- `block`, --duplicate of block_number
            id,
            block_number,
            transaction_hash,
            contract_id,
            borrower,
            debt,
            coll as collateral,
            operation,
            _gs_chain,
            _gs_gid,
            timestamp_millis(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select
            * except (debt, collateral, operation),
            {{ categorize_operation("operation") }} as operation,
            {{ format_musd_currency_columns(["debt", "collateral"]) }}
        from renamed
    )

select *
from transformed_fields
