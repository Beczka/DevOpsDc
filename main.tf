locals {
  common_tags = {
    Tool = "Terraform"
  }
}

provider "azurerm" {
  version         = "~> 1.9.0"
  subscription_id = ""
  client_id       = ""
  tenant_id       = ""
}

terraform {
  backend "azurerm" {
    storage_account_name = "terraformsettings"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    resource_group_name  = "terraform-westeurope"
    arm_subscription_id  = ""
    arm_client_id        = ""
    arm_tenant_id        = ""
  }
}

module "dev-env" {
  source        = "./envs/dev"
  region        = "WestEurope"
  common_tags   = "${local.common_tags}"
  address_space = "10.0.0.0/16"
  env           = "Dev"
}