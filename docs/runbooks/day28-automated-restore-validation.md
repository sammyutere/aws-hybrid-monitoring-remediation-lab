# Day 28 Runbook — Automated Monitoring Stack Restore Validation

## Objective

Automate validation of the monitoring stack backup and restore workflow.

## Script

scripts/day28_restore_validation.sh

## Backup Source

backups/day26-monitoring-stack.tar.gz

## Validation Performed

- backup archive exists
- checksum file exists
- checksum verifies
- restore directory is recreated cleanly
- archive extracts successfully
- required files exist
- restored Docker Compose config validates
- restored configs are compared with live configs
- Prometheus config validates
- Prometheus rules validate
- monitoring stack services are checked
- meta-health metrics are queried

## Recovery Interpretation

Operational recovery and statistical recovery are not the same.

Operational recovery means the stack is healthy now and restore artifacts are valid.

Statistical recovery means alert windows have decayed and long-window alerts have cleared.

Long-window alerts may remain visible after validation if they reflect historical downtime.

## Failure Modes

| Issue | Cause |
|------|------|
| archive missing | Day 26 backup was not created |
| checksum fails | backup changed or corrupted |
| restored files missing | archive incomplete |
| Compose config fails | invalid restored Compose file |
| Prometheus rules fail | invalid rule syntax |
| meta-health metrics fail | monitoring stack component unhealthy |
