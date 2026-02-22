variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for Ubuntu or Amazon Linux"
}
