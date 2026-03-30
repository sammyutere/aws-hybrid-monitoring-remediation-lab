# Runbook: SLO and Error Budget Tracking (aws-node job)

## Objective

Measure system reliability using Prometheus-based SLI, SLO, and error budget calculations for the monitored EC2 node.

---

## Service Mapping (IMPORTANT)

| Component | Value |
|----------|------|
| Service | node_exporter |
| Prometheus job label | aws-node |
| Instance | 184.73.6.214:9100 |

NOTE:
Prometheus queries must use the **job label (`aws-node`)**, not the service name (`node_exporter`).

---

## SLI (Service Level Indicator)

Prometheus target availability:

up{job="aws-node"}

This metric represents whether Prometheus can successfully scrape the node exporter.

---

## SLO (Service Level Objective)

99.0% availability over a rolling 24-hour window.

---

## Error Budget

Allowed failure:

1.0% over 24 hours

Error budget remaining:

job:aws_node:error_budget_remaining_24h

---

## Recording Rules

- job:aws_node:up:ratio_5m
- job:aws_node:up:ratio_1h
- job:aws_node:up:ratio_24h
- job:aws_node:error_budget_remaining_24h

---

## Alerts

### SLO Breach

- Alert: AwsNodeSLOBreaching
- Condition: 24h availability < 99%

### Fast Burn

- Alert: AwsNodeFastBurn
- Condition: 1h availability < 95%

---

## Investigation Steps

1. Check Prometheus target health:

   curl -s http://localhost:9090/api/v1/targets | jq '.'

2. Check availability metric:

   curl -sG http://localhost:9090/api/v1/query \
     --data-urlencode 'query=up{job="aws-node"}' | jq '.'

3. Check SLO ratios:

   job:aws_node:up:ratio_5m  
   job:aws_node:up:ratio_1h  
   job:aws_node:up:ratio_24h

4. Check error budget:

   job:aws_node:error_budget_remaining_24h

5. Check active alerts:

   curl -s http://localhost:9090/api/v1/alerts | jq '.'

6. Validate exporter on EC2:

   systemctl status node_exporter --no-pager

---

## Remediation

If exporter is down:

aws ssm send-command \
  --instance-ids <INSTANCE_ID> \
  --document-name AWS-RunShellScript \
  --parameters 'commands=["sudo systemctl restart node_exporter"]'

---

## Validation

- Prometheus target returns to UP
- up{job="aws-node"} returns value 1
- SLO ratios begin recovering
- alerts resolve automatically

---

## Failure Modes

| Failure | Cause |
|--------|------|
| Empty query results | incorrect job label |
| No SLO metrics | rules not loaded |
| Alerts not firing | Prometheus not reloaded |
| No data | exporter stopped or unreachable |

---

## Rollback

git checkout day16-pre-slo-error-budget

or:

git reset --hard <commit_sha>
