with
    source as (
        select * from {{ source("raw_other_marketing_costs", "other_marketing_costs") }}
    ),

    renamed as (
        select
            cast(record_date as date) as date_day,
            cast(referrer_source as string) as referrer_source,
            cast(referrer_medium as string) as referrer_medium,
            cast(spend as float64) as spend,
            cast(impressions as int64) as impressions,
            cast(clicks as int64) as clicks
        from source
    )

select *
from renamed
