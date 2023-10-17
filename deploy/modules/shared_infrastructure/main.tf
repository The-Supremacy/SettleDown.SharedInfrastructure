resource "azurerm_user_assigned_identity" "shared_identity" {
  location            = var.location
  name                = "id-settledown-shared-${var.env}-001"
  resource_group_name = var.rg_name
}

module "key_vault" {
  source                       = "../keyvault"
  rg_name                      = var.rg_name
  key_vault_name               = "kv-settledown-${var.env}-001"
  location                     = var.location
  shared_identity_principal_id = azurerm_user_assigned_identity.shared_identity.principal_id
}

module "app_config" {
  source                       = "../app_configuration"
  rg_name                      = var.rg_name
  app_config_name              = "appcs-settledown-${var.env}-001"
  location                     = var.location
  shared_identity_principal_id = azurerm_user_assigned_identity.shared_identity.principal_id
}

module "log_analytics_workspace" {
  source                       = "../log_analytics_workspace"
  rg_name                      = var.rg_name
  log_analytics_workspace_name = "log-settledown-cae-${var.env}-001"
  location                     = var.location
}

module "aca_env" {
  source                     = "../aca_environment"
  rg_name                    = var.rg_name
  location                   = var.location
  cae_name                   = "cae-settledown-${var.env}-001"
  ai_name                    = "appi-settledown-${var.env}-001"
  log_workspace_workspace_id = module.log_analytics_workspace.log_id

  depends_on = [
    module.log_analytics_workspace
  ]
}