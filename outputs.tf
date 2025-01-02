##################################################
# GuardDuty Detector
##################################################
output "guardduty_detector" {
  description = "AWS GuardDuty Detector."
  value       = aws_guardduty_detector.guardduty_detector
}

##################################################
# GuardDuty Filter
##################################################
output "guardduty_filter" {
  description = "AWS GuardDuty Findings Filters definition."
  value       = aws_guardduty_filter.guardduty_filter
}

##################################################
# GuardDuty IPSet
##################################################
output "guardduty_ipset" {
  description = "AWS GuardDuty trusted IPSet configuration."
  value       = aws_guardduty_ipset.guardduty_ipset
}

##################################################
# GuardDuty Threatintelset
##################################################
output "guardduty_threatintelset" {
  description = "AWS GuardDuty known ThreatIntelSet configuration."
  value       = aws_guardduty_threatintelset.guardduty_threatintelset
}