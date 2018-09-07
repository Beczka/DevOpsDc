output "resource_id_map" {
  value = "${zipmap(slice(local.resource_id_split, 0, length(local.resource_id_split) - 1), slice(local.resource_id_split, 1, length(local.resource_id_split)))}"
}
