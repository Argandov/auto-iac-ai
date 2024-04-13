provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "user-1" {
  algorithm = "RSA"
}

data "aws_ami" "debian" {
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-12.0*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"] // Debian AWS account ID
}

resource "aws_instance" "server-1" {
  ami           = data.aws_ami.debian.id
  instance_type = "t2.micro" // This instance type has 1 VCPU and 1GB RAM; you may sort by price or search a comparable instance with 4GB
  key_name = aws_key_pair.user-1.key_name

  tags = {
    Name  = "Server-1"
    Usage = "Lab"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y && apt upgrade -y
              apt install -y nginx git
              git clone https://github.com/IBM-EPBL/ibm-cloud-pak-for-data.git /home/ec2-user/ibm-cloud-pak-for-data
              EOF
}

resource "aws_security_group" "server-1-sg" {
  name        = "Server-1-sg"
  description = "Security Group for Server-1, allowing SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["182.35.46.18/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    security_groups = ["sg-0a9f8a8b8b8b8b8b"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "user-1" {
  key_name   = "User-1"
  public_key = "${tls_private_key.user-1.public_key_openssh}"
}

resource "aws_s3_bucket" "bucket-1" {
  bucket = "bucket-1"
  acl    = "private"
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = aws_iam_role.s3_access_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::Server-1-data/*"
    }
  ]
}
EOF
 }

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access_profile"
  role = aws_iam_role.s3_access_role.name
}

resource "aws_instance" "s3_instance" {
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.arn
}

