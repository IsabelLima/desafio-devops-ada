terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_security_group" "backend-sg" {
  name_prefix = "backend-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["189.73.139.107/32"] # coloquei meu ip aqui
  }
}


resource "aws_instance" "ec2-backend" {
  ami           = "ami-0fe472d8a85bc7b0e" #pegar dinamico ultimo ami de amazon linux
  instance_type = "t2.micro"
  key_name      = "ada"
  vpc_security_group_ids = [aws_security_group.backend-sg.id]
  subnet_id = aws_subnet.ada-public-1a.id
  tags = {
    Name = "Ada Backend"
  }
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-8-jdk
              EOF
}