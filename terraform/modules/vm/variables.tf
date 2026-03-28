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
	default     = "us-central1-a"
}

variable "project_id" {
	description = "The ID of the GCP project where the resources will be created."
	type        = string
}
