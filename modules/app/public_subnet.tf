resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "192.168.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "Internet Gateway from Terraform"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route table for public subnet"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}
