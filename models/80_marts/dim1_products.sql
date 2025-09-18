with
    products as (
        select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}
    ),

    filtered_products as (
        select distinct product_id as id, product_name
        from products
        qualify row_number() over (partition by product_id order by product_id) = 1
    )

select *
from filtered_products
