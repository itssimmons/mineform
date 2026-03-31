resource "google_storage_bucket" "bucket" {
	name          = var.bucket_name
	location      = var.bucket_location
	project       = var.project_id
	
	force_destroy = true

	lifecycle_rule {
		action {
			type = "Delete"
		}
		condition {
			age = 1
		}
	}
}

resource "google_storage_bucket_object" "startup_files" {
	for_each = fileset("${path.module}/config", "**")
	
	name   = each.value
	bucket = google_storage_bucket.bucket.name
	source = "${path.module}/config/${each.value}"
	
	depends_on = [google_storage_bucket.bucket]
}

resource "google_storage_bucket_object" "upload_world" {
  for_each = fileset("${path.module}/data", "**")

  name   = "data/${each.value}"
  bucket = google_storage_bucket.bucket.name
  source = "${path.module}/data/${each.value}"

  depends_on = [google_storage_bucket.bucket]
}
