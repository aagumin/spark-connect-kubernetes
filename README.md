# Helm Chart Spark Connect

This Helm chart is designed for deploying the Spark Connect application.

## Description

Spark Connect is an application that allows you to perform data processing tasks using Apache Spark.

## Requirements

- Kubernetes 1.16.0 or later
- Helm 3.0.0 or later

## Installation

1. Make sure you have Helm 3.0.0 or later installed.
2. Add the Helm repository for your project:

```sh
helm repo add spark-connect https://your-helm-repo-url
```

3. Update the Helm repository list:

```sh
helm repo update
```

4. Install the Spark Connect Helm chart:
```sh
helm install spark-connect spark-connect/spark-connect
```