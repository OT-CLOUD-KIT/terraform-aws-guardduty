# Terraform AWS GuardDuty

A Terraform module to deploy and manage **Amazon GuardDuty** across one or multiple AWS regions and accounts. This module supports enabling various protection types, exporting findings to S3, configuring threat intelligence and IP sets, filters, and more.

---

## Architecture
<img width="490" height="338" alt="image" src="https://github.com/user-attachments/assets/03b4f2d9-acda-47b8-a2bf-6110b8bf9136" />



> **Note:**  
> This module supports both **organization-wide** and **standalone** GuardDuty deployments. You can enable advanced features such as **S3 protection**, **Malware protection**, and **Kubernetes audit logging**.


---

##  Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0   |
| <a name="terraform"></a> Terraform                | >= 1.3.0 |

---

## Usage

```hcl
module "guardduty" {
  source = "OT-CLOUD-KIT/terraform-aws-guardduty"

  enable_guardduty             = true
  enable_s3_protection         = true
  enable_kubernetes_protection = true
  enable_malware_protection    = true
  enable_snapshot_retention    = false

  finding_publishing_frequency = "FIFTEEN_MINUTES"

  publish_to_s3        = true
  guardduty_s3_bucket  = "my-gd-findings-bucket"
  guardduty_bucket_acl = "private"

  replica_region = "us-west-2"

  publishing_config = [{
    destination_arn  = "arn:aws:s3:::my-gd-findings-bucket"
    kms_key_arn      = "arn:aws:kms:us-east-1:111122223333:key/abcd1234-ef56-7890-abcd-111122223333"
    destination_type = "S3"
  }]

  ipset_config = [{
    activate = true
    name     = "MyIPSet"
    format   = "TXT"
    content  = "10.0.0.0/8\n"
    key      = "ipsets/my-ipset.txt"
  }]

  threatintelset_config = [{
    activate   = true
    name       = "MyThreatIntel"
    format     = "TXT"
    content    = "198.51.100.0/24\n"
    key        = "intel/my-threatintel.txt"
    object_acl = "private"
  }]

  filter_config = [{
    name        = "LowSeverityFilter"
    description = "Archive low severity findings"
    rank        = 1
    action      = "ARCHIVE"
    criterion = [{
      field      = "severity"
      less_than  = "4"
    }]
  }]

  tags = {
    Environment = "prod"
    Project     = "GuardDutyDeployment"
  }
}
```

## Resource

| Name                                                                                                                                                    | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws\_guardduty\_detector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector)                              | resource |
| [aws\_guardduty\_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_filter)                                  | resource |
| [aws\_guardduty\_ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset)                                    | resource |
| [aws\_guardduty\_threatintelset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_threatintelset)                  | resource |
| [aws\_guardduty\_publishing\_destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination) | resource |

___

## Input

| Name                                                                                                                    | Description                                                                    | Type           | Default             | Required |
| ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | -------------- | ------------------- | :------: |
| <a name="input_replica_region"></a> [replica\_region](#input_replica_region)                                            | Region to replicate findings S3 bucket                                         | `string`       | `null`              |    no    |
| <a name="input_enable_guardduty"></a> [enable\_guardduty](#input_enable_guardduty)                                      | Enable GuardDuty detection                                                     | `bool`         | `true`              |    no    |
| <a name="input_enable_s3_protection"></a> [enable\_s3\_protection](#input_enable_s3_protection)                         | Enable S3 protection                                                           | `bool`         | `true`              |    no    |
| <a name="input_enable_kubernetes_protection"></a> [enable\_kubernetes\_protection](#input_enable_kubernetes_protection) | Enable Kubernetes audit log protection                                         | `bool`         | `true`              |    no    |
| <a name="input_enable_malware_protection"></a> [enable\_malware\_protection](#input_enable_malware_protection)          | Enable Malware Protection                                                      | `bool`         | `true`              |    no    |
| <a name="input_enable_snapshot_retention"></a> [enable\_snapshot\_retention](#input_enable_snapshot_retention)          | Retain EBS snapshots for 30 days                                               | `bool`         | `false`             |    no    |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input_finding_publishing_frequency) | Frequency for publishing findings (`FIFTEEN_MINUTES`, `ONE_HOUR`, `SIX_HOURS`) | `string`       | `"FIFTEEN_MINUTES"` |    no    |
| <a name="input_filter_config"></a> [filter\_config](#input_filter_config)                                               | Filter configuration block for custom finding filters                          | `list(object)` | `null`              |    no    |
| <a name="input_ipset_config"></a> [ipset\_config](#input_ipset_config)                                                  | List of IPSet configurations                                                   | `list(object)` | `null`              |    no    |
| <a name="input_threatintelset_config"></a> [threatintelset\_config](#input_threatintelset_config)                       | List of ThreatIntelSet configurations                                          | `list(object)` | `null`              |    no    |
| <a name="input_publish_to_s3"></a> [publish\_to\_s3](#input_publish_to_s3)                                              | Whether to export findings to S3                                               | `bool`         | `false`             |    no    |
| <a name="input_publishing_config"></a> [publishing\_config](#input_publishing_config)                                   | S3/KMS config for findings export                                              | `list(object)` | See example         |    no    |
| <a name="input_guardduty_s3_bucket"></a> [guardduty\_s3\_bucket](#input_guardduty_s3_bucket)                            | S3 bucket name for exporting findings                                          | `string`       | `null`              |    no    |
| <a name="input_guardduty_bucket_acl"></a> [guardduty\_bucket\_acl](#input_guardduty_bucket_acl)                         | ACL to apply to the S3 bucket                                                  | `string`       | `null`              |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                           | Key-value tags for all resources                                               | `map(any)`     | `{}`                |    no    |


## Output

| Name                                                                                                         | Description                                       |
| ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------- |
| <a name="output_guardduty_detector"></a> [guardduty\_detector](#output_guardduty_detector)                   | AWS GuardDuty Detector.                           |
| <a name="output_guardduty_filter"></a> [guardduty\_filter](#output_guardduty_filter)                         | AWS GuardDuty Findings Filters definition.        |
| <a name="output_guardduty_ipset"></a> [guardduty\_ipset](#output_guardduty_ipset)                            | AWS GuardDuty trusted IPSet configuration.        |
| <a name="output_guardduty_threatintelset"></a> [guardduty\_threatintelset](#output_guardduty_threatintelset) | AWS GuardDuty known ThreatIntelSet configuration. |


___


## Contributors

- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)

