output "instance_name" {
  description = "The name of the instance"
  value       = google_compute_instance.default.name
}

output "instance_zone" {
  description = "The zone where the instance is deployed"
  value       = google_compute_instance.default.zone
}

output "instance_self_link" {
  description = "The self-link of the instance"
  value       = google_compute_instance.default.self_link
}

output "instance_external_ip" {
  description = "The external IP address of the instance"
  value       = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
