# Use Python 3.11 as the base image
FROM ghcr.io/astral-sh/uv:python3.11-bookworm


# Install system dependencies and Google Cloud SDK
RUN apt-get update \
    && apt-get install -y curl gnupg apt-transport-https ca-certificates lsb-release \
    # Add Google Cloud SDK distribution URI as a package source
    && export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    # Install Google Cloud SDK using apt-get so it's available system-wide
    && apt-get update \
    && apt-get install -y google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin \
    && apt-get clean

# Create a new user (Debian-compatible)
RUN useradd -m dbtuser

# Set the working directory in the Docker container
WORKDIR /app


# Copy the project files into the Docker container
COPY . /app


# Ensure dbtuser owns all files in /app and make script.sh executable
RUN chown -R dbtuser:dbtuser /app \
    && chmod +x /app/script.sh

# Switch to dbtuser
USER dbtuser

# Install the project dependencies as dbtuser
RUN uv sync --no-dev
RUN uv run dbt deps

# Set the command to run when the Docker container starts
# Accept an optional SELECT argument at runtime (default empty)
ENV SELECT_ARG=""
CMD ["sh", "-c", "./script.sh"]
