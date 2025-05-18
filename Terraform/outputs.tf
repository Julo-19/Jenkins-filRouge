output "frontend_url" {
  description = "URL pour accéder au frontend"
  value       = "http://${var.minikube_ip}:30517"
}
