terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.25.0"
    }
  }
}

provider "google" {
  project = var.gcp.project_id
  region  = var.gcp.region
  zone    = var.gcp.zone
}
