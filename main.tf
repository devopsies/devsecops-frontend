# Where to store the state
terraform {
  backend "remote" {
    organization = "devopsies"

    workspaces {
      name = "devsecops-frontend"
    }
  }
}

# from where to allocate resources
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
}

resource "kubernetes_deployment" "front-app-deployment-tf" {
  metadata {
    name = "front-app-deployment"
    labels = {
      app = "front-app"
    }
  }

  spec {
    replicas = 3

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
          image = "mdnfiras/front-app"
          name  = "front-app"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          port{
              container_port = "80"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "front-app-service-tf" {
  metadata {
    name = "front-app-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.front-app-deployment-tf.spec.0.template.0.metadata.0.labels.app
    }
    
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

