resource "azurerm_app_configuration" "app_config" {
  name                  = var.app_config_name
  resource_group_name   = var.rg_name
  location              = var.location
  sku                   = "free"
  local_auth_enabled    = true
  public_network_access = "Enabled"
  tags = {
    Area        = "Shared infrastructure"
    Environment = "Dev"
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_app_configuration.app_config.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = var.shared_identity_principal_id
}