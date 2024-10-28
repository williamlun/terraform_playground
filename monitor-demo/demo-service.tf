resource "helm_release" "fastapi-demo" {
  name       = "fastapi-demo"
  repository = "https://williamlun.github.io/my_helm_repo/"
  chart      = "fastapi-monitor-demo"

  set {
    name  = "image.tag"
    value = "0.0.2"
  }

  set {
    name  = "env.SERVICE_NAME"
    value = "fastapi-app-for-opentelemetry-demo"
  }
  set {
    name  = "env.SERVICE_PORT"
    value = 8000
  }
  set {
    name  = "env.OTLP_EXPORTER_ENDPOINT"
    value = "k8s-monitoring-alloy.monitor:4317"
  }
}