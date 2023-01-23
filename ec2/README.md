AWS EC2, encrypted EBS and GP3 as standard

Features
- Creates public_ingress_rules, management_ingress_rules and internal_ingress_rules security groups to divide rules
- Create multiple EBS disks
- Support different subnet ID 
- Support different AZ zone
- Change Userdata to add extra installations while booting, only applies once
- Change policies if you need to add more rules or to the EC2
- Change cw_agent_config to add metrics for CW alarms

Dependencies
- VPC
- SNS needs to be already deployed

```
module "ec2" {
  source            = "../../modules/ec2"
  aws_region        = local.aws_region
  name              = "ec2"
  ami               = "ami-01cde3564ad4cc003"
  vpc_id            = module.vpc.vpc_id
  instance_type     = "t3.large"
  key_name          = "prod-eu-central-1-ec2"
  sns_alert_arn     = module.sns.sns
  availability_zone = element(module.vpc.azs, 0)
  subnet_id         = element(module.vpc.subnet_private_subnet_ids, 0)
  public_ports      = []
  volume_size       = 30
  data_volume_size  = 100
  extra_disk_config = {
    disk = {
      device_name = "/dev/sdi"
      volume_size = "10"
      volume_type = "gp3"
    },
    disk1 = {
      device_name = "/dev/sdj"
      volume_size = "10"
      volume_type = "gp3"      
    },
    disk2 = {
      device_name = "/dev/sdk"
      volume_size = "10"
      volume_type = "gp3"       
    }
  }
  tags = (merge({
    weeklybackup = "true", adjoin = "true"
  } ))
  private_hosted_zone_id   = module.vpc.private_zone_id
  public_ingress_rules     = []
  management_ingress_rules = []
  internal_ingress_rules = [
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      security_groups = [module.ec2.instance_sg]
      description     = "https"
    },
    {
      from_port       = 3389
      to_port         = 3389
      protocol        = "tcp"
      security_groups = [module.ec2.instance_sg]
      description     = "rdp"
    }
  ]
}
```