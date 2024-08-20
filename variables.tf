variable "zone_name" {
  description = "The name of the hosted zone"
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a new Route53 Hosted Zone"
  type        = bool
  default     = true
}

variable "is_private_zone" {
  description = "Whether the hosted zone is private"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with a private hosted zone"
  type        = string
  default     = ""
}

variable "records" {
  description = "List of Route53 records to create. Each record should have a name, type, ttl, and values"
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "enable_records" {
  description = "Whether to enable the creation of Route53 records"
  type        = bool
  default     = false
}

variable "ns_record_ttl" {
  description = "TTL for the NS record"
  type        = number
  default     = 300
}

variable "soa_record_ttl" {
  description = "TTL for the SOA record"
  type        = number
  default     = 900
}

variable "existing_zone_id" {
  description = "The ID of an existing Route53 hosted zone. Used when create_hosted_zone is false."
  type        = string
  default     = null
}