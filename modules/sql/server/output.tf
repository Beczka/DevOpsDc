output "sql_serwer_name" {
  value = "${azurerm_sql_server.sql-serwer.name}"
}

output "sql_server_fully_qualified_domain_name" {
  value = "${azurerm_sql_server.sql-serwer.fully_qualified_domain_name}"
}


output "sql_server_admin" {
  value = "${var.administrator_login}"
}

output "sql_server_admin_password" {
  value = "${module.sql-serwer.password}"
}