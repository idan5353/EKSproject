# 🚀 Project Overview

This project is a **DevOps demo app** running on **Amazon EKS** with infrastructure managed by **Terraform**.  
It deploys a simple **Node.js/Express web app** containerized with **Docker**, stored in **ECR**, and exposed via a **LoadBalancer service** in Kubernetes.

---
![7836ec7f-40e7-407c-895c-d172f40f97d0](https://github.com/user-attachments/assets/61a010b9-66c1-4692-b933-abd59f46b9f3)

## 🔹 Application (Docker + Node.js)

- **Dockerfile** → Builds a Node.js 20 Alpine image, installs production dependencies, and runs `npm start`.  
- **server.js** → Minimal Express API returning JSON with:
  - `"Hello from EKS! 🚀"`
  - Current timestamp  
  - App version (`APP_VERSION`)  
  - Node.js version  

---

## 🔹 Kubernetes Manifests

- **Namespace (`namespaces.yaml`)** → Creates `demo` namespace.  
- **Deployment (`deployment.yaml`)** → Runs 2 replicas of the app with resource limits.  
- **Service (`service.yaml`)** → Exposes the app via an **AWS NLB (LoadBalancer)** on port 80 → container port 3000.  
- **HPA (`hpa.yaml`)** → Auto-scales pods (2–6 replicas) based on **CPU utilization (60%)**.  

---

## 🔹 Terraform Infrastructure

### VPC Module
- 2 public + 2 private subnets  
- NAT gateway enabled  

### IAM Role
- `eks-admin` role with cluster, worker node, and ECR permissions  

### EKS Cluster Module
- EKS v1.29  
- Managed node group (`t3.medium`) with autoscaling (min=1, max=3)  
- IRSA enabled + KMS encryption for secrets  

### ECR Repository
- Stores the application container image  

---

## 🔹 Outputs
- `cluster_name`  
- `cluster_endpoint`  
- `ecr_repo_url`  
- `region`  

---

## 🌐 End Result
1. **Terraform** provisions all AWS infra (VPC, EKS, IAM, ECR).  
2. **Docker** builds and pushes the app image to ECR.  
3. **Kubernetes** deploys the app (with scaling + load balancing).  
4. App is accessible via **AWS Load Balancer**, serving a JSON response.  

---

## 👉 In Short
You built a **complete CI/CD-ready demo stack**:  
**Node.js app → Docker → ECR → Terraform → EKS → NLB → Auto-scaled & secured Kubernetes deployment.**
