terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "node" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  tags = {
    Name = "monitoring-node"
  }
}
