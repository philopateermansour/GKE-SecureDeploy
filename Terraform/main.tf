module "network" {
  source = "./modules/network"
  region = var.region
  project = var.project_id
}
module "compute" {
  source = "./modules/compute"
  zone = var.zone
  machine_type = var.machine_type
  management_subnet_id = module.network.management_subnet_id 
  project_id = var.project_id
}
module "gke" {
  source = "./modules/gke"
  cluster_name = var.cluster_name
  cluster_location = var.cluster_location
  node_pool_name = var.node_pool_name
  management_cidr = module.network.management_cidr
  restricted_subnet_id = module.network.restricted_subnet_id
  project_id = var.project_id 
  vpc_name = module.network.vpc_name
}
module "security" {
  source = "./modules/security"
  vpc_name = module.network.vpc_name
  management_cidr = module.network.management_cidr
  restricted_cidr = module.network.restricted_cidr
}
module "artifact" {
  source = "./modules/artifact" 
}
