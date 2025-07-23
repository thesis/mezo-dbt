# Use Python 3.11 as the base image
FROM ghcr.io/astral-sh/uv:python3.11-bookworm


# Create a new user and switch to that user (Debian-compatible)
RUN useradd -m dbtuser
USER dbtuser

# Set the working directory in the Docker container
WORKDIR /app

# Copy the project files into the Docker container
COPY --chown=dbtuser:dbtuser . /app

# Install the project dependencies
RUN uv sync --no-dev

WORKDIR /app/

# Set the command to run when the Docker container starts
# Accept an optional SELECT argument at runtime (default empty)
ENV SELECT_ARG=""
CMD ["sh", "-c", "uv run dbt run --profiles-dir /app --project-dir /app --target prod ${SELECT_ARG:+--select $SELECT_ARG}"]
