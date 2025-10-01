with
    loans as (
        select * from {{ ref("int_goldsky_borrower_operations_mezo__loans_graph") }}
    ),

    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    filtered_loan as (
        select
            l.*,
            coalesce(f.referrer_id, 'unknown') as referrer_id,
            coalesce(f.referrer_source, 'unknown') as referrer_source,
            coalesce(f.referrer_medium, 'unknown') as referrer_medium
        from loans as l
        left join
            first_touch_point as f on l.canonical_segment_id = f.canonical_segment_id
    )

select *
from filtered_loan
