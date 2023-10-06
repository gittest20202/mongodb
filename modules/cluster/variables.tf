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
variable "cluster_name" {}
variable "subscription_id" {
  default = "fee7b7ee-0390-4383-a392-3a90b8e633cb"
  type    = string
}
variable "tenant_id" {
  default = "b6e48814-eeb3-4969-916c-01d2f4743536"
  type    = string
}
#ariable "region" {}
variable "resource_group_name" {
  type = string
}
variable "subnet" {
  type = list
}
variable "vnet" {
  type =list
}
