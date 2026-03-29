output "network_name" {
	value = google_compute_network.minecraft_vpc.name	
}

output "subnet_id" {
  value = google_compute_subnetwork.minecraft_subnet.id
}
