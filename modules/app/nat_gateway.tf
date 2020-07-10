resource "aws_eip" "nat_gw_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat_gw_ip.id

  subnet_id = aws_subnet.public_subnet.id
  
  depends_on = [aws_internet_gateway.igw]
}

# Route table for NAT
resource "aws_route_table" "nat_route_table" {
  
  vpc_id = aws_vpc.tf_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
}

resource "aws_route_table_association" "nat_rt_associations" {
  subnet_id = aws_subnet.private_subnet.id
  
  route_table_id = aws_route_table.nat_route_table.id
}