data "azurerm_resource_group" "test" {
  name = var.resource_group_name
}

data "azurerm_subnet" "test" {
  count                = length(var.subnet)
  name                 = var.subnet[count.index]
  virtual_network_name = var.vnet[count.index]
  resource_group_name  = data.azurerm_resource_group.test.name
}

data "mongodbatlas_advanced_cluster" "cluster" {
  for_each = { for idx, cluster in var.cluster_name : idx => cluster }
  project_id = var.project-id
  name       = each.value.cluster_name
}

resource "mongodbatlas_privatelink_endpoint" "test" {
  for_each = { for idx, cluster in var.cluster_name : idx => cluster }
  project_id    = var.project-id
  provider_name = "AZURE"
  region        = each.value.replication_specs.region_configs.region_name
}

resource "azurerm_private_endpoint" "test" {
  count                = length(var.subnet)
  name                = "endpoint-test-${count.index}"
  location            = data.azurerm_resource_group.test.location
  resource_group_name = data.azurerm_resource_group.test.name
  subnet_id           = data.azurerm_subnet.test[count.index].id
  private_service_connection {
    name                           = mongodbatlas_privatelink_endpoint.test[count.index].private_link_service_name
    private_connection_resource_id = mongodbatlas_privatelink_endpoint.test[count.index].private_link_service_resource_id
    is_manual_connection           = true
    request_message                = "Azure Private Link test"
  }
}

resource "mongodbatlas_privatelink_endpoint_service" "test" {
  count  = length(var.subnet)
  project_id = var.project-id
  #for_each = { for id, end in mongodbatlas_privatelink_endpoint.test : id => end }
  #private_link_id             = each.value.private_link_id
  private_link_id             = mongodbatlas_privatelink_endpoint.test[count.index].private_link_id
  #for_each = { for idx, endpoint in azurerm_private_endpoint.test : idx => endpoint }
  #private_link_id             = mongodbatlas_privatelink_endpoint.test.private_link_id
  #endpoint_service_id         = each.value.id
  #private_endpoint_ip_address = each.value.private_service_connection[0].private_ip_address
  endpoint_service_id         = azurerm_private_endpoint.test[count.index].id
  private_endpoint_ip_address = azurerm_private_endpoint.test[count.index].private_service_connection[0].private_ip_address
  provider_name               = "AZURE"
}