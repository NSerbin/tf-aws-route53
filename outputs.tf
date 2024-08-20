output "zone_id" {
  description = "The ID of the Route53 hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.default[0].id : null
}

output "zone_name" {
  description = "The name of the Route53 hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.default[0].name : null
}

output "is_private_zone" {
  description = "Indicates if the hosted zone is private"
  value       = var.is_private_zone
}

output "vpc_id" {
  description = "The ID of the VPC associated with the private hosted zone"
  value       = var.is_private_zone ? var.vpc_id : null
}

output "name_servers" {
  description = "The name servers of the Route53 hosted zone (only applicable for public zones)"
  value       = var.create_hosted_zone && !var.is_private_zone ? aws_route53_zone.default[0].name_servers : null
}

output "soa_record" {
  description = "The SOA record details"
  value       = var.create_hosted_zone && !var.is_private_zone ? {
    name    = aws_route53_record.soa_record[0].name,
    ttl     = aws_route53_record.soa_record[0].ttl,
    records = aws_route53_record.soa_record[0].records,
  } : null
}

output "ns_record" {
  description = "The NS record details (only applicable for public zones)"
  value       = var.create_hosted_zone && !var.is_private_zone ? {
    name    = aws_route53_record.ns_record[0].name,
    ttl     = aws_route53_record.ns_record[0].ttl,
    records = aws_route53_record.ns_record[0].records,
  } : null
}

output "user_records" {
  description = "Details of all user-defined Route53 records"
  value       = var.enable_records && length(var.records) > 0 ? [
    for record in aws_route53_record.user_records :
    {
      name    = record.name,
      type    = record.type,
      ttl     = record.ttl,
      records = record.records
    }
  ] : []
}