variable "env" {
  description = "Environment: dev, qa, prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}
