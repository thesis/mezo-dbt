with
    source as (
        select *
        from {{ source("raw_goldsky", "raw_goldsky_market_mezo__order_placed") }}
    ),

    renamed as (
        select
            block,
            block_number,
            transaction_hash,
            contract_id,
            order_id,
            customer,
            price,
            _gs_chain,
            _gs_gid,
            lower(product_id) as product_id,
            timestamp_seconds(cast(`timestamp` as int)) as record_timestamp
        from source
    ),

    transformed_fields as (
        select * except (price), {{ format_musd_currency_columns(["price"]) }}
        from renamed
    )

select *
from transformed_fields
