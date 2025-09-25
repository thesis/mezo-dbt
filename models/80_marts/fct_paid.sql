with
    all_paid as (select * from {{ ref("int_paid__all_paid") }}),

    fact as (
        select id, campaign_id as fk__dim1_campaign, spend, impressions, clicks
        from all_paid
    )

select *
from fact
