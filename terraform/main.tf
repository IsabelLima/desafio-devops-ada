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

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "ada-vpc"

  cidr = "10.0.0.0/24"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.0.96/27", "10.0.0.128/27", "10.0.0.160/27"]
  public_subnets  = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/ada-cluster" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/ada-cluster" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

resource "aws_security_group" "backend_sg" {
  name_prefix = "backend_sg"
  vpc_id = module.vpc.vpc_id
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_sg"
  vpc_id = module.vpc.vpc_id
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
  subnet_ids = module.vpc.private_subnets
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
  identifier           = "ada-database"
  username             = "ada_admin"
  password             = "senhaDoBanco"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.ada_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = "ada-cluster"
  cluster_version = "1.25"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }
}

resource "aws_ecr_repository" "ada_frontend" {
  name                 = "ada-frontend"
}

resource "aws_ecr_repository" "ada_backend" {
  name                 = "ada-backend"
}