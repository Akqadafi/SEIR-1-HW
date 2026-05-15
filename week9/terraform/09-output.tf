output "vpc_name" {
  description = "The name of the VPC network."
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = google_compute_subnetwork.fortress.name
}

output "instance_template_name" {
    description = "The name of the instance template."
    value       = google_compute_instance_template.Instance_Template01.name
}

output "instance_group_manager_name" {
    description = "The name of the instance group manager."
    value       = google_compute_instance_group_manager.instance_group_manager01.name
}

output "instance_group_manager_group" {
    description = "The name of the instance group."
    value       = google_compute_instance_group_manager.instance_group_manager01.instance_group
}

output "health_check_name" {
    description = "The name of the health check."
    value       = google_compute_health_check.hc01.name
}