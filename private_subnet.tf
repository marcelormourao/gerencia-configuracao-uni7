resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "192.168.15.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private subnet"
  }
}