output "public_dns" {
  value = "http://${aws_instance.public_instance.public_dns}:5000"
}
