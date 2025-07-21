with source as (
        select * from {{ source('raw_goldsky', 'raw_goldky__musd_trove_manager_2') }}
  ),
  renamed as (
      select
          vid,
          block,
          id,
          block_number,
          TIMESTAMP_MILLIS(cast(`timestamp` as int)) as record_timestamp,
          transaction_hash,
          contract_id,
          liquidated_principal,
          liquidated_interest,
          liquidated_coll,
          coll_gas_compensation,
          gas_compensation,
          _gs_chain,
          _gs_gid,
          event_type

      from source
  )
  select * from renamed
