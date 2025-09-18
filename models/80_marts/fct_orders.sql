with
    orders as (select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}),

    filtered_orders as (
        select
            order_id as id,
            canonical_segment_id as fk_dim1__users,
            transaction_hash as fk_transaction_hash,  -- check --> transaction_hash or order_id as id
            customer as fk_dim1__customer,  -- check --> customer or canonical_segment_id or both
            product_id as fk_dim1__products,
            price,
            1 as order_count,
            date(record_timestamp) as record_date
        from orders
    )

select *
from filtered_orders
