variable "databases" {
  type = map(object({
    db_name             = optional(string)
    username            = optional(string)
    password            = optional(string)
    secret_arn          = optional(string)   # NEW optional field
    engine              = optional(string, "postgres")
    engine_version      = optional(string)
    instance_class      = optional(string)
    storage             = optional(number)
    multi_az            = optional(bool, false)
    skip_final_snapshot = optional(bool, true)
    deletion_protection = optional(bool, false)
  }))
}
variable "env" {
  type        = string
  description = "Environment (dev/prod/etc)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for RDS"
}

variable "db_security_group_ids" {
  type        = list(string)
  description = "Security groups for RDS"
}

variable "databases" {
  type        = map(object({
    db_name   : string
    secret_arn: string
  }))
  description = "Databases and corresponding secrets"
}

variable "tags" {
  type        = map(string)
  description = "Tags for RDS resources"
  default     = {}
}

