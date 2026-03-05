# Runbook: NodeExporterDown

## Alert

NodeExporterDown

## Severity

page

## Description

Prometheus cannot scrape node_exporter from EC2 instance.

## Detection

Alert fires when:

up{job="aws-node"} == 0

for 2 minutes.

## Immediate Checks

1. Confirm Prometheus target status.

http://localhost:9090/targets

2. Verify exporter port reachable.

curl http://<ELASTIC_IP>:9100/metrics

3. Confirm EC2 instance running.

aws ec2 describe-instances --instance-ids <INSTANCE_ID>

## Automated Remediation

Alertmanager webhook triggers automation script:

automation/scripts/restart_node_exporter.sh

Script sends SSM command:

sudo systemctl restart node_exporter

## Manual Recovery

If automation fails:

aws ssm send-command \
 --instance-ids <INSTANCE_ID> \
 --document-name AWS-RunShellScript \
 --parameters commands="sudo systemctl restart node_exporter"

## Validation

Verify exporter metrics:

curl http://<ELASTIC_IP>:9100/metrics

Verify Prometheus target:

http://localhost:9090/targets

Status should return to UP.

## Root Cause Investigation

Possible causes:

- exporter process crash
- EC2 reboot
- networking failure
- security group change

## Evidence Collection

Prometheus alerts API

curl http://localhost:9090/api/v1/alerts

Alertmanager alerts

curl http://localhost:9093/api/v2/alerts

SSM command history

aws ssm list-commands
