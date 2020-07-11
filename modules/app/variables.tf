variable "vpc_cidr_block" {
    type = string
    description = "cidr_block VPC"
    default = "192.168.0.0/16"
}

variable "vpc_name" {
    type = string
    description = "VPC name"
    default = "UNI7_VPC"
}

# variable "ami_id" {
#     type = string
#     description = "Ami used to create EC2 instance"
#     default = null
# }

variable "app_instance_type" {
    type = string
    description = "Instance type of App machine"
}

variable "db_instance_type" {
    type = string
    description = "Instance type of App machine"
}

variable "db_name" {
    type = string
    description = "db_name"
}

variable "db_user" {
    type = string
    description = "db_user"
}

variable "db_password" {
    type = string
    description = "db_password"
}