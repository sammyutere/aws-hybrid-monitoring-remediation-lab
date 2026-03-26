## Prometheus Target DOWN Troubleshooting

### Overview

This guide provides troubleshooting steps when a Prometheus scrape target shows as DOWN.

Prometheus targets represent endpoints being scraped for metrics. A DOWN target indicates Prometheus cannot successfully collect metrics.

---

## Symptoms

Prometheus UI:

```bash
http://localhost:9090/targets
```
Status:

```bash
DOWN
```
Error examples:

```bash
connection refused
context deadline exceeded
no route to host
```

---

## Troubleshooting Procedure

Follow steps in order.

---

## Step 1-Identify the failing target

Open:

```bash
http://localhost:9090/targets
```
Locate:

- job name (e.g. node)
- instance (e.g. <ELASTIC_IP>:9100)
- error message

This defines the failure type.

---

## Step 2-Test target manually

From local machine:

```bash
curl http://<ELASTIC_IP>:9100/metrics | head
```
---

### Interpretation

### Case A — Success
Metrics returned → Prometheus configuration issue

### Case B — Connection refused
Target reachable, service not running

### Case C — Timeout
Network issue (Security Group, routing, firewall)

---

## Step 3-Verify node_exporter service

```bash
INSTANCE_ID=$(cat lab/evidence/day08_instance_id.txt)

aws ssm send-command \
 --instance-ids "$INSTANCE_ID" \
 --document-name AWS-RunShellScript \
 --parameters commands="sudo systemctl status node_exporter" \
 --region us-east-1
```
Expected:

```bash
Active: active (running)
```
---

## Step 4-Restart exporter if needed

```bash
aws ssm send-command \
 --instance-ids "$INSTANCE_ID" \
 --document-name AWS-RunShellScript \
 --parameters commands="sudo systemctl restart node_exporter" \
 --region us-east-1
```
---

## Step 5-Validate Security Group ingress

Check current public ip:

```bash
curl -4 https://api.ipify.org
```
Ensure Terraform variable matches:

```bash
my_ip = "<your-ip>/32"
```
Apply changes:

```bash
cd infra/terraform
./tf.sh apply -var-file=terraform.tfvars
```
---

## Step 6-Verify Prometheus configuration

Open:

```bash
monitoring/prometheus/prometheus.yml
```
Ensure target is correct:

```bash
<ELASTIC_IP>:9100
```
Restart prometheus:

```bash
cd monitoring
docker compose restart prometheus
```
---

## Step 7-Verify recovery

Open:

```bash
http://localhost:9090/targets
```
Expected:

```bash
UP
```
---

## Root Causes

Common causes include:
- node_exporter service stopped
- incorrect Elastic IP
- Security Group ingress mismatch
- Prometheus configuration error
- network connectivity issues

---

## Preventive Measures
- use Elastic IP for stable endpoints
- automate exporter restart (Alertmanager webhook)
- validate infrastructure changes after Terraform apply
- maintain runbooks for common failures

---

## Related Documentation

```bash
docs/troubleshooting/exporter-connectivity.md
docs/runbooks/node-exporter-down.md
```
 





















































