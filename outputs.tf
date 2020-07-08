output "private_subnets" {
  value = module.network.private_subnets
}

output "security_groups" {
    value = module.network.security_groups
}