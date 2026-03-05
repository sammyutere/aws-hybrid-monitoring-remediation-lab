# Runbook: High CPU Utilization

## Alert

EC2HighCPU

## Severity

ticket

## Description

CloudWatch reports CPU utilization above 80%.

## Detection

CloudWatch Alarm:

EC2HighCPU

Prometheus CPU query:

100 - idle %

## Investigation

Check CloudWatch metrics.

aws cloudwatch get-metric-statistics \
 --namespace AWS/EC2 \
 --metric-name CPUUtilization

Check Prometheus CPU query.

http://localhost:9090

Query:

100-(avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[2m]))*100)

## Common Causes

- application workload
- background job
- runaway process
- system misconfiguration

## Remediation

Use SSM to inspect system.

aws ssm send-command \
 --instance-ids <INSTANCE_ID> \
 --document-name AWS-RunShellScript \
 --parameters commands="top -b -n 1"

If necessary restart workload.

## Validation

Confirm CPU returns to normal levels.

CloudWatch metrics

Prometheus query results
