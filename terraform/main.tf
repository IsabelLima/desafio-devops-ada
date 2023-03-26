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

resource "aws_vpc" "ada_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    name = "ada"
  }
}

resource "aws_subnet" "ada_public_1a" {
    vpc_id = aws_vpc.ada_vpc.id
    cidr_block = "10.0.0.0/27"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "ada_public_1a"
    }
}

resource "aws_subnet" "ada_public_1b" {
    vpc_id = aws_vpc.ada_vpc.id
    cidr_block = "10.0.0.32/27"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
        Name = "ada_public_1b"
    }
}

resource "aws_subnet" "ada_public_1c" {
    vpc_id = aws_vpc.ada_vpc.id
    cidr_block = "10.0.0.64/27"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"
    tags = {
        Name = "ada_public_1c"
    }
}

resource "aws_subnet" "ada_private_1a" {
    vpc_id = aws_vpc.ada_vpc.id
    cidr_block = "10.0.0.96/27"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"
    tags = {
        Name = "ada_private_1a"
    }
}

resource "aws_subnet" "ada_private_1b" {
    vpc_id = aws_vpc.ada_vpc.id
    cidr_block = "10.0.0.128/27"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"
    tags = {
        Name = "ada_private_1b"
    }
}

resource "aws_subnet" "ada_private_1c" {
    vpc_id = aws_vpc.ada_vpc.id
    cidr_block = "10.0.0.160/27"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1c"
    tags = {
        Name = "ada_private_1c"
    }
}

resource "aws_security_group" "backend_sg" {
  name_prefix = "backend_sg"
  vpc_id = aws_vpc.ada_vpc.id
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

resource "aws_instance" "ec2_backend" {
  ami           = "ami-0fe472d8a85bc7b0e" #pegar dinamico ultimo ami de amazon linux
  instance_type = "t2.micro"
  key_name      = "ada"
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  subnet_id = aws_subnet.ada_public_1a.id
  tags = {
    Name = "Ada Backend"
  }
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-8-jdk
              EOF
}


resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_sg"
  vpc_id = aws_vpc.ada_vpc.id
}

resource "aws_security_group_rule" "allow_backend_access_rds" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  source_security_group_id = aws_security_group.backend_sg.id
  security_group_id = aws_security_group.rds_sg.id
}

resource "aws_db_subnet_group" "ada_db_subnet_group" {
  name       = "ada_db_subnet_group"
  subnet_ids = [aws_subnet.ada_private_1a.id, aws_subnet.ada_private_1b.id, aws_subnet.ada_private_1c.id]
  tags = {
    Name = "Ada DB subnet group"
  }
}

resource "aws_db_instance" "ada_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "adaDatabase"
  identifier           = "adaDatabase"
  username             = "ada_admin"
  password             = "senhaDoBanco"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.ada_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}