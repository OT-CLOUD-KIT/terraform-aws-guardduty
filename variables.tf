##################################################
# GuardDuty Detector
##################################################
variable "enable_guardduty" {
  description = "Enable monitoring and feedback reporting. Setting to false is equivalent to 'suspending' GuardDuty. Defaults to `true`."
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Specifies the frequency of notifications sent for subsequent finding occurrences. If the detector is a GuardDuty member account, the value is determined by the GuardDuty primary account and cannot be modified. For standalone and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. Valid values for standalone and primary accounts: `FIFTEEN_MINUTES`, `ONE_HOUR`, `SIX_HOURS`. Defaults to `SIX_HOURS`."
  type        = string
  default     = "FIFTEEN_MINUTES"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "Valid values for finding_publishing_frequency are 'FIFTEEN_MINUTES', 'ONE_HOUR', or 'SIX_HOURS'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. Defaults to `{}`."
  type        = map(string)
}

##################################################
# GuardDuty Detector Feature
##################################################

variable "guardduty_detector_feature_variables" {
  description = <<EOF
  Specifies AWS GuardDuty Detector feature configuration.
  `name` - The name of the detector feature. Valid values: `S3_DATA_EVENTS`, `EKS_AUDIT_LOGS`, `EBS_MALWARE_PROTECTION`, `RDS_LOGIN_EVENTS`, `EKS_RUNTIME_MONITORING`, `LAMBDA_NETWORK_LOGS`, `RUNTIME_MONITORING`.
  `status` - The status of the detector feature. Valid values: `ENABLED`, `DISABLED`.
  `additional_configuration` - Optional configuration block for additional features (EKS_RUNTIME_MONITORING or RUNTIME_MONITORING).
  EOF
  type = list(object({
    name   = string
    status = string
    additional_configuration = optional(list(object({
      name   = string
      status = string
    })))
  }))
  default = null

  validation {
    condition = alltrue([
      for feature in var.guardduty_detector_feature_variables :
      contains(
        ["S3_DATA_EVENTS", "EKS_AUDIT_LOGS", "EBS_MALWARE_PROTECTION", "RDS_LOGIN_EVENTS", "EKS_RUNTIME_MONITORING", "LAMBDA_NETWORK_LOGS", "RUNTIME_MONITORING"],
        feature.name
      ) &&
      contains(["ENABLED", "DISABLED"], feature.status)
    ])
    error_message = "Each feature must have a valid 'name' from ['S3_DATA_EVENTS', 'EKS_AUDIT_LOGS', 'EBS_MALWARE_PROTECTION', 'RDS_LOGIN_EVENTS', 'EKS_RUNTIME_MONITORING', 'LAMBDA_NETWORK_LOGS', 'RUNTIME_MONITORING'] and a valid 'status' of either 'ENABLED' or 'DISABLED'."
  }
}


##################################################
# GuardDuty Filter
##################################################

variable "enable_guardduty_filter" {
  description = "Enable GuardDuty Filter. Defaults to `true`."
  type        = bool
  default     = true
}

variable "guardduty_filter_variables" {
  description = <<EOF
  Specifies AWS GuardDuty Filter configuration.
  `name` - The name of the filter.
  `rank` - Specifies the position of the filter in the list of current filters. Also specifies the order in which this filter is applied to the findings.
  `action` - Specifies the action that is to be applied to the findings that match the filter. Can be one of ARCHIVE or NOOP.
  `criterion` - Configuration block for `finding_criteria`. Composed by `field` and one or more of the following operators: `equals` | `not_equals` | `greater_than` | `greater_than_or_equal` | `less_than` | `less_than_or_equal`.
  EOF
  type = list(object({
    name        = string
    description = optional(string)
    rank        = number
    action      = string
    criterion = list(object({
      field                 = string
      equals                = optional(list(string))
      not_equals            = optional(list(string))
      greater_than          = optional(string)
      greater_than_or_equal = optional(string)
      less_than             = optional(string)
      less_than_or_equal    = optional(string)
    }))
  }))
  default = null

  validation {
    condition = alltrue([
      for filter in var.guardduty_filter_variables :
      contains(["ARCHIVE", "NOOP"], filter.action)
    ])
    error_message = "Each filter must have a valid 'action' from ['ARCHIVE', 'NOOP']."
  }
}

##################################################
# GuardDuty IPSet
##################################################

variable "enable_guardduty_ipset" {
  description = "Enable GuardDuty IPSet. Defaults to `true`."
  type        = bool
  default     = true
}

variable "guardduty_s3_bucket" {
  description = "Name of the S3 Bucket for GuardDuty. Defaults to `null`."
  type        = string
  default     = null
}

variable "guardduty_ipset_variables" {
  description = <<EOF
  Specifies AWS GuardDuty IPSet configuration.
  `activate` - Specifies whether GuardDuty is to start using the uploaded IPSet.
  `name` - The friendly name to identify the IPSet.
  `format` - The format of the file that contains the IPSet. Valid values: `TXT` | `STIX` | `OTX_CSV` | `ALIEN_VAULT` | `PROOF_POINT` | `FIRE_EYE`.
  `content`- Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Example: `10.0.0.0/8\n`.
  `key` - Name of the object once it is in the bucket.
  EOF
  type = list(object({
    activate = bool
    name     = string
    format   = string
    content  = string
    key      = string
  }))
  default = null
}

##################################################
# GuardDuty ThreatIntelSet
##################################################

variable "enable_guardduty_threatintelset" {
  description = "Enable GuardDuty ThreatIntelSet. Defaults to `true`."
  type        = bool
  default     = true
}

variable "guardduty_threatintelset_variables" {
  description = <<EOF
  Specifies AWS GuardDuty ThreatIntelSet configuration.
  `activate` - Specifies whether GuardDuty is to start using the uploaded ThreatIntelSet.
  `name` - The friendly name to identify the ThreatIntelSet.
  `format` - The format of the file that contains the ThreatIntelSet. Valid values: `TXT` | `STIX` | `OTX_CSV` | `ALIEN_VAULT` | `PROOF_POINT` | `FIRE_EYE`.
  `content`- Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. Example: `10.0.0.0/8\n`.
  `key` - Name of the object once it is in the bucket.
  `object_acl`- Canned ACL to apply to the object. Valid values are `private` | `public-read` | `public-read-write` | `aws-exec-read` | `authenticated-read` | `bucket-owner-read` | `bucket-owner-full-control`.
  EOF
  type = list(object({
    activate   = bool
    name       = string
    format     = string
    content    = string
    key        = string
    object_acl = string
  }))
  default = null
}
