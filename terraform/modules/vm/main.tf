resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone				 = var.zone
  
  project = var.project_id
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 30
    }
  }
  
  tags = ["minecraft-server", "allow-ssh", "allow-icmp"]

  network_interface {
    network = var.network_name
    
    access_config {
    	 # Ephemeral public IP
    }
  }
  
  # metadata_startup_script = file("${path.module}/scripts/startup.sh")
	metadata = {
		serial-port-enable = "TRUE"
	}

	service_account {
		email  = var.service_account_email
		scopes = ["https://www.googleapis.com/auth/cloud-platform"]
	}
}
