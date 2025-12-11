variable "env" {
  description = "Environment (dev/qa/prod)"
}

variable "prefix" {
  description = "Name prefix"
  default     = "fdx"
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Optional: list of secret ARNs to allow read access (pass empty list for wildcard)
variable "secrets_arns" {
  type    = list(string)
  default = []
}
