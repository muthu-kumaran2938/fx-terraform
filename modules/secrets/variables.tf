variable "env" {}

variable "secret_name" {
  description = "Name of the secret to create"
}

variable "description" {
  default = "Managed by Terraform"
}

variable "secret_value" {
  description = "Actual value stored in the secret"
}
