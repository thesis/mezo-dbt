with
    liquidation as (
        select * from {{ ref("int_goldsky_musd_trove_manager__liquidation_graph") }}
    ),

    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    filtered_liquidation as (
        select
            l.*,
            coalesce(f.referrer_id, 'unknown') as referrer_id,
            coalesce(f.referrer_source, 'unknown') as referrer_source,
            coalesce(f.referrer_medium, 'unknown') as referrer_medium
        from liquidation as l
        left join
            first_touch_point as f on l.canonical_segment_id = f.canonical_segment_id
    )

select *
from filtered_liquidation
