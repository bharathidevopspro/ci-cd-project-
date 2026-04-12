variable "region" {}
variable "vpc_cidr" {}
variable "instance_type" {}
variable "ami_id" {}
variable "alb_sg_id" {}
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}
