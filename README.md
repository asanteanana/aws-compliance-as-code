# AWS Compliance-as-Code Demo

A comprehensive demonstration of implementing compliance controls as code using Terraform, AWS Config, and Python. This project showcases how to build infrastructure that follows security best practices and automatically validates compliance requirements with automated Slack notifications.

## 🎯 Features

- **Infrastructure as Code**: Terraform-based AWS resource provisioning with built-in compliance controls
- **Automated Compliance Checking**: Integration with AWS Config for continuous compliance monitoring
- **Real-time Notifications**: Context-aware Slack reporting with risk levels and remediation guides
- **Audit Trail**: CSV export for long-term compliance tracking
- **Security Best Practices**: Encryption, versioning, access controls, and proper tagging

## 🏗️ Project Structure

```
aws-compliance-as-code/
│
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

## 🚀 Quick Start

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

## 📋 Compliance Controls Implemented

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

## 🔍 Compliance Reporting

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

## 🔧 Customization

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

## 📊 Example Output

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

## 🛡️ Security Considerations

### Never Commit These Files

- `.env` - Contains API tokens and secrets
- `terraform.tfstate` - Contains AWS resource IDs and credentials
- `.aws/credentials` - AWS access keys
- Any files with real account IDs or personal information

### Best Practices

- Always use `.env.example` as a template
- Rotate keys immediately if accidentally committed
- Use AWS IAM roles instead of access keys when possible
- Enable GitHub Secret Scanning in repository settings
- Use pre-commit hooks to prevent secret commits

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Config User Guide](https://docs.aws.amazon.com/config/latest/developerguide/)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-resources/)
- [Compliance-as-Code Patterns](https://www.hashicorp.com/resources/compliance-as-code)
- [Infrastructure Security Guidelines](https://aws.amazon.com/architecture/security-identity-compliance/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This is a demonstration project for educational purposes. Adapt the compliance rules and infrastructure to your specific requirements and security policies. Always test thoroughly in a non-production environment before deploying to production.

---

**Note:** This project demonstrates modern DevOps practices including Infrastructure as Code, automated compliance checking, and integration with collaboration tools. It's designed as a portfolio piece showcasing cloud security and automation skills.
