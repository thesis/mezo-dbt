FROM ghcr.io/dbt-labs/dbt-bigquery:1.9.latest


WORKDIR /app

COPY . /app

WORKDIR /app/

CMD ["dbtf", "run", "--profiles-dir", "/app", "--project-dir", "/app", "--target", "prod"]