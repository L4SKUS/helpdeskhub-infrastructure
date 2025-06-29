resource "kubernetes_ingress_class_v1" "ingressclass_alb" {
  depends_on = [null_resource.apply_ingressclassparams_manifest]
  metadata {
    name = "ingressclass-alb"

    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }

  spec {
    controller = "eks.amazonaws.com/alb"
    parameters {
      api_group = "eks.amazonaws.com"
      kind      = "IngressClassParams"
      name      = "ingressclassparams-alb"
    }
  }
}

# resource "null_resource" "apply_ingressclassparams_manifest" {
#   provisioner "local-exec" {
#     command = <<EOT
#     aws eks --region eu-central-1 update-kubeconfig --name helpdeskhub-eks-cluster
#     kubectl apply -f - <<EOF
# apiVersion: eks.amazonaws.com/v1
# kind: IngressClassParams
# metadata:
#   name: "ingressclassparams-alb"
# spec:
#   scheme: internet-facing
# EOF
#     EOT
#   }
# }

resource "null_resource" "apply_ingressclassparams_manifest" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOT
aws eks --region eu-central-1 update-kubeconfig --name helpdeskhub-eks-cluster;
@"
apiVersion: eks.amazonaws.com/v1
kind: IngressClassParams
metadata:
  name: "ingressclassparams-alb"
spec:
  scheme: internet-facing
"@ | kubectl apply -f -
EOT
  }
}


resource "kubernetes_ingress_v1" "ingress_alb" {
  metadata {
    name      = "ingress-alb"
    namespace = "default"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
    }
  }

  spec {
    ingress_class_name = "ingressclass-alb"

    rule {
      http {
        path {
          path      = "/api/users"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.helpdeskhub_user_service.metadata[0].name
              port {
                number = 8081
              }
            }
          }
        }
        path {
          path      = "/api/tickets"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.helpdeskhub_ticket_service.metadata[0].name
              port {
                number = 8082
              }
            }
          }
        }
        path {
          path      = "/api/auth"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.helpdeskhub_auth_service.metadata[0].name
              port {
                number = 8083
              }
            }
          }
        }
        path {
          path      = "/api/comments"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.helpdeskhub_comment_service.metadata[0].name
              port {
                number = 8084
              }
            }
          }
        }
        path {
          path      = "/api/notifications"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.helpdeskhub_notification_service.metadata[0].name
              port {
                number = 8085
              }
            }
          }
        }
      }
    }
  }
}

# helpdeskhub-user-service
resource "kubernetes_deployment_v1" "helpdeskhub_user_service" {
  metadata {
    name = "helpdeskhub-user-service"
    labels = {
      app = "helpdeskhub-user-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helpdeskhub-user-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "helpdeskhub-user-service"
        }
      }

      spec {
        container {
          image = "laskus/helpdeskhub-user-service:latest"
          name  = "helpdeskhub-user-service"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "helpdeskhub_user_service" {
  metadata {
    name      = "helpdeskhub-user-service"
    namespace = "default"
    labels = {
      app = "helpdeskhub-user-service"
    }
  }

  spec {
    selector = {
      app = "helpdeskhub-user-service"
    }

    port {
      port        = 8081
      target_port = 8081
    }

    type = "ClusterIP"
  }
}

# helpdeskhub-ticket-service
resource "kubernetes_deployment_v1" "helpdeskhub_ticket_service" {
  metadata {
    name = "helpdeskhub-ticket-service"
    labels = {
      app = "helpdeskhub-ticket-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helpdeskhub-ticket-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "helpdeskhub-ticket-service"
        }
      }

      spec {
        container {
          image = "laskus/helpdeskhub-ticket-service:latest"
          name  = "helpdeskhub-ticket-service"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "helpdeskhub_ticket_service" {
  metadata {
    name      = "helpdeskhub-ticket-service"
    namespace = "default"
    labels = {
      app = "helpdeskhub-ticket-service"
    }
  }

  spec {
    selector = {
      app = "helpdeskhub-ticket-service"
    }

    port {
      port        = 8082
      target_port = 8082
    }

    type = "ClusterIP"
  }
}

# helpdeskhub-auth-service
resource "kubernetes_deployment_v1" "helpdeskhub_auth_service" {
  metadata {
    name = "helpdeskhub-auth-service"
    labels = {
      app = "helpdeskhub-auth-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helpdeskhub-auth-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "helpdeskhub-auth-service"
        }
      }

      spec {
        container {
          image = "laskus/helpdeskhub-auth-service:latest"
          name  = "helpdeskhub-auth-service"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "helpdeskhub_auth_service" {
  metadata {
    name      = "helpdeskhub-auth-service"
    namespace = "default"
    labels = {
      app = "helpdeskhub-auth-service"
    }
  }

  spec {
    selector = {
      app = "helpdeskhub-auth-service"
    }

    port {
      port        = 8083
      target_port = 8083
    }

    type = "ClusterIP"
  }
}

# helpdeskhub-comment-service
resource "kubernetes_deployment_v1" "helpdeskhub_comment_service" {
  metadata {
    name = "helpdeskhub-comment-service"
    labels = {
      app = "helpdeskhub-comment-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helpdeskhub-comment-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "helpdeskhub-comment-service"
        }
      }

      spec {
        container {
          image = "laskus/helpdeskhub-comment-service:latest"
          name  = "helpdeskhub-comment-service"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "helpdeskhub_comment_service" {
  metadata {
    name      = "helpdeskhub-comment-service"
    namespace = "default"
    labels = {
      app = "helpdeskhub-comment-service"
    }
  }

  spec {
    selector = {
      app = "helpdeskhub-comment-service"
    }

    port {
      port        = 8084
      target_port = 8084
    }

    type = "ClusterIP"
  }
}

# helpdeskhub-notification-service
resource "kubernetes_deployment_v1" "helpdeskhub_notification_service" {
  metadata {
    name = "helpdeskhub-notification-service"
    labels = {
      app = "helpdeskhub-notification-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "helpdeskhub-notification-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "helpdeskhub-notification-service"
        }
      }

      spec {
        container {
          image = "laskus/helpdeskhub-notification-service:latest"
          name  = "helpdeskhub-notification-service"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "helpdeskhub_notification_service" {
  metadata {
    name      = "helpdeskhub-notification-service"
    namespace = "default"
    labels = {
      app = "helpdeskhub-notification-service"
    }
  }

  spec {
    selector = {
      app = "helpdeskhub-notification-service"
    }

    port {
      port        = 8085
      target_port = 8085
    }

    type = "ClusterIP"
  }
}
