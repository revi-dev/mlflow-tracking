## 概要
MLFlow TrackingのdocumentationのScenario 5をベースに  
エンティティの記録をSQLite, アーティファクトの保存をローカルストレージとしたコンテナイメージ

https://mlflow.org/docs/latest/tracking.html#scenario-5-mlflow-tracking-server-enabled-with-proxied-artifact-storage-access

## 使用方法

1. コンテナ間で通信するためのbridgeネットワークを作成
    ```bash
    docker network create -d bridge {任意のネットワーク名}
    ```

以下では, ネットワーク名を"mlflow-net"とした例を記載

2. 1.で作成したネットワーク名に合わせて, リポジトリのcompose.ymlを修正
    ```yml
    services:
      mlflow:
        networks:
          - mlflow-net

    networks:
      mlflow-net:
        name: mlflow-net
        driver: bridge
        external: true
    ```
   
3. MLFlow Tracking用のコンテナを起動
    ```bash
    docker compose up -d
    ```

4. 実験用のcompose.ymlに以下を追加
    ```yml
    services:    
      {任意のサービス名}:
        networks:
          - mlflow-net # 下のnetworksで定義したネットワークのキー
    
    networks:
      mlflow-net: # servicesでネットワークを指定するためのキー
        name: mlflow-net # 1.で作成したネットワーク名
        driver: bridge
        external: true
    ```

5. 実験コード内で以下を実行
    ```python
    import mlflow

    TRACKING_SERVER_URI = 'http://{3.で起動したコンテナ名}:5000'
    mlflow.set_tracking_uri(TRACKING_SERVER_URI)
    ```