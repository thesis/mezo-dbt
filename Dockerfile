# Use Python 3.11 as the base image
FROM ghcr.io/astral-sh/uv:python3.11-bookworm


# Install system dependencies and Google Cloud SDK as root
RUN apt-get update \
    && apt-get install -y curl \
    && curl https://sdk.cloud.google.com | bash \
    && export PATH="$PATH:/root/google-cloud-sdk/bin" \
    && gcloud components install gsutil -q

# Create a new user (Debian-compatible)
RUN useradd -m dbtuser

# Set the working directory in the Docker container
WORKDIR /app


# Copy the project files into the Docker container
COPY . /app

# Ensure dbtuser owns all files in /app
RUN chown -R dbtuser:dbtuser /app

# Switch to dbtuser
USER dbtuser

# Install the project dependencies as dbtuser
RUN uv sync --no-dev

# Set the command to run when the Docker container starts
# Accept an optional SELECT argument at runtime (default empty)
ENV SELECT_ARG=""
CMD ["sh", "-c", "uv run dbt run --profiles-dir /app --project-dir /app --target prod ${SELECT_ARG:+--select $SELECT_ARG} && /root/google-cloud-sdk/bin/gsutil cp /app/target/manifest.json gs://mezo-prod-dp-dwh-dbt-cs-0/manifest/mainfest.json"]
