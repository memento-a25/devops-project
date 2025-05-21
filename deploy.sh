#!/bin/bash
set -x # debugg mod
set -o pipefail
set -e # Stop on error

# 1. Installing dependencies

echo "Installing core dependencies"
sudo apt-get update
sudo apt-get install -y ansible

# 2. Cloning repo

if [ ! -f docker-compose.yml ]; then
  echo "Cloning repository"
  git clone https://github.com/memento-a25/jun-devops-project.git
  cd jun-devops-project
fi

# 3. Configuring environment via Ansible

echo "Configuring environment via Ansible"
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook.yml

# 4. Building and Starting containers
echo "Building and Starting containers"
sudo docker compose up -d --build

# 5. Checking if everything working properly
echo "Sleep 30s"
sleep 30

echo "Checking components"
# Checking Flask
curl -s http://localhost:8080 | grep "Hello from Flask-app!" && echo "Flask: OK" || echo "Flask:ERROR"

# Checking Prometheus
curl -s http://localhost:9091/metrics | grep 'app_requests_total' && echo "Prometheus: OK" || echo "Prometheus: ERROR"

# Checking PostgreSQL
sudo docker exec -it jun-devops-project-db-1 psql -U test -d test -c "SELECT 1" | grep "1 row" && echo "PostgreSQL: OK" || echo "PostgreSQL: ERROR"

# Checking Grafan
curl -s -u admin:admin http://localhost:3001/api/health | grep "database" && echo "Grafana: OK" || echo "Grafana: ERROR"

echo "All components ready!"
echo "Available Interfaces:"
echo "- App: http://localhost:8080"
echo "- Prometheus: http://localhost:9091"
echo "- Grafana: http://localhost:3031 (admin/admin)"
