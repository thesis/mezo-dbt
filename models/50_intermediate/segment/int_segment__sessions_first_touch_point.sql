{{ config(materialized="incremental", unique_key="canonical_segment_id") }}

with
    all_sessions as (
        select
            anonymous_id,
            canonical_segment_id_with_fallback as canonical_segment_id,
            referrer_source as src,
            referrer_medium as med,
            referrer_id as id,
            session_start_tstamp as ts
        from {{ ref("int_segment__sessions") }}
    ),

    agg as (
        select
            canonical_segment_id,
            anonymous_id,
            array_agg(struct(src, med, id, ts) order by ts) as all_touches,
            array_agg(
                if(
                    src in ('direct', 'session_continue'),
                    null,
                    struct(src, med, id, ts)
                )
                ignore nulls
                order by ts
            ) as non_direct_touches
        from all_sessions
        group by 1, 2
    ),

    first_touch_canonical as (
        select
            canonical_segment_id,
            anonymous_id,
            coalesce(
                (non_direct_touches[safe_offset(0)]).src,
                (all_touches[safe_offset(0)]).src
            ) as referrer_source,
            coalesce(
                (non_direct_touches[safe_offset(0)]).med,
                (all_touches[safe_offset(0)]).med
            ) as referrer_medium,
            coalesce(
                (non_direct_touches[safe_offset(0)]).id,
                (all_touches[safe_offset(0)]).id
            ) as referrer_id,
            coalesce(
                (non_direct_touches[safe_offset(0)]).ts,
                (all_touches[safe_offset(0)]).ts
            ) as record_timestamp
        from agg
        qualify
            row_number() over (
                partition by canonical_segment_id order by record_timestamp asc
            )
            = 1
    )

select *
from first_touch_canonical
