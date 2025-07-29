with
    source as (select * from {{ source("raw_coin_gecko", "coins") }}),

    renamed as (select id, symbol, name, _dlt_load_id, _dlt_id, platforms from source)

select *
from renamed
