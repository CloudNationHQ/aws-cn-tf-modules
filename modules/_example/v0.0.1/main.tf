resource "aws_infinidash_dashboard" "example" {
  parameter1 = var.requiredparameter
  parameter2 = var.defaultparameter
  parameter3 = var.optionalparameter
}

resource "aws_infinidash_auth" "example" {
  count     = var.optionalresource ? 1 : 0
  dashboard = aws_infinidash_dashboard.example.dashboard_id
}