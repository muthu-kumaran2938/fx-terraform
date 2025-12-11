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
