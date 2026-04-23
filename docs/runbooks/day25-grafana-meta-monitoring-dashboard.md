# Runbook: Grafana Dashboard for Monitoring Stack Health

## Objective

Visualize the health of the monitoring stack itself.

## Dashboard Title

Monitoring Stack Health Overview

## Metrics Used

- meta_prometheus_up
- meta_alertmanager_up
- meta_grafana_up
- meta_test_receiver_up

## Panels

1. Prometheus health
2. Alertmanager health
3. Grafana health
4. Test receiver health
5. Meta-monitoring alerts
6. Receiver health over time
7. Stack health note

## Validation Workflow

1. Confirm dashboard JSON is mounted inside Grafana
2. Restart Grafana if needed
3. Confirm source metrics return 1 when healthy
4. Stop a monitored component
5. Confirm metric drops and alert fires
6. Restore the component
7. Confirm metric returns to 1 and alert resolves

## Failure Modes

| Failure | Cause |
|--------|------|
| dashboard missing | provisioning path or mount issue |
| empty panels | source metric missing |
| alert panel empty | no active alerts or query mismatch |
| metric stays 0 after recovery | monitored component still unhealthy |
