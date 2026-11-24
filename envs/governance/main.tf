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
    key              = "governance.tfstate"
    use_oidc         = true
    use_azuread_auth = true
  }
}

# Subscription, tenant and client IDs come from ARM_* environment variables.
provider "azurerm" {
  features {}
  use_oidc = true
}

variable "subscription_id" {
  description = "Subscription the budget applies to."
  type        = string
}

variable "alert_email" {
  description = "Address that receives budget alerts."
  type        = string
}

variable "monthly_budget" {
  description = "Monthly budget in the billing currency of the subscription."
  type        = number
  default     = 200
}

resource "azurerm_consumption_budget_subscription" "monthly" {
  name            = "budget-monthly"
  subscription_id = "/subscriptions/${var.subscription_id}"

  amount     = var.monthly_budget
  time_grain = "Monthly"

  time_period {
    start_date = "2026-11-01T00:00:00Z"
  }

  # Actual spend: early warning and a hard signal.
  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }

  notification {
    enabled        = true
    threshold      = 90
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email]
  }

  # Forecast: warns before the money is spent.
  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = [var.alert_email]
  }
}
