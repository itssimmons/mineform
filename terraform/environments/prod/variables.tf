variable "project_id" {
  description = "The ID of the GCP project where the resources will be created."
  type        = string
}

variable "gcp" {
  type = object({
    project_id = string
    region     = string
    zone       = string
  })
}
