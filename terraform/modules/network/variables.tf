variable "network_name" {
	description = "The name of the VPC network to create."
	type        = string
	default     = "minecraft-network"
}

variable "project_id" {
	description = "The ID of the GCP project where the firewall rule will be created."
	type        = string	
}
