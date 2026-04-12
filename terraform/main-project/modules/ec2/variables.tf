variable "vpc_id" {}
variable "private_subnets" {}
variable "instance_type" {}
variable "ami_id" {}
variable "target_group_arn" {}
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}
