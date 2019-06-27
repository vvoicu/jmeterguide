output "ips" {
  value = "${module.linux_instances.ip_addresses}"
}

output "fqdns" {
  value = "${module.dns.fqdns}"
}
