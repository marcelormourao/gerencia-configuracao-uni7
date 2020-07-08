variable "ami_id" {
    type = string
    description = "Ami used to create EC2 instance"
    default = null
}

variable "instance_type" {
    type = string
    description = "Instance type of EC2 variables"
    default = "t2.micro"
}