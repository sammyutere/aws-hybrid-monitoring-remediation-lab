# Runbook: Meta-Monitoring for the Observability Stack

## Objective

Validate that the monitoring stack itself is healthy.

## Components Checked

- Prometheus
- Alertmanager
- Grafana
- test-receiver
- Prometheus aws-node target

## Health Signals

- Docker Compose service state
- Prometheus /-/healthy
- Alertmanager /-/healthy
- Grafana HTTP reachability
- test-receiver HTTP reachability
- up{job="aws-node"}

## Validation Workflow

1. Run the Day 22 health-check script
2. Confirm all services are healthy
3. Simulate a local component failure
4. Re-run the script
5. Restore the failed component
6. Re-run the script after recovery

## Failure Modes

| Failure | Cause |
|--------|------|
| Prometheus unhealthy | container down or config issue |
| Alertmanager unhealthy | container down or config issue |
| Grafana unreachable | container down or port issue |
| test-receiver unreachable | receiver container stopped |
| aws-node target down | exporter down or network issue |

## Recovery

- restart stopped Compose service
- review container logs
- confirm service returns in `docker compose ps`
- confirm Day 22 health-check script returns to healthy output
