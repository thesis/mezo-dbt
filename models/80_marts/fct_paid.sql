with
    all_paid as (select * from {{ ref("int_paid__all_paid") }}),

    fact as (
        select
            paid_id as id,
            date_day as record_date,
            spend,
            impressions,
            clicks,
            referrer_source,
            referrer_medium
        from all_paid
    )

select *
from fact
