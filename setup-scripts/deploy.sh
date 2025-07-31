#!/bin/bash

# Deploy application to EKS for CLO835 Final Project
set -e

echo "🚀 Deploying application to EKS..."

# Get configuration
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
REPO_NAME="clo835-final-project"
BUCKET_NAME=$(cat .s3-bucket-name 2>/dev/null || echo "clo835-final-project-${ACCOUNT_ID}")

# Update ConfigMap with correct bucket name
sed -i "s/clo835-final-project/${BUCKET_NAME}/g" k8s/configmap.yaml

# Update app deployment with correct ECR repository
ECR_REPO="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"
sed -i "s|ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/clo835-final-project|$ECR_REPO|g" k8s/app-deployment.yaml

# Build and push Docker image
echo "🐳 Building Docker image..."
docker build -t $ECR_REPO:latest .

echo "📤 Pushing image to ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
docker push $ECR_REPO:latest

# Deploy to Kubernetes
echo "📦 Deploying to Kubernetes..."

# Create namespace
kubectl apply -f k8s/namespace.yaml

# Apply all manifests
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/serviceaccount.yaml
kubectl apply -f k8s/role.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/app-service.yaml
kubectl apply -f k8s/hpa.yaml

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mysql-deployment -n final
kubectl wait --for=condition=available --timeout=300s deployment/flask-app -n final

# Get service URL
echo "🌐 Getting service URL..."
kubectl get service flask-app-service -n final

echo "✅ Deployment completed!"
echo "📋 Application deployed successfully!"
echo "📋 Check the LoadBalancer URL above to access the application" 