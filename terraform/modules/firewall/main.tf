resource "google_compute_firewall" "minecraft" {
  name    = "allow-minecraft"
  network = var.network_name
  
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  allow {
    protocol = "udp"
    ports    = ["25565"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["minecraft-server"]
}

resource "google_compute_firewall" "ssh" {
	name    = "allow-ssh"
	network = var.network_name
	
	project = var.project_id

	allow {
		protocol = "tcp"
		ports    = ["22"]
	}
	
	source_ranges = ["0.0.0.0/0"]
	target_tags = ["allow-ssh"]
}

resource "google_compute_firewall" "icmp" {
	name    = "allow-icmp"
	network = var.network_name
	
	project = var.project_id

	allow {
		protocol = "icmp"
	}
	
	source_ranges = ["0.0.0.0/0"]
	target_tags = ["allow-icmp"]
}
