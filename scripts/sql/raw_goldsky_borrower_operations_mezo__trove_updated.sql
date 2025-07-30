CREATE OR REPLACE EXTERNAL TABLE
  `mezo-portal-data.raw_goldsky.raw_goldsky_borrower_operations_mezo__trove_updated` (
    -- The block number in which this event occurred.
    `block` INTEGER,
    -- The block number as a high-precision numeric value.
    `block_number` BIGNUMERIC,
    -- The timestamp of the block as a Unix timestamp.
    `timestamp` BIGNUMERIC,
    -- The hash of the transaction that emitted this event.
    `transaction_hash` STRING,
    -- The address of the contract that emitted the event.
    `contract_id` STRING,
    -- The address of the borrower.
    `borrower` STRING,
    -- The principal debt amount.
    `principal` BIGNUMERIC,
    -- The interest amount.
    `interest` BIGNUMERIC,
    -- The collateral amount.
    `coll` BIGNUMERIC,
    -- The stake amount.
    `stake` BIGNUMERIC,
    -- The interest rate for the trove.
    `interest_rate` BIGNUMERIC,
    -- The timestamp of the last interest update.
    `last_interest_update_time` BIGNUMERIC,
    -- The type of operation performed.
    `operation` STRING,
    -- The chain where the event originated, e.g., 'mezo'.
    `_gs_chain` STRING,
    -- The unique identifier from Goldsky for the event.
    `_gs_gid` STRING
  )
  WITH PARTITION COLUMNS (
    -- The table is partitioned by the date of the event.
    `event_date` DATE
  )
  OPTIONS (
    format = 'PARQUET',
    -- The prefix for the hive-style partitions in Google Cloud Storage.
    hive_partition_uri_prefix = 'gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/borrower_operations_mezo/event_type=trove_updated',
    -- The URIs pointing to the Parquet files in Google Cloud Storage.
    uris = ["gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/borrower_operations_mezo/event_type=trove_updated/*"]
  );
