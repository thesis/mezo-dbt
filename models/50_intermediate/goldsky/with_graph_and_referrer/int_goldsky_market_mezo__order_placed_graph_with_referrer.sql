with
    orders as (select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}),

    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    filtered_order as (
        select
            o.*,
            coalesce(f.referrer_id, 'unknown') as referrer_id,
            coalesce(f.referrer_source, 'unknown') as referrer_source,
            coalesce(f.referrer_medium, 'unknown') as referrer_medium
        from orders as o
        left join
            first_touch_point as f on o.canonical_segment_id = f.canonical_segment_id
    )

select *
from filtered_order
