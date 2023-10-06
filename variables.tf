variable "atlas_org_id" {
  description = "Atlas organization id"
  type        = string
  default = "650bc62cbf602f41ea61b424"
}
variable "public_key" {
  description = "Public API key to authenticate to Atlas"
  type        = string
  default = "fhxzivjz"
}
variable "private_key" {
  description = "Private API key to authenticate to Atlas"
  type        = string
  default = "6a781bbc-025f-4ac9-a147-62c1a12d2b3c"
}
variable "subscription_id" {
  default = "fee7b7ee-0390-4383-a392-3a90b8e633cb"
  type    = string
}
variable "tenant_id" {
  default = "b6e48814-eeb3-4969-916c-01d2f4743536"
  type    = string
}

variable "resource_group_name" {
  default = "rg-vnet"
  type = string
}

variable "subnet" {
  default = ["mongosubnet","mongosubnet1"]
  type    = list
}
variable "vnet" {
  default = ["vnet","vnet1"]
  type = list
}
  
 variable "geocluster_name" {
  description = "List of geo-cluster configurations"
  type        = list(object({
    cluster_name  = string
    cluster_type = string
    mongo_db_major_version = string
    replication_specs = object({
      zone_name  = string
      num_shards = number
      region_configs = object({
        provider_name = string
        region_name   = string
        priority      = number
        electable_specs = object({
          instance_size = string
          node_count    = number
        })
      })
    })
  }))
  default = [
    {
      cluster_name  = "GlobalCluster"
      cluster_type = "GEOSHARDED"
      mongo_db_major_version = "5.0"
      replication_specs = {
        zone_name     = "NASA"
        num_shards    = 1
        region_configs = {
          provider_name = "AZURE"
          region_name   = "US_EAST"
          priority      = 7
          electable_specs = {
            instance_size = "M30"
            node_count    = 3
          }
        }
      }
    },
    {
      cluster_name  = "GlobalCluster"
      cluster_type = "GEOSHARDED"
      mongo_db_major_version = "5.0"
      replication_specs = {
        zone_name     = "EMEA"
        num_shards    = 1
        region_configs = {
          provider_name = "AZURE"
          region_name   = "US_EAST_2"
          priority      = 7
          electable_specs = {
            instance_size = "M30"
            node_count    = 3
          }
        }
      }
    }
  ]
}

 variable "repcluster_name" {
  description = "List of region configurations"
  type        = list(object({
    cluster_name     = string
    cluster_type    = string
    mongo_db_major_version = string
    instance_size_name = string
    num_shards = number
    region_name = string
    electable_nodes = number
    priority        = number
    provider_name = string
    read_only_nodes = number
    })
  )
  default = [
    {
      cluster_name = "GlobalCluster"
      provider_name = "AZURE"
      cluster_type = "REPLICASET"
      mongo_db_major_version = "5.0"
      instance_size_name = "M10"
      num_shards = 1
      region_name = "US_EAST"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  ]
 }   

 variable "cluster_type" {
  default = "REPLICASET"
  type = string
 }