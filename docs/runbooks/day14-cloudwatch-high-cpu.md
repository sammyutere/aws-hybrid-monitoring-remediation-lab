# Runbook: CloudWatch High CPU (IAM-corrected model)

## Access
ssh -i ~/.ssh/aws-hybrid-lab ssm-user@<EC2_PUBLIC_IP>

## Detection
- Prometheus (primary)
- CloudWatch Agent (secondary validation)

## IAM Model
- EC2 role: metric write only
- Operator credentials: metric read

## Remediation
aws ssm send-command \
  --parameters 'commands=["pkill yes"]'

## Validation
- CPU drops
- alarms resolve
- system stable

## Rollback
pre-day14-cloudwatch-agent-YYYYMMDD-HHMM
