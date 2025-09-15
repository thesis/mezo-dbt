{{
    config(
        full_refresh=true,
        materialized="incremental",
        unique_key="canonical_segment_id_with_fallback",
    )
}}

with
    first_touch_anonymous as (
        select
            anonymous_id,
            canonical_segment_id_with_fallback,
            min(session_start_tstamp) as first_touch_time
        from {{ ref("int_segment__sessions") }}
        group by 1, 2
    ),

    first_touch_canonical as (
        select
            fa.*,
            s.referrer_source as first_touch_source,
            s.referrer_medium as first_touch_medium
        from first_touch_anonymous as fa
        left join
            {{ ref("int_segment__sessions") }} as s
            on fa.anonymous_id = s.anonymous_id
            and fa.first_touch_time = s.session_start_tstamp
    )

select *
from first_touch_canonical
