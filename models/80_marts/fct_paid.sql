with
    all_paid as (select * from {{ ref("int_paid__all_paid") }}),

    fact as (
        select
            paid_id as id,
            referrer_id as fk__dim1_attribution,
            date_day as record_date,
            spend,
            impressions,
            clicks
        from all_paid
    )

select *
from fact
