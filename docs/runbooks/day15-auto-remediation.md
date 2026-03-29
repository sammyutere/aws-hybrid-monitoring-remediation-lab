# Runbook: Automated CPU Remediation

## Trigger
CloudWatch Alarm → Day14-HighCPU-System

## Flow
CloudWatch → EventBridge → SSM → EC2

## Remediation
pkill yes

## Validation
- CPU drops automatically
- no manual SSM execution required

## Failure Modes
- EventBridge rule misconfigured
- IAM role missing permissions
- SSM agent not running

## Rollback
Disable EventBridge rule:
aws events disable-rule --name Day15-HighCPU-Trigger
