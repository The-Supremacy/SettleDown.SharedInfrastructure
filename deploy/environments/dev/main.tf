locals {
  env = "dev"
}

resource "azurerm_resource_group" "acr_rg" {
  name     = "rg-settledown-shared-${local.env}-ne-001"
  location = "North Europe"
  tags = {
    Area = "Shared"
  }
}

module "shared_infra" {
  source   = "../../modules/shared_infrastructure"
  rg_name  = azurerm_resource_group.acr_rg.name
  env      = local.env
  location = azurerm_resource_group.acr_rg.location
}