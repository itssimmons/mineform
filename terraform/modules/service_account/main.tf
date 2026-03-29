data "google_compute_default_service_account" "default" {
	project = var.project_id
}

resource "google_service_account" "sa" {
  account_id   = "minecraft-service-account"
	project      = var.project_id
  display_name = "Service Account"
}

resource "google_project_iam_member" "secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.sa.email}"
}
