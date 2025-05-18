import pytest
import requests

def test_grafana_prometheus_connection():
    response = requests.get(
        "http://localhost:3001/api/datasources",
        auth=("admin", "admin")  # Дефолтные креды Grafana
    )
    
    assert response.status_code == 200
    datasources = response.json()
    prometheus_ds = [ds for ds in datasources if ds["type"] == "prometheus"]
    
    assert len(prometheus_ds) > 0, "Prometheus datasource not found"
    assert prometheus_ds[0]["url"] == "http://prometheus:9091", "Wrong Prometheus URL"
