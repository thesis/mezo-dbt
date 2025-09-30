with
    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    assets_locked as (
        select * from {{ ref("int_goldsky_mezo_bridge_mainnet__assets_locked_graph") }}
    ),

    loans as (
        select * from {{ ref("int_goldsky_borrower_operations_mezo__loans_graph") }}
    ),

    donations as (select * from {{ ref("int_goldsky_market_mezo__donated_graph") }}),

    orders as (select * from {{ ref("int_goldsky_market_mezo__order_placed_graph") }}),

    filtered_first_touch_point as (
        select
            canonical_segment_id,
            first_touch_time,
            first_touch_source,
            first_touch_medium
        from first_touch_point
    ),

    filtered_assets_locked as (
        select
            canonical_segment_id,
            min(record_timestamp) as first_touch_time,
            'unknown' as first_touch_source,
            'unknown' as first_touch_medium
        from assets_locked
        group by 1
    ),

    filtered_loan as (
        select
            canonical_segment_id,
            min(record_timestamp) as first_touch_time,
            'unknown' as first_touch_source,
            'unknown' as first_touch_medium
        from loans
        group by 1
    ),

    filtered_donation as (
        select
            canonical_segment_id,
            min(record_timestamp) as first_touch_time,
            'unknown' as first_touch_source,
            'unknown' as first_touch_medium
        from donations
        group by 1
    ),

    filtered_orders as (
        select
            canonical_segment_id,
            min(record_timestamp) as first_touch_time,
            'unknown' as first_touch_source,
            'unknown' as first_touch_medium
        from orders
        group by 1
    ),

    combined as (
        select *
        from filtered_first_touch_point
        union distinct
        select *
        from filtered_assets_locked
        union distinct
        select *
        from filtered_loan
        union distinct
        select *
        from filtered_donation
        union distinct
        select *
        from filtered_orders
    ),

    deduplicated as (
        select *
        from combined
        qualify
            row_number() over (
                partition by canonical_segment_id order by first_touch_time
            )
            = 1
    )

select *
from deduplicated
