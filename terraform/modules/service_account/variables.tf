variable "project_id" {
	description = "The ID of the GCP project where the resources will be created."
	type        = string
}

variable "bucket_name" {
	description = "The name of the S3 bucket to create."
	type        = string
}
