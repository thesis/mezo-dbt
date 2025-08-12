# DBT DataWarhouse Transformations for Mezo



## How to Set Up a Goldsky Table

To set up a new table using Goldsky data in BigQuery:

1. **Contact Goldsky Support:** Email [Goldsky](support@goldsky.com) to request the setup of a new table to be imported into the `mezo-prod-dp-dwh-lnd-goldsky-cs-0` Google Cloud Storage (GCS) bucket. As of this writing, the [Goldsky documentation](https://docs.goldsky.com/mirror/extensions/channels/aws-s3) is limited, and self-service setup is not available—you must contact support to establish the connection.

2. **Organize Data in GCS:**
   - For each import, create a separate folder in the GCS bucket.
   - The folder structure should follow this pattern: `event_type=<event_type>/event_date=<YYYY-MM-DD>/` (e.g., `event_type=donated/event_date=2025-05-22/`).
   - This structure enables Hive partitioning of the table. For more details, see the [BigLake partitioned data documentation](https://cloud.google.com/bigquery/docs/create-cloud-storage-table-biglake#create-biglake-partitioned-data).

3. **Update dbt Source Configuration:**
   - Edit the [models/00_sources/goldsky.yml](models/00_sources/goldsky.yml) file to add the new table definition.
   - Use the existing configurations in the file as a template for your new entry as a reference.
   - Ensure all relevant metadata, columns, and partitioning information are included.

4. **Register the Table in BigQuery:**
   - The table will be created in BigQuery using the [dbt-external-tables](https://github.com/dbt-labs/dbt-external-tables) package.
   - After updating the YAML file, run the following dbt command to create the external tables:

     ```sh
     dbt run-operation stage_external_sources
     ```

   - This command will register the external tables in BigQuery based on your configuration. This is automatically run during deployment and CI Process.
