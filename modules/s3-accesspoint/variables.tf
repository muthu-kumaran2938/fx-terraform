variable "vpc_id" {}
variable "bucket_map" {
  description = "Map of logical keys to actual bucket names (from modules/s3 outputs)"
  type        = map(string)
}
variable "access_points" {
  type = map(object({
    bucket_key = string
  }))
}
variable "default_tags" {
  type    = map(string)
  default = {}
}
