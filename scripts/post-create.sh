#!/bin/bash

echo "Updating Nix channels..."
nix-channel --update

echo "Installing Nix and cacert packages..."
nix-env --install --attr nixpkgs.nix nixpkgs.cacert

echo "Reloading systemd daemon..."
systemctl daemon-reload

echo "Restarting Nix daemon..."
systemctl restart nix-daemon

echo "Building the flake..."
nix build
echo "Post-create script executed successfully."
