CREATE OR REPLACE EXTERNAL TABLE
  `mezo-portal-data.raw_goldsky.raw_goldsky_mezo_bridge_mainnet__assets_locked` (
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
    -- The sequence number for the lock event.
    `sequence_number` BIGNUMERIC,
    -- The address of the asset recipient.
    `recipient` STRING,
    -- The address of the token contract.
    `token` STRING,
    -- The amount of tokens locked.
    `amount` BIGNUMERIC,
    -- The chain where the event originated, e.g., 'mainnet'.
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
    hive_partition_uri_prefix = 'gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/mezo_bridge_mainnet/event_type=assets_locked',
    -- The URIs pointing to the Parquet files in Google Cloud Storage.
    uris = ["gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/mezo_bridge_mainnet/event_type=assets_locked/*"]
  );
