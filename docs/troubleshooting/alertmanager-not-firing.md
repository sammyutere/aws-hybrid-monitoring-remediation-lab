## Alertmanager Not Firing Alerts Troubleshooting
### Overview

This guide addresses situations where:
- Prometheus alerts exist
- but Alertmanager does not send or display alerts

---

## Symptoms

Prometheus shows alerts:

```bash
http://localhost:9090/alerts
```
But alertmanager shows:

```bash
http://localhost:9093
```
No alerts or empty results.

---

## Troubleshooting Procedure

---

## Step 1-Confirm Prometheus has active alerts

```bash
curl http://localhost:9090/api/v1/alerts
```
Expected:

```bash
"state": "firing"
```
If no alerts exist, issue is not Alertmanager.

---

## Step 2-Verify Prometheus->Alertmanager configuration

Open:

```bash
monitoring/prometheus/prometheus.yml
```
Ensure section exists:

```bash
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093
```
---

## Step 3-Verify Alertmanager is reachable

From host:

```bash
curl http://localhost:9093/-/ready
```
Expected:

```bash
OK
```
If not, restart:

```bash
cd monitoring
docker compose restart alertmanager
```
---

## Step 4-Verify alert rules are loaded

```bash
curl http://localhost:9090/api/v1/rules
```
Ensure rule groups exist:

- node-basic
- node-warning
- slo-burnrate

---

## Step 5-Validate alert labels

Alertmanager routing depends on labels.

Example:

```bash
severity="page"
```
Check alert labels:

```bash
curl http://localhost:9090/api/v1/alerts
```
Ensure labels match routing config.

---

## Step 6-Verify Alertmanager routing configuration

Open:

```bash
monitoring/alertmanager/alertmanager.yml
```
Check routes:

```bash
routes:
  - matchers:
      - severity="page"
    receiver: page-receiver
```
If labels do not match, alerts will not route.

---

## Step 7-Check webhook configuration

If using automation:

```bash
webhook_configs:
  - url: http://host.docker.internal:5001
```
Ensure:

- webhook listener is running
- port 5001 is accessible
- script path is correct

---

## Step 8-Inspect Alertmanager API

```bash
curl http://localhost:9093/api/v2/alerts
```
Expected:

- active alerts present
- correct receiver assigned

---

## Step 9-Restart entire monitoring stack

```bash
cd monitoring
docker compose down
docker compose up -d
```
---

## Root Causes

Common issues:

- Prometheus not configured to use Alertmanager
- Alert rules not loaded
- label mismatch with routing rules
- Alertmanager container not running
- webhook misconfiguration

---

## Preventive Measures

- standardize alert labels (severity, instance, job)
- validate configuration after changes
- maintain consistent routing rules
- test alerts after deployment

---

## Related Documentation

```bash
docs/runbooks/node-exporter-down.md
docs/troubleshooting/prometheus-target-down.md
```















































