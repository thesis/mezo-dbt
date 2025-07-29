with
    source as (select * from {{ ref("token_map") }}),

    renamed as (select token_adress, token_symbol, token_name, token_type from source)

select *
from renamed
