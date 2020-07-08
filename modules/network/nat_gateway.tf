locals {
    has_at_least_one_private_and_one_public_subnets = length(var.public_subnets) >= 1 && length(var.private_subnets) >= 1
}

resource "aws_eip" "nat_gw_ip" {
  count = local.has_at_least_one_private_and_one_public_subnets ? 1 : 0

  vpc = true
}

locals {
  key_first_subnet = length(aws_subnet.public_subnet) > 0 ? keys(aws_subnet.public_subnet)[0] : null
}

resource "aws_nat_gateway" "nat-gw" {
  count = local.has_at_least_one_private_and_one_public_subnets ? 1 : 0

  allocation_id = aws_eip.nat_gw_ip[0].id

  subnet_id = aws_subnet.public_subnet[local.key_first_subnet].id
  
  depends_on = [aws_internet_gateway.igw]
}

# Route table for NAT
resource "aws_route_table" "nat_route_table" {
  count = local.has_at_least_one_private_and_one_public_subnets ? 1 : 0
  
  vpc_id = aws_vpc.tf_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[0].id
  }
}

locals {
    private_subnets_nat_gw = local.has_at_least_one_private_and_one_public_subnets ? var.private_subnets : {}
}

resource "aws_route_table_association" "nat_rt_associations" {
  for_each = local.private_subnets_nat_gw

  subnet_id = aws_subnet.private_subnet[each.key].id
  
  route_table_id = aws_route_table.nat_route_table[0].id
}