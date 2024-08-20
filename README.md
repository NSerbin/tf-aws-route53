# Terraform Route53 Hosted Zone Module

This Terraform module creates and manages an AWS Route53 hosted zone, along with DNS records. It supports both public and private hosted zones, and allows the creation of various DNS records.

## Features
- Create Hosted Zone: Optionally create a new Route53 hosted zone (public or private).
- NS and SOA Records: Automatically create NS and SOA records for the hosted zone.
- User-Defined Records: Dynamically create custom DNS records based on user input.

## Usage

```hcl
module "route53" {
  source = "./path-to-module"

  create_hosted_zone = true
  zone_name          = "example.com"
  is_private_zone    = false
  vpc_id             = "vpc-123456"
  ns_record_ttl      = 300
  soa_record_ttl     = 7200
  enable_records     = true
  records = [
    {
      name    = "www.example.com"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.44"]
    },
    {
      name    = "mail.example.com"
      type    = "MX"
      ttl     = 3600
      records = ["10 mailserver.example.com"]
    }
  ]
}

```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_hosted_zone"></a> [create\_hosted\_zone](#input\_create\_hosted\_zone) | Whether to create a new Route53 hosted zone | `bool` | `false` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The name of the domain. Required if create\_hosted\_zone is true | `string` | `""` | no |
| <a name="input_is_private_zone"></a> [is\_private\_zone](#input\_is\_private\_zone) | Whether the hosted zone is private | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID for private hosted zones. Required if is\_private\_zone is true | `string` | `""` | no |
| <a name="input_ns_record_ttl"></a> [ns\_record\_ttl](#input\_ns\_record\_ttl) | The TTL for the NS record. Only used for public zones | `number` | `300` | no |
| <a name="input_soa_record_ttl"></a> [soa\_record\_ttl](#input\_soa\_record\_ttl) | The TTL for the SOA record. Only used for public zones | `number` | `7200` | no |
| <a name="input_enable_records"></a> [enable\_records](#input\_enable\_records) | Whether to create custom DNS records | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | A list of DNS records to create. Each record should include name, type, ttl, and records fields | `list(object)` | `[]` | no |
| <a name="input_existing_zone_id"></a> [existing\_zone\_id](#input\_existing\_zone\_id) | The ID of an existing Route53 hosted zone to use. Required if create\_hosted\_zone is false | `string` | `""` | no |

## Examples

### Creating a Public Hosted Zone with Records
```hcl
module "route53" {
  source = "./path-to-module"

  create_hosted_zone = true
  zone_name          = "example.com"
  is_private_zone    = false
  ns_record_ttl      = 300
  soa_record_ttl     = 7200
  enable_records     = true
  records = [
    {
      name    = "www.example.com"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.44"]
    }
  ]
}
```

### Using an Existing Hosted Zone
```hcl
module "route53" {
  source = "./path-to-module"

  create_hosted_zone = false
  existing_zone_id   = "Z1234567890"
  enable_records     = true
  records = [
    {
      name    = "www.example.com"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.44"]
    }
  ]
}
```