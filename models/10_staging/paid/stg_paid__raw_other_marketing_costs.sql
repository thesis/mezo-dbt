with
    source as (
        select * from {{ source("raw_other_marketing_costs", "other_marketing_costs") }}
    ),

    renamed as (
        select
            cast(date_start as date) as date_start,
            cast(date_end as date) as date_end,
            cast(referrer_source as string) as referrer_source,
            cast(referrer_medium as string) as referrer_medium,
            coalesce(cast(spend as float64), 0.00) as spend,
            coalesce(cast(impressions as int64), 0) as impressions,
            coalesce(cast(clicks as int64), 0) as clicks
        from source
    )

select *
from renamed
