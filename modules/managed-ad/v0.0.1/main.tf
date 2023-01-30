#Create password
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
}

resource "aws_secretsmanager_secret" "password" {
  name = "${var.name}-ad"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = <<EOF
   {
    "password": "${random_password.password.result}"
   }
EOF
}
#Import password
data "aws_secretsmanager_secret" "password" {
  arn = aws_secretsmanager_secret.password.arn
}
data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = data.aws_secretsmanager_secret.password.arn
}
locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.credentials.secret_string)
}

resource "aws_directory_service_directory" "ad" {
  name     = var.name
  password = local.creds.password
  type     = var.type
  edition  = var.edition
  tags     = var.tags

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }
}

# Associate the domain IP's of the AWS Managed AD with the VPC
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = [sort(aws_directory_service_directory.ad.dns_ip_addresses)[0], sort(aws_directory_service_directory.ad.dns_ip_addresses)[1]]
  domain_name         = var.name
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

resource "aws_ssm_document" "ad_join_domain" {
  name          = "${var.name}-ssm"
  document_type = "Command"
  content = jsonencode(
    {
      "schemaVersion" = "2.2"
      "description"   = "aws:domainJoin"
      "mainSteps" = [
        {
          "action" = "aws:domainJoin",
          "name"   = "domainJoin",
          "inputs" = {
            "directoryId"    = aws_directory_service_directory.ad.id,
            "directoryName"  = aws_directory_service_directory.ad.name,
            "dnsIpAddresses" = aws_directory_service_directory.ad.dns_ip_addresses
          }
        }
      ]
    }
  )
}

resource "aws_ssm_association" "windows_server" {
  name = aws_ssm_document.ad_join_domain.name
  targets {
    key    = var.key
    values = var.values
  }
}


