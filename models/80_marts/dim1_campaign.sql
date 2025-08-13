with
    campaign_data as (
        select distinct campaign_id as id, campaign_name
        from {{ ref("int_paid__all_paid") }}
        qualify row_number() over (partition by campaign_id order by date_day) = 1
    )

select *
from campaign_data
