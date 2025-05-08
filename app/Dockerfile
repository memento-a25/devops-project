FROM python:3.13-slim
WORKDIR /app
COPY main.py /app
RUN pip install flask prometheus_client
CMD ["python","main.py"]

