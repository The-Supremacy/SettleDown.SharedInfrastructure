locals {
  shared_identity_name         = "id-settledown-shared-${var.env}-001"
  key_vault_name               = "kv-settledown-${var.env}-001"
  app_config_name              = "appcs-settledown-${var.env}-001"
  log_analytics_workspace_name = "log-settledown-cae-${var.env}-001"
  ca_environment_name          = "cae-settledown-${var.env}-001"
  ca_environment_ai_name       = "appi-settledown-${var.env}-001"
  tags = {
    Area        = "Shared infrastructure"
    Environment = title(var.env)
  }
}

resource "azurerm_user_assigned_identity" "shared_identity" {
  location            = var.location
  name                = local.shared_identity_name
  resource_group_name = var.rg_name

}

module "key_vault" {
  source                       = "github.com/The-Supremacy/SettleDown.InfrastructureModules//keyvault"
  rg_name                      = var.rg_name
  key_vault_name               = local.key_vault_name
  location                     = var.location
  shared_identity_principal_id = azurerm_user_assigned_identity.shared_identity.principal_id
  tags                         = local.tags
}

module "app_config" {
  source                       = "github.com/The-Supremacy/SettleDown.InfrastructureModules//app_configuration"
  rg_name                      = var.rg_name
  app_config_name              = local.app_config_name
  location                     = var.location
  shared_identity_principal_id = azurerm_user_assigned_identity.shared_identity.principal_id
  tags                         = local.tags  
}

module "log_analytics_workspace" {
  source                       = "github.com/The-Supremacy/SettleDown.InfrastructureModules//log_analytics_workspace"
  rg_name                      = var.rg_name
  log_analytics_workspace_name = local.log_analytics_workspace_name
  location                     = var.location
  tags                         = local.tags
}

module "aca_env" {
  source                     = "github.com/The-Supremacy/SettleDown.InfrastructureModules//aca_environment"
  rg_name                    = var.rg_name
  location                   = var.location
  cae_name                   = local.ca_environment_name
  ai_name                    = local.ca_environment_ai_name
  log_workspace_workspace_id = module.log_analytics_workspace.log_id
  tags                       = local.tags

  depends_on = [
    module.log_analytics_workspace
  ]
}