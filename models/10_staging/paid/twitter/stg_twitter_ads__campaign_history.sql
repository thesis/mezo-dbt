with
    source as (select * from {{ source("twitter_ads", "campaign_history") }}),

    renamed as (
        select
            id,
            updated_at,
            account_id,
            funding_instrument_id,
            `name` as campaign_name,
            start_time,
            servable,
            daily_budget_amount_local_micro,
            end_time,
            duration_in_days,
            standard_delivery,
            total_budget_amount_local_micro,
            budget_optimization,
            entity_status,
            frequency_cap,
            currency,
            created_at,
            deleted,
            _fivetran_synced
        from source
    )

select *
from renamed
