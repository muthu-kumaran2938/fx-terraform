variable "cluster_name" {}
variable "cluster_role_arn" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "endpoint_private_access" {
  type = bool
  default = true
}
variable "endpoint_public_access" {
  type = bool
  default = true
}
variable "public_access_cidrs" {
  type = list(string)
  default = ["0.0.0.0/0"]
}
variable "kubeconfig_path" {
  default = "/tmp"
}
