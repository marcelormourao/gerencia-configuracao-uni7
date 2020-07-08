# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
  profile = "TERRAFORM"
}

module "network" {
  source = "./modules/network"
  
  vpc_cidr_block = "192.168.0.0/16"
  vpc_name = "UNI7_VPC"

  public_subnets = {
    public_sub1 = { cidr_block = "192.168.10.0/24", subnet_name = "Public Subnet from Terraform" }
  }

  private_subnets = {
    private_sub1 = { cidr_block = "192.168.11.0/24", subnet_name = "Private Subnet from Terraform" }
  }

  security_groups = local.security_groups
}

data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

locals {
  security_groups = {
    security_group_ssh = {
      name = "allow_ssh"
      description = "Permite ssh"
      ingresses = [
        {
          description = "SSH"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["${chomp(data.http.icanhazip.body)}/32"]
          security_groups_dependency = []
        }
      ]
      egresses = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
    security_group_app = {
      name = "security_group_app"
      description = "Permite conexao na porta 5000 vindas de qualquer origem"
      ingresses = [
        {
          description = "SSH"
          from_port   = 5000
          to_port     = 5000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          security_groups_dependency = []
        }
      ]
      egresses = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
    security_group_db = {
      name = "security_group_db"
      description = "Permite conexao na porta 5432 vindas do security group da instancia do app"
      ingresses = [
        {
          description = "PG port"
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          cidr_blocks = []
          security_groups_dependency = ["security_group_app"]
        }
      ]
      egresses = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}
