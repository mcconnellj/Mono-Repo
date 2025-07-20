#!/bin/bash
set -euxo pipefail  # Safer scripting: fail fast and show errors

# Update system packages
apt update
apt upgrade -y

# Install required dependencies
apt install -y curl unzip python3 python3-pip gnupg software-properties-common


curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
cilium install --version 1.17.5 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16"
cilium hubble enable
cilium hubble port-forward&
HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
HUBBLE_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then HUBBLE_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}
sha256sum --check hubble-linux-${HUBBLE_ARCH}.tar.gz.sha256sum
sudo tar xzvfC hubble-linux-${HUBBLE_ARCH}.tar.gz /usr/local/bin
rm hubble-linux-${HUBBLE_ARCH}.tar.gz{,.sha256sum}
cilium status --wait
hubble status --wait


# Download and extract k3s manifests
curl -L -o k3s-server.zip "https://github.com/mcconnellj/k3s-server/archive/refs/heads/development.zip?nocache=$(date +%s)"
unzip k3s-server.zip
rm k3s-server.zip

# Get machine's IP
export NODE_IP=$(hostname -I | awk '{print $1}')

# Create K3s config
mkdir -p ./k3s-server-development/configs
cat <<EOF > ./k3s-server-development/configs/cloud-development.yaml
node-ip: ${NODE_IP}
advertise-address: ${NODE_IP}
tls-san:
  - ${NODE_IP}
EOF

# Prepare K3s directories
mkdir -p /var/lib/rancher/k3s/server/manifests/
mkdir -p /etc/rancher/k3s/
mv ./k3s-server-development/manifests/k3s-init/* /var/lib/rancher/k3s/server/manifests/

# Install K3s (fixed: replace `url` with `curl`)
curl -sfL https://get.k3s.io | sh -s -- \
  --flannel-backend "none" \
  --disable-kube-proxy \
  --disable-network-policy \
  --cluster-init \
  --write-kubeconfig /etc/rancher/k3s/k3s.yaml \
  --write-kubeconfig-mode 0600 \
  --server https://127.0.0.1:6443 \
  --disable servicelb \
  --disable traefik \
  --disable-coredns

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Wait for Kubernetes API to become ready
sleep 30  # crude, but works reliably for early boot

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Helm install Cilium
helm repo add cilium https://helm.cilium.io
helm repo update
helm install cilium cilium/cilium -n kube-system \
  -f applications-core/cilium/values.yaml \
  -f applications-core/cilium/development.yaml \
  --version 1.17.0-rc.2 \
  --set operator.replicas=1
