module "dapr_ai" {
  source           = "../application_insights_loganalytics"
  rg_name          = var.rg_name
  location         = var.location
  ai_name          = var.ai_name
  log_workspace_id = var.log_workspace_workspace_id
}

resource "azurerm_container_app_environment" "cae" {
  name                                        = var.cae_name
  resource_group_name                         = var.rg_name
  location                                    = var.location
  log_analytics_workspace_id                  = var.log_workspace_workspace_id
  dapr_application_insights_connection_string = module.dapr_ai.ai_connection_string

  tags = {
    Area        = "Shared infrastructure"
    Environment = "Dev"
  }

  depends_on = [
    module.dapr_ai
  ]
}