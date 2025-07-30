with
    trove_updated as (
        select * from {{ ref("stg_goldsky_borrower_operations_mezo__trove_updated") }}
    ),

    currency_conversion as (
        select coin_id, usd_value, last_updated_at
        from {{ ref("stg_coin_gecko__prices") }}
    ),

    most_recent_conversion as (
        select coin_id, usd_value, last_updated_at
        from currency_conversion
        qualify
            row_number() over (partition by coin_id order by last_updated_at desc) = 1
    ),

    convert_currencies as (
        select
            trove_updated.*,
            most_recent_conversion.last_updated_at as currency_conversion_timestamp,
            round(
                trove_updated.collateral * most_recent_conversion.usd_value, 2
            ) as collateral_usd_value
        from trove_updated
        left join most_recent_conversion on "bitcoin" = most_recent_conversion.coin_id
    ),

    collateral_ratio as (
        select *, safe_divide(collateral_usd_value, principal) as collateral_ratio
        from convert_currencies
    ),

    add_inital_values as (
        select
            *,
            case
                when operation = "adjusted_loan"
                then

                    lead(principal) over (
                        partition by borrower order by record_timestamp desc
                    )
            end as previous_principal_value,
            case
                when operation = "adjusted_loan"
                then
                    lead(collateral) over (
                        partition by borrower order by record_timestamp desc
                    )
            end as previous_collateral_value
        from collateral_ratio
    ),

    add_adjustment_types as (
        select
            *,
            case
                when operation = "adjusted_loan"
                then
                    case
                        when principal > previous_principal_value
                        then "increase"
                        when principal < previous_principal_value
                        then "decrease"
                        else "no_change"
                    end
            end as adjustment_type_principal,
            case
                when operation = "adjusted_loan"
                then
                    case
                        when collateral > previous_collateral_value
                        then "increase"
                        when collateral < previous_collateral_value
                        then "decrease"
                        else "no_change"
                    end
            end as adjustment_type_collateral
        from add_inital_values
    )

select *
from add_adjustment_types
