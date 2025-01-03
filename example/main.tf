module "standard_tags" {
  source  = "git::https://github.com/OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"
  bu      = "TF"
  program = "OT"
  app     = "GD"
  team    = "test@mail.com"
  region  = "ap-south-1"
  env     = "q"
}

module "guardduty" {
  source = "../"

  enable_guardduty             = var.enable_guardduty
  finding_publishing_frequency = var.finding_publishing_frequency
  tags                         = module.standard_tags.standard_tags

  guardduty_detector_feature_variables = var.guardduty_detector_feature_variables

  enable_guardduty_filter    = var.enable_guardduty_filter
  guardduty_filter_variables = var.guardduty_filter_variables

  enable_guardduty_ipset    = var.enable_guardduty_ipset
  guardduty_ipset_variables = var.guardduty_ipset_variables
  guardduty_s3_bucket       = var.guardduty_s3_bucket

  enable_guardduty_threatintelset    = var.enable_guardduty_threatintelset
  guardduty_threatintelset_variables = var.guardduty_threatintelset_variables
  depends_on                         = [module.aws_s3_bucket]
}

module "aws_s3_bucket" {
  source = "git::https://github.com/OT-CLOUD-KIT/terraform-aws-s3.git?ref=dev"
  name   = var.name
}
