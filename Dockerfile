FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git python3-dev libffi-dev build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install from PyPI instead of bundling repo
RUN pip install calibreweb

EXPOSE 8083
CMD ["calibre-web", "--host", "0.0.0.0", "--port", "8083"]
