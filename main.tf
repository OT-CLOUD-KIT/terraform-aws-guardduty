##################################################
# GuardDuty Detector
##################################################
resource "aws_guardduty_detector" "guardduty_detector" {
  enable = var.enable_guardduty

  datasources {
    s3_logs {
      enable = var.enable_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_malware_protection
        }
      }
    }
  }

  finding_publishing_frequency = var.finding_publishing_frequency

  tags = merge(
    {
      "Provisioner" = "Terraform"
    },
    var.tags
  )
}

##################################################
# GuardDuty Filter
##################################################
resource "aws_guardduty_filter" "guardduty_filter" {
  for_each = var.enable_guardduty_filter && var.guardduty_filter_variables != null ? { for filter in var.guardduty_filter_variables : filter.name => filter } : {}

  detector_id = aws_guardduty_detector.guardduty_detector.id

  name        = each.value.name
  action      = each.value.action
  rank        = each.value.rank
  description = each.value.description

  finding_criteria {
    dynamic "criterion" {
      for_each = each.value.criterion
      content {
        field                 = criterion.value.field
        equals                = criterion.value.equals
        not_equals            = criterion.value.not_equals
        greater_than          = criterion.value.greater_than
        greater_than_or_equal = criterion.value.greater_than_or_equal
        less_than             = criterion.value.less_than
        less_than_or_equal    = criterion.value.less_than_or_equal
      }
    }
  }

  tags = merge(
    {
      "Provisioner" = "Terraform"
    },
    var.tags
  )
}

##################################################
# GuardDuty IPSet
##################################################
resource "aws_guardduty_ipset" "guardduty_ipset" {
  for_each = var.enable_guardduty_ipset && var.guardduty_ipset_variables != null ? { for ipset in var.guardduty_ipset_variables : ipset.name => ipset } : {}

  detector_id = aws_guardduty_detector.guardduty_detector.id

  activate = each.value.activate
  name     = each.value.name
  format   = each.value.format
  location = "https://s3.amazonaws.com/${aws_s3_object.ipset_object[each.key].bucket}/${each.value.key}"

  tags = merge(
    {
      "Provisioner" = "Terraform"
    },
    var.tags
  )
}

resource "aws_s3_object" "ipset_object" {
  for_each = var.enable_guardduty_ipset && var.guardduty_ipset_variables != null ? { for ipset in var.guardduty_ipset_variables : ipset.name => ipset } : {}

  bucket = var.guardduty_s3_bucket

  content = each.value.content
  key     = each.value.key

  tags = merge(
    {
      "Provisioner" = "Terraform"
    },
    var.tags
  )
}

##################################################
# GuardDuty ThreatIntelSet
##################################################
resource "aws_guardduty_threatintelset" "guardduty_threatintelset" {
  for_each = var.enable_guardduty_threatintelset && var.guardduty_threatintelset_variables != null ? { for threatintelset in var.guardduty_threatintelset_variables : threatintelset.name => threatintelset } : {}

  detector_id = aws_guardduty_detector.guardduty_detector.id

  activate = each.value.activate
  name     = each.value.name
  format   = each.value.format
  location = "https://s3.amazonaws.com/${aws_s3_object.threatintelset_object[each.key].bucket}/${each.value.key}"

  tags = merge(
    {
      "Provisioner" = "Terraform"
    },
    var.tags
  )
}

resource "aws_s3_object" "threatintelset_object" {
  for_each = var.enable_guardduty_threatintelset && var.guardduty_threatintelset_variables != null ? { for threatintelset in var.guardduty_threatintelset_variables : threatintelset.name => threatintelset } : {}

  bucket = var.guardduty_s3_bucket

  content = each.value.content
  key     = each.value.key

  tags = merge(
    {
      "Provisioner" = "Terraform"
    },
    var.tags
  )
}
