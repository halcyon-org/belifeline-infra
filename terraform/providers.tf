terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.45.0"
    }
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
  zone    = local.zone
}
