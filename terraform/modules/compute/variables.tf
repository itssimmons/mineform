variable "network_name" {
	description = "The name of the VPC network to create."
	type        = string
	default     = "minecraft-network"
}

variable "instance_name" {
	description = "The name of the Compute Engine instance to create."
	type        = string
	default     = "minecraft-server"
}

variable "machine_type" {
	description = "The machine type to use for the Compute Engine instance."
	type        = string
	default     = "e2-medium"
}

variable "zone" {
	description = "The zone to deploy the Compute Engine instance."
	type        = string
}

variable "project_id" {
	description = "The ID of the GCP project where the resources will be created."
	type        = string
}

variable "service_account_email" {
	description = "The email of the service account to attach to the Compute Engine instance."
	type        = string
}

variable "bucket_name" {
	description = "The name of the GCS bucket to use for storing Minecraft data."
	type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to attach to the Compute Engine instance."
  type        = string
}
