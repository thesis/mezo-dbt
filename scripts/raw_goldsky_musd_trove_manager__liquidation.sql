CREATE OR REPLACE EXTERNAL TABLE
  `mezo-portal-data.raw_goldsky.raw_goldsky_musd_trove_manager__liquidation` ( `vid` integer,
    `block` integer,
    `id` string,
    `block_number` bignumeric,
    `timestamp` bignumeric,
    `transaction_hash` string,
    `contract_id` string,
    `liquidated_principal` bignumeric,
    `liquidated_interest` bignumeric,
    `liquidated_coll` bignumeric,
    `coll_gas_compensation` bignumeric,
    `gas_compensation` bignumeric,
    `_gs_chain` string,
    `_gs_gid` string
    )
    WITH PARTITION COLUMNS (`event_date` date)
    OPTIONS (format = 'PARQUET',
    hive_partition_uri_prefix = 'gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/musd_trove_manager/event_type=liquidation',
    uris = ["gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/musd_trove_manager/event_type=liquidation/*"]);
