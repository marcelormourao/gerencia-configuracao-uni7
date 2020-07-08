variable "vpc_cidr_block" {
    type = string
    description = "cidr_block VPC"
}

variable "vpc_name" {
    type = string
    description = "VPC name"
}

variable "public_subnets" {
    type = map(object({
        cidr_block = string
        subnet_name = string
    }))
    description = "cidrs_block of all public subnets that will be created"
    default = {}
}

variable "private_subnets" {
    type = map(object({
        cidr_block = string
        subnet_name = string
    }))
    description = "cidrs_block of all private subnets that will be created"
    default = {}
}

variable "security_groups" {
    type = map(object({
        name = string
        description = string
        ingresses = list(object({
            description = string
            from_port   = number
            to_port     = number
            protocol    = string
            cidr_blocks = list(string)
            security_groups = list(string)
        }))
        egresses = list(object({
            from_port   = number
            to_port     = number
            protocol    = string
            cidr_blocks = list(string)
        }))
    }))
    description = "map of security groups that will be created"
    default = {}
}

variable "igw_name" {
    type = string
    default = "Internet Gateway from Terraform"
}