output "nsg_rules" {
  value = {
    allow_http_rule  = "${local.allow_http_rule}"
    allow_https_rule = "${local.allow_https_rule}"
    allow_rdp_rule   = "${local.allow_rdp_rule}"
    allow_winrm      = "${local.allow_winrm}"
  }
}
