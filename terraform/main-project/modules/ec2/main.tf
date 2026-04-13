resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]   # later restrict to ALB
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "web-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
  name = aws_iam_instance_profile.ec2_profile
}
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
   }


resource "aws_autoscaling_group" "asg" {
  name             = "web-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
  tag {
    key                 = "Name"
    value               = "ansible-server"
    propagate_at_launch = true
  }
}

