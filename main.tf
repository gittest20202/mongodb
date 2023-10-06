module "cluster" {
    source = "./modules/cluster"
    resource_group_name = var.resource_group_name
    subnet = var.subnet
    vnet = var.vnet
    cluster_name = local.cluster_name
    #region = var.region
}
module "azurelink" {
    source = "./modules/azurelink"
    resource_group_name = var.resource_group_name
    subnet = var.subnet
    vnet = var.vnet
    cluster_name = local.cluster_name
    #region_name = var.region_name
    project-id = module.cluster.project-id
}
locals {
  #cluster_name = var.cluster_type == "GEOSHARDED" ? var.repcluster_name : var.geocluster_name
  cluster_name = var.geocluster_name
  #cluster_name = [for cluster in var.repcluster_name : cluster if cluster.cluster_type == "GEOSHARDED"]
}