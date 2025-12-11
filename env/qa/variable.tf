variable "name" {}
variable "cidr" {}
variable "azs" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "tags" {
  type = map(string)
}
variable "services" {
  type = list(string)
}
