vscode ➜ /workspaces/k3s (development) $ helm install my-actualbudget community-charts/actualbudget --version 1.7.2
NAME: my-actualbudget
LAST DEPLOYED: Fri Jul 18 19:44:38 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=actualbudget,app.kubernetes.io/instance=my-actualbudget" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT