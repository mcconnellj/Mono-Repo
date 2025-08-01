# Helm Charts Quick Summary

This section provides a quick overview of the deployment and access steps for all Helm charts in this repository.

---

**ActualBudget**

- Deploy: `helm install my-actualbudget ...`
- Access: Use `kubectl port-forward $POD_NAME 8080:$CONTAINER_PORT` (see below for details)
- URL: http://127.0.0.1:8080

**Vaultwarden**

- Deploy: `helm install my-vaultwarden ...`
- Access: Use `kubectl port-forward $POD_NAME 8080:8080`
- URL: http://127.0.0.1:8080

**n8n**

- Deploy: `helm install my-n8n ...`
- Access: Use `kubectl port-forward $POD_NAME 8080:$CONTAINER_PORT` (see below for details)
- URL: http://127.0.0.1:8080

**FoundryVTT**

- Deploy: `helm install my-foundryvtt ...`
- Access: Use `kubectl port-forward $POD_NAME 8080:30000`
- URL: http://127.0.0.1:8080

**Keycloak**

- Deploy: `helm install my-keycloak ...`
- Access: Use `kubectl port-forward svc/my-keycloak $PORT:$PORT` (see below for details)
- URL: http://127.0.0.1:$PORT/

**General Steps:**

1. Deploy the chart using `helm install ...` (see individual sections for full commands and values).
2. Get the pod name and port as shown in each chart's section below.
3. Use `kubectl port-forward` to access the service locally.
4. Open the provided URL in your browser.

---

## Helm Charts Documentation

This document provides details and usage instructions for the Helm charts deployed in this repository. Below are the charts, their deployment notes, and how to access the deployed applications.

---

### 1. ActualBudget

**Repository:** community-charts  
**Release Name:** my-actualbudget  
**Namespace:** default  
**Status:** deployed

**Access Instructions:**

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=actualbudget,app.kubernetes.io/instance=my-actualbudget" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
# Then visit: http://127.0.0.1:8080
```

---

### 2. Vaultwarden

**Repository:** gissilabs  
**Release Name:** my-vaultwarden  
**Namespace:** default  
**Status:** deployed

**Access Instructions:**

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=vaultwarden,app.kubernetes.io/instance=my-vaultwarden" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 8080:8080
# Then visit: http://127.0.0.1:8080
```

---

### 3. n8n

**Image:** 8gears.container-registry.com/library/n8n:1.0.10  
**Release Name:** my-n8n  
**Namespace:** default  
**Status:** deployed

**Access Instructions:**

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=n8n,app.kubernetes.io/instance=my-n8n" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
# Then visit: http://127.0.0.1:8080
```

---

### 4. FoundryVTT

**Repository:** geek-cookbook  
**Release Name:** my-foundryvtt  
**Namespace:** default  
**Status:** deployed

**Access Instructions:**

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=foundryvtt,app.kubernetes.io/instance=my-foundryvtt" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:30000
# Then visit: http://127.0.0.1:8080
```

---

### 5. Keycloak

**Repository:** bitnami  
**Release Name:** my-keycloak  
**Namespace:** default  
**Status:** deployed

**Chart Version:** 24.8.1  
**App Version:** 26.3.2

**Access Instructions:**
Keycloak is available inside the cluster at:

```
my-keycloak.default.svc.cluster.local (port 80)
```

To access from outside the cluster:

```bash
export HTTP_SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[?(@.name=='http')].port}" services my-keycloak)
kubectl port-forward --namespace default svc/my-keycloak ${HTTP_SERVICE_PORT}:${HTTP_SERVICE_PORT} &
echo "http://127.0.0.1:${HTTP_SERVICE_PORT}/"
```

**Important Notes:**

- Starting August 28th, 2025, only a limited subset of Bitnami images/charts will remain available for free. See [Bitnami containers notice](https://github.com/bitnami/containers/issues/83267).
- For production, set resource requests/limits explicitly instead of using `resourcesPreset`. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

---

## General Notes

- All charts are deployed in the `default` namespace unless otherwise specified.
- Use `kubectl get pods` and `kubectl get services` to check the status of deployments.
- For port-forwarding, ensure you have `kubectl` access to the cluster and the correct context is set.

---

For more details, refer to the individual chart documentation or values files in the repository.
