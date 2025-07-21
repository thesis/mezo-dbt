# Workload Identity Federation Steps

```bash
gcloud iam workload-identity-pools create mezo-prod-dwh-pool-0 \
    --location="global" \
    --description="Workflow Idenetity Federation Pool for enableing CI/CD on Github Actions" \
    --display-name="mezo-prod-dwh-pool-0"

gcloud iam workload-identity-pools providers create-oidc mezo-prod-dwh-wif-provider-0 \
    --location="global" \
    --workload-identity-pool="mezo-prod-dwh-pool-0" \
    --issuer-uri="https://token.actions.githubusercontent.com/" \
    --attribute-mapping="google.subject=assertion.sub,google.repository_id=assertion.repository_id" \
    --attribute-condition="assertion.repository_id=='1021997167'"

gcloud iam workload-identity-pools providers update-oidc mezo-prod-dwh-wif-provider-0 \
    --location="global" \
    --workload-identity-pool="mezo-prod-dwh-pool-0" \
    --attribute-condition="assertion.repository_id=='1021997167'"

gcloud iam service-accounts add-iam-policy-binding mezo-prod-dp-dwh-dbt-sa-0@mezo-portal-data.iam.gserviceaccount.com \
    --role=roles/iam.workloadIdentityUser \
    --member="principal://iam.googleapis.com/projects/58470652468/locations/global/workloadIdentityPools/mezo-prod-dwh-pool-0/subject/repo:<YOUR_ORG>/<YOUR_REPO>:*"
```

```yml
- id: 'auth'
  name: 'Authenticate to Google Cloud'
  uses: 'google-github-actions/auth@v1'
  with:
    create_credentials_file: true
    workload_identity_provider: 'projects/58470652468/locations/global/workloadIdentityPools/mezo-prod-dwh-pool-0/providers/mezo-prod-dwh-wif-provider-0'
    service_account: 'mezo-prod-dp-dwh-dbt-sa-0@mezo-portal-data.iam.gserviceaccount.com'
```

```yml
jobs:
  build:
    # Allow the job to fetch a GitHub ID token
    permissions:
      id-token: write
      contents: read

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - id: 'auth'
        name: 'Authenticate to Google Cloud'
        uses: 'google-github-actions/auth@v1'
        with:
          create_credentials_file: true
          workload_identity_provider: 'projects/58470652468/locations/global/workloadIdentityPools/mezo-prod-dwh-pool-0/providers/mezo-prod-dwh-wif-provider-0'
          service_account: 'mezo-prod-dp-dwh-dbt-sa-0@mezo-portal-data.iam.gserviceaccount.com'
```