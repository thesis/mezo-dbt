with
    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    filtered_users as (
        select
            canonical_segment_id,
            first_touch_time,
            first_touch_source,
            first_touch_medium
        from first_touch_point
    )

select *
from filtered_users
