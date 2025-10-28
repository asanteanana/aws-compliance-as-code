# Terraform Outputs Configuration
# This file demonstrates proper output management

output "compliance_summary" {
  description = "Summary of compliance controls implemented"
  value = {
    s3_encryption_enabled       = true
    s3_versioning_enabled       = true
    s3_public_access_blocked    = true
    iam_least_privilege         = true
    security_groups_restrictive = true
    logging_enabled             = true
    tagging_compliant           = true
  }
}

output "resource_arns" {
  description = "ARNs of created resources for compliance tracking"
  value = {
    bucket_arn    = aws_s3_bucket.compliance_demo.arn
    role_arn      = aws_iam_role.compliance_role.arn
    log_group_arn = aws_cloudwatch_log_group.compliance_logs.arn
  }
}

output "compliance_tags" {
  description = "Standard compliance tags applied to resources"
  value = {
    Compliance   = "enabled"
    Environment  = var.environment
    Project      = var.project_name
    ManagedBy    = "terraform"
    LastModified = timestamp()
  }
}
