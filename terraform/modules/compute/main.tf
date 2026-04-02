resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  project = var.project_id
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-ssd"
      size  = 10
    }
  }
  
  tags = ["allow-minecraft", "allow-ssh", "allow-metrics"]

  network_interface {
    subnetwork = var.subnet_id
    access_config {} # Gives public IP
  }
  
  metadata_startup_script = file("${path.module}/scripts/startup.sh")

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  
  metadata = {
    bucket_name      = var.bucket_name
  }
}

# resource "google_compute_health_check" "minecraft-health-check" {
# 	name    = "minecraft-health-check"
# 	project = var.project_id

# 	check_interval_sec   = 60
# 	timeout_sec          = 10
# 	unhealthy_threshold  = 3
# 	healthy_threshold    = 1

# 	tcp_health_check {
# 		port = "25565"
# 	}
# }
