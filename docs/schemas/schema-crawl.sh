#!/bin/bash

set -e

SCHEMA_ROOT="docs/schemas"

declare -A REPOS=(
    ["argocd"]="https://github.com/argoproj/argo-cd/|manifests/crds"
    ["devcontainer"]="https://github.com/devcontainers/spec/|schemas"
)

for repo in "${!REPOS[@]}"; do
    IFS="|" read -r repo_url schema_path <<< "${REPOS[$repo]}"

    TARGET_DIR="$SCHEMA_ROOT/$repo"
    rm -rf "$TARGET_DIR"

    # Clone without checkout
    git clone --depth=1 --no-checkout "$repo_url" "$TARGET_DIR"

    # Initialize sparse-checkout in non-cone mode
    git -C "$TARGET_DIR" sparse-checkout init --no-cone

    # Set the specific subfolder to include
    git -C "$TARGET_DIR" sparse-checkout set "$schema_path"

    # Checkout the branch (assumes default is main)
    git -C "$TARGET_DIR" checkout
done
