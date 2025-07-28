with
    source as (
        select *
        from {{ source("raw_goldsky", "raw_goldsky_market_mezo__order_placed") }}
    ),

    market_mapping as (select * from {{ ref("stg_seed_musd_market_map") }}),

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
    ),

    mapp_markets as (
        select
            transformed_fields.* except (product_id),
            market_mapping.market_name as product_name
        from transformed_fields
        left join
            market_mapping
            on transformed_fields.product_id = lower(market_mapping.market_id)
    )

select *
from mapp_markets
