
resource "google_compute_instance" "default" {
  name         = "sevpn"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "user:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ+Vh84iPZs3O/cKdfWJR4uZKkPG9pxXXIOr9DKxoMr"
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  service_account {
    email  = local.compute_sa_email
    scopes = ["cloud-platform"]
  }

  tags = ["web"]
}

# Allow HTTPS only from 103.2.36.0/22
resource "google_compute_firewall" "allow_https_specific" {
  name    = "allow-https-specific"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["103.2.36.0/22"]
  target_tags   = ["web"]
}

# Deny HTTPS from other IPs
resource "google_compute_firewall" "deny_https_others" {
  name    = "deny-https-others"
  network = "default"

  deny {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
  priority      = 1000
}
