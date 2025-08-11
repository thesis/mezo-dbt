with
    donated as (select * from {{ ref("stg_goldsky_market_mezo__donated") }}),

    market_mapping as (select * from {{ ref("stg_seed_musd_market_map") }}),

    mapp_markets as (
        select donated.* except (recipient), market_mapping.market_name as recipient
        from donated
        left join market_mapping on donated.recipient = lower(market_mapping.market_id)
    )

select *
from mapp_markets
