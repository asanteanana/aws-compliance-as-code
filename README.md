# AWS Compliance-as-Code Demo

A comprehensive demonstration of implementing compliance controls as code using Terraform, AWS Config, and Python. This project showcases how to build infrastructure that follows security best practices and automatically validates compliance requirements with automated Slack notifications.

## Features

- **Infrastructure as Code**: Terraform-based AWS resource provisioning with built-in compliance controls
- **Automated Compliance Checking**: Integration with AWS Config for continuous compliance monitoring
- **Real-time Notifications**: Context-aware Slack reporting with risk levels and remediation guides
- **Audit Trail**: CSV export for long-term compliance tracking
- **Security Best Practices**: Encryption, versioning, access controls, and proper tagging

## Demo & Screenshots

### Context-Aware Slack Compliance Report

![Slack Compliance Report](./images/slack-compliance-report.png)

*Automated compliance report with risk levels, regulatory mapping, and remediation guides*

### Infrastructure Deployment

![Terraform Plan](./images/terraform-plan.png)

*Terraform plan showing 11 resources with compliance controls*

### S3 Bucket Compliance Configuration

![S3 Bucket Configuration](./images/s3-bucket-config.png)

*Encryption, versioning, and comprehensive tagging on S3 resources*

### AWS Config Integration

![AWS Config Rules](./images/aws-config-console.png)

*AWS Config rules dashboard showing compliance status*

### Terminal Output

![Compliance Check Output](./images/terminal-report.png)

*Python automation checking AWS Config compliance rules*

## Project Structure

```
aws-compliance-as-code/
│
├── images/                      # Screenshots and demo images
├── main.tf                      # Terraform infrastructure with compliance controls
├── variables.tf                 # Terraform variables with validation rules
├── outputs.tf                   # Terraform outputs configuration
├── report.py                    # Python compliance reporting with AWS Config
├── compliance_rules.py          # Compliance rules configuration
├── requirements.txt             # Python dependencies
├── .env.example                 # Example environment variables template
├── .gitignore                   # Git ignore rules for sensitive data
└── README.md                    # This documentation
```

## Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Python](https://www.python.org/downloads/) >= 3.7
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with necessary permissions
- Slack workspace with a bot token

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/aws-compliance-as-code.git
   cd aws-compliance-as-code
   ```

2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your actual Slack bot token and channel ID
   ```

4. **Configure AWS credentials:**
   ```bash
   aws configure
   # Or use environment variables
   export AWS_ACCESS_KEY_ID="your-key"
   export AWS_SECRET_ACCESS_KEY="your-secret"
   ```

5. **Initialize Terraform:**
   ```bash
   terraform init
   ```

### Running the Demo

1. **Plan the infrastructure:**
   ```bash
   terraform plan
   ```

2. **Apply the infrastructure:**
   ```bash
   terraform apply
   ```

3. **Run compliance checks and send to Slack:**
   ```bash
   python report.py
   ```

## Compliance Controls Implemented

### Infrastructure Security

- **S3 Bucket Security:**
  - Server-side encryption (AES256)
  - Versioning enabled
  - Public access blocked
  - Proper tagging for accountability

- **IAM Security:**
  - Least privilege access policies
  - Role-based access control
  - Resource-specific permissions

- **Network Security:**
  - Security groups with restrictive rules
  - HTTPS and SSH access only
  - Proper CIDR restrictions

- **Logging & Monitoring:**
  - CloudWatch log groups
  - Configurable log retention
  - Structured logging

## Compliance Reporting

The `report.py` script provides comprehensive compliance checking:

### Features

- **Automated Validation:** Checks AWS Config compliance rules
- **Security Compliance:** Validates S3, IAM, and Security Group configurations
- **Context-Aware Reporting:** Includes risk levels, regulation mapping, and remediation guides
- **Multiple Output Formats:** Terminal output, Slack notifications, and CSV export
- **CI/CD Integration:** Audit-ready reports with timestamps

### Usage Examples

```bash
# Basic compliance check with Slack notification
python report.py

# Generate JSON report
python report.py --format json --output compliance-report.json

# Generate Markdown report
python report.py --format markdown --output compliance-report.md
```

### Report Output

The compliance report includes:

- **Summary Statistics:** Total checks, passed, failed, warnings
- **Detailed Results:** Individual check status and messages
- **Risk Assessment:** Low/Medium/High risk classification
- **Regulatory Mapping:** GDPR, ISO 27001, NIST 800-53, SOC 2 compliance
- **Remediation Guides:** Direct links to fix compliance issues
- **Timestamps:** When checks were performed

## Customization

### Adding New Compliance Rules

1. **Extend the RULE_CONTEXT in report.py:**
   ```python
   RULE_CONTEXT = {
       "your-rule-name": {
           "context": "Why this rule matters",
           "reference": "AWS documentation link",
           "regulation": "Regulatory requirements",
           "risk": "High/Medium/Low",
           "remediation": "How to fix it"
       }
   }
   ```

2. **Update AWS Config rules in fetch_config_compliance():**
   ```python
   rules = [
       "s3-bucket-server-side-encryption-enabled",
       "required-owner-tag",
       "your-new-rule"
   ]
   ```

### Terraform Variables

Modify `variables.tf` to add new parameters:

```hcl
variable "custom_setting" {
  description = "Custom compliance setting"
  type        =.string
  default     = "secure-default"
  
  validation {
    condition = can(regex("^[a-z-]+$", var.custom_setting))
    error_message = "Setting must be lowercase with hyphens only."
  }
}
```

## Example Output

### Slack Notification

```
Compliance-as-Code Report
Generated: 2025-01-15 10:30:00 UTC
Compliant: 1
Non-Compliant: 1
────────────────────────────
Rule: s3-bucket-server-side-encryption-enabled
Status: COMPLIANT
Risk Level: High
Context: Ensures S3 buckets enforce encryption at rest
Regulation: GDPR Art.32, ISO 27001 A.10
Remediation: Enable default bucket encryption
────────────────────────────
```

## Security Considerations

### Never Commit These Files

- `.env` - Contains API tokens and secrets
- `terraform.tfstate` - Contains AWS resource IDs and credentials
- `.aws/credentials` - AWS access keys
- Any files with real account IDs or personal information

### Best Practices I've Learned

- Always use `.env.example` as a template
- Rotate keys immediately if accidentally committed
- Use AWS IAM roles instead of access keys when possible
- Enable GitHub Secret Scanning in repository settings
- Use pre-commit hooks to prevent secret commits


## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Config User Guide](https://docs.aws.amazon.com/config/latest/developerguide/)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-resources/)
- [Compliance-as-Code Patterns](https://www.hashicorp.com/resources/compliance-as-code)
- [Infrastructure Security Guidelines](https://aws.amazon.com/architecture/security-identity-compliance/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
