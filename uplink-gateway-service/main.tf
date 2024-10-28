terraform {
  required_version = "~>1.5.0"
  required_providers {

    helm = {
      version = "~> 2.7"

    }
    kubernetes = {
      source = "hashicorp/kubernetes"

      version = ">= 2.0.0"
    }


  }
}
resource "kubernetes_namespace" "gatway" {
  metadata {
    name = "gateway-testing"
  }
}

resource "helm_release" "my_app" {
  for_each = { for code in var.access_codes : code => code }

  chart      = "uplink-gateway-service-pipeline"
  repository = "https://williamlun.github.io/my_helm_repo"
  name       = "my-app-${each.key}"
  namespace  = "gateway-testing"


  set {
    name  = "env.CHIRPSTACK_MQTT_HOST"
    value = "localhost"
  }
  set {
    name  = "env.CHIRPSTACK_MQTT_PORT"
    value = "1883"
  }

  dynamic "set" {
    for_each = { "env.THINGSBOARD_MQTT_USERNAME" = each.value }
    content {
      name  = set.key
      value = set.value
    }
  }
}


# resource "helm_release" "gateway" {
#   chart      = "uplink-gateway-service-pipeline"
#   repository = "https://williamlun.github.io/my_helm_repo"
#   name       = "argo-cd"
#   namespace  = "gateway-testing"

#   set {
#     name  = "env.CHIRPSTACK_MQTT_HOST"
#     value = "localhost"
#   }
#   set {
#     name  = "env.CHIRPSTACK_MQTT_PORT"
#     value = "1883"
#   }
#   set {
#     name  = "env.THINGSBOARD_MQTT_USERNAME"
#     value = "dllm"
#   }
# }



