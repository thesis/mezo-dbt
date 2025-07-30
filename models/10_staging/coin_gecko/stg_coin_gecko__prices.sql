with
    source as (select * from {{ source("raw_coin_gecko", "prices") }}),

    renamed as (
        select id, coin_id, usd_value, last_updated_at, _dlt_load_id, _dlt_id
        from source
    )

select *
from renamed
