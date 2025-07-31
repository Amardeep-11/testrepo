#!/bin/bash

# Setup EKS cluster for CLO835 Final Project
set -e

echo "🚀 Setting up EKS cluster..."

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
CLUSTER_NAME="clo835-cluster"
BUCKET_NAME=$(cat .s3-bucket-name 2>/dev/null || echo "clo835-final-project-${ACCOUNT_ID}")

echo "📦 Creating EKS cluster: $CLUSTER_NAME"

# Create EKS cluster
eksctl create cluster \
    --name $CLUSTER_NAME \
    --region $REGION \
    --nodegroup-name standard-workers \
    --node-type t3.medium \
    --nodes 2 \
    --nodes-min 2 \
    --nodes-max 4 \
    --managed

# Update kubeconfig
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

# Create IAM OIDC provider
eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --region $REGION --approve

# Create IAM role for S3 access
echo "🔐 Creating IAM role for S3 access..."

# Create trust policy
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/oidc.eks.${REGION}.amazonaws.com/id/$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION --query 'cluster.identity.oidc.issuer' --output text | cut -d'/' -f5)"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${REGION}.amazonaws.com/id/$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION --query 'cluster.identity.oidc.issuer' --output text | cut -d'/' -f5):sub": "system:serviceaccount:final:clo835"
        }
      }
    }
  ]
}
EOF

# Create S3 access policy
cat > s3-access-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${BUCKET_NAME}",
        "arn:aws:s3:::${BUCKET_NAME}/*"
      ]
    }
  ]
}
EOF

# Create IAM role and policy
aws iam create-role --role-name clo835-s3-access-role --assume-role-policy-document file://trust-policy.json
aws iam create-policy --policy-name clo835-s3-access-policy --policy-document file://s3-access-policy.json
aws iam attach-role-policy --role-name clo835-s3-access-role --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/clo835-s3-access-policy

# Clean up policy files
rm -f trust-policy.json s3-access-policy.json

# Update service account with correct role ARN
sed -i "s/ACCOUNT_ID/${ACCOUNT_ID}/g" k8s/serviceaccount.yaml

# Deploy metrics server for HPA
echo "📊 Deploying metrics server..."
kubectl apply -f k8s/metrics-server.yaml

# Wait for metrics server to be ready
echo "⏳ Waiting for metrics server to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/metrics-server -n kube-system

echo "✅ EKS setup completed!"
echo "📋 Cluster name: $CLUSTER_NAME"
echo "📋 Region: $REGION"
echo "📋 IAM role: clo835-s3-access-role"

# Save cluster info for other scripts
echo $CLUSTER_NAME > .eks-cluster-name 