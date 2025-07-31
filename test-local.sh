#!/bin/bash

# Test the application locally
set -e

echo "🧪 Testing application locally..."

# Build and run with docker-compose
echo "🐳 Building and running application with Docker Compose..."
docker-compose up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Test the application
echo "🔍 Testing application endpoints..."

# Test health endpoint
echo "Testing health endpoint..."
curl -f http://localhost:81/health || echo "❌ Health check failed"

# Test main page
echo "Testing main page..."
curl -f http://localhost:81/ || echo "❌ Main page failed"

echo "✅ Local testing completed!"
echo "📋 Application is running at: http://localhost:81"
echo "📋 To stop the application, run: docker-compose down" 