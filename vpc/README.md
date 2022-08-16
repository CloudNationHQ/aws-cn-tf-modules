VPC with configurable AZs, Flow logs and Gateway Endpoints

# Usage

```module "vpc" {
  source                  = "github.com/CloudNation-nl/aws-terraform-modules//vpc/v0.0.1"
  private_zone_name       = "customer.internal"
  name                    = "customer"
  env                     = "dev"
  azs                     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  cidr                    = "10.60.0.0/16"
  public_subnets          = ["10.60.1.0/24", "10.60.2.0/24", "10.60.3.0/24"]
  private_subnets         = ["10.60.4.0/24", "10.60.5.0/24", "10.60.6.0/24"]
  database_subnets        = ["10.60.7.0/24", "10.60.8.0/24", "10.60.9.0/24"]
  enable_nat_gateway      = true
  single_nat_gateway      = true
  deletion_window_in_days = 30
  log_destination_type    = "s3"
  traffic_type            = "ALL"
  tags                    = {
    tag          = "value"
    Managedby    = "Terraform"
  }
}
```

# CHANGELOG

v0.0.1
- Initial Commit