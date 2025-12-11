variable "vpc_id" {}
variable "region" {}
variable "subnet_ids" {
  type = list(string)
}
variable "public_route_table_ids" {
  type = list(string)
}
variable "endpoint_sg_ids" {
  type = list(string)
}
