provider "aws" {
  profile                  = "aws-cn-rd"
  region                   = "eu-west-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

locals {
  cluster_name = "ecs-cluster-asg-sebro-${local.env}"
  env = "poc"
}

module "vpc" {
  source             = "github.com/CloudNation-nl/aws-terraform-modules//modules/vpc/v2.1.0"
  cidr_range         = "10.13.0.0/16"
  env                = local.env
  azs                = ["eu-west-1a"]
  public_subnets     = ["10.13.1.0/24"]
  private_subnets    = ["10.13.2.0/24"]
  database_subnets   = ["10.13.3.0/24"]
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
  source             = "github.com/CloudNation-nl/aws-terraform-modules//modules/ecs-cluster-ec2-asg/v0.0.1?ref=affb6f0bed8791157ececd779f8feed738afc4ac"
  cluster_name       = "ecs_cluster_asg_sebro"
  subnet_ids         = module.vpc.subnet_private_subnet_ids
  security_group_ids = [aws_security_group.this.id]
}
