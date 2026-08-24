#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/bernik1986/reserchagentworld.git"
INSTALL_DIR="/opt/reserchagentworld"
AGENT_USER="agentworld"
DOMAIN_VALUE="${DOMAIN:-localhost}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root (or with sudo)."
  exit 1
fi

if ! grep -q 'Ubuntu 24.04' /etc/os-release 2>/dev/null; then
  echo "Warning: bootstrap is designed for Ubuntu 24.04; continuing anyway."
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl git openssl ufw

if ! command -v docker >/dev/null 2>&1; then
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

systemctl enable --now docker

if ! id "${AGENT_USER}" >/dev/null 2>&1; then
  useradd --create-home --shell /bin/bash "${AGENT_USER}"
fi
usermod -aG docker "${AGENT_USER}"

mkdir -p "${INSTALL_DIR}"
if [[ -d "${INSTALL_DIR}/.git" ]]; then
  git -C "${INSTALL_DIR}" fetch --all --prune
  git -C "${INSTALL_DIR}" checkout main
  git -C "${INSTALL_DIR}" pull --ff-only origin main
else
  rm -rf "${INSTALL_DIR:?}"/*
  git clone "${REPO_URL}" "${INSTALL_DIR}"
fi

cd "${INSTALL_DIR}"

if [[ ! -f .env ]]; then
  cp .env.example .env
  DB_PASSWORD="$(openssl rand -hex 32)"
  sed -i "s|POSTGRES_PASSWORD=replace-with-a-long-random-secret|POSTGRES_PASSWORD=${DB_PASSWORD}|" .env
  sed -i "s|postgresql://agentworld:replace-with-a-long-random-secret@|postgresql://agentworld:${DB_PASSWORD}@|" .env
fi

if grep -q '^DOMAIN=' .env; then
  sed -i "s|^DOMAIN=.*|DOMAIN=${DOMAIN_VALUE}|" .env
else
  printf '\nDOMAIN=%s\n' "${DOMAIN_VALUE}" >> .env
fi

if grep -q '^PUBLIC_BASE_URL=' .env; then
  if [[ "${DOMAIN_VALUE}" == "localhost" ]]; then
    sed -i 's|^PUBLIC_BASE_URL=.*|PUBLIC_BASE_URL=http://localhost|' .env
  else
    sed -i "s|^PUBLIC_BASE_URL=.*|PUBLIC_BASE_URL=https://${DOMAIN_VALUE}|" .env
  fi
fi

chown -R "${AGENT_USER}:${AGENT_USER}" "${INSTALL_DIR}"
chmod 600 .env

ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

sudo -u "${AGENT_USER}" docker compose pull || true
sudo -u "${AGENT_USER}" docker compose build --pull
sudo -u "${AGENT_USER}" docker compose up -d

sleep 3
sudo -u "${AGENT_USER}" docker compose ps

echo
echo "===================================="
echo " RESEARCH AGENT WORLD BOOTSTRAPPED"
echo "===================================="
echo "Install dir: ${INSTALL_DIR}"
echo "Domain:      ${DOMAIN_VALUE}"
echo "Secrets:     ${INSTALL_DIR}/.env"
echo "Next: add MODEL_PROVIDER / MODEL_API_KEY to .env when ready."
echo "===================================="
