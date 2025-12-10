# AccuKnox DevOps Trainee Assessment - Verification Report

This document verifies the completion of all Problem Statements against the provided requirements.

## Problem Statement 1: Containerisation and Deployment (Wisecow)
**Location**: `problem_statement_1/`

| Requirement | Status | File Location |
| :--- | :--- | :--- |
| **Dockerization** | | |
| Dockerfile | ✅ Done | `problem_statement_1/Dockerfile` |
| **Kubernetes Deployment** | | |
| Deployment Manifest | ✅ Done | `problem_statement_1/k8s/deployment.yaml` |
| Service Manifest | ✅ Done | `problem_statement_1/k8s/service.yaml` |
| Exposed as Service | ✅ Done | Defined in `service.yaml` |
| **tls Implementation** | | |
| Secure TLS (Ingress) | ✅ Done | `problem_statement_1/k8s/ingress.yaml` |
| TLS Certificate | ✅ Done | `problem_statement_1/k8s/clusterissuer.yaml` (and `self-signed` for local) |
| **CI/CD** | | |
| GitHub Actions Workflow | ✅ Done | `problem_statement_1/.github/workflows/ci-cd.yaml` |
| Build & Push | ✅ Done | `build-and-push` job in workflow |
| Continuous Deployment | ✅ Done | `deploy` job in workflow |
| **Artifacts** | | |
| Helper Scripts | ✅ Done | `problem_statement_1/create_ghcr_secret.sh`, `problem_statement_1/generate_kubeconfig_secret.sh` |

> **Note**: As requested, the CI/CD workflow is located inside `problem_statement_1/`. For GitHub to run it automatically, it usually requires it to be in the repository root (`.github/workflows/`).

---

## Problem Statement 2: Scripting (Choose Two)
**Location**: `problem_statement_2/`

| Objective | Status | Implementation |
| :--- | :--- | :--- |
| **1. System Health Monitoring** | ✅ Done | `problem_statement_2/system_health.sh` (Bash) |
| *Checks* | | CPU, Memory, Disk, Processes |
| **4. Application Health Checker** | ✅ Done | `problem_statement_2/app_health.py` (Python) |
| *Checks* | | HTTP Status Codes (UP/DOWN detection) |
| *Dependencies* | | `problem_statement_2/requirements.txt` |

---

## Problem Statement 3: Zero-Trust KubeArmor (Extra)
**Location**: `problem_statement_3/`

| Requirement | Status | File Location |
| :--- | :--- | :--- |
| KubeArmor Policy | ✅ Done | `problem_statement_3/kubearmor_policy.yaml` |
| Apply Policy | ⚠️ User Action | See `walkthrough.md` for commands |
| Screenshot of Violation | ⚠️ User Action | See `walkthrough.md` for instructions |

---

## Folder Structure Verification
The repository is correctly structured into separate folders for each task:
```text
.
├── problem_statement_1/   # Wisecow App, Dockerfile, K8s, CI/CD
├── problem_statement_2/   # Bash & Python Scripts
└── problem_statement_3/   # KubeArmor Policy
```
