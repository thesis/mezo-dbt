with
    base as (

        select distinct referrer_source, referrer_medium
        from {{ ref("int_segment__sessions") }}

    ),

    with_keys as (

        select
            {{
                dbt_utils.generate_surrogate_key(
                    ["referrer_source", "referrer_medium"]
                )
            }} as id, referrer_source, referrer_medium
        from base

    )

select *
from with_keys
