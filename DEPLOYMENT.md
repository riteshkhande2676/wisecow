# Wisecow: Containerization, Kubernetes Deployment, CI/CD, and TLS

This document covers containerization, Kubernetes deployment, CI/CD via GitHub Actions, and TLS for the Wisecow app.

## Prerequisites
- A Kubernetes cluster (Kind or Minikube recommended)
- `kubectl` configured to your cluster
- NGINX Ingress Controller installed
- cert-manager installed (for TLS)
- A DNS host pointing to your ingress controller (or use `nip.io`)
- GitHub repository (public) containing this code

## Containerization
- Dockerfile resides at `Dockerfile`
- Image installs `cowsay`, `fortune-mod`, and `netcat-openbsd`
- Exposes port `4499`

Build locally:
```
docker build -t wisecow:local .
docker run -p 4499:4499 wisecow:local
```
Open `http://localhost:4499`.

## Kubernetes Manifests
- Namespace: `k8s/namespace.yaml`
- Deployment: `k8s/deployment.yaml`
- Service: `k8s/service.yaml`
- Ingress (TLS): `k8s/ingress.yaml`
- ClusterIssuer: `k8s/clusterissuer.yaml`

Update the image in `deployment.yaml`:
```
image: ghcr.io/REPLACE_WITH_YOUR_GH_USERNAME/wisecow:latest
```

Apply manifests:
```
kubectl apply -f k8s/namespace.yaml
kubectl -n wisecow apply -f k8s/deployment.yaml
kubectl -n wisecow apply -f k8s/service.yaml
kubectl -n wisecow apply -f k8s/ingress.yaml
```

## Ingress & TLS
- Ingress host default: `wisecow.local`. Change it to your domain in `k8s/ingress.yaml`.
- If using Minikube, map the host to Minikube IP:
```
minikube ip
# Add an entry in /etc/hosts: <MINIKUBE_IP> wisecow.local
```
- For quick testing without DNS, use `nip.io`:
  - Replace `wisecow.local` with `<MINIKUBE_IP>.nip.io`

### cert-manager ClusterIssuer
- `k8s/clusterissuer.yaml` uses Let's Encrypt staging. Update email:
```
spec:
  acme:
    email: your-email@example.com
```
- Apply issuer:
```
kubectl apply -f k8s/clusterissuer.yaml
```
- Switch to production by changing `server:` to `https://acme-v02.api.letsencrypt.org/directory` and names accordingly.

## GitHub Actions CI/CD
Workflow file: `.github/workflows/ci-cd.yaml`

### What it does
- Builds and pushes image to GHCR: `ghcr.io/<owner>/wisecow`
- Deploys to cluster using `kubectl` after successful build
- Updates Deployment image to the commit SHA

### Required Secrets
- `GITHUB_TOKEN`: provided by GitHub; used to push to GHCR (permissions configured in the workflow)
- `KUBECONFIG`: the kubeconfig content for your cluster

### Usage
- Push to `main` to trigger build and deployment
- Ensure `deployment.yaml` references `ghcr.io/<owner>/wisecow:latest`
- Workflow updates image to `${{ github.sha }}` on deploy

## Verify
- Check pods: `kubectl -n wisecow get pods`
- Check service: `kubectl -n wisecow get svc wisecow`
- Check ingress: `kubectl -n wisecow get ingress wisecow`
- Access: `https://wisecow.local/` (or your domain)

## Notes
- The app itself serves HTTP; TLS is terminated at the ingress layer.
- Use staging issuer while testing to avoid rate limits.
- For production, set up proper DNS and switch ClusterIssuer to Let's Encrypt prod.