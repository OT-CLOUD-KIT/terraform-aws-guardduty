enable_guardduty             = true
finding_publishing_frequency = "FIFTEEN_MINUTES"
bu                           = "TF"
program                      = "OT"
app                          = "GD"
team                         = "test@mail.com"
region                       = "ap-south-1"
env                          = "q"

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
    status = "DISABLED"
  },
  {
    name   = "EKS_AUDIT_LOGS"
    status = "ENABLED"
  },
  {
    name   = "EBS_MALWARE_PROTECTION"
    status = "DISABLED"
  },
  {
    name   = "RDS_LOGIN_EVENTS"
    status = "DISABLED"
  },
  {
    name   = "LAMBDA_NETWORK_LOGS"
    status = "DISABLED"
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
      equals = ["ap-south-1"]
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
guardduty_s3_bucket    = "testbucketot"
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

name = "testbucketot"
