import boto3
import csv
import datetime
import os
import tempfile
from dotenv import load_dotenv
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

# Load environment variables from .env file
load_dotenv()

def fetch_config_compliance():
    client = boto3.client("config")
    rules = [
        "s3-bucket-server-side-encryption-enabled",
        "required-owner-tag"
    ]
    report = []
    for rule in rules:
        response = client.describe_compliance_by_config_rule(
            ConfigRuleNames=[rule]
        )
        for r in response["ComplianceByConfigRules"]:
            report.append({
                "Rule": r["ConfigRuleName"],
                "Status": r["Compliance"]["ComplianceType"]
            })
    return report
    
def post_to_slack(results):
    """Send context-aware compliance report to Slack with detailed information"""
    client = WebClient(token=os.getenv("SLACK_BOT_TOKEN"))
    channel = os.getenv("SLACK_CHANNEL_ID")

    # Context and mappings
    RULE_CONTEXT = {
        "s3-bucket-server-side-encryption-enabled": {
            "context": "Ensures S3 buckets enforce encryption at rest.",
            "reference": "<https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-server-side-encryption-enabled.html|AWS Config Rule Doc>",
            "regulation": "GDPR Art.32, ISO 27001 A.10",
            "risk": "High",
            "remediation": "<https://docs.aws.amazon.com/AmazonS3/latest/userguide/default-bucket-encryption.html|Enable default bucket encryption>"
        },
        "required-owner-tag": {
            "context": "Ensures resources include an 'owner' tag for accountability.",
            "reference": "<https://docs.aws.amazon.com/config/latest/developerguide/required-tags.html|AWS Config Rule Doc>",
            "regulation": "NIST 800-53 CM-8, ISO 27001 A.8.1.1",
            "risk": "Medium",
            "remediation": "<https://aws.amazon.com/blogs/mt/automate-tag-compliance-using-aws-config-and-aws-lambda/|Automate tag compliance>"
        },
        "account-part-of-organizations": {
            "context": "Validates account is part of AWS Organizations for centralized governance.",
            "reference": "<https://docs.aws.amazon.com/config/latest/developerguide/account-part-of-organizations.html|AWS Config Rule Doc>",
            "regulation": "SOC 2 CC1.2, NIST 800-53 AC-2",
            "risk": "Medium",
            "remediation": "<https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tutorials_basic.html|Add account to AWS Organizations>"
        }
    }

    compliant = sum(1 for r in results if r["Status"] == "COMPLIANT")
    non_compliant = sum(1 for r in results if r["Status"] != "COMPLIANT")

    summary = [
        {
            "type": "header",
            "text": {"type": "plain_text", "text": "Compliance-as-Code Report"}
        },
        {
            "type": "section",
            "fields": [
                {"type": "mrkdwn", "text": f"*Generated:* {datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}"},
                {"type": "mrkdwn", "text": f"*Compliant:* `{compliant}`"},
                {"type": "mrkdwn", "text": f"*Non-Compliant:* `{non_compliant}`"}
            ]
        },
        {"type": "divider"},
    ]

    details = []
    csv_rows = []

    for r in results:
        info = RULE_CONTEXT.get(r["Rule"], {})
        context = info.get("context", "No context available.")
        reference = info.get("reference", "")
        regulation = info.get("regulation", "N/A")
        risk = info.get("risk", "Low")
        remediation = info.get("remediation", "N/A")

        details.append({
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": (
                    f"*Rule:* `{r['Rule']}`\n"
                    f"*Status:* `{r['Status']}`\n"
                    f"*Risk Level:* {risk}\n"
                    f"*Context:* {context}\n"
                    f"*Regulation:* {regulation}\n"
                    f"*Remediation:* {remediation}\n"
                    f"{reference}"
                )
            }
        })
        details.append({"type": "divider"})

        csv_rows.append([
            r['Rule'], r['Status'], risk, context, regulation, remediation
        ])

    # Generate CSV for audit logs
    with tempfile.NamedTemporaryFile(mode='w', delete=False, newline='', suffix='.csv') as tmp:
        writer = csv.writer(tmp)
        writer.writerow(["Rule", "Status", "Risk Level", "Context", "Regulation", "Remediation Guide"])
        writer.writerows(csv_rows)
        csv_path = tmp.name

    # Send Slack message
    try:
        client.chat_postMessage(
            channel=channel,
            text="Compliance-as-Code Report",
            blocks=summary + details
        )
        print("Compliance report successfully sent to Slack.")
        
        # Try to upload CSV summary (optional - requires files:write scope)
        try:
            client.files_upload_v2(
                channel=channel,
                initial_comment="📁 Compliance Audit Summary (CSV)",
                file=csv_path,
                title=f"Compliance_Report_{datetime.date.today()}.csv"
            )
            print("CSV audit summary uploaded to Slack.")
        except SlackApiError as e:
            print(f"⚠️ CSV upload skipped (missing files:write scope): {e.response['error']}")
            print(f"💡 Tip: Add 'files:write' scope to your Slack bot for CSV uploads")
    except SlackApiError as e:
        print(f"Error posting to Slack: {e.response['error']}")
    finally:
        os.remove(csv_path)

if __name__ == "__main__":
    results = fetch_config_compliance()
    
    # Print to console
    print(f"\nCompliance Report — {datetime.datetime.utcnow().isoformat()} UTC\n")
    for r in results:
        print(f"{r['Rule']}: {r['Status']}")
    
    # Send to Slack
    print("\n📤 Sending to Slack...")
    post_to_slack(results)
