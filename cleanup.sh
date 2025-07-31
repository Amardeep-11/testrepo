#!/bin/bash

# Cleanup script for CLO835 Final Project
set -e

echo "🧹 Cleaning up AWS resources..."

# Get configuration
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
CLUSTER_NAME="clo835-cluster"
BUCKET_NAME=$(cat .s3-bucket-name 2>/dev/null || echo "clo835-final-project-${ACCOUNT_ID}")

echo "🗑️  Deleting EKS cluster..."
eksctl delete cluster --name $CLUSTER_NAME --region $REGION

echo "🗑️  Deleting ECR repository..."
aws ecr delete-repository --repository-name clo835-final-project --region $REGION --force

echo "🗑️  Deleting S3 bucket..."
aws s3 rb s3://$BUCKET_NAME --force

echo "🗑️  Deleting IAM roles and policies..."
aws iam detach-role-policy --role-name clo835-s3-access-role --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/clo835-s3-access-policy
aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/clo835-s3-access-policy
aws iam delete-role --role-name clo835-s3-access-role

echo "🗑️  Cleaning up local files..."
rm -f .s3-bucket-name .ecr-repository .eks-cluster-name

echo "✅ Cleanup completed!" 