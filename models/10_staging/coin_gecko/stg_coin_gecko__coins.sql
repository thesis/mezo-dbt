with
    source as (select * from {{ source("raw_coin_gecko", "coins") }}),

    renamed as (select id, symbol, name, platforms, _dlt_load_id, _dlt_id from source)

select *
from renamed
