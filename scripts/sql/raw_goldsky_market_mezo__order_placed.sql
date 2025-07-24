CREATE OR REPLACE EXTERNAL TABLE
  `mezo-portal-data.raw_goldsky.raw_goldsky_market_mezo__order_placedmezo-portal-data.raw_goldsky.raw_goldsky_market_mezo__order_placed` (
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
    -- The unique identifier for the order.
    `order_id` STRING,
    -- The address of the customer who placed the order.
    `customer` STRING,
    -- The identifier for the product that was ordered.
    `product_id` STRING,
    -- The price of the order.
    `price` BIGNUMERIC,
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
    hive_partition_uri_prefix = 'gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/market_mezo/event_type=order_placed',
    -- The URIs pointing to the Parquet files in Google Cloud Storage.
    uris = ["gs://mezo-prod-dp-dwh-lnd-goldsky-cs-0/market_mezo/event_type=order_placed/*"]
  );
