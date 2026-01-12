enable_guardduty             = true
finding_publishing_frequency = "FIFTEEN_MINUTES"


guardduty_detector_feature_variables = [
  {
    name   = "EKS_RUNTIME_MONITORING"
    status = "ENABLED"
    additional_configuration = [
      {
        name   = "EKS_ADDON_MANAGEMENT"
        status = "ENABLED"
      }
    ]
  },
  {
    name   = "S3_DATA_EVENTS"
    status = "ENABLED"
  },
  {
    name   = "EKS_AUDIT_LOGS"
    status = "ENABLED"
  },
  {
    name   = "EBS_MALWARE_PROTECTION"
    status = "ENABLED"
  },
  {
    name   = "RDS_LOGIN_EVENTS"
    status = "ENABLED"
  },
  {
    name   = "LAMBDA_NETWORK_LOGS"
    status = "ENABLED"
  }
  
]

enable_guardduty_filter = true
guardduty_filter_variables = [{
  name        = "guardduty_filter"
  description = "AWS GuardDuty example filter."
  rank        = 1
  action      = "ARCHIVE"
  criterion = [

    {
      field  = "region"
      equals = ["us-east-1"]
    },
    {
      field      = "service.additionalInfo.threatListName"
      not_equals = ["some-threat", "another-threat"]
    },
    {
      field        = "updatedAt"
      greater_than = "2023-01-01T00:00:00Z"
      less_than    = "2023-12-31T23:59:59Z"
    },
    {
      field                 = "severity"
      greater_than_or_equal = "4"
    }
  ]
}]

enable_guardduty_ipset = true
guardduty_s3_bucket    = "team-d-ntd-bucket"
guardduty_ipset_variables = [{
  activate = false
  name     = "DefaultGuardDutyIPSet"
  format   = "TXT"
  content  = "10.0.0.0/8\n"
  key      = "DefaultGuardDutyIPSet"
}]

enable_guardduty_threatintelset = true
guardduty_threatintelset_variables = [{
  activate   = false
  name       = "DefaultGuardThreatIntelSet"
  format     = "TXT"
  content    = "1.10.16.0/20\n1.19.0.0/16\n"
  key        = "DefaultGuardThreatIntelSet"
  object_acl = "public-read"
}]

create_bucket = true
name          = "team-d-ntd-bucket"
bucket_prefix = "ntd-"
force_destroy = true

object_lock_enabled          = false
enable_transfer_acceleration = true


acl = "private"

attach_public_policy    = true
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true

attach_cloudtrail_policy       = true
attach_elb_log_delivery_policy = false
attach_lb_log_delivery_policy  = false
attach_iam_policy              = false
iam_policy                     = ""

control_object_ownership = true
object_ownership         = "BucketOwnerEnforced"

cors_rules = []

server_side_encryption_configuration = []

logging = {
  target_bucket = "ot-cloud-kit-bucket-2"
  target_prefix = "logs/"
}

versioning = {
  enabled    = true
  status     = "Enabled"
  mfa_delete = false
}


lifecycle_rules = [
  {
    id     = "log-transition"
    status = "Enabled"

    transitions = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 60
        storage_class = "GLACIER"
      }
    ]
    expiration_days = 365
  }
]

metric_configuration = []

elb_service_accounts = {}

elb_identifier      = "logdelivery.elb.amazonaws.com"
lb_identifier       = "logdelivery.elasticloadbalancing.amazonaws.com"
log_delivery_folder = "logs"

lb_log_delivery_conditions = {}
