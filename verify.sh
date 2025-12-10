#!/bin/bash
# verify.sh - Script to verify Wisecow k8s deployment

echo "=== Wisecow Verification Started ==="
date

echo -e "\n[1] Checking kubectl version..."
kubectl version --client --short || echo "WARNING: kubectl not found or not working"

echo -e "\n[2] Checking Pod Status..."
kubectl get pods -n wisecow -o wide || echo "ERROR: Could not list pods. Is the cluster reachable?"

echo -e "\n[3] Checking Service..."
kubectl get svc -n wisecow || echo "ERROR: Could not list service."

echo -e "\n[4] Checking Ingress..."
kubectl get ingress -n wisecow || echo "ERROR: Could not list ingress."

echo -e "\n[5] Testing Application Connectivity (Internal)..."
# Try to connect to localhost:4499 if port-forwarded, or wisecow.local if /etc/hosts is set
echo "Attempting curl to https://wisecow.local (requires /etc/hosts entry)..."
curl -k -I https://wisecow.local || echo "Could not reach https://wisecow.local"

echo -e "\n=== Verification Finished ==="
