terraform {
  required_version = ">=0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-settledown-tfstate-shd-ne-001"
    storage_account_name = "stsdtfstateshdne001"
    container_name       = "tfstate-dev"
    key                  = "sharedinfra.terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.dev_subscription_id
  features {}
}

provider "azurerm" {
  subscription_id = var.shared_subscription_id
  alias           = "shared"
  features {}
}