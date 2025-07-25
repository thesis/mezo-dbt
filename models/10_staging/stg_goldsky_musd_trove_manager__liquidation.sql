with source as (
        select * from
        {{ source('raw_goldsky', 'raw_goldsky_musd_trove_manager__liquidation') }}
  ),

  renamed as (
      select
          vid,
        block,
        id,
        block_number,
        transaction_hash,
        contract_id,
        liquidated_principal,
        liquidated_interest,
        liquidated_coll as liquidated_collateral,
        coll_gas_compensation,
        gas_compensation,
        _gs_chain,
        _gs_gid,
        timestamp_millis(cast(`timestamp` as int)) as record_timestamp
      from source
  ),

  transformed_fields as (
      select * except(liquidated_principal,liquidated_interest, liquidated_collateral),
        {{ format_musd_currency_columns(
          ['liquidated_principal', 'liquidated_interest', 'liquidated_collateral']
          ) }}
      from renamed
 )

 select * from transformed_fields
