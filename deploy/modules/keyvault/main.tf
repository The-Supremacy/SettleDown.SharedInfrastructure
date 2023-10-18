data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.rg_name
  enabled_for_disk_encryption     = false
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 90
  purge_protection_enabled        = false
  enable_rbac_authorization       = true
  enabled_for_template_deployment = true

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = {
    Area        = "Shared infrastructure"
    Environment = "Dev"
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.shared_identity_principal_id
}