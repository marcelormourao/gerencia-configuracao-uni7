resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.subnet_name
  }
}