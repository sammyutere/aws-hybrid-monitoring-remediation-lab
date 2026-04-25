# Day 26 Runbook — Monitoring Stack Backup and Restore

## Objective

Back up and validate recovery of the local monitoring stack configuration.

## Components Backed Up

- monitoring/docker-compose.yml
- monitoring/prometheus
- monitoring/alertmanager
- grafana dashboards and provisioning files

## Backup Location

backups/day26-monitoring-stack.tar.gz

## Validation

1. Create backup directory
2. Copy monitoring stack configuration
3. Create compressed archive
4. Generate SHA-256 checksum
5. Extract archive to temporary restore location
6. Verify required files exist
7. Validate Docker Compose syntax
8. Validate Prometheus config and rules
9. Confirm Grafana dashboards remain visible
10. Confirm monitoring stack health metrics remain healthy

## Recovery Notes

If monitoring stack files are lost, restore from:

backups/day26-monitoring-stack.tar.gz

Then re-run:

docker compose -f monitoring/docker-compose.yml up -d

## Failure Modes

| Issue | Cause |
|------|------|
| archive missing | backup step failed |
| checksum mismatch | archive changed or corrupted |
| restored config invalid | backup captured broken config |
| dashboards missing | Grafana directory not backed up |
| Prometheus rules fail | invalid rule syntax |
