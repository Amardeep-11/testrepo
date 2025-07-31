# CLO835 Final Project - Deployment Guide

## Prerequisites

Before starting, ensure you have the following installed and configured:

1. **AWS CLI** - Configured with appropriate permissions
2. **kubectl** - Kubernetes command-line tool
3. **eksctl** - EKS cluster management tool
4. **Docker** - For building and running containers
5. **Git** - For version control

## Step-by-Step Deployment

### Step 1: Clone and Setup Repository

```bash
# Clone your repository (replace with your actual repo URL)
git clone <your-repo-url>
cd FinalProject

# Make scripts executable
chmod +x setup-scripts/*.sh
chmod +x test-local.sh
chmod +x cleanup.sh
```

### Step 2: Test Application Locally

```bash
# Test the application locally first
./test-local.sh

# Access the application at http://localhost:81
# Add some users to test the functionality
```

### Step 3: Setup AWS Infrastructure

Run the setup scripts in order:

```bash
# 1. Setup S3 bucket and upload background images
./setup-scripts/setup-s3.sh

# 2. Setup ECR repository
./setup-scripts/setup-ecr.sh

# 3. Setup EKS cluster with IRSA
./setup-scripts/setup-eks.sh
```

### Step 4: Deploy Application

```bash
# Deploy the application to EKS
./setup-scripts/deploy.sh
```

### Step 5: Verify Deployment

```bash
# Check all resources
kubectl get all -n final

# Get the LoadBalancer URL
kubectl get service flask-app-service -n final

# Check HPA status
kubectl get hpa -n final

# Check metrics server
kubectl get pods -n kube-system | grep metrics-server
```

### Step 6: Test Application Features

1. **Access the application** using the LoadBalancer URL
2. **Add users** through the web interface
3. **Test data persistence** by deleting and recreating MySQL pod
4. **Test background image** by updating ConfigMap
5. **Test auto-scaling** by generating load

### Step 7: Test Background Image Change

```bash
# Update ConfigMap with new background image
kubectl patch configmap app-config -n final --patch '{"data":{"S3_IMAGE_KEY":"background2.jpg"}}'

# Restart the application pod to pick up changes
kubectl rollout restart deployment/flask-app -n final

# Verify the new background image appears
```

### Step 8: Test Auto-Scaling

```bash
# Generate load to test HPA
while true; do curl http://<loadbalancer-url>; done

# Monitor HPA in another terminal
kubectl get hpa -n final -w
```

## GitHub Actions Setup

### Step 1: Create GitHub Repository

1. Create a new repository on GitHub
2. Push your code to the repository

### Step 2: Configure GitHub Secrets

Add the following secrets to your GitHub repository:

- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key

### Step 3: Test CI/CD Pipeline

1. Make a change to your code
2. Push to main/master branch
3. Check GitHub Actions for successful build and deployment

## Verification Checklist

- [ ] Application runs locally with Docker Compose
- [ ] S3 bucket created with background images
- [ ] ECR repository created
- [ ] EKS cluster created with 2 worker nodes
- [ ] Application deployed to EKS
- [ ] LoadBalancer URL accessible
- [ ] Background image loads from S3
- [ ] Database persistence works
- [ ] ConfigMap updates reflect in application
- [ ] HPA auto-scaling works
- [ ] GitHub Actions pipeline works

## Troubleshooting

### Common Issues

1. **EKS cluster creation fails**
   - Check AWS CLI configuration
   - Ensure sufficient IAM permissions
   - Verify region settings

2. **Application pods not starting**
   - Check pod logs: `kubectl logs <pod-name> -n final`
   - Verify ConfigMap and Secret exist
   - Check image pull permissions

3. **S3 access issues**
   - Verify IAM role and policy
   - Check ServiceAccount annotations
   - Verify bucket name in ConfigMap

4. **LoadBalancer not accessible**
   - Wait for LoadBalancer provisioning
   - Check security groups
   - Verify service configuration

### Useful Commands

```bash
# Check pod status
kubectl get pods -n final

# View pod logs
kubectl logs <pod-name> -n final

# Describe resources
kubectl describe <resource-type> <resource-name> -n final

# Port forward for debugging
kubectl port-forward <pod-name> 8080:81 -n final

# Check events
kubectl get events -n final --sort-by='.lastTimestamp'
```

## Cleanup

When you're done testing, clean up all resources:

```bash
./cleanup.sh
```

## Recording Requirements

For your submission recording, demonstrate:

1. **Local testing** - Show application running locally
2. **GitHub Actions** - Show successful CI/CD pipeline
3. **EKS deployment** - Show cluster and application deployment
4. **S3 integration** - Show background image loading
5. **Data persistence** - Show data surviving pod restarts
6. **Internet access** - Show application accessible via LoadBalancer
7. **ConfigMap updates** - Show background image changes
8. **Auto-scaling** - Show HPA in action (bonus)
9. **Flux automation** - Show automated deployments (bonus)

## Submission Checklist

- [ ] GitHub repository with all code and manifests
- [ ] Recording demonstrating all functionality
- [ ] Detailed report of issues and solutions
- [ ] All commits dated before due date
- [ ] Meaningful commit messages
- [ ] No credentials in repository 