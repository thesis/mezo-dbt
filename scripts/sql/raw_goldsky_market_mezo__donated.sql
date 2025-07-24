CREATE OR REPLACE EXTERNAL TABLE
  `mezo-portal-data.raw_goldsky.raw_goldsky_market_mezo__donated` (
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
    -- The address of the donor.
    `donor` STRING,
    -- The ID of the beneficiary.
    `beneficiary_id` STRING,
    -- The address of the recipient.
    `recipient` STRING,
    -- The amount that was donated.
    `amount` BIGNUMERIC,
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
    hive_partition_uri_prefix = 'gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/market_mezo/event_type=donated',
    -- The URIs pointing to the Parquet files in Google Cloud Storage.
    uris = ["gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/market_mezo/event_type=donated/*"]
  );

