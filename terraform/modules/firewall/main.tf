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
  target_tags = ["allow-minecraft"]
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

resource "google_compute_firewall" "metrics" {
	name    = "allow-metrics"
	network = var.network_name
	project = var.project_id

	allow {
		protocol = "tcp"
		ports    = ["25565"]
	}
	
	source_ranges = [
		"35.191.0.0/16",
		"130.211.0.0/22"
	]

  target_tags = ["allow-metrics"]	
}
