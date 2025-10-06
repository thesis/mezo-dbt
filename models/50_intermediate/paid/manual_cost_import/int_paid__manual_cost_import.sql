with
    cost_import as (select * from {{ ref("stg_paid__raw_other_marketing_costs") }}),

    costs_with_duration as (
        select
            *,
            1 + date_diff(
                coalesce(date_end, date_start), date_start, day
            ) as number_of_days
        from cost_import
    ),

    daily_costs as (
        select
            referrer_source,
            referrer_medium,
            generate_date_array(
                date_start, coalesce(date_end, date_start), interval 1 day
            ) as date_array,

            safe_divide(spend, number_of_days) as daily_spend,
            safe_divide(impressions, number_of_days) as daily_impressions,
            safe_divide(clicks, number_of_days) as daily_clicks
        from costs_with_duration
    )

select
    dc.referrer_source,
    dc.referrer_medium,
    date_day,
    dc.daily_spend as spend,
    dc.daily_impressions as impressions,
    dc.daily_clicks as clicks
from daily_costs as dc
cross join unnest(dc.date_array) as date_day
