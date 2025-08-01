#!/bin/bash
set -x

echo $USER
echo $HOME

# Downloads and installs K3s Kubernetes with custom options:
# - Disables Flannel networking backend (--flannel-backend=none)
# - Disables Kubernetes network policy controller (--disable-network-policy)
# Any installation errors are redirected to 'k3s-install-error.txt'.
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh - 2> k3s-install-error.txt

# Set KUBECONFIG for kubectl/cilium
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Install cilium CLI
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# Install cilium in the cluster
cilium install --version 1.18.0 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16"

