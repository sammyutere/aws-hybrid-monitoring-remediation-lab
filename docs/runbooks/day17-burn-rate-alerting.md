# Runbook: Burn Rate Alerting (aws-node)

## Objective

Detect reliability issues based on **error budget consumption rate**

## Burn Rate Formula

burn_rate = error_rate / allowed_error_rate

## Thresholds

| Severity | Burn Rate | Meaning |
|---------|----------|--------|
| critical | >14 | catastrophic failure |
| page | >6 | rapid degradation |
| ticket | >3 | slow degradation |

## Alerts

- AwsNodeFastBurnCritical
- AwsNodeBurnRateHigh
- AwsNodeBurnRateSlow

## Investigation

1. Check burn rate metrics
2. Check SLO ratios
3. Check exporter status
4. Confirm system load

## Remediation

Restart exporter:

aws ssm send-command \
  --parameters 'commands=["sudo systemctl restart node_exporter"]'

## Validation

- burn rate returns to ~0
- alerts resolve
