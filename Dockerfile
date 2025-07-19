# Use Python 3.11 as the base image
FROM ghcr.io/astral-sh/uv:python3.11-alpine


# Create a new user and switch to that user (Alpine-compatible)
RUN adduser -D dbtuser
USER dbtuser

# Set the working directory in the Docker container
WORKDIR /app

# Copy the project files into the Docker container
COPY --chown=dbtuser:dbtuser . /app

# Install the project dependencies
RUN uv sync --no-dev

WORKDIR /app/

# Set the command to run when the Docker container starts
CMD ["uv", "run", "dbt", "run", "--profiles-dir", "/app", "--project-dir", "/app", "--target", "prod"]