with
    base as (select * from {{ ref("int_segment_web_sessions__initial") }}),

    with_keys as (

        select referrer_id as id, referrer_source, referrer_medium
        from base
        qualify
            row_number() over (
                partition by referrer_source, referrer_medium order by referrer_id
            )
            = 1

    )

select *
from with_keys
