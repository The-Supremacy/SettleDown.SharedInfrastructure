module "key_vault" {
  source         = "../keyvault"
  rg_name        = var.rg_name
  key_vault_name = "kv-settledown-${var.env}-001"
  location       = var.location
}

module "app_config" {
  source          = "../app_configuration"
  rg_name         = var.rg_name
  app_config_name = "appcs-settledown-${var.env}-001"
  location        = var.location
}

module "log_analytics_workspace" {
  source                       = "../log_analytics_workspace"
  rg_name                      = var.rg_name
  log_analytics_workspace_name = "log-settledown-${var.env}-001"
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