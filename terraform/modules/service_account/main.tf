data "google_compute_default_service_account" "default" {
	project = var.project_id
}

resource "google_service_account" "sa" {
  account_id   = "minecraft-service-account"
	project      = var.project_id
  display_name = "Service Account"
}

resource "google_service_account_iam_member" "default-account-iam" {
	service_account_id = google_service_account.sa.name
	role               = "roles/iam.serviceAccountUser"
	member             = "serviceAccount:${google_service_account.sa.email}"
}
