module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ec2" {
  source           = "./modules/ec2"  
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  instance_type    = var.instance_type
  ami_id           = var.ami_id
  target_group_arn = module.alb.target_group_arn
  alb_sg_id = module.alb.alb_sg_id
  instance_profile_name = aws_iam_instance_profile.ec2_profile.name
}


