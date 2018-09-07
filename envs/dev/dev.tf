locals {
  common_tags = "${merge(
        var.common_tags,
        map(
            "Environment", "${var.env}"
        )
    )}"
  env_prefix = "${lower(var.env)}"
  region_lower = "${lower(var.region)}"
}

resource "azurerm_resource_group" "env_resource_group" {
  name     = "${local.env_prefix}-${local.region_lower}"
  location = "${var.region}"
}

module "kv" {
  source              = "../../modules/kv/create_kv"
  name                = "${local.env_prefix}-dc-kv"
  region              = "${var.region}"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  tags                = "${local.common_tags}"
  # optional if you plan to use azure ad
  operation_ad_group  = "9d279d10-48f0-4258-9065-bc43c8441be5"
}

module "automation-account" {
  source              = "../../modules/automation_account"
  name                = "${local.env_prefix}-dc-automation"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  sku = "basic"
  vault_id           =  "${module.kv.vault_id}"
}

module "dsc" {
  source              = "../../modules/dsc"
  automationAccountId =  "${module.automation-account.automation_account_id}"
}

module "common-network-nsg" {
  source = "../../modules/network/nsg/common"
}

module "vnet" {
  source              = "../../modules/network/vnet"
  name                = "${local.env_prefix}-vnet"
  address_space       = "${var.address_space}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
}

module "mirror-check-subnet" {
  source               = "../../modules/network/subnet"
  region               = "${var.region}"
  tags                 = "${local.common_tags}"
  name                 = "${local.env_prefix}-mirror-check-subnet"
  address_prefix       = "${cidrsubnet(var.address_space, 13, 0)}"
  virtual_network_name = "${module.vnet.vnet_name}"
  resource_group_name  = "${azurerm_resource_group.env_resource_group.name}"
  service_endpoints =  ["Microsoft.Sql"]

  nsg_rules = [
    "${module.common-network-nsg.nsg_rules["allow_http_rule"]}",
    "${module.common-network-nsg.nsg_rules["allow_https_rule"]}",
    "${module.common-network-nsg.nsg_rules["allow_rdp_rule"]}",
    "${module.common-network-nsg.nsg_rules["allow_winrm"]}",
  ]
}

module "service-fabric-subnet" {
  source               = "../../modules/network/subnet"
  region               = "${var.region}"
  tags                 = "${local.common_tags}"
  name                 = "${local.env_prefix}-service-fabric-subnet"
  address_prefix       = "${cidrsubnet(var.address_space, 8, 1)}"
  virtual_network_name = "${module.vnet.vnet_name}"
  resource_group_name  = "${azurerm_resource_group.env_resource_group.name}"
  service_endpoints =  ["Microsoft.Sql"]
}

module "vm" {
  source              = "../../modules/vm"
  region              = "${var.region}"
  name =              "${local.env_prefix}-mirror-check"
  tags                = "${local.common_tags}"
  subnet_id           = "${module.mirror-check-subnet.subnet_id}"
  vault_url           = "${module.kv.vault_url}"
  count               = 1
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
}

module "storage" {
  source              = "../../modules/storage"
  name                = "${local.env_prefix}dcaccount"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  storage_table_name =  "sometablename"
  vault_url           =  "${module.kv.vault_url}"
}

module "app-insights" {
  source              = "../../modules/application_insights"
  name                = "${local.env_prefix}-dc-app-insights"
  vault_url           = "${module.kv.vault_url}"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
}

module "sql-server" {
  source              = "../../modules/sql/server"
  name                = "${local.env_prefix}-dc-sql-server"
  vault_url           = "${module.kv.vault_url}"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  administrator_login = "superlogin"
  networks_count      = "2"
  subnet_ids          = ["${module.service-fabric-subnet.subnet_id}", "${module.mirror-check-subnet.subnet_id}"]
  firewall_rules = [
    {
      name = "all",
      start_ip_address =  "0.0.0.0",
      end_ip_address =   "255.255.255.255"
    }
  ]
}

module "databases" {
  source              = "../../modules/sql/db"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  server_name         = "${module.sql-server.sql_serwer_name}"
  vault_url           = "${module.kv.vault_url}"
  count               = 2
  databases = [
    {
      name                 = "${local.env_prefix}-service-1-db"
      edition = "Basic",
      value_to_store      = "Server=tcp:${module.sql-server.sql_server_fully_qualified_domain_name},1433;Initial Catalog=${local.env_prefix}-service-1-db;Persist Security Info=False;User ID=${module.sql-server.sql_server_admin};Password=${module.sql-server.sql_server_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
      tags                = "${local.common_tags}"
    },
    {
      name                 = "${local.env_prefix}-service-2-db"
      edition = "Basic",
      value_to_store      = "Server=tcp:${module.sql-server.sql_server_fully_qualified_domain_name},1433;Initial Catalog=${local.env_prefix}-service-2-db;Persist Security Info=False;User ID=${module.sql-server.sql_server_admin};Password=${module.sql-server.sql_server_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
      tags                = "${local.common_tags}"
    }
  ]
}

# todo add subscription https://www.terraform.io/docs/providers/azurerm/r/servicebus_subscription.html
# todo add queue https://www.terraform.io/docs/providers/azurerm/r/servicebus_queue.html
module "servicebus" {
  source              = "../../modules/service_bus"
  name                = "${local.env_prefix}-mirror-service-bus"
  vault_url           = "${module.kv.vault_url}"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  sku = "basic"
}

# optional
# module "service-plans" {
#   source              = "../../modules/app/service_plan"
#   resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
#   region              = "${var.region}"
#   tags                = "${local.common_tags}"
#   plans = [
#     {
#       name                 = "${local.env_prefix}-sp-1"
#       tier                 = "Shared"
#       size = "D1"
#     },
#     {
#      name                 = "${local.env_prefix}-sp-2"
#       tier                 = "Shared"
#       size = "D1"
#     }
#   ]
# }

# optional
# module "web-aps" {
#   source              = "../../modules/app/web_app"
#   count =             2 
#   resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
#   region              = "${var.region}"
#   tags                = "${local.common_tags}"
#   apps = [
#     {
#       name                 = "${local.env_prefix}-dc-app-1"
#       app_service_plan_id  = "${module.service-plans.plans_ids[0]}"
#     },
#     {
#      name                 = "${local.env_prefix}-dc-app-2"
#      app_service_plan_id  = "${module.service-plans.plans_ids[1]}"
#     }
#   ]
# }
