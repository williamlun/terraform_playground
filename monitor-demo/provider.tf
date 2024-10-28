terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = "~/.kube/config"  # Update this path if your kubeconfig is located elsewhere
}

# Configure the Helm provider
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Update this path if your kubeconfig is located elsewhere
  }
}

