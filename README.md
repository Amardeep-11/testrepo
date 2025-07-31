# Final Project: 2-Tier Web Application Deployment to Amazon EKS

## Project Overview
This project demonstrates the deployment of a 2-tier web application to a managed Kubernetes cluster on Amazon EKS, with pod auto-scaling and deployment automation.

## Architecture
- **Frontend**: Flask web application with configurable background image from S3
- **Backend**: MySQL database with persistent storage
- **Infrastructure**: Amazon EKS cluster with auto-scaling
- **CI/CD**: GitHub Actions for automated builds and deployments
- **Monitoring**: Metrics server and HPA for auto-scaling

## Project Structure
```
FinalProject/
├── app/                          # Flask application
│   ├── templates/               # HTML templates
│   ├── static/                  # Static files
│   ├── app.py                   # Main Flask application
│   └── requirements.txt         # Python dependencies
├── k8s/                         # Kubernetes manifests
│   ├── namespace.yaml           # Namespace definition
│   ├── configmap.yaml          # ConfigMap for app configuration
│   ├── secret.yaml             # Secret for database credentials
│   ├── pvc.yaml               # Persistent Volume Claim
│   ├── serviceaccount.yaml     # Service account with IRSA
│   ├── role.yaml              # RBAC role and binding
│   ├── mysql-deployment.yaml   # MySQL deployment
│   ├── mysql-service.yaml      # MySQL service
│   ├── app-deployment.yaml     # Flask app deployment
│   ├── app-service.yaml        # Flask app service
│   ├── hpa.yaml               # Horizontal Pod Autoscaler
│   └── metrics-server.yaml     # Metrics server deployment
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # GitHub Actions workflow
├── Dockerfile                  # Docker image definition
├── docker-compose.yml          # Local development setup
└── setup-scripts/             # Setup and deployment scripts
    ├── setup-eks.sh           # EKS cluster setup
    ├── setup-s3.sh            # S3 bucket setup
    ├── setup-ecr.sh           # ECR repository setup
    └── deploy.sh              # Deployment script
```

## Prerequisites
- AWS CLI configured
- kubectl installed
- eksctl installed
- Docker installed
- GitHub account with repository

## Quick Start
1. Clone this repository
2. Run the setup scripts in order:
   ```bash
   chmod +x setup-scripts/*.sh
   ./setup-scripts/setup-s3.sh
   ./setup-scripts/setup-ecr.sh
   ./setup-scripts/setup-eks.sh
   ./setup-scripts/deploy.sh
   ```

## Features Implemented
- ✅ Enhanced Flask application with S3 background image
- ✅ ConfigMap and Secret integration
- ✅ Persistent storage for MySQL
- ✅ IRSA for S3 access
- ✅ GitHub Actions CI/CD pipeline
- ✅ Auto-scaling with HPA
- ✅ Flux deployment automation (bonus)

## Learning Outcomes Covered
- Design and implement containerized applications
- Deploy to managed Kubernetes cluster
- Implement CI/CD pipelines
- Configure auto-scaling and monitoring
- Manage persistent storage and networking
- Implement security best practices # Updated Thu Jul 31 21:35:33 UTC 2025
# Updated Thu Jul 31 21:55:20 UTC 2025
# ECR repository created - re-trigger build
# Trigger GitHub Actions with fixed permissions - Thu Jul 31 22:19:46 UTC 2025
# Manual trigger - Thu Jul 31 22:32:11 UTC 2025
# Testing GitHub Actions workflow - Thu Jul 31 22:34:17 UTC 2025
# ECR repository: clo835-final-project
# AWS Region: us-east-1
