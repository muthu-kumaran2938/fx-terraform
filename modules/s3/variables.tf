variable "buckets" {
  type = map(object({
    name       = string
    versioning = optional(bool, false)
  }))
}

variable "default_tags" {
  type    = map(string)
  default = {}
}
