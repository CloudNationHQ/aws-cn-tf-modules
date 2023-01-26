<powershell>
# Install the AWS CLI
Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -OutFile C:\AWSCLIV2.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I C:\AWSCLIV2.msi /quiet'

# Download the CloudWatch agent installation package
Invoke-WebRequest -Uri https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi -OutFile C:\amazon-cloudwatch-agent.msi

# # Install the CloudWatch agent
Start-Process msiexec.exe -Wait -ArgumentList '/I C:\amazon-cloudwatch-agent.msi /quiet'

# Configure CloudWatch Agent
& "C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1" -a fetch-config -m ec2 -s -c ssm:${ssm_cloudwatch_config}

</powershell>