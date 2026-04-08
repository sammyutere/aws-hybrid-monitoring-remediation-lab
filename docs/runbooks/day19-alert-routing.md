# Runbook: Alertmanager Severity Routing with Containerized Test Receiver

## Objective

Route alerts by severity and validate delivery through a local webhook receiver container.

## Severity Model

- critical
- page
- ticket

## Routing Logic

- critical -> /critical
- page -> /page
- ticket -> /ticket
- fallback -> /default

## Receiver Architecture

Alertmanager sends webhooks to:
http://test-receiver:5001/<path>

This keeps all delivery inside the Docker Compose network.

## Grouping

group_by:
- alertname
- job
- severity

## Investigation

1. Confirm alert labels in Prometheus
2. Confirm alerts appear in Alertmanager
3. Confirm the test receiver container is running
4. Confirm receiver logs show the expected path
5. Confirm exporter recovers after the test

## Validation

- expected receiver paths are hit
- Alertmanager loads config successfully
- no webhook delivery failures appear in logs
- alerts are grouped by alertname, job, and severity

## Failure Modes

| Failure | Cause |
|--------|------|
| no receiver logs | test-receiver container not running |
| webhook delivery failure | wrong service name or port |
| wrong receiver hit | route matcher misconfigured |
| no routing by severity | alerts missing severity label |
