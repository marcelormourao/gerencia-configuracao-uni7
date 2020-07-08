resource "aws_security_group" "security_groups" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.tf_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingresses
    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      # security_groups = 
    }
  }

  dynamic "egress" {
    for_each = each.value.egresses
    content {
      from_port = egress.value.from_port
      to_port   = egress.value.to_port
      protocol  = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = each.value.name
  }
}