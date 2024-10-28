resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "server.extraFlags[0]"
    value = "web.enable-lifecycle"
  }

  set {
    name  = "server.extraFlags[1]"
    value = "web.enable-remote-write-receiver"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-node-exporter.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-pushgateway.enabled"
    value = "false"
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = "true"
  }
#   set {
#     name = "extraScrapeConfigs"
#     value = <<EOF
# - job_name: 'fastapi'
#   scrape_interval: 10s
#   metrics_path: /metrics
#   static_configs:
#     - targets: ['fastapi-demo-fastapi-monitor-demo.default:8000']
# EOF
#   }
}


resource "helm_release" "grafana_loki" {
  name       = "loki"
  chart      = "loki"
  repository = "https://grafana.github.io/helm-charts"
  version    = "6.5.2"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Install Loki in monolithic mode with filesystem storage
  # Reference: https://grafana.com/docs/loki/latest/setup/install/helm/install-monolithic
  values = [
    yamlencode({
      "deploymentMode" : "SingleBinary",
      "loki" : {
        "commonConfig" : {
          "replication_factor" : 1
        },
        "storage" : {
          "type" : "filesystem"
        },
        "schemaConfig" : {
          "configs" : [
            {
              "from" : "2024-01-01",
              "store" : "tsdb",
              "index" : {
                "prefix" : "loki_index_",
                "period" : "24h",
              },
              "object_store" : "filesystem",
              "schema" : "v13"
            }
          ]
        },
        "memcached" : {
          "chunk_cache" : {
            "enabled" : false,
          },
          "results_cache" : {
            "enabled" : false,
          }
        },
      },
      "singleBinary" : {
        replicas : 1
      },
      "read" : {
        replicas : 0
      },
      "backend" : {
        replicas : 0
      },
      "write" : {
        replicas : 0
      },
      }
    )
  ]

  set {
    name  = "loki.auth_enabled"
    value = "false"
  }

  set {
    name  = "lokiCanary.enabled"
    value = "false"
  }

  set {
    name  = "test.enabled"
    value = "false"
  }

  set {
    name  = "gateway.enabled"
    value = "false"
  }

  set {
    name  = "resultsCache.enabled"
    value = "false"
  }

  set {
    name  = "chunksCache.enabled"
    value = "false"
  }
}


resource "helm_release" "grafana_tempo" {
  name       = "tempo"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "tempo.reportingEnabled"
    value = "false"
  }

  set {
    name  = "tempo.metricsGenerator.enabled"
    value = "true"
  }

  set {
    name  = "tempo.metricsGenerator.remoteWriteUrl"
    value = "http://${helm_release.prometheus.name}-server.monitor/api/v1/write"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }
}