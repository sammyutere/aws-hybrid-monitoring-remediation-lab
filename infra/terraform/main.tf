terraform {
  required_version = ">= 1.4.0"

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

# ----------------------------
# VPC
# ----------------------------
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab-vpc"
  }
}

# ----------------------------
# Internet Gateway
# ----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id
}

# ----------------------------
# Public Subnet
# ----------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "lab-public-subnet"
  }
}

# ----------------------------
# Route Table
# ----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ----------------------------
# Security Group
# ----------------------------
resource "aws_security_group" "node_sg" {
  name   = "node-exporter-sg"
  vpc_id = aws_vpc.lab_vpc.id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    description = "Allow node_exporter from my IPv4"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [trimspace(var.my_ip)]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-exporter-sg"
  }
}

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "node" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.node_sg.id]
  associate_public_ip_address = true
  monitoring                  = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y wget

              useradd --no-create-home --shell /bin/false node_exporter

              cd /tmp
              wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
              tar -xzf node_exporter-1.8.2.linux-amd64.tar.gz

              cp node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
              chown node_exporter:node_exporter /usr/local/bin/node_exporter

              cat <<EOT > /etc/systemd/system/node_exporter.service
              [Unit]
              Description=Prometheus Node Exporter
              After=network.target

              [Service]
              User=node_exporter
              ExecStart=/usr/local/bin/node_exporter

              [Install]
              WantedBy=multi-user.target
              EOT

              systemctl daemon-reload
              systemctl enable node_exporter
              systemctl start node_exporter
              EOF

  tags = {
    Name = "monitoring-node"
  }
}

# ----------------------------
# Elastic IP
# ----------------------------
resource "aws_eip" "node_eip" {
  domain = "vpc"

  tags = {
    Name = "monitoring-node-eip"
  }
}

resource "aws_eip_association" "node_eip_assoc" {
  instance_id   = aws_instance.node.id
  allocation_id = aws_eip.node_eip.id
}
