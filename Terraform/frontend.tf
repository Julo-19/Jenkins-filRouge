resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "front-app"
    labels = {
      app = "front-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "front-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "front-app"
        }
      }

      spec {
        container {
          name  = "frontend-container"
          image = "julo1997/stp"  # Assure-toi que c’est bien l’image correcte
          port {
            container_port = 80
          }
          image_pull_policy = "Always"
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "front-service"
  }

  spec {
    selector = {
      app = "front-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
