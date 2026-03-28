module "network" {
  source     = "../../modules/network"
  project_id = var.project_id
}

module "firewall" {
  source     = "../../modules/firewall"
  project_id = var.project_id
}

module "vm" {
  source     = "../../modules/vm"
  project_id = var.project_id
  network_name = module.network.network_name
  service_account_email = module.service_account.email
}

module "service_account" {
	source     = "../../modules/service_account"
	project_id = var.project_id
}
