provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minipc"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minipc"
}

provider "null" {
}

provider "random" {
  # Configuration options
}
