
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitor"
  }
}


resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "persistence.enabled" 
    value = "true"
  }
    set {
    name  = "adminUser"
    value = "admin123"
  }

  set_sensitive {
    name  = "adminPassword"
    value = "admin123"
  }

}


