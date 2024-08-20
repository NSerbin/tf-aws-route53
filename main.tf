resource "aws_route53_zone" "default" {
  count = var.create_hosted_zone ? 1 : 0

  name = var.zone_name

  # VPC block only when it's a private zone
  dynamic "vpc" {
    for_each = var.is_private_zone ? [1] : []
    content {
      vpc_id = var.vpc_id
    }
  }
}

resource "aws_route53_record" "ns_record" {
  count = var.create_hosted_zone && !var.is_private_zone ? 1 : 0

  zone_id = aws_route53_zone.default[0].id
  name    = aws_route53_zone.default[0].name
  type    = "NS"
  ttl     = var.ns_record_ttl
  records = aws_route53_zone.default[0].name_servers
}

resource "aws_route53_record" "soa_record" {
  count = var.create_hosted_zone && !var.is_private_zone ? 1 : 0

  zone_id = aws_route53_zone.default[0].id
  name    = aws_route53_zone.default[0].name
  type    = "SOA"
  ttl     = var.soa_record_ttl
  records = [
    format("%s. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400", aws_route53_zone.default[0].name_servers[0])
  ]
}

resource "aws_route53_record" "user_records" {
  for_each = var.enable_records && length(var.records) > 0 ? { for i, record in var.records : i => record } : {}

  zone_id = var.create_hosted_zone ? aws_route53_zone.default[0].id : var.existing_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}
