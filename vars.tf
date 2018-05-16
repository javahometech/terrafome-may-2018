variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "173.30.0.0/16"
}

variable "webservers_cidr" {
  default = ["173.30.0.0/24", "173.30.1.0/24", "173.30.2.0/24"]
}

variable "private_servers_cidr" {
  default = ["173.30.10.0/24", "173.30.11.0/24", "173.30.12.0/24"]
}

variable "webservers_count" {
  default = "2"
}

variable "vpc_tenency" {
  default = "default"
}

# Declare the data source for AZs
data "aws_availability_zones" "available" {}

variable "azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "web_instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "hari"
}

variable "amis" {
  type = "map"

  default = {
    ap-south-1 = "ami-5b673c34"
    us-east-1  = "ami-467ca739"
  }
}
