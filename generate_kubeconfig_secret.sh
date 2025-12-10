#!/bin/bash
# generate_kubeconfig_secret.sh

echo "=== Generating KUBECONFIG for GitHub Secrets ==="
echo "Run this command and copy the output to your GitHub Repo Secrets as 'KUBECONFIG'"
echo "--------------------------------------------------------------------------------"
# Using base64 to avoid formatting issues, or just raw cat if the action supports it.
# The azure/setup-kubectl action and standard usage usually expect the raw yaml content.

if [ -f ~/.kube/config ]; then
  cat ~/.kube/config
else
  echo "ERROR: ~/.kube/config not found. Are you running this where kubectl is configured?"
fi
echo "--------------------------------------------------------------------------------"
