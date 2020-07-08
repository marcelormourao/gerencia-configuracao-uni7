resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.subnet_name
  }
}

resource "aws_internet_gateway" "igw" {
  count = length(var.public_subnets) >= 1 ? 1 : 0

  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "route_table" {
  count = length(var.public_subnets) >= 1 ? 1 : 0

  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "Route table for public subnet"
  }
}

resource "aws_route_table_association" "rt_association" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.route_table[0].id
}
