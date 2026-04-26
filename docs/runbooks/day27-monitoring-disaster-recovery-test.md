# Day 27 Runbook — Monitoring Stack Disaster Recovery Test

## Objective

Validate that the monitoring stack backup can be restored and verified without damaging the live stack.

## Backup Source

backups/day26-monitoring-stack.tar.gz

## Restore Test Location

/tmp/day27-monitoring-restore-test

## Components Validated

- Docker Compose file
- Prometheus configuration
- Prometheus rules
- Alertmanager configuration
- Grafana dashboards
- Grafana provisioning files

## Validation Workflow

1. Verify the backup archive exists
2. Verify the checksum
3. Extract the archive to a temporary restore directory
4. Validate restored file structure
5. Validate restored Docker Compose syntax
6. Compare restored config with live config
7. Validate current Prometheus config and rules
8. Confirm monitoring stack health
9. Capture current alert state
10. Document operational versus statistical recovery

## Recovery Interpretation

Operational recovery and statistical recovery are not the same.

Operational recovery means the restored configuration exists, validates, and the monitoring stack is healthy now.

Statistical recovery means time-window alerts have decayed and long-window alerts have cleared.

Long-window alerts may remain after recovery validation if their evaluation windows still include historical downtime.

## Failure Modes

| Issue | Cause |
|------|------|
| Backup archive missing | Day 26 backup was not created |
| Checksum mismatch | Backup archive changed or is corrupted |
| Compose validation fails | Restored Compose file is invalid |
| Config diff unexpected | Live config changed after backup |
| Prometheus rules fail | Invalid rule syntax |
| Dashboards missing | Grafana directory was not included in backup |

## Recovery Procedure

If live monitoring files are lost:

1. Extract the backup archive
2. Copy restored files back into the repo
3. Validate Docker Compose config
4. Start the monitoring stack
5. Validate Prometheus, Alertmanager, Grafana, and meta-health metrics
