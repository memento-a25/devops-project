#!/usr/bin/env bash
set -eo pipefail

REPO_URL="https://github.com/memento-a25/devops-project.git"
INSTALL_DIR="${HOME}/devops-project"

# 1. Check distribution
check_distro() {
  if ! grep -qEi 'ubuntu|debian' /etc/os-release; then
    echo "ERROR: Only Ubuntu/Debian supported" >&2
    exit 1
  fi
}

# 2. Checking if Ansible installed
check_and_install_ansible() {
  if command -v ansible >/dev/null 2>&1; then
    # Receiving Ansible version
    current_version=$(ansible --version | head -n1 | grep -oP 'core \K[0-9.]+')

    # Minimal allowed version
    required_version="2.15"

    # Version comparison function
    version_is_less_than() {
      # Returning 0 (true), if $1 < $2
      [ "$(printf '%s\n%s' "$1" "$2" | sort -V | head -n1)" = "$1" ] && [ "$1" != "$2" ]
    }

    if version_is_less_than "$current_version" "$required_version"; then
      echo "Found old version of ansible-core: $current_version < $required_version, switching to the newest version..."
      sudo apt-get remove -y ansible ansible-core
      install_ansible_from_ppa
    else
      echo "Version of ansible-core is higher than $required_version"
    fi
  else
    echo "Ansible is not installed, installing new version..."
    install_ansible_from_ppa
  fi
}

install_ansible_from_ppa() {
  # Installing ansible according to official documentation
  UBUNTU_CODENAME=$(grep -oP '(?<=VERSION_CODENAME=).*' /etc/os-release | tr -d '"')

  echo "Adding PPA and installing Ansible"

  sudo apt-get update -qq
  sudo apt-get install -y wget gpg

  wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
  sudo apt-get update
  sudo apt-get install -y ansible
}

# 3. Check that required Ansible Collections installed (docker compose v2 module)
check_ansible_collections() {
  if ! ansible-galaxy collection list | grep -q 'community.docker'; then
    echo "Installing community.docker collection..."
    ansible-galaxy collection install community.docker -f
  fi
}

# 4. Installing required packages
install_deps() {
  echo "Updating packages..."
  sudo apt-get update -qq

  echo "Installing dependencies"
  sudo apt-get install -y --no-install-recommends git curl
}

# 5. Cloning repository
clone_repo() {
  if [[ -d "${INSTALL_DIR}" ]]; then
    echo "Updating existing repository..."
    git -C "${INSTALL_DIR}" pull --ff-only
  else
    echo "Cloning repository..."
    git clone "${REPO_URL}" "${INSTALL_DIR}"
  fi
}

# 6. Setup docker-stack

setup_docker() {
  echo "Installing docker-stack"
  ansible-playbook -i "${INSTALL_DIR}/ansible/inventory/hosts.ini" \
    "${INSTALL_DIR}/ansible/playbook.yml"
}


# 7. Running deployment
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

# 8. Check the result
verify() {
  echo "Checking services..."
  curl -sSf http://localhost:8080
  echo -e "\nDeployment successful! Access:"
  echo "App:      http://localhost:8080"
  echo "Grafana:  http://localhost:3001"
}

main() {
  check_distro
  check_and_install_ansible
  check_ansible_collections
  install_deps
  clone_repo
  setup_docker
  deploy_app
  verify
}

main
