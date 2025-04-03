FROM python:3.11-slim

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Install system dependencies for Playwright and other potential requirements
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    gnupg \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install ScrapegraphAI and related dependencies
RUN pip install --no-cache-dir scrapegraphai
RUN pip install --no-cache-dir scrapegraphai[burr]

# Install Playwright dependencies and browsers
RUN python3 -m playwright install-deps
RUN python3 -m playwright install

# Set working directory
WORKDIR /app

# Copy any additional project files if needed
COPY . .

# Expose port if running a web service
EXPOSE 8084

# Default command (modify as needed)
CMD ["python3", "-m", "scrapegraphai"]
