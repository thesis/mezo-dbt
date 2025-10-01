{{ config(materialized="incremental", unique_key="canonical_segment_id") }}

with
    first_touch_anonymous as (
        select
            anonymous_id,
            canonical_segment_id_with_fallback as canonical_segment_id,
            min(session_start_tstamp) as record_timestamp
        from {{ ref("int_segment__sessions") }}
        group by 1, 2
    ),

    first_touch_canonical as (
        select
            fa.anonymous_id,
            fa.canonical_segment_id,
            fa.record_timestamp,
            s.referrer_id,
            s.referrer_source,
            s.referrer_medium
        from first_touch_anonymous as fa
        left join
            {{ ref("int_segment__sessions") }} as s
            on fa.anonymous_id = s.anonymous_id
            and fa.record_timestamp = s.session_start_tstamp
        qualify
            row_number() over (
                partition by fa.canonical_segment_id order by fa.record_timestamp asc
            )
            = 1
    )

select *
from first_touch_canonical
