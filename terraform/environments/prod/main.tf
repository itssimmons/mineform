module "bucket" {
  source = "../../modules/bucket"

  project_id      = var.project_id
  bucket_name     = var.bucket_name
  bucket_location = var.gcp.region
}

module "compute" {
  source = "../../modules/compute"

  project_id            = var.project_id
  zone                  = var.gcp.zone
  service_account_email = module.service_account.email
  network_name          = module.network.network_name
  bucket_name           = module.bucket.bucket_name
  subnet_id             = module.network.subnet_id
}

module "firewall" {
  source = "../../modules/firewall"

  project_id   = var.project_id
  network_name = module.network.network_name
}

module "network" {
  source = "../../modules/network"

  project_id = var.project_id
  region     = var.gcp.region
}

module "service_account" {
  source = "../../modules/service_account"

  project_id  = var.project_id
  bucket_name = module.bucket.bucket_name
}
