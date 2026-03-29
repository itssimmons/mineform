variable "project_id" {
  description = "The ID of the GCP project where resources will be created."
  type        = string
}

variable "bucket_name" {
	description = "The name of the S3 bucket to create."
	type        = string
	default     = "mineform-data"
}

variable "bucket_location" {
	description = "The location where the bucket will be created."
	type        = string
}
