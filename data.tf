data "aws_ami" "ubuntu18" {
  most_recent      = true
  
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Ubuntu ID, don't change without change the filter

  ## example: https://gist.github.com/AlainODea/be4fd6fc53bfbbcad45a7a9989db6c4e
}