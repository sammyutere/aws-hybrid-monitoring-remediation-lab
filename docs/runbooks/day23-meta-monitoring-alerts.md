# Runbook: Meta-Monitoring Alerts for the Observability Stack

## Objective

Alert when core monitoring-stack components fail.

## Components Covered

- Prometheus
- Alertmanager
- Grafana
- test-receiver

## Metrics

- meta_prometheus_up
- meta_alertmanager_up
- meta_grafana_up
- meta_test_receiver_up

## Alerts

- MetaPrometheusDown
- MetaAlertmanagerDown
- MetaGrafanaDown
- MetaTestReceiverDown

## Validation Workflow

1. Confirm meta-health exporter is running
2. Confirm Prometheus scrapes the meta-monitoring job
3. Confirm new metrics return 1 in the healthy state
4. Stop a monitoring-stack component
5. Confirm the matching alert fires
6. Restore the component
7. Confirm the alert resolves

## Failure Modes

| Failure | Cause |
|--------|------|
| no meta metrics | exporter not running or not scraped |
| no meta alerts | rules not loaded |
| alert does not fire | scrape or query mismatch |
| alert does not resolve | service not fully recovered or stale state |

## Recovery

- restart the affected stack component
- verify Docker Compose state
- verify metric returns to 1
- verify alert clears
