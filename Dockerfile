FROM python:3.10-slim

# Installer les dépendances système (ffmpeg, git, curl) et uv
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installer uv (gestionnaire de paquets utilisé par Bluez-Dubbing)
RUN pip install --no-cache-dir uv

WORKDIR /app

# Cloner le dépôt de Bluez-Dubbing
RUN git clone https://github.com/Globluez/bluez-dubbing.git .

# Installer TOUTES les dépendances avec uv (méthode officielle du projet)
RUN uv sync --all-extras

EXPOSE 7860

# Lancer l'API FastAPI de l'orchestrateur
CMD ["uv", "run", "uvicorn", "apps.backend.orchestrator.main:app", "--host", "0.0.0.0", "--port", "7860"]
