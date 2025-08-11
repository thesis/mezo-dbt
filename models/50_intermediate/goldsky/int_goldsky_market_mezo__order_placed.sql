with
    order_places as (select * from {{ ref("stg_goldsky_market_mezo__order_placed") }}),

    market_mapping as (select * from {{ ref("stg_seed_musd_market_map") }}),

    mapp_markets as (
        select order_places.*, market_mapping.market_name as product_name
        from order_places
        left join
            market_mapping on order_places.product_id = lower(market_mapping.market_id)
    )

select *
from mapp_markets
