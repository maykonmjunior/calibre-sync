#!/bin/bash
# setup_calibre_render.sh
# Prepares a repo for Render

set -e

# Create Render Dockerfile
cat > Dockerfile <<'EOF'
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

EOF

# Render configuration
cat > render.yaml <<'EOF'
services:
  - type: web
    name: calibre-web
    env: docker
    plan: free
    autoDeploy: true    
    envVars:
      - key: GOOGLE_DRIVE_ENABLED
        value: "true"
      - key: GOOGLE_DRIVE_CLIENT_ID
        sync: false
      - key: GOOGLE_DRIVE_CLIENT_SECRET
        sync: false
    disk:
      name: calibre-data
      mountPath: /data
      sizeGB: 1
EOF

echo "✅ Repo prepared. Push to GitHub, then go to https://dashboard.render.com → New Web Service → connect repo."
