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

locals {
  sg_dependency = flatten([
    for security_group_key, security_group in var.security_groups : [
      for ingress in security_group.ingresses : [
        for dependency in ingress.security_groups_dependency : {
          security_group_key = security_group_key
          from_port = ingress.from_port
          to_port = ingress.to_port
          protocol = ingress.protocol
          dependency = dependency
        }
        if length(ingress.security_groups_dependency) != 0
      ]
    ]
  ])
}

resource "aws_security_group_rule" "dependency-security-group-ingress" {
  count = length(local.sg_dependency)
  type = "ingress"
  from_port = local.sg_dependency[count.index].from_port
  to_port = local.sg_dependency[count.index].to_port
  protocol = local.sg_dependency[count.index].protocol
  security_group_id = aws_security_group.security_groups[local.sg_dependency[count.index].security_group_key].id
  source_security_group_id = aws_security_group.security_groups[local.sg_dependency[count.index].dependency].id
}
