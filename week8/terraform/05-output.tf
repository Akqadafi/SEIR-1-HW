output "vm_internal_ip" {
  description = "The internal private IP address of the VM."
  value       = google_compute_instance.centos_vm.network_interface[0].network_ip
}

output "vm_external_ip" {
  description = "The external public IP address of the VM."
  value       = google_compute_instance.centos_vm.network_interface[0].access_config[0].nat_ip
}

output "vm_name" {
  description = "The name of the VM."
  value       = google_compute_instance.centos_vm.name
}

output "vm_id" {
  description = "The ID of the VM."
  value       = google_compute_instance.centos_vm.id
}

output "vm_self_link" {
  description = "The self link of the VM."
  value       = google_compute_instance.centos_vm.self_link
}