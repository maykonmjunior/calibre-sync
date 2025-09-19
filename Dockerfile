FROM python:3.11-slim

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PATH="/opt/venv/bin:$PATH"

RUN apt-get update && apt-get install -y \
    git python3-dev libffi-dev build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create venv
RUN python -m venv /opt/venv

WORKDIR /app

# Install from PyPI instead of bundling repo
RUN pip install calibreweb gunicorn

EXPOSE 8083
CMD ["calibre-web", "--host", "0.0.0.0", "--port", "8083"]
