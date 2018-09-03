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
  # operation_ad_group  = ""
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
  firewall_start_ip_address =  "0.0.0.0"
  firewall_end_ip_address =   "255.255.255.255"
}

module "databases" {
  source              = "../../modules/sql/db"
  resource_group_name = "${azurerm_resource_group.env_resource_group.name}"
  region              = "${var.region}"
  tags                = "${local.common_tags}"
  server_name =      "${module.sql-server.sql_serwer_name}"
  databases = [
    {
      name                 = "${local.env_prefix}-service-1-db"
      edition = "Basic"
    },
    {
      name                 = "${local.env_prefix}-service-2-db"
      edition = "Basic"
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
