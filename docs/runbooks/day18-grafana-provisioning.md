# Runbook: Grafana Provisioning for Reliability Dashboard

## Objective

Provision the Prometheus datasource and Day 18 reliability dashboard automatically at Grafana startup.

## Provisioned Files

### Datasource
grafana/provisioning/datasources/prometheus.yml

### Dashboard provider
grafana/provisioning/dashboards/dashboards.yml

### Dashboard JSON
grafana/dashboards/day18-slo-dashboard.json

## Expected Datasource

Name: Prometheus
Type: prometheus
URL: http://prometheus:9090

## Expected Dashboard

Title: AWS Hybrid Reliability Overview

## Validation

1. Restart Grafana
2. Check Grafana logs
3. Confirm datasource exists
4. Confirm dashboard exists
5. Confirm Prometheus source queries return data

## Failure Modes

| Failure | Cause |
|--------|------|
| datasource missing | provisioning file not mounted |
| dashboard missing | dashboard JSON not mounted or provider path mismatch |
| empty panels | Prometheus query returned no data |
| burn-rate panels empty | Day 17 rules not loaded |
| SLO panels empty | Day 16 rules not loaded |
