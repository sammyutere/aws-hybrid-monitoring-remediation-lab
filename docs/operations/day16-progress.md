# Day 16 Progress

## Summary

Implemented Prometheus-based SLO, SLI, and error budget tracking using the aws-node job label.

---

## Key Correction

Original implementation assumed:

job="node_exporter"

Actual system uses:

job="aws-node"

All rules and queries were updated accordingly.

---

## Snapshot

day16-pre-slo-error-budget

---

## Evidence

- lab/evidence/day16_prometheus_targets.json
- lab/evidence/day16-slo-rules.yml
- lab/evidence/day16_prometheus_rules.json
- lab/evidence/day16_slo_ratio_24h.json
- lab/evidence/day16_error_budget_remaining_24h.json
- lab/evidence/day16_ssm_exporter_outage_command.json
- lab/evidence/day16_prometheus_alerts.json
- lab/evidence/day16_up_query.json

---

## Outcome

System now measures:

- availability over time (SLI)
- compliance with SLO (99%)
- remaining error budget
- rate of degradation (burn rate)

---

## Architecture Evolution

From:

- threshold-based alerting
- reactive remediation

To:

- reliability-based monitoring
- SLO-driven alerting
- error budget visibility

---

## Observability Insight

Prometheus queries depend on **labels, not service names**.

Mismatch between:

- service: node_exporter
- job label: aws-node

caused initial SLO failure.

---

## Final State

- SLO rules active
- recording rules validated
- alerts configured
- outage simulation verified
- system producing reliability metrics

---

## Next Step

Day 17:

- burn rate alert tuning
- alert noise reduction
- multi-window alert strategy
