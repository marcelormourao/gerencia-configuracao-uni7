resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_key"
  public_key = file("keys/terraform_key.pub")
}

# Private instance
resource "aws_instance" "private_instance" {
  ami = var.ami_id == null ? data.aws_ami.ubuntu18.id : var.ami_id
  
  instance_type = var.instance_type

  key_name = "terraform_key"

  subnet_id = module.network.private_subnets["private_sub1"].id

  vpc_security_group_ids = [module.network.security_groups["security_group_ssh"].id]

  tags = {
    Name = "DB Instance"
  }

  #user_data = file("scripts/self_terminate_instance.sh")

  depends_on = [aws_key_pair.terraform_key_pair]
}

#Public instance
resource "aws_instance" "public_instance" {
  ami = var.ami_id == null ? data.aws_ami.ubuntu18.id : var.ami_id
  
  instance_type = var.instance_type

  key_name = "terraform_key"

  subnet_id = module.network.public_subnets["public_sub1"].id

  vpc_security_group_ids = [module.network.security_groups["security_group_ssh"].id]

  associate_public_ip_address = true

  tags = {
    Name = "APP Instance"
  }

  provisioner "file" {
    source      = "keys/terraform_key"
    destination = "/home/ubuntu/.ssh/id_rsa"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = self.public_ip
      private_key = file("keys/terraform_key")
    }
  }

  user_data = file("scripts/user_data.sh")

  depends_on = [aws_key_pair.terraform_key_pair]
}

