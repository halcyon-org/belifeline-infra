terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }

  backend "gcs" {
    bucket = "vaulted-zodiac-431004-s7-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
  zone    = local.zone
}
