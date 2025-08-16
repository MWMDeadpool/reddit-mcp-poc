# 1. Builder stage: Install dependencies
FROM python:3.11-slim AS builder

# Copy the uv binary from the official distroless image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create a virtual environment and add it to the PATH
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy only the dependency files to leverage Docker layer caching
WORKDIR /app
COPY pyproject.toml ./

# Install dependencies into the virtual environment
RUN uv pip sync --no-cache --frozen pyproject.toml

# 2. Final stage: Copy application and installed dependencies
FROM python:3.11-slim AS final

WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy your application code
COPY . .

# Activate the virtual environment and run the application
ENV PATH="/opt/venv/bin:$PATH"

# Expose the port the app runs on
EXPOSE 8000

# Run the server
CMD ["python", "src/server.py"]