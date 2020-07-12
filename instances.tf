resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_key"
  public_key = file("keys/terraform_key.pub")
}

# Private instance
resource "aws_instance" "private_instance" {
  ami = data.aws_ami.ubuntu18.id
  
  instance_type = var.db_instance_type

  key_name = "terraform_key"

  subnet_id = aws_subnet.private_subnet.id

  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.db.id, aws_security_group.ssh_internal.id]

  iam_instance_profile = aws_iam_instance_profile.s3_profile.name

  tags = {
    Name = "DB Instance"
  }

  user_data = templatefile("${path.module}/scripts/user_data_db.sh.tlp", 
  {db_name = var.db_name,
   db_user = var.db_user,
   db_password = var.db_password})

  depends_on = [aws_key_pair.terraform_key_pair]
}

#Public instance
resource "aws_instance" "public_instance" {
  ami = data.aws_ami.ubuntu18.id
  
  instance_type = var.app_instance_type

  key_name = "terraform_key"

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.app.id]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.s3_profile.name

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

  user_data = templatefile("${path.module}/scripts/user_data_app.sh.tlp",
   { db_ip = aws_instance.private_instance.private_ip,
     db_name = var.db_name,
     db_user = var.db_user,
     db_password = var.db_password })

  depends_on = [aws_key_pair.terraform_key_pair]
}

