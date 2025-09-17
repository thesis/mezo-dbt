with
    loans as (select * from {{ ref("int_goldsky_borrower_operations_mezo__loans") }}),

    filtered_loans as (
        select
            transaction_hash as id,
            borrower as fk_dim1__borrower,
            collateral_usd_value,
            principal,  -- check --> if we need it
            interest,  -- check --> if we need it
            collateral,  -- check --> if we need it
            stake,  -- check --> if we need it
            previous_principal_value,  -- check --> if we need it
            previous_collateral_value,  -- check --> if we need it
            1 as total_loans_count,
            date(record_timestamp) as record_date,
            case when operation = 'new_loan' then 1 else 0 end as new_loan_count,
            case
                when operation = 'adjusted_loan' then 1 else 0
            end as adjusted_loan_count,
            case when operation = 'closed_loan' then 1 else 0 end as closed_loan_count
        from loans
    )

select *
from filtered_loans
