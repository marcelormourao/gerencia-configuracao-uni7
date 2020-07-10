resource "aws_s3_bucket" "ansible_bucket" {
  bucket = "ansibleappuni7nodeapp"
  acl    = "private"
}

resource "aws_s3_bucket_object" "upload" {
  bucket = aws_s3_bucket.ansible_bucket.bucket
  key    = "ansible/ansible.zip"
  source = "ansible/ansible.zip"
  acl = "private"
  tags = {
      Name = "Ansible and application scripts"
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = file("modules/app/s3_policys/assume_role_files.json")
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = file("modules/app/s3_policys/policy.json")
}

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "policy-attachment"
  roles      = [aws_iam_role.ec2_s3_access_role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}