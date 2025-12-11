variable "env" {}
variable "name" {}
variable "subnet_id" {}
variable "instance_type" { default = "t3.micro" }
variable "sg_id" {}
variable "key_secret_name" { default = "red-ec2" }
