output "vpc_name" {
  description = "The name of the VPC network in GCP"
  value       = google_compute_network.vpc_network.name
}