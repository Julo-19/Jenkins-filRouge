resource "kubernetes_deployment" "backend" {
  metadata {
    name = "django-backend"
    labels = {
      app = "django"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "django"
      }
    }

    template {
      metadata {
        labels = {
          app = "django"
        }
      }

      spec {
        container {
          name  = "django"
          image = "julo1997/samabackend" # Modifie par l'image Docker que tu as build
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "django-service"
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 8000
      target_port = 8000
    }

    type = "NodePort"
  }
}
