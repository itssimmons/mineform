variable "network_name" {
	description = "The name of the VPC network to create."
	type        = string
	default     = "minecraft-network"
}

variable "project_id" {
	description = "The ID of the project in which to create the resources."
	type        = string
}
