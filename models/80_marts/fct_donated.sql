with
    donated as (select * from {{ ref("int_goldsky_market_mezo__donated_graph") }}),

    filtered_donated as (
        select
            transaction_hash as id,
            donor as fk_dim1__donor,
            canonical_segment_id as fk_dim1__users,
            amount,
            1 as total_donations_count,
            date(record_timestamp) as record_date,
            case when recipient = 'Brink' then 1 else 0 end as recipient_brink_count,
            case when recipient = 'SheFi' then 1 else 0 end as recipient_shefi_count
        from donated
    )

select *
from filtered_donated
