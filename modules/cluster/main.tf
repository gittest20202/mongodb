data "azurerm_resource_group" "test" {
  name = var.resource_group_name
}

#data "azurerm_subnet" "test" {
#  name                 = var.subnet 
#  virtual_network_name = var.vnet
#  resource_group_name  = data.azurerm_resource_group.test.name
#}

data "azurerm_subnet" "test" {
  count                = length(var.subnet)
  name                 = var.subnet[count.index]
  virtual_network_name = var.vnet[count.index]
  resource_group_name  = data.azurerm_resource_group.test.name
}

resource "mongodbatlas_project" "project" {
  name   = "Global Cluster Poc"
  org_id = var.atlas_org_id
}

resource "mongodbatlas_cluster" "cluster" {
  for_each = { for idx, cluster in var.cluster_name : idx => cluster if cluster.cluster_type == "REPLICASET" }
  project_id                 = mongodbatlas_project.project.id
  name                       = each.value.cluster_name
  cluster_type               = each.value.cluster_type
  mongo_db_major_version     = each.value.mongo_db_major_version
  provider_instance_size_name  = each.value.instance_size_name
  provider_name = each.value.provider_name
  replication_specs {
      num_shards = each.value.num_shards
      regions_config {
        electable_nodes = 3
        priority        = 7
        read_only_nodes = 0
        region_name   = each.value.region_name
       }
  }   
}

resource "mongodbatlas_advanced_cluster" "cluster" {
  for_each = { for idx, config in var.cluster_name : idx => config  if config.cluster_type == "GEOSHARDED" }
  project_id             = mongodbatlas_project.project.id
  name                   = each.value.cluster_name
  cluster_type           = "GEOSHARDED"
  backup_enabled         = true
  mongo_db_major_version = each.value.mongo_db_major_version

  dynamic "replication_specs" {
    for_each = [each.value.replication_specs]
    content {
      zone_name  = replication_specs.value.zone_name
      num_shards = replication_specs.value.num_shards

      dynamic "region_configs" {
        for_each = [replication_specs.value.region_configs]
        content {
          provider_name = region_configs.value.provider_name
          region_name   = region_configs.value.region_name
          priority      = region_configs.value.priority

          dynamic "electable_specs" {
            for_each = [region_configs.value.electable_specs]
            content {
              instance_size = electable_specs.value.instance_size
              node_count    = electable_specs.value.node_count
            }
          }
        }
      }
    }
  }
}


output "project-id" {
  value = mongodbatlas_project.project.id
}