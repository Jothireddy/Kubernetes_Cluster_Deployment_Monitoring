#!/bin/bash
set -e

# Change to the terraform directory and initialize/apply the configuration
echo "Initializing Terraform..."
cd terraform
terraform init

echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Fetch the cluster name and AWS region from Terraform outputs
CLUSTER_NAME=$(terraform output -raw cluster_name)
AWS_REGION=$(terraform output -raw aws_region)

echo "Updating kubeconfig for cluster: ${CLUSTER_NAME} in region: ${AWS_REGION}"
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${AWS_REGION}"

# Go back to the root directory for Helm operations
cd ..

# Add and update Helm repos
echo "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy Prometheus
echo "Deploying Prometheus via Helm..."
helm install prometheus prometheus-community/prometheus -f helm/prometheus-values.yaml

# Deploy Grafana
echo "Deploying Grafana via Helm..."
helm install grafana grafana/grafana -f helm/grafana-values.yaml

echo "Deployment complete."
