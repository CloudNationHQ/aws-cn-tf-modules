locals {
  cluster_name = join("-", [local.env, "ecs-cluster-asg"])
  env          = "poc"
}

module "vpc" {
  source             = "github.com/CloudNation-nl/aws-terraform-modules//modules/vpc/v2.1.0"
  cidr_range         = "10.0.0.0/16"
  env                = local.env
  azs                = ["eu-west-1a", "eu-west-1b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  database_subnets   = ["10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway = false
}

resource "aws_security_group" "this" {
  description = "Security Group for the ECS cluster ${local.cluster_name}"
  name        = join("-", ["ecs", local.cluster_name])
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    "Name" = join("-", ["ecs", local.cluster_name])
  }
}

module "ecs_asg_ec2" {
  source                     = "github.com/CloudNation-nl/aws-terraform-modules//modules/ecs-cluster-ec2-asg/v0.0.1"
  cluster_name               = local.cluster_name
  subnet_ids                 = module.vpc.subnet_private_subnet_ids
  security_group_ids         = [aws_security_group.this.id]
  health_check_grace_period  = 30
  min_size                   = 0
  max_size                   = 2
  desired_capacity           = 1
  managed_scaling_protection = false
  instance_warmup_period     = 120
  target_capacity            = 100
}
