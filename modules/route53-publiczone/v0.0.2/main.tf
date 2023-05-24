resource "aws_route53_zone" "public" {
  name    = var.public_zone_name
  comment = "${var.public_zone_name} public zone"
  tags    = var.tags
}

resource "aws_route53_record" "publiczone-caa" {
  zone_id = aws_route53_zone.public.zone_id
  name    = aws_route53_zone.public.name
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
}