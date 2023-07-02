## 概要
MLFlow TrackingのdocumentationのScenario 5をベースに  
エンティティの記録をSQLite, アーティファクトの保存をローカルストレージとしたコンテナイメージ

https://mlflow.org/docs/latest/tracking.html#scenario-5-mlflow-tracking-server-enabled-with-proxied-artifact-storage-access

## 使用方法

1. 本リポジトリのcompose.ymlを用いてDocker Imageをビルド
    ```
    docker compose build
    ```

2. 実験用のcompose.ymlに以下を追加
    ```
    services:    
        <myservice>:
            networks:
                - mynetwork

        mlflow:
            image: mlflow-server:latest
            container_name: mlflow-server
            ports:
                - 5000:5000
            volumes:
                - <path/to/directory>:/usr/mlflow
            networks:
                - mynetwork

    
    networks:
        mlflow-net:
            driver: bridge
            name: mynetwork
    ```

3. 実験コード内で以下を実行
    ```
    import mlflow

    TRACKING_SERVER_URI = 'http://mlflow:5000' # mlflowはcompose.ymlのサービス名
    mlflow.set_tracking_uri(TRACKING_SERVER_URI)
    ```