module "keyVault" {
    source = "../keyvault"
    rg_name = var.rg_name
    key_vault_name = "kv-settledown-${var.env}-001"
    location = var.location
}