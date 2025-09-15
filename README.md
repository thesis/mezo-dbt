# DBT DataWarhouse Transformations for Mezo


## Setup the dbt project locally:

1. **Prerequesites**
- Install [gcloud](https://cloud.google.com/sdk/docs/install)
- VSCode or any other code editor
Optional:
- [dbt power user for vscode](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user)

2. **Clone the Repository**
```sh
   git clone https://github.com/thesis/mezo-dbt
   cd mezo-dbt
```

3. **Install Dependencies**
- Install [uv](https://docs.astral.sh/uv/getting-started/installation/#installing-uv)  
- Install Python dependencies (with uv):
```sh 
   uv sync   
```

4. **Configure dbt [profile.yml](https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml) locally**
- Create a .dbt folder in your home directory if it doesn’t exist:
```sh
   mkdir -p ~/.dbt
   touch profiles.yml
   vim profiles.yml
```
- Create a profiles.yml file inside it with your BigQuery configuration:
```yml
   mezo:
      outputs:
         dev:
            type: bigquery
            method: oauth
            project: <your-gcp-project-id>
            dataset: dbt_yourname
            location: EU
            threads: 4
   target: dev
```
- Authenticate with gcloud (creates local credentials JSON automatically):
```sh
   gcloud auth application_default_login
```

5. **Setup git branch**
```sh
   git checkout -b <your-branch> (e.g. feature/channel_grouping)
```

6. **Install DBT Dependencies**
```sh   
   dbt deps
```

7. **Test your setup**
```sh   
   dbt debug
```
For other dbt commands check: [https://docs.getdbt.com/reference/dbt-commands](https://docs.getdbt.com/reference/dbt-commands)

8. **Run checks manually:**
```sh
   pre-commit run --all-files --config .pre-commit-config_local.yaml
```

9. **Commit & push changes**
```sh
   git add.
   git commit -m "fix: bla bla issue"
   git push origin <your-branch>
```

10. **Run a full refresh:**
```sh
    dbt build --full-refresh
```

**Or build a specific model:**
```sh
    dbt build --select +<your_table> (e.g. +int_segment__sessions_first_touch_point)
```


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
