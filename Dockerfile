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
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port if running a web service
EXPOSE 8084

# Default command to run the application
CMD ["python3", "-m", "scrapegraphai"]
