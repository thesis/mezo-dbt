with
    asset_locked as (
        select * from {{ ref("int_goldsky_mezo_bridge_mainnet__assets_locked_graph") }}
    ),

    first_touch_point as (
        select * from {{ ref("int_segment__sessions_first_touch_point") }}
    ),

    filtered_assets_locked as (
        select
            al.*,
            coalesce(f.referrer_id, 'unknown') as referrer_id,
            coalesce(f.referrer_source, 'unknown') as referrer_source,
            coalesce(f.referrer_medium, 'unknown') as referrer_medium
        from asset_locked as al
        left join
            first_touch_point as f on al.canonical_segment_id = f.canonical_segment_id
    )

select *
from filtered_assets_locked
