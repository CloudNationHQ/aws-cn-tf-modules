# Features

- Creates public_ingress_rules, management_ingress_rules and internal_ingress_rules security groups to divide rules
- Create multiple EBS disks
- Support different subnet ID 
- Support different AZ zone
- Change Userdata to add extra installations while booting, only applies once
- Change policies if you need to add more rules or to the EC2
- Change cw_agent_config to add metrics for CW alarms
- Standard GP3 EBS
- Standard Encrypted EBS

Dependencies
- VPC needs to be deployed
- SNS needs to be deployed

```
module "ec2" {
  source            = "github.com/CloudNation-nl/aws-terraform-modules/modules/ec2/v0.0.1"
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | ~> 4.2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.ec2_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_root_disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ebs_volume.extra_disc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_route53_record.private_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.internal-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.management-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.cw_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_volume_attachment.extra_disc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_volume_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_EC2_ROOT_VOLUME_DELETE_ON_TERMINATION"></a> [EC2\_ROOT\_VOLUME\_DELETE\_ON\_TERMINATION](#input\_EC2\_ROOT\_VOLUME\_DELETE\_ON\_TERMINATION) | n/a | `string` | `"false"` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | AMI to use for the instance. Required unless launch\_template is specified and the Launch Template specifes an AMI. | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC. | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | availability zones in the region | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create things in. | `any` | n/a | yes |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size) | Size of the volume in gibibytes (GiB). | `string` | `"50"` | no |
| <a name="input_extra_disk_config"></a> [extra\_disk\_config](#input\_extra\_disk\_config) | Size of the extra volumes in gibibytes (GiB). | <pre>map(object({<br>    device_name = string<br>    volume_type = string<br>    volume_size = number<br>  }))</pre> | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the instance. Required unless launch\_template is specified and the Launch Template specifies an instance type. | `string` | `"t3.small"` | no |
| <a name="input_internal_ingress_rules"></a> [internal\_ingress\_rules](#input\_internal\_ingress\_rules) | Security rules for internal security group | <pre>list(object({<br>    from_port       = number<br>    to_port         = number<br>    protocol        = string<br>    security_groups = list(string)<br>    description     = string<br>  }))</pre> | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key name of the Key Pair to use for the instance; which can be managed using the aws\_key\_pair resource | `string` | `""` | no |
| <a name="input_management_ingress_rules"></a> [management\_ingress\_rules](#input\_management\_ingress\_rules) | Security rules for management security group | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_block  = string<br>    description = string<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the instance. | `string` | `"Instance"` | no |
| <a name="input_private_hosted_zone_id"></a> [private\_hosted\_zone\_id](#input\_private\_hosted\_zone\_id) | private hosted zone ID from VPC | `string` | `""` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to associate with the instance in a VPC | `string` | `null` | no |
| <a name="input_public_ingress_rules"></a> [public\_ingress\_rules](#input\_public\_ingress\_rules) | Security rules for public security group | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_block  = string<br>    description = string<br>  }))</pre> | n/a | yes |
| <a name="input_public_ports"></a> [public\_ports](#input\_public\_ports) | Port numbers to be used in the security group | `list(number)` | `[]` | no |
| <a name="input_sns_alert_arn"></a> [sns\_alert\_arn](#input\_sns\_alert\_arn) | When CloudWatch receives an error message, it will notifies the subscribers in the SNS group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to launch in. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the volume in gibibytes (GiB). | `string` | `"20"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1 | `string` | `"gp3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID. Defaults to the region's default VPC. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | EC2 id |
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip) | EC2 private ip |
| <a name="output_instance_sg"></a> [instance\_sg](#output\_instance\_sg) | Instance SecurityGroup |
