with
    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    assets_locked as (
        select *
        from
            {{
                ref(
                    "int_goldsky_mezo_bridge_mainnet__assets_locked_graph_with_referrer"
                )
            }}
    ),

    loans as (
        select *
        from
            {{ ref("int_goldsky_borrower_operations_mezo__loans_graph_with_referrer") }}
    ),

    donations as (
        select * from {{ ref("int_goldsky_market_mezo__donated_graph_with_referrer") }}
    ),

    orders as (
        select *
        from {{ ref("int_goldsky_market_mezo__order_placed_graph_with_referrer") }}
    ),

    filtered_first_touch_point as (
        select canonical_segment_id, record_timestamp, referrer_id
        from first_touch_point
    ),

    filtered_assets_locked as (
        select
            canonical_segment_id, min(record_timestamp) as record_timestamp, referrer_id
        from assets_locked
        group by 1, 3
    ),

    filtered_loans as (
        select
            canonical_segment_id, min(record_timestamp) as record_timestamp, referrer_id
        from loans
        group by 1, 3
    ),

    filtered_donations as (
        select
            canonical_segment_id, min(record_timestamp) as record_timestamp, referrer_id
        from donations
        group by 1, 3
    ),

    filtered_orders as (
        select
            canonical_segment_id, min(record_timestamp) as record_timestamp, referrer_id
        from orders
        group by 1, 3
    ),

    combined as (
        select *
        from filtered_first_touch_point
        union distinct
        select *
        from filtered_assets_locked
        union distinct
        select *
        from filtered_loans
        union distinct
        select *
        from filtered_donations
        union distinct
        select *
        from filtered_orders
    ),

    deduplicated as (
        select * except (record_timestamp), date(record_timestamp) as record_date
        from combined
        qualify
            row_number() over (
                partition by canonical_segment_id order by record_timestamp
            )
            = 1
    )

select *
from deduplicated
