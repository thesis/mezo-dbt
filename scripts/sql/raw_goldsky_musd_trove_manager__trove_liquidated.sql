CREATE OR REPLACE EXTERNAL TABLE
  `mezo-portal-data.raw_goldsky.raw_goldsky_musd_trove_manager__trove_liquidated` (`vid` INTEGER,
    `block` INTEGER,
    `id` STRING,
    `block_number` BIGNUMERIC,
    `timestamp` BIGNUMERIC,
    `transaction_hash` STRING,
    `contract_id` STRING,
    `borrower` STRING,
    `debt` BIGNUMERIC,
    `coll` BIGNUMERIC,
    `operation` STRING,
    `_gs_chain` STRING,
    `_gs_gid` STRING)
WITH PARTITION COLUMNS (`event_date` date)
OPTIONS (format = 'PARQUET',
    hive_partition_uri_prefix = 'gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/musd_trove_manager/event_type=trove_liquidated',
    uris = ["gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/musd_trove_manager/event_type=trove_liquidated/*"]);
