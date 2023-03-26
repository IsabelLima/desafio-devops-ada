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

resource "aws_subnet" "ada-public-1a" {
    vpc_id = "${aws_vpc.ada_vpc.id}"
    cidr_block = "10.0.0.0/27"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "ada-public-1a"
    }
}

resource "aws_subnet" "ada-public-1b" {
    vpc_id = "${aws_vpc.ada_vpc.id}"
    cidr_block = "10.0.0.32/27"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
        Name = "ada-public-1b"
    }
}

resource "aws_subnet" "ada-public-1c" {
    vpc_id = "${aws_vpc.ada_vpc.id}"
    cidr_block = "10.0.0.64/27"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"
    tags = {
        Name = "ada-public-1c"
    }
}

resource "aws_subnet" "ada-private-1a" {
    vpc_id = "${aws_vpc.ada_vpc.id}"
    cidr_block = "10.0.0.96/27"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"
    tags = {
        Name = "ada-private-1a"
    }
}

resource "aws_subnet" "ada-private-1b" {
    vpc_id = "${aws_vpc.ada_vpc.id}"
    cidr_block = "10.0.0.128/27"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"
    tags = {
        Name = "ada-private-1b"
    }
}

resource "aws_subnet" "ada-private-1c" {
    vpc_id = "${aws_vpc.ada_vpc.id}"
    cidr_block = "10.0.0.160/27"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1c"
    tags = {
        Name = "ada-private-1c"
    }
}