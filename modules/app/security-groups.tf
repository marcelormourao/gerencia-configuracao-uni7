data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

resource "aws_security_group" "ssh" {

  name        = "ssh"
  description = "Allow ssh connection only from your public ip"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "SSH ingress"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${chomp(data.http.icanhazip.body)}/32"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH"
  }
}

resource "aws_security_group" "ssh_internal" {

  name        = "ssh_internal"
  description = "Allow ssh connection only from ssh security group"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "SSH ingress"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.ssh.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH"
  }
}

resource "aws_security_group" "app" {

  name        = "app"
  description = "Allow connection over port 5000"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "Node app port ingress"
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "APP"
  }
}

resource "aws_security_group" "db" {

  name        = "db"
  description = "Allow connection over port 5432"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "Postgres app port ingress"
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB"
  }
}

# locals {
#   sg_dependency = flatten([
#     for security_group_key, security_group in var.security_groups : [
#       for ingress in security_group.ingresses : [
#         for dependency in ingress.security_groups_dependency : {
#           security_group_key = security_group_key
#           from_port = ingress.from_port
#           to_port = ingress.to_port
#           protocol = ingress.protocol
#           dependency = dependency
#         }
#         if length(ingress.security_groups_dependency) != 0
#       ]
#     ]
#   ])
# }

# resource "aws_security_group_rule" "dependency-security-group-ingress" {
#   count = length(local.sg_dependency)
#   type = "ingress"
#   from_port = local.sg_dependency[count.index].from_port
#   to_port = local.sg_dependency[count.index].to_port
#   protocol = local.sg_dependency[count.index].protocol
#   security_group_id = aws_security_group.security_groups[local.sg_dependency[count.index].security_group_key].id
#   source_security_group_id = aws_security_group.security_groups[local.sg_dependency[count.index].dependency].id
# }
