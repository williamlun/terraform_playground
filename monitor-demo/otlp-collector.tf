resource "helm_release" "grafana_k8s_monitoring" {
  name       = "k8s-monitoring"
  chart      = "k8s-monitoring"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "cluster.name"
    value = "docker-desktop"
  }

  # Prometheus connection configs

  set {
    name  = "externalServices.prometheus.host"
    value = "http://prometheus-server.monitor"
  }

  set {
    name  = "externalServices.prometheus.authMode"
    value = "none"
  }

  set {
    name  = "externalServices.prometheus.protocol"
    value = "remote_write"
  }

  set {
    name  = "externalServices.prometheus.writeEndpoint"
    value = "/api/v1/write"
  }

  set {
    name  = "externalServices.prometheus.queryEndpoint"
    value = "/api/v1/query"
  }

  # Grafana Loki connection configs

  set {
    name  = "externalServices.loki.host"
    value = "http://${helm_release.grafana_loki.name}.${kubernetes_namespace.monitoring.id}:3100"
  }

  set {
    name  = "externalServices.loki.protocol"
    value = "loki"
  }

  set {
    name  = "externalServices.loki.authMode"
    value = "none"
  }

  # Grafana Tempo connection configs

  set {
    name  = "externalServices.tempo.host"
    value = "${helm_release.grafana_tempo.name}.${kubernetes_namespace.monitoring.id}:4317"
  }

  set {
    name  = "externalServices.tempo.protocol"
    value = "otlp"
  }

  set {
    name  = "externalServices.tempo.authMode"
    value = "none"
  }

  set {
    name  = "externalServices.tempo.tls.insecure"
    value = "true"
  }

  # Other configs

  set {
    name  = "traces.enabled"
    value = "true"
  }

  set {
    name  = "opencost.enabled"
    value = "false"
  }

  set {
    name  = "metrics.node-exporter.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-node-exporter.enabled"
    value = "false"
  }

  set {
    name  = "receivers.deployGrafanaAgentService"
    value = "false"
  }

  set {
    name  = "receivers.http.enabled"
    value = "false"
  }

  set {
    name  = "logs.pod_logs.gatherMethod"
    value = "api"
  }

  set {
    name  = "alloy-logs.controller.type"
    value = "deployment"
  }

  set {
    name  = "receivers.grpc.disable_debug_metrics"
    value = "false"
  }
}