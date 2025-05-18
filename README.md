# 🚀 Flask Monitoring App | DevOps Showcase

# DevOps-проект с полным циклом CI/CD, мониторингом и автоматизированным деплоем

## 🎯 Цель проекта
Демонстрация ключевых DevOps-навыков:
1. Автоматизация жизненного цикла приложения
2. Настройка CI/CD для микросервисной архитектуры
3. Реализация базового мониторинга
4. Документирование инфраструктуры

Проект показывает понимание полного цикла от разработки до эксплуатации."


![Architecture Diagram](docs/architecture.png)

## 🌟 Основные особенности:

- **Full CI/CD Pipeline**  
  GitHub Actions → Unit/Integration Tests → Docker Build → Ansible Deployment → Telegram уведомления

- **Production-Grade Monitoring**  
  Prometheus metrics scraping + Preconfigured Grafana dashboards
  
- **Infrastructure as Code**  
  Docker Compose + Ansible playbooks для воспроизводимых деплоев
  
- **Cloud-Native Design**  
  Микросервисная архитектура с изолированными компонентами
  
- **Security**  
  Секреты через GitHub Secrets, изолированные Docker сети

## 🛠 Технический стек

| Категория       | Технологии                                                                 |
|-----------------|----------------------------------------------------------------------------|
| **Основа**      | Python 3.13, Flask, Gunicorn, PostgreSQL                                  |
| **DevOps**      | Docker, Docker Compose, GitHub Actions, Ansible                           |
| **Мониторинг**  | Prometheus, Grafana, Custom Metrics                                       |
| **Тестирование**| Pytest, Integration Tests, Smoke Tests                                    |
| **Сети**        | Изолированные Docker-сети для компонентов системы, Порт-маппинг с контролем доступа к сервисам, Настройка межсервисного взаимодействия через DNS-алиасы                    |


## 🚦 Quick Start
```bash
# 1. Клонировать репозиторий
git clone https://github.com/memento-a25/jun-devops-project.git
cd jun-devops-project

# 2. Установить Ansible (для деплоя)
sudo apt update && sudo apt install -y ansible

# 3. Настроить окружение через Ansible (Docker, зависимости)
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook.yml

# 4. Запустить все сервисы
sudo docker compose up -d --build

# 5. Проверить работу системы (ждем 30 сек для инициализации)
sleep 30




Доступные endpoints для проверки:

# Основное приложение
curl http://localhost:8080

# Метрики Prometheus
curl http://localhost:8080/metrics

# Интерфейс Prometheus (порт 9091)
curl http://localhost:9091/targets

# Grafana Dashboard (порт 3001)
curl -u admin:admin http://localhost:3001/api/health

# Проверка PostgreSQL
sudo docker exec -it jun-devops-project-db-1 psql -U ${DB_USER} -d ${DB_NAME} -c "SELECT 1"

