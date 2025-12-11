###########################################################
# Environment
###########################################################
variable "env" {
  description = "Environment (dev/prod/etc)"
  type        = string
}

###########################################################
# Private Subnets
###########################################################
variable "private_subnet_ids" {
  description = "Private subnet IDs for the RDS instances"
  type        = list(string)
}

###########################################################
# Security Groups
###########################################################
variable "db_security_group_ids" {
  description = "Security group IDs to attach to the RDS instances"
  type        = list(string)
}

###########################################################
# Databases map
###########################################################
variable "databases" {
  description = "Map of databases and optional parameters for each RDS instance"
  type = map(object({
    db_name             = optional(string)
    username            = optional(string)
    password            = optional(string)
    secret_arn          = optional(string)   # Use Secrets Manager if provided
    engine              = optional(string, "postgres")
    engine_version      = optional(string)
    instance_class      = optional(string)
    storage             = optional(number)
    multi_az            = optional(bool, false)
    skip_final_snapshot = optional(bool, true)
    deletion_protection = optional(bool, false)
  }))
}

###########################################################
# Tags
###########################################################
variable "tags" {
  description = "Tags to assign to all RDS resources"
  type        = map(string)
  default     = {}
}

###########################################################
# Default engine version (if not specified per database)
###########################################################
variable "default_engine_version" {
  description = "Default engine version if not specified in the database map"
  type        = string
  default     = "15.3"   # change as needed (Postgres example)
}
