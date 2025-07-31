#!/bin/bash

# Setup ECR repository for CLO835 Final Project
set -e

echo "🚀 Setting up ECR repository..."

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
REPO_NAME="clo835-final-project"

echo "📦 Creating ECR repository: $REPO_NAME"

# Create ECR repository
aws ecr create-repository \
    --repository-name $REPO_NAME \
    --region $REGION \
    --image-scanning-configuration scanOnPush=true \
    --encryption-configuration encryptionType=AES256

# Get login token
echo "🔐 Getting ECR login token..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

echo "✅ ECR setup completed!"
echo "📋 Repository URI: $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"

# Save repository info for other scripts
echo $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME > .ecr-repository 