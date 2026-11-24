terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # resource_group_name and storage_account_name are passed with
  # -backend-config at init time (see .github/workflows/terraform.yml).
  backend "azurerm" {
    container_name   = "tfstate"
    key              = "prod.tfstate"
    use_oidc         = true
    use_azuread_auth = true
  }
}

# Subscription, tenant and client IDs come from ARM_* environment variables.
provider "azurerm" {
  features {}
  use_oidc = true
}

module "network" {
  source = "../../modules/hub-spoke"

  name              = "prod"
  location          = "norwayeast"
  hub_address_space = "10.20.0.0/16"

  spokes = {
    app  = "10.21.0.0/16"
    data = "10.22.0.0/16"
  }

  tags = {
    environment = "prod"
    project     = "azure-network-foundation"
    managed_by  = "terraform"
  }
}
