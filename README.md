
# Kubernetes Cluster Deployment & Monitoring

Welcome to the **Kubernetes Cluster Deployment & Monitoring** project! This repository contains Infrastructure as Code (IaC) for deploying a multi-node Kubernetes cluster on AWS (using EKS) along with an integrated monitoring stack using Prometheus and Grafana. The project leverages Terraform for provisioning cloud resources and Helm for deploying Kubernetes applications.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation & Deployment](#installation--deployment)
  - [Terraform: Provisioning the EKS Cluster](#terraform-provisioning-the-eks-cluster)
  - [Helm: Deploying Prometheus & Grafana](#helm-deploying-prometheus--grafana)
  - [Automated Deployment Script](#automated-deployment-script)
- [Configuration Details](#configuration-details)
- [Troubleshooting & Tips](#troubleshooting--tips)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This project demonstrates a complete end-to-end solution for deploying a Kubernetes cluster and monitoring it with Prometheus and Grafana. The solution is designed with automation and scalability in mind, using the following core concepts:

- **Infrastructure as Code:** Automate the provisioning of AWS resources using Terraform.
- **Container Orchestration:** Create and manage a multi-node Kubernetes cluster on AWS EKS.
- **Monitoring & Visualization:** Deploy Prometheus to collect metrics and Grafana to visualize them.
- **Deployment Automation:** Use a shell script to streamline the entire deployment process.

---

## Features

- **Multi-Node Kubernetes Cluster:** Provision an EKS cluster with a dedicated VPC, subnets, and a managed node group.
- **Automated Provisioning:** Use Terraform scripts to deploy and configure AWS infrastructure.
- **Integrated Monitoring:** Install Prometheus and Grafana via Helm charts for real-time monitoring.
- **Customizable Configuration:** Modify variables and Helm values to tailor the setup to your needs.
- **Extensible Architecture:** Easily adapt the project for other cloud providers or on-premises deployments.

---

## Technologies Used

- **Terraform:** For provisioning AWS resources such as VPC, subnets, EKS cluster, and node groups.
- **AWS (EKS):** Managed Kubernetes service to run containerized applications.
- **Kubernetes:** Container orchestration platform.
- **Helm:** Package manager for Kubernetes to install Prometheus and Grafana.
- **Prometheus:** Open-source monitoring and alerting toolkit.
- **Grafana:** Open-source analytics & monitoring solution.
- **Bash:** Scripting for automating deployment tasks.

---

## Project Structure

The repository is organized as follows:

k8s-monitoring-project/ ├── README.md # This documentation file ├── terraform/
│ ├── provider.tf # AWS provider configuration for Terraform │ ├── main.tf # Terraform configuration for the EKS cluster & node group │ ├── variables.tf # Input variables for configuration │ └── outputs.tf # Outputs to expose cluster details ├── helm/ │ ├── prometheus-values.yaml # Custom configuration for Prometheus Helm chart │ └── grafana-values.yaml # Custom configuration for Grafana Helm chart └── scripts/ └── deploy.sh # Deployment script for automating the provisioning & Helm installation


---

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- **Terraform (v1.0+)** – [Download Terraform](https://www.terraform.io/downloads.html)
- **AWS CLI** – Configured with appropriate AWS credentials  
  *[AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)*
- **Helm (v3+)** – [Helm Installation Instructions](https://helm.sh/docs/intro/install/)
- **kubectl** – [kubectl Installation Guide](https://kubernetes.io/docs/tasks/tools/)
- **Git** – For cloning the repository

---

## Installation & Deployment

### Terraform: Provisioning the EKS Cluster

1. **Clone the repository:**

   ```bash
   git clone <repository_url>
   cd k8s-monitoring-project
   ```
Navigate to the Terraform directory:

```bash
cd terraform

```
Initialize Terraform:
```
terraform init
```
Apply the Terraform configuration:

```
terraform apply -auto-approve
```
Configure kubectl to connect to your new EKS cluster:

Use the outputs provided by Terraform:
```
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $(terraform output -raw aws_region)
```
Helm: Deploying Prometheus & Grafana
Add and update Helm repositories:
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```
Deploy Prometheus:

```
helm install prometheus prometheus-community/prometheus -f ../helm/prometheus-values.yaml
```
Deploy Grafana:

```
helm install grafana grafana/grafana -f ../helm/grafana-values.yaml
```
Automated Deployment Script
Alternatively, you can use the provided deployment script to run all steps automatically.

Make the script executable:
```
chmod +x scripts/deploy.sh
```
Run the deployment script:
```
./scripts/deploy.sh
```
This script initializes Terraform, applies the configuration, updates your kubectl configuration, and then deploys Prometheus and Grafana via Helm.

Configuration Details
Terraform Variables
aws_region: The AWS region where the cluster will be deployed (default: us-west-2).
cluster_name: The name of your EKS cluster (default: my-eks-cluster).
vpc_cidr: CIDR block for the VPC (default: 10.0.0.0/16).
node_instance_type: EC2 instance type for the worker nodes (default: t3.medium).
desired_capacity: Number of nodes in the EKS node group (default: 2).
Feel free to modify these in terraform/variables.tf to match your desired configuration.

Helm Values Files
prometheus-values.yaml: Customize settings for Prometheus (e.g., persistence, alertmanager configuration).
grafana-values.yaml: Configure Grafana settings such as admin credentials and persistence options.
Troubleshooting & Tips
Cluster Connectivity: If kubectl cannot connect to the cluster, ensure that your AWS CLI is properly configured and that you have updated your kubeconfig using the correct cluster name and region.
Resource Limits: For production deployments, consider adjusting the node group scaling and instance types.
Monitoring Customizations: Modify the Helm values files if you require persistent storage, custom dashboards, or integration with additional data sources.
Logs & Debugging: Review the logs from Terraform (terraform plan and terraform apply) and Helm (helm status <release-name>) for troubleshooting.
Contributing
Contributions are welcome! If you have suggestions, bug fixes, or improvements, please open an issue or submit a pull request. Follow the standard Git branching model and ensure your code adheres to the project's style guidelines.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Final Notes
This project demonstrates modern DevOps practices by automating the provisioning of cloud infrastructure and deploying containerized applications with robust monitoring. It is a starting point that can be extended with additional features like ingress controllers, CI/CD pipelines, enhanced security policies, and more. Enjoy exploring, modifying, and building upon this setup!

Happy Deploying!
