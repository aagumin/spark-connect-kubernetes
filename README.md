# Helm Chart Spark Connect

[![Release Helm Chart and Docker Image](https://github.com/aagumin/spark-connect-kubernetes/actions/workflows/release.yaml/badge.svg)](https://github.com/aagumin/spark-connect-kubernetes/actions/workflows/release.yaml)

This Helm chart is designed for deploying the Spark Connect application.

## Description

Spark Connect is an application that allows you to perform data processing tasks using Apache Spark.

### Feature

- [X] Dynamic package list
- [ ] Optional mTLS.
- [ ] Istio support
- [ ] Celeborn in box

## Requirements

- Kubernetes 1.16.0 or later
- Helm 3.0.0 or later

## Installation

1. Make sure you have Helm 3.0.0 or later installed.
2. Add the Helm repository for your project:

```sh
helm repo add spark-connect-kubernetes https://aagumin.github.io/spark-connect-kubernetes
```

3. Update the Helm repository list:

```sh
helm repo update
```

4. Install the Spark Connect Helm chart:
```sh
helm install [RELEASE_NAME] spark-connect-kubernetes/spark-connect
```
