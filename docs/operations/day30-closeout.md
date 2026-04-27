# Day 30 Closeout

## Summary

Completed the AWS Hybrid Monitoring and Remediation Lab through Day 30.

## Major Outcomes

- Built a local Prometheus, Alertmanager, and Grafana stack
- Monitored an AWS EC2 instance through node_exporter
- Implemented SLO and burn-rate alerting
- Added Alertmanager severity routing
- Added silences and inhibition rules
- Standardized notification capture
- Added meta-monitoring for the monitoring stack itself
- Containerized meta-health checks
- Added Grafana dashboards
- Created backup and restore validation
- Automated restore validation
- Created audit-ready evidence bundles

## Evidence Model

Evidence is stored under:

lab/evidence/

## Documentation Model

Runbooks are stored under:

docs/runbooks/

Progress notes are stored under:

docs/operations/

## Final Validation

Final validation evidence was captured on Day 30.

## Recovery Interpretation

A recovered service does not guarantee cleared alerts.

Prometheus rules based on 5m, 1h, or 24h windows may continue firing after service recovery because their evaluation windows still include historical downtime.

## Final Status

The lab is complete and ready for portfolio review.
