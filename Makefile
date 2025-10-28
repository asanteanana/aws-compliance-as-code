# Makefile for Compliance-as-Code Demo
# This file provides convenient commands for running compliance checks

.PHONY: help init plan apply destroy check-compliance clean test format validate

# Default target
help: ## Show this help message
	@echo "Compliance-as-Code Demo Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Terraform commands
init: ## Initialize Terraform
	terraform init

plan: ## Plan Terraform changes
	terraform plan

apply: ## Apply Terraform changes
	terraform apply

destroy: ## Destroy Terraform resources
	terraform destroy

# Compliance commands
check-compliance: ## Run all compliance checks
	python report.py

check-compliance-json: ## Run compliance checks and output JSON
	python report.py --format json --output compliance-report.json

check-compliance-markdown: ## Run compliance checks and output Markdown
	python report.py --format markdown --output compliance-report.md

# Code quality commands
format: ## Format Terraform code
	terraform fmt -recursive

validate: ## Validate Terraform configuration
	terraform validate

test: ## Run all tests and checks
	@echo "Running Terraform validation..."
	terraform validate
	@echo "Running Terraform format check..."
	terraform fmt -check -diff
	@echo "Running compliance checks..."
	python report.py
	@echo "All checks completed!"

# Environment setup
setup-dev: ## Setup development environment
	@echo "Setting up development environment..."
	cp environment.tfvars.example dev.tfvars
	@echo "Edit dev.tfvars with your development settings"

setup-prod: ## Setup production environment  
	@echo "Setting up production environment..."
	cp environment.tfvars.example prod.tfvars
	@echo "Edit prod.tfvars with your production settings"

# Cleanup commands
clean: ## Clean up temporary files
	rm -f *.tfstate*
	rm -f .terraform.lock.hcl
	rm -f compliance-report.*
	rm -f *.log

clean-all: clean ## Clean up all files including Terraform state
	rm -rf .terraform/
	rm -f *.tfvars

# CI/CD commands
ci-check: ## Run CI/CD compliance checks
	@echo "Running CI/CD compliance checks..."
	terraform init
	terraform validate
	terraform fmt -check -diff
	python report.py --format json --output compliance-report.json
	@echo "CI/CD checks completed!"

# Documentation commands
docs: ## Generate documentation
	@echo "Generating compliance documentation..."
	python report.py --format markdown --output COMPLIANCE.md
	@echo "Documentation generated: COMPLIANCE.md"

# Security commands
security-scan: ## Run security scan
	@echo "Running security scan..."
	python report.py --format json --output security-report.json
	@echo "Security scan completed!"

# Monitoring commands
monitor: ## Run monitoring checks
	@echo "Running monitoring compliance checks..."
	python report.py --format json --output monitoring-report.json
	@echo "Monitoring checks completed!"
