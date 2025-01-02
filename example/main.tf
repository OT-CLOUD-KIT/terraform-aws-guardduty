module "guardduty" {
  source = "../"

  enable_guardduty             = var.enable_guardduty
  enable_s3_protection         = var.enable_s3_protection
  enable_kubernetes_protection = var.enable_kubernetes_protection
  enable_malware_protection    = var.enable_malware_protection
  enable_snapshot_retention    = var.enable_snapshot_retention
  finding_publishing_frequency = var.finding_publishing_frequency
  tags                         = var.tags

  enable_guardduty_filter    = var.enable_guardduty_filter
  guardduty_filter_variables = var.guardduty_filter_variables

  enable_guardduty_ipset    = var.enable_guardduty_ipset
  guardduty_ipset_variables = var.guardduty_ipset_variables
  guardduty_s3_bucket       = var.guardduty_s3_bucket

  enable_guardduty_threatintelset    = var.enable_guardduty_threatintelset
  guardduty_threatintelset_variables = var.guardduty_threatintelset_variables

}
