#!/bin/bash

# Quick Start Script for CLO835 Final Project
# This script automates the entire deployment process

set -e

echo "🚀 CLO835 Final Project - Quick Start"
echo "======================================"

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if required tools are installed
for tool in kubectl eksctl docker git; do
    if ! command -v $tool &> /dev/null; then
        echo "❌ $tool is not installed. Please install it first."
        exit 1
    fi
done

echo "✅ All prerequisites met!"

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x setup-scripts/*.sh
chmod +x test-local.sh
chmod +x cleanup.sh

# Test locally first
echo "🧪 Testing application locally..."
./test-local.sh

echo "⏳ Waiting for local test to complete..."
sleep 10

# Check if local test was successful
if curl -f http://localhost:81/health &> /dev/null; then
    echo "✅ Local test successful!"
else
    echo "❌ Local test failed. Please check the application."
    exit 1
fi

# Stop local containers
echo "🛑 Stopping local containers..."
docker-compose down

# Setup AWS infrastructure
echo "☁️  Setting up AWS infrastructure..."

echo "📦 Setting up S3 bucket..."
./setup-scripts/setup-s3.sh

echo "📦 Setting up ECR repository..."
./setup-scripts/setup-ecr.sh

echo "📦 Setting up EKS cluster..."
./setup-scripts/setup-eks.sh

# Deploy application
echo "🚀 Deploying application to EKS..."
./setup-scripts/deploy.sh

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
sleep 60

# Get service URL
echo "🌐 Getting service URL..."
SERVICE_URL=$(kubectl get service flask-app-service -n final -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "LOADING...")

echo ""
echo "🎉 Deployment completed successfully!"
echo "======================================"
echo "📋 Application URL: http://$SERVICE_URL"
echo "📋 To monitor the deployment:"
echo "   kubectl get all -n final"
echo "📋 To view logs:"
echo "   kubectl logs -f deployment/flask-app -n final"
echo "📋 To test auto-scaling:"
echo "   kubectl get hpa -n final"
echo "📋 To clean up resources:"
echo "   ./cleanup.sh"
echo ""
echo "📝 Next steps:"
echo "1. Access the application using the URL above"
echo "2. Add some users to test the functionality"
echo "3. Test background image changes by updating ConfigMap"
echo "4. Test auto-scaling by generating load"
echo "5. Record your demonstration for submission"
echo ""
echo "✅ Quick start completed!" 