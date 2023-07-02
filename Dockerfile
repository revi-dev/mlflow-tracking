FROM python:3.10.12-slim-buster

RUN apt update && apt upgrade -y

RUN pip install mlflow

RUN mkdir /usr/mlflow /usr/mlflow/artifacts

CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --backend-store-uri sqlite:///usr/mlflow/tracking.db \
    --artifacts-destination file:///usr/mlflow/artifacts \
    --serve-artifacts
