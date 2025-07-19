#!/bin/bash

set -e

# Pull post install manifests
sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
sudo curl -L https://raw.githubusercontent.com/mcconnellj/mono-repo/development/projects/k3s/manifests/k3s/post-start.yaml -o /var/lib/rancher/k3s/server/manifests/post-start.yaml

echo "[*] Getting machine's IP address..."

# Get machine's IP
export NODE_IP=$(hostname -I | awk '{print $1}')

curl -sfL https://get.k3s.io | sh -s - \
  --cluster-init 

sudo chmod 644 /etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> "$HOME/.bashrc"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

export KRO_VERSION=$(curl -sL \
    https://api.github.com/repos/kro-run/kro/releases/latest | \
    jq -r '.tag_name | ltrimstr("v")'
  )

helm install kro oci://ghcr.io/kro-run/kro/kro \
  --namespace kro \
  --create-namespace \
  --version=${KRO_VERSION}

