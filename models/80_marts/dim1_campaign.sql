with
    all_paid as (select * from {{ ref("int_paid__all_paid") }}),

    fact as (
        select campaign_id as id, campaign_name
        from all_paid
        qualify row_number() over (partition by campaign_id order by date_day desc) = 1
    )

select *
from fact
