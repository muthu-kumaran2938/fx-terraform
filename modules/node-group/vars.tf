variable "cluster_name" {}
variable "node_role_arn" {}
variable "subnet_ids" {
  type = list(string)
}
variable "node_groups" {
  type = map(object({
    desired_size  = optional(number, 2)
    max_size      = optional(number, 3)
    min_size      = optional(number, 1)
    instance_types= optional(list(string), ["t3.medium"])
    ec2_ssh_key   = optional(string)   # pass keypair name if you need SSH to nodes
    ami_type      = optional(string, "AL2_x86_64")
  }))
}
variable "tags" {
  type = map(string)
  default = {}
}
