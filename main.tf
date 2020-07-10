# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
  profile = "TERRAFORM"
}

module "app_node" {
  source = "./modules/app"

  db_instance_type  = "t2.micro"

  app_instance_type  = "t2.micro"
}

output "endereco_app" {
  value = module.app_node.public_dns 
}