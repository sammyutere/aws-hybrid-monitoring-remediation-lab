# Runbook: Containerized Meta-Health Exporter

## Objective

Make meta-monitoring persistent by running the meta-health exporter inside Docker Compose.

## Service

meta-health-exporter

## Metrics Exposed

- meta_prometheus_up
- meta_alertmanager_up
- meta_grafana_up
- meta_test_receiver_up

## Validation Workflow

1. Build and start meta-health-exporter in Compose
2. Confirm Prometheus scrapes the meta-monitoring job
3. Confirm metrics return 1 when healthy
4. Stop a monitored Compose service
5. Confirm metric returns 0 and alert fires
6. Restart the service
7. Confirm metric returns to 1 and alert resolves

## Failure Modes

| Failure | Cause |
|--------|------|
| exporter not starting | bad Dockerfile or app error |
| no meta metrics | scrape target not configured correctly |
| metric never changes | exporter checking wrong service URL |
| alert never fires | Day 23 rules not loaded |

## Recovery

- rebuild and restart the exporter container
- check Prometheus targets
- check exporter logs
- verify Compose service status

