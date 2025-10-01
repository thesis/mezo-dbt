with
    union_paid as (select * from {{ ref("int_paid__union_paid") }}),

    sur_key as (
        select
            *,
            {{
                dbt_utils.generate_surrogate_key(
                    ["referrer_medium", "referrer_source"]
                )
            }} as referrer_id,
            {{
                dbt_utils.generate_surrogate_key(
                    ["campaign_id", "date_day", "referrer_medium", "referrer_source"]
                )
            }} as paid_id
        from union_paid
    )

select *
from sur_key
