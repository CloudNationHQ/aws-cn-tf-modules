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

variable "scaling_adjustment_up" {
  description = "How many instances to scale up by when triggered"
  type        = number
  default     = 1
}

variable "scaling_adjustment_down" {
  description = "How many instances to scale down by when triggered"
  type        = number
  default     = -1
}

variable "scaling_metric_name" {
  description = "The name for the alarm's associated metric. Valid values are CPUReservation and MemoryReservation"
  type        = string
  default     = "CPUReservation"
  validation {
    condition     = contains(["CPUReservation", "MemoryReservation"], var.scaling_metric_name)
    error_message = "Valid values for scaling_metric_name are: CPUReservation, MemoryReservation"
  }
}

variable "adjustment_type" {
  description = "Whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity"
  type        = string
  default     = "ChangeInCapacity"
  validation {
    condition     = contains(["ChangeInCapacity", "ExactCapacity", "PercentChangeInCapacity"], var.adjustment_type)
    error_message = "Valid values for adjustment_type are: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity"
  }
}

variable "policy_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  type        = number
  default     = 300
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = 2
}

variable "alarm_period" {
  description = "The period in seconds over which the specified statistic is applied."
  type        = number
  default     = 120
}

variable "alarm_threshold_scale_up" {
  description = "The value against which the specified statistic is compared."
  type        = number
  default     = 100
}

variable "alarm_threshold_scale_down" {
  description = "The value against which the specified statistic is compared."
  type        = number
  default     = 50
}

variable "alarm_actions_enabled" {
  description = "Whether or not to enable alarm actions for scaling up and down."
  type        = bool
  default     = true
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
