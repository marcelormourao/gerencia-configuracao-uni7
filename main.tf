# # Configure the AWS Provider
# provider "aws" {
#   version = "~> 2.0"
#   region  = "us-east-2"
#   profile = "TERRAFORM"
# }

# module "app_node" {
#   source = "./modules/app"

#   project_name = "app"

#   db_name = "mourao"
#   db_user = "mourao"
#   db_password = "mourao"
#   db_instance_type  = "t2.micro"

#   app_instance_type  = "t2.micro"
#   app_src_dir = "app/node-app"
# }

# output "endereco_app" {
#   value = module.app_node.public_dns 
# }
