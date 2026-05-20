FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install uv for fast dependency management
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv into the system python
RUN uv pip install --system -r pyproject.toml

# Copy application files
COPY . .

# Expose Cloud Run default port
EXPOSE 8080

# Run the server using Cloud Run's dynamic PORT environment variable (defaulting to 8080)
CMD ["sh", "-c", "uvicorn server:app --host 0.0.0.0 --port ${PORT:-8080}"]
