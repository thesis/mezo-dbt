with
    orders as (select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}),

    filtered_order as (
        select
            order_id as id,
            canonical_segment_id as fk__dim1_users,
            transaction_hash as fk_transaction_hash,
            product_id as fk__dim1_products,
            price,
            1 as order_count,
            date(record_timestamp) as record_date
        from orders
    )

select *
from filtered_order
