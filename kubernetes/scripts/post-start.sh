#!/bin/bash
set -x pipefail
minikube status

echo "🧹 Step 1: Deleting existing Minikube cluster..."
minikube delete
echo "✅ Minikube deleted."

echo "🚀 Step 2: Starting a fresh Minikube cluster..."
minikube start
echo "✅ Minikube started."

echo "⏳ Step 3: Waiting for Kubernetes API to become available..."
sleep 30

echo "🔄 Step 4: Deleting all non-system namespaces..."
kubectl get ns --no-headers | awk '{print $1}' | grep -vE 'kube-system|default|kube-public' | xargs -r kubectl delete ns
echo "✅ Finished deleting non-system namespaces."

echo "📦 Step 5: Adding Argo Helm repo..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
echo "✅ Argo Helm repo added and updated."

echo "🛠 Step 6: Installing Argo CD (version 8.1.3)..."
helm install my-argo-cd argo/argo-cd --version 8.1.3
echo "✅ Argo CD installed."

echo "🌐 Step 7: Fetching latest Kro release version..."
export KRO_VERSION=$(curl -sL https://api.github.com/repos/kro-run/kro/releases/latest | jq -r '.tag_name | ltrimstr("v")')
echo "✅ Kro version set to: $KRO_VERSION"

echo "📥 Step 8: Installing Kro Helm chart (version $KRO_VERSION)..."
helm install kro oci://ghcr.io/kro-run/kro/kro \
  --namespace kro \
  --create-namespace \
  --version="${KRO_VERSION}"
echo "✅ Kro installed."

echo "📄 Step 9: Applying bootstrap manifest..."
kubectl apply -f ./manifests/bootstrap/resourcegraphdefinition.yaml
echo "✅ Manifest applied."

echo "🎉 Setup complete. Argo CD and Kro are installed and ready."

kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d






# helm install my-n8n oci://8gears.container-registry.com/library/n8n --version 1.0.10

# helm repo add community-charts https://community-charts.github.io/helm-charts
# helm install my-actualbudget community-charts/actualbudget --version 1.7.2

# helm repo add gissilabs https://gissilabs.github.io/charts/
# helm install my-vaultwarden gissilabs/vaultwarden --version 1.2.5

# #xz -d -c your-image.tar.xz > your-image.tar


# set -euo pipefail

# echo "[*] Starting system update and package installation..."

# # Update system packages
# sudo apt update
# sudo apt install -y fuse-overlayfs systemd systemd-sysv dbus
# sudo apt upgrade -y


# echo "[*] Downloading install config and manifests..."

# # Pull the install config and manifests
# sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
# sudo curl -L https://raw.githubusercontent.com/mcconnellj/mono-repo/development/projects/k3s/manifests/k3s/post-start.yaml -o /var/lib/rancher/k3s/server/manifests/post-start.yaml

# echo "[*] Getting machine's IP address..."

# # Get machine's IP
# export NODE_IP=$(hostname -I | awk '{print $1}')

# echo "[*] Generating values.yaml..."

# echo "[*] Installing Docker..."

# curl -fsSL https://get.docker.com | sh

# echo "[*] Starting Docker daemon in background..."

# echo "[*] Installing K3s..."

# curl -sfL https://get.k3s.io | sh -s - \
#   --flannel-backend="none" \
#   --disable-kube-proxy \
#   --disable-network-policy \
#   --cluster-init \
#   --disable servicelb \
#   --disable traefik \
#   --node-ip="${NODE_IP}" \
#   --advertise-address="${NODE_IP}" \
#   --containerd-snapshotter=fuse-overlayfs \
#   --docker

# echo "[*] Waiting for Kubernetes API server to be reachable..."
# sudo /usr/local/bin/k3s server &

# # Wait for k3s.yaml to be created
# echo "[*] Waiting for K3s to generate kubeconfig..."
# while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do
#   sleep 1
# done

# echo "[*] Setting permissions and exporting KUBECONFIG..."

# sudo chmod 600 /etc/rancher/k3s/k3s.yaml
# echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> "$HOME/.bashrc"
# export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# echo "[*] Installing Cilium CLI..."

# CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
# CLI_ARCH=amd64
# if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi

# curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
# sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
# sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
# rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# echo "[*] Deploying Cilium..."

# cilium install --version 1.17.5 \
#   -f ./configs/cilium/values.yaml \
#   --set k8sServiceHost=${NODE_IP} \
#   --set k8sServicePort=6443 \
#   --set operator.replicas=1

# echo "[*] Waiting for Cilium to be ready..."
# cilium status --wait

# echo "[*] Applying Cilium upgrade with values.yaml..."
# cilium upgrade -f values.yaml

# echo "[*] Installing and enabling Hubble..."

# cilium hubble enable
# cilium hubble port-forward &

# HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
# HUBBLE_ARCH=amd64
# if [ "$(uname -m)" = "aarch64" ]; then HUBBLE_ARCH=arm64; fi

# curl -L --fail --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}
# sha256sum --check hubble-linux-${HUBBLE_ARCH}.tar.gz.sha256sum
# sudo tar xzvfC hubble-linux-${HUBBLE_ARCH}.tar.gz /usr/local/bin
# rm hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}

# echo "[*] Waiting for Hubble to be ready..."
# hubble status --wait

# echo "[+] Setup complete!"
