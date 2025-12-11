variable "env" {}
variable "name" {}
variable "subnet_id" {}
variable "instance_type" { default = "t3.micro" }
variable "sg_id" {}
variable "key_secret_name" { default = "red-ec2" }
# ../../modules/ec2/variables.tf
variable "iam_instance_profile" {
  description = "IAM instance profile to attach to EC2"
  type        = string
  default     = null
}
