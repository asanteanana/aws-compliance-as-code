# Compliance Rules Configuration
# This file defines additional compliance rules that can be checked

COMPLIANCE_RULES = {
    "terraform": {
        "required_version": ">= 1.0",
        "required_providers": {
            "aws": "~> 5.0"
        },
        "backend_encryption": True,
        "state_locking": True
    },
    "aws_s3": {
        "encryption_required": True,
        "versioning_required": True,
        "public_access_blocked": True,
        "ssl_only": True,
        "minimum_tls_version": "TLSv1.2"
    },
    "aws_iam": {
        "least_privilege": True,
        "no_wildcard_permissions": True,
        "mfa_required": True,
        "password_policy": {
            "min_length": 14,
            "require_uppercase": True,
            "require_lowercase": True,
            "require_numbers": True,
            "require_symbols": True
        }
    },
    "aws_security_groups": {
        "restrictive_rules": True,
        "no_0.0.0.0/0_ingress": True,
        "specific_ports_only": True,
        "documented_rules": True
    },
    "aws_logging": {
        "cloudwatch_enabled": True,
        "log_retention_minimum": 30,
        "structured_logging": True,
        "log_encryption": True
    },
    "aws_tagging": {
        "required_tags": [
            "Name",
            "Environment",
            "Project",
            "Owner",
            "CostCenter"
        ],
        "tag_naming_convention": "snake_case",
        "tag_value_validation": True
    },
    "aws_networking": {
        "vpc_required": True,
        "private_subnets": True,
        "nat_gateway": True,
        "no_direct_internet_access": True
    }
}

# Compliance Severity Levels
SEVERITY_LEVELS = {
    "CRITICAL": {
        "color": "red",
        "exit_code": 1,
        "description": "Security vulnerability or compliance violation"
    },
    "HIGH": {
        "color": "orange", 
        "exit_code": 1,
        "description": "Important security or compliance issue"
    },
    "MEDIUM": {
        "color": "yellow",
        "exit_code": 2,
        "description": "Security or compliance warning"
    },
    "LOW": {
        "color": "blue",
        "exit_code": 0,
        "description": "Informational compliance note"
    }
}

# Compliance Check Categories
CHECK_CATEGORIES = {
    "SECURITY": "Security-related compliance checks",
    "NETWORKING": "Network security and configuration checks", 
    "IDENTITY": "Identity and access management checks",
    "DATA": "Data protection and encryption checks",
    "LOGGING": "Logging and monitoring checks",
    "TAGGING": "Resource tagging and metadata checks",
    "COST": "Cost optimization and resource management checks"
}
