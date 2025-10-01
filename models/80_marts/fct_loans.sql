with
    loans as (
        select *
        from
            {{ ref("int_goldsky_borrower_operations_mezo__loans_graph_with_referrer") }}
    ),

    filtered_loan as (
        select
            transaction_hash as id,
            canonical_segment_id as fk__dim1_users,
            referrer_id as fk__dim1_attribution,
            collateral_usd_value,
            principal,
            interest,
            collateral,
            stake,
            1 as loan_count,
            date(record_timestamp) as record_date,
            case when operation = 'new_loan' then 1 else 0 end as new_loan_count,
            case
                when operation = 'adjusted_loan' then 1 else 0
            end as adjusted_loan_count,
            case when operation = 'closed_loan' then 1 else 0 end as closed_loan_count
        from loans
    )

select *
from filtered_loan
