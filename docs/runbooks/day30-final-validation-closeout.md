# Day 30 Runbook — Final Validation and Closeout

## Objective

Perform final validation of the monitoring stack and close out the 30-day lab.

## Validation Areas

- Docker Compose service state
- Prometheus targets
- meta-monitoring metrics
- alert state
- Prometheus config and rules
- Grafana dashboard provisioning
- backup archive
- audit bundle
- EC2 node_exporter

## Recovery Interpretation

Operational recovery and statistical recovery are not the same.

Operational recovery means the system is healthy now.

Statistical recovery means alert windows have decayed and long-window alerts have cleared.

If long-window alerts remain visible, compare them against current health metrics before treating them as active failures.

## Final Validation Commands

- docker compose ps
- Prometheus query API
- Prometheus targets API
- Prometheus alerts API
- Alertmanager alerts API
- promtool config check
- promtool rules check
- Grafana dashboard directory listing
- backup and audit bundle checksum verification
- EC2 node_exporter status check

## Success Criteria

- monitoring stack services are running
- meta-monitoring metrics return healthy values
- Prometheus config validates
- Prometheus rules validate
- Grafana dashboards are mounted
- backup archive exists
- latest audit bundle verifies
- EC2 exporter is reachable or its state is clearly documented
