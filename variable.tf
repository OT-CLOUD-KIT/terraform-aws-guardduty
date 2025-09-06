##################################################
# GuardDuty Detector
##################################################
variable "enable_guardduty" {
  description = "Enable monitoring and feedback reporting. Setting to false is equivalent to 'suspending' GuardDuty. Defaults to `true`."
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Specifies the frequency of notifications sent for subsequent finding occurrences."
  type        = string
  default     = "FIFTEEN_MINUTES"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "Valid values are 'FIFTEEN_MINUTES', 'ONE_HOUR', or 'SIX_HOURS'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

##################################################
# GuardDuty Detector Feature
##################################################
variable "guardduty_detector_feature_variables" {
  description = "AWS GuardDuty Detector feature configuration."
  type = list(object({
    name   = string
    status = string
    additional_configuration = optional(list(object({
      name   = string
      status = string
    })))
  }))
  default = null
}

##################################################
# GuardDuty Filter
##################################################
variable "enable_guardduty_filter" {
  description = "Enable GuardDuty Filter."
  type        = bool
  default     = true
}

variable "guardduty_filter_variables" {
  description = "AWS GuardDuty Filter configuration."
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
}

##################################################
# GuardDuty IPSet
##################################################
variable "enable_guardduty_ipset" {
  description = "Enable GuardDuty IPSet."
  type        = bool
  default     = true
}

variable "guardduty_s3_bucket" {
  description = "Name of the S3 Bucket for GuardDuty."
  type        = string
  default     = null
}

variable "guardduty_ipset_variables" {
  description = "AWS GuardDuty IPSet configuration."
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
  description = "Enable GuardDuty ThreatIntelSet."
  type        = bool
  default     = true
}

variable "guardduty_threatintelset_variables" {
  description = "AWS GuardDuty ThreatIntelSet configuration."
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
