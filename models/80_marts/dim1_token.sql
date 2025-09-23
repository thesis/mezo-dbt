with
    assets_locked as (
        select * from {{ ref("int_goldsky_mezo_bridge_mainnet__assets_locked_graph") }}
    ),

    tokens as (
        select distinct token_id as id, token_symbol, token_address, token_name
        from assets_locked
    )

select *
from tokens
