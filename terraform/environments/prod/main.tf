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
}
