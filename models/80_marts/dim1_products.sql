with
    products as (
        select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}
    ),

    donated as (
        select * from {{ ref("int_goldsky_market_mezo__donated_graph_with_referrer") }}
    ),

    filtered_donated as (
        select recipient as id, recipient as product_name
        from donated
        qualify row_number() over (partition by recipient order by recipient) = 1
    ),

    filtered_products as (
        select product_id as id, product_name
        from products
        qualify row_number() over (partition by product_id order by product_id) = 1
    ),

    unioned as (
        select *
        from filtered_products
        union all
        select *
        from filtered_donated
    )

select *
from unioned
