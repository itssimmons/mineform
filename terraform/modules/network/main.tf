resource "google_compute_network" "minecraft_vpc" {
  name = var.network_name
	project = var.project_id
	auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "minecraft_subnet" {
	name          = "${var.network_name}-subnet"
 	ip_cidr_range = "10.10.0.0/24"
  project       = var.project_id

	network       = google_compute_network.minecraft_vpc.id
	region 				= var.region
	
	private_ip_google_access = true
}
