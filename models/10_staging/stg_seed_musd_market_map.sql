with
    source as (select * from {{ ref("musd_market_map") }}),

    renamed as (select id as market_id, name as market_name from source)

select *
from renamed
