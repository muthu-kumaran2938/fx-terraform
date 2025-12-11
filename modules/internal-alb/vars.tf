variable "name" {}
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "vpc_id" {}
variable "target_port" { default = 8080 }
variable "certificate_arn" {
  type    = string
  default = ""
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "enable_http" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

