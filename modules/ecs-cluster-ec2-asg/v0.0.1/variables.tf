# ASG related variables
# Required:
variable "security_group_ids" {
  description = "List of security group IDs to assign to instances"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs to launch instances in"
  type        = list(string)
}

# Optional:
variable "instance_type" {
  description = "See: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html#AvailableInstanceTypes"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "Bash code for inclusion as user_data on instances. By default contains minimum for registering with ECS cluster"
  type        = string
  default     = "false"
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Number of Amazon EC2 instances that should be running in the group"
  type        = number
  default     = 1
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "default_cooldown" {
  description = "Amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 30
}

variable "termination_policies" {
  description = "List of policies to decide how the instances in the Auto Scaling Group should be terminated. Valid values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default."
  type        = list(string)
  default     = ["Default"]
  validation {
    condition     = setintersection(["OldestInstance", "NewestInstance", "OldestLaunchConfiguration", "ClosestToNextInstanceHour", "OldestLaunchTemplate", "AllocationStrategy", "Default"], var.termination_policies) == toset(var.termination_policies)
    error_message = "Valid values for termination_policies are: OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, OldestLaunchTemplate, AllocationStrategy, Default"
  }
}

variable "protect_from_scale_in" {
  description = "Whether newly launched instances are automatically protected from termination by Amazon EC2 Auto Scaling when scaling in"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to add to created resources"
  type        = map(string)
  default = {
    managed_by = "Terraform"
  }
}

variable "ssh_key_name" {
  description = "Name of SSH key pair to use as default (ec2-user) user key"
  type        = string
  default     = ""
}

# ECS related variables
# Required:
variable "cluster_name" {
  description = "Name of the ECS cluster to create"
  type        = string
}

variable "container_insights" {
  description = "Enable or disable Container Insights. Valid values are enabled and disabled"
  type        = string
  default     = "disabled"
  validation {
    condition     = contains(["enabled", "disabled"], var.container_insights)
    error_message = "Valid values for container_insights are: enabled, disabled"
  }
}

variable "cloudwatch_log_retention" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 7
}

variable "ecs_instance_role_assume_role_policy" {
  description = "Assume role policy for the instance role"
  type        = string
  default     = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

variable "ecs_instance_role_policy" {
  description = "Instance role policy"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

variable "ecs_service_role_assume_role_policy" {
  description = "Assume role policy for the service role"
  type        = string
  default     = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

variable "ecs_service_role_policy" {
  description = "Service role policy"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
