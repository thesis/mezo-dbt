with source as (
        select * from {{ source('raw_goldsky', 'raw_goldsky_musd_trove_manager__trove_liquidated') }}
  ),
  renamed as (
      select
        vid,
        `block`,
        id,
        block_number,
        TIMESTAMP_MILLIS(cast(`timestamp` as int)) as record_timestamp,
        transaction_hash,
        contract_id,
        borrower,
        debt,
        coll as collateral,
        operation,
        _gs_chain,
        _gs_gid
      from source
  )
  select * from renamed
