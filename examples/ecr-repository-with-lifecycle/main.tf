#Deploys an ECR repository that is shared with an AWS account and a specific IAM user. Lifecycle policy is attached.
#Terraform init
#Terraform plan
#Terraform apply

variable "lifecycle_policy" {
  default = {
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire images older than 14 days",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 14
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  }
}

module "ecr" {
  source             = "github.com/CloudNation-nl/aws-terraform-modules//modules/ecr-repository/v0.0.1"
  name               = "my-example-repo"
  allowed_principals = ["12344534233", "arn:aws:iam::12344534233:user/bill"]
  lifecycle_policy   = var.lifecycle_policy
}