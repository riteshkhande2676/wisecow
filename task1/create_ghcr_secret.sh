#!/bin/bash
# create_ghcr_secret.sh

# Usage: ./create_ghcr_secret.sh <github-username> <github-token>

USER=$1
TOKEN=$2

if [ -z "$USER" ] || [ -z "$TOKEN" ]; then
  echo "Usage: ./create_ghcr_secret.sh <github-username> <github-token(PAT)>"
  echo "Creates a kubernetes secret 'regcred' for pulling images from GHCR."
  exit 1
fi

kubectl create secret docker-registry regcred \
  --docker-server=ghcr.io \
  --docker-username=$USER \
  --docker-password=$TOKEN \
  --docker-email=$USER@users.noreply.github.com \
  -n wisecow \
  --dry-run=client -o yaml > task1/k8s/regcred.yaml

echo "Created task1/k8s/regcred.yaml"
echo "You can apply it with: kubectl apply -f task1/k8s/regcred.yaml"
