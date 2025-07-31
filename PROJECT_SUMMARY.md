# CLO835 Final Project - Complete Implementation

## Project Overview

This project implements a complete 2-tier web application deployment to Amazon EKS with all the required features and bonus components. The application demonstrates containerization, Kubernetes orchestration, CI/CD automation, and cloud-native best practices.

## Architecture Components

### 1. Application Layer
- **Flask Web Application** (`app/app.py`)
  - Enhanced with S3 background image support
  - ConfigMap and Secret integration
  - MySQL database connectivity
  - Health check endpoints
  - Logging for background image URL
  - Runs on port 81 as required

- **HTML Template** (`app/templates/index.html`)
  - Modern, responsive design
  - Dynamic background image from S3
  - User management interface
  - Student name display from ConfigMap

### 2. Infrastructure Layer
- **Amazon EKS Cluster**
  - 2 worker nodes (t3.medium)
  - Auto-scaling node group
  - IRSA (IAM Roles for Service Accounts)
  - Metrics server for HPA

- **Amazon S3**
  - Private bucket for background images
  - Multiple images for testing
  - IAM role-based access

- **Amazon ECR**
  - Private Docker registry
  - Automated image builds
  - Security scanning enabled

### 3. Kubernetes Resources

#### Core Resources
- **Namespace**: `final`
- **ConfigMap**: Application configuration
- **Secret**: Database credentials
- **PVC**: 2Gi persistent storage for MySQL

#### RBAC & Security
- **ServiceAccount**: `clo835` with IRSA
- **Role**: `CLO835` with namespace permissions
- **RoleBinding**: Links role to service account

#### Database Layer
- **MySQL Deployment**: 1 replica with persistent storage
- **MySQL Service**: ClusterIP for internal access

#### Application Layer
- **Flask Deployment**: 1 replica with health checks
- **Flask Service**: LoadBalancer for internet access
- **HPA**: Auto-scaling based on CPU/memory

### 4. CI/CD Pipeline
- **GitHub Actions** (`.github/workflows/ci-cd.yml`)
  - Automated testing
  - Docker image building
  - ECR push
  - EKS deployment
  - Service URL output

## Features Implemented

### ✅ Required Features
1. **Enhanced Flask Application**
   - Background image from S3
   - ConfigMap integration
   - Secret integration
   - Port 81 listening
   - Student name in header

2. **Docker Containerization**
   - Multi-stage Dockerfile
   - Security best practices
   - Health checks
   - Non-root user

3. **GitHub Actions CI/CD**
   - Automated builds
   - ECR push
   - EKS deployment
   - Testing pipeline

4. **EKS Cluster**
   - 2 worker nodes
   - Auto-scaling
   - IRSA setup
   - Metrics server

5. **Kubernetes Manifests**
   - All required resources
   - Proper RBAC
   - Persistent storage
   - LoadBalancer service

6. **S3 Integration**
   - Private bucket
   - Background images
   - IAM role access
   - ConfigMap configuration

7. **Data Persistence**
   - MySQL with PVC
   - 2Gi storage
   - ReadWriteOnce access

8. **Internet Access**
   - LoadBalancer service
   - Stable endpoint
   - Health checks

### ✅ Bonus Features
1. **Auto-scaling (HPA)**
   - CPU and memory metrics
   - 1-10 replicas
   - Intelligent scaling behavior

2. **Metrics Server**
   - Resource monitoring
   - HPA support
   - Cluster metrics

3. **Comprehensive Testing**
   - Local testing script
   - Health checks
   - Load testing

## File Structure

```
FinalProject/
├── app/                          # Flask application
│   ├── app.py                   # Main application
│   ├── requirements.txt         # Python dependencies
│   └── templates/
│       └── index.html          # Web interface
├── k8s/                         # Kubernetes manifests
│   ├── namespace.yaml          # Namespace
│   ├── configmap.yaml         # Application config
│   ├── secret.yaml            # Database credentials
│   ├── pvc.yaml              # Persistent storage
│   ├── serviceaccount.yaml    # IRSA setup
│   ├── role.yaml             # RBAC
│   ├── mysql-deployment.yaml # Database
│   ├── mysql-service.yaml    # Database service
│   ├── app-deployment.yaml   # Application
│   ├── app-service.yaml      # LoadBalancer
│   ├── hpa.yaml             # Auto-scaling
│   └── metrics-server.yaml   # Metrics
├── setup-scripts/             # Automation scripts
│   ├── setup-s3.sh          # S3 setup
│   ├── setup-ecr.sh         # ECR setup
│   ├── setup-eks.sh         # EKS setup
│   └── deploy.sh            # Deployment
├── .github/workflows/        # CI/CD pipeline
│   └── ci-cd.yml           # GitHub Actions
├── Dockerfile               # Container image
├── docker-compose.yml       # Local development
├── quick-start.sh          # One-click deployment
├── test-local.sh           # Local testing
├── cleanup.sh              # Resource cleanup
└── DEPLOYMENT_GUIDE.md     # Step-by-step guide
```

## Learning Outcomes Covered

1. **Containerization Concepts**
   - Docker image creation
   - Multi-stage builds
   - Security best practices
   - Health checks

2. **Kubernetes Orchestration**
   - Pod management
   - Service networking
   - Persistent storage
   - RBAC security

3. **Cloud Infrastructure**
   - EKS cluster management
   - S3 object storage
   - ECR container registry
   - IAM security

4. **CI/CD Automation**
   - GitHub Actions
   - Automated testing
   - Deployment automation
   - Infrastructure as Code

5. **Monitoring & Scaling**
   - Metrics server
   - HPA auto-scaling
   - Resource monitoring
   - Performance optimization

6. **Security Best Practices**
   - IRSA implementation
   - Secret management
   - RBAC policies
   - Network security

## Deployment Process

### Quick Start (Automated)
```bash
chmod +x quick-start.sh
./quick-start.sh
```

### Manual Deployment
```bash
# 1. Test locally
./test-local.sh

# 2. Setup infrastructure
./setup-scripts/setup-s3.sh
./setup-scripts/setup-ecr.sh
./setup-scripts/setup-eks.sh

# 3. Deploy application
./setup-scripts/deploy.sh
```

## Testing & Verification

### Local Testing
- Docker Compose setup
- Health check endpoints
- Database connectivity
- Background image loading

### Production Testing
- LoadBalancer accessibility
- S3 image retrieval
- Data persistence
- Auto-scaling functionality
- ConfigMap updates

### Monitoring Commands
```bash
# Check deployment status
kubectl get all -n final

# View application logs
kubectl logs -f deployment/flask-app -n final

# Monitor auto-scaling
kubectl get hpa -n final -w

# Check service URL
kubectl get service flask-app-service -n final
```

## Cost Optimization

- **EKS**: 2 t3.medium nodes (minimal for testing)
- **S3**: Only background images stored
- **ECR**: Single repository with lifecycle policies
- **EBS**: 2Gi storage for MySQL
- **Cleanup**: Automated cleanup script

## Security Features

- **IRSA**: Service account with minimal S3 permissions
- **RBAC**: Namespace-scoped permissions
- **Secrets**: Encrypted database credentials
- **Network**: Private subnets with LoadBalancer
- **Container**: Non-root user, security scanning

## Submission Requirements Met

✅ **GitHub Repository**: Complete codebase with manifests
✅ **Enhanced Application**: All required features implemented
✅ **Docker Containerization**: Production-ready image
✅ **CI/CD Pipeline**: GitHub Actions automation
✅ **EKS Deployment**: 2-tier application with persistence
✅ **S3 Integration**: Background image from private bucket
✅ **Auto-scaling**: HPA with metrics server
✅ **Documentation**: Comprehensive guides and scripts
✅ **Testing**: Local and production verification
✅ **Cleanup**: Resource management scripts

## Bonus Features

✅ **HPA Auto-scaling**: CPU and memory-based scaling
✅ **Metrics Server**: Resource monitoring
✅ **Comprehensive Testing**: Automated test scripts
✅ **Security Best Practices**: IRSA, RBAC, secrets
✅ **Documentation**: Complete deployment guide
✅ **Automation**: One-click deployment script

This implementation provides a complete, production-ready solution that demonstrates all the learning outcomes and meets all assignment requirements with additional bonus features for enhanced functionality and security. 