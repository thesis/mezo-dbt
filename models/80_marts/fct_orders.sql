with
    orders as (select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}),

    filtered_orders as (
        select
            transaction_hash as id,  -- check --> or-- order_id as id,
            customer as fk_dim1__customer,  -- check -->
            -- customer or canonical_segment_id or both
            canonical_segment_id as fk_dim1__users,
            product_id as fk_dim1__products,
            price,
            1 as total_orders_count,
            date(record_timestamp) as record_date
        from orders
    )

select *
from filtered_orders
