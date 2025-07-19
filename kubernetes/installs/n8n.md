vscode ➜ /workspaces/k3s (development) $ helm install my-n8n oci://8gears.container-registry.com/library/n8n --version 1.0.10
Pulled: 8gears.container-registry.com/library/n8n:1.0.10
Digest: sha256:488b5efb8a31e1d03d7402abd3a7a096ac93b7f278837521a8b5df6caa6323d8
NAME: my-n8n
LAST DEPLOYED: Fri Jul 18 19:42:54 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=n8n,app.kubernetes.io/instance=my-n8n" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT