output "private_subnets" {
    value = aws_subnet.private_subnet
}

output "public_subnets" {
    value = aws_subnet.public_subnet
}

output "security_groups" {
    value = aws_security_group.security_groups
}