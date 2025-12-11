variable "domain_name" {}
variable "sans" {
  type = list(string)
  default = []
}
variable "route53_zone_id" {}
variable "tags" {
  type = map(string)
  default = {}
}
