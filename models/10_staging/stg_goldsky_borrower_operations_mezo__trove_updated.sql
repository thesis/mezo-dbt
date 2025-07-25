with
    source as (
        select *
        from
            {{
                source(
                    "raw_goldsky",
                    "raw_goldsky_borrower_operations_mezo__trove_updated",
                )
            }}
    ),

    renamed as (
        select
            block,
            block_number,
            transaction_hash,
            contract_id,
            borrower,
            principal,
            interest,
            coll as collateral,
            stake,
            interest_rate,
            last_interest_update_time,
            operation,
            _gs_chain,
            _gs_gid,
            timestamp_millis(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select
            * except (principal, interest, collateral, stake, interest_rate, operation),
            {{ categorize_operation("operation") }} as operation,
            {{
                format_musd_currency_columns(
                    ["principal", "interest", "collateral", "stake", "interest"]
                )
            }}
        from renamed
    )

select *
from transformed_fields
