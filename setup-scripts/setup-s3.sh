#!/bin/bash

# Setup S3 bucket and background image for CLO835 Final Project
set -e

echo "🚀 Setting up S3 bucket and background image..."

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
BUCKET_NAME="clo835-final-project-${ACCOUNT_ID}"

echo "📦 Creating S3 bucket: $BUCKET_NAME"

# Create S3 bucket
aws s3 mb s3://$BUCKET_NAME --region $REGION

# Set bucket policy for private access
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Download a sample background image
echo "📥 Downloading sample background image..."
curl -o background.jpg https://images.unsplash.com/photo-1557683316-973673baf926?w=800

# Upload background image to S3
echo "📤 Uploading background image to S3..."
aws s3 cp background.jpg s3://$BUCKET_NAME/background.jpg

# Create additional background images for testing
echo "🎨 Creating additional background images for testing..."

# Download different background images
curl -o background2.jpg https://images.unsplash.com/photo-1506905925346-21bda4d134df?w=800
curl -o background3.jpg https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800

# Upload additional images
aws s3 cp background2.jpg s3://$BUCKET_NAME/background2.jpg
aws s3 cp background3.jpg s3://$BUCKET_NAME/background3.jpg

# Clean up local files
rm -f background.jpg background2.jpg background3.jpg

echo "✅ S3 setup completed!"
echo "📋 Bucket name: $BUCKET_NAME"
echo "📋 Background images uploaded:"
echo "   - background.jpg"
echo "   - background2.jpg" 
echo "   - background3.jpg"

# Save bucket name for other scripts
echo $BUCKET_NAME > .s3-bucket-name 