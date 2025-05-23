#!/usr/bin/env bash
set -eo pipefail

REPO_URL="https://github.com/memento-a25/jun-devops-project.git"
INSTALL_DIR="${HOME}/georges-project"

# 1. Check distribution
check_distro() {
  if ! grep -qEi 'ubuntu|debian' /etc/os-release; then
    echo "ERROR: Only Ubuntu/Debian supported" >&2
    exit 1
  fi
}

# 2. Installing required packages
install_deps() {
  echo "Updating packages..."
  sudo apt-get update -qq

  echo "Installing dependencies"
  sudo apt-get install -y --no-install-recommends git curl
}

# 3. Clonning repository
clone_repo() {
  if [[ -d "${INSTALL_DIR}" ]]; then
    echo "Updating existing repository..."
    git -C "${INSTALL_DIR}" pull --ff-only
  else
    echo "Cloning repository..."
    git clone "${REPO_URL}" "${INSTALL_DIR}"
  fi
}

# 4. Setup docker-stack

setup_docker() {
  echo "Installing docker-stack"
  ansible-playbook -i "${INSTALL_DIR}/ansible/inventory/hosts.ini" \
    "${INSTALL_DIR}/ansible/playbook.yml"
}


# 5. Running deployment
deploy_app() {
  echo "Deploying app..."
  cd "${INSTALL_DIR}"
  ansible-playbook -i ansible/inventory/hosts.ini ansible/deploy.yml \
    -e "project_dir=${INSTALL_DIR}" \
    -e "dockerhub_username=${DOCKERHUB_USERNAME:-devopstestproject}" \
    -e "db_user=${DB_USER:-test}" \
    -e "db_password=${DB_PASSWORD:-test}" \
    -e "db_name=${DB_NAME:-test}"
}

# 6. Check the result
verify() {
  echo "Checking services..."
  curl -sSf http://localhost:8080
  echo -e "\nDeployment successful! Access:"
  echo "App:      http://localhost:8080"
  echo "Grafana:  http://localhost:3001"
}

main() {
  check_distro
  install_deps
  clone_repo
  setup_docker
  deploy_app
  verify
}

main
