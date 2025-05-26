from flask import Flask
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

REQUEST_COUNT = Counter('app_requests_total', 'Total number of requests')

@app.route('/')
def hello():
  REQUEST_COUNT.inc()
  return "Hello from Flask-app!"

@app.route('/metrics')
def metrics():
  return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=5000)

# TEST
