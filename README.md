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
# Локальный запуск
docker compose up -d --build

# Доступные endpoints:
curl http://localhost:8080               # Основное приложение
curl http://localhost:8080/metrics       # Prometheus metrics
