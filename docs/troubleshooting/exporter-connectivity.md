## Node Exporter Connectivity Troubleshooting

### Overview
This guide provides troubleshooting procedures when Prometheus or external tools cannot reach the node_exporter metrics endpoint.

The node exporter runs on the EC2 monitoring node and exposes system metrics on:

```bash
http://<ELASTIC_IP>:9100/metrics
```
This endpoint must be reachable for Prometheus scraping and Grafana visualization.

---

## Common Symptoms

### Exporter endpoint unreachable

Example command:

```bash
curl http://<ELASTIC_IP>:9100/metrics
```
Possible errors:

```bash
curl: (7) Failed to connect to <IP> port 9100: Connection refused
```
or 

```bash
curl: (7) Failed to connect to <IP> port 9100: Operation timed out
```

### Prometheus target DOWN

Prometheus UI:

```bash
http://localhost:9090/targets
```

Status:

```bash
DOWN
```

### Grafana dashboards show no data

Grafana panels display empty charts.

---

## Troubleshooting Procedure

Follow the steps in order.

---

## Step 1-Verify exporter endpoint from local machine

```bash
EIP=$(cat lab/evidence/day06_elastic_ip.txt)

curl http://$EIP:9100/metrics | head
```
Expected output:

```bash
# HELP go_goroutines
# TYPE go_goroutines gauge
```
If this works, exporter is running and reachable.

---

## Step 2-Check Prometheus target health

Open:

```bash
http://localhost:9090/targets
```
Verify:

```bash
UP
```
If the target is DOWN, continue troubleshooting.

---

## Step 3-Verify Security Group ingress rule

The EC2 security group must allow access from your public IPv4 address

Retrieve your current IP: 

```bash
curl -4 https://api.ipify.org
```

Update Terraform variable if needed:

```bash
my_ip = "<your-ip>/32"
```

Apply Terraform:

```bash
cd infra/terraform
./tf.sh apply -var-file=terraform.tfvars
```
This updates the security group ingress rule.

---

## Step 4-Verify node_exporter service status

Use AWS Systems Manager to check the exporter service

```bash
INSTANCE_ID=$(cat lab/evidence/day08_instance_id.txt)

aws ssm send-command \
 --instance-ids "$INSTANCE_ID" \
 --document-name AWS-RunShellScript \
 --parameters commands="sudo systemctl status node_exporter" \
 --region us-east-1 
```
Expected status:

```bash
Active: active (running)
```
If the service is inactive, restart it.

---

## Step 5-Restart node exporter

Restart using AWS SSM.

```bash
aws ssm send-command \
 --instance-ids "$INSTANCE_ID" \
 --document-name AWS-RunShellScript \
 --parameters commands="sudo systemctl restart node_exporter" \
 --region us-east-1 
```
Wait approximately 10 seconds, then test connectivity again.

```bash
curl http://$EIP:9100/metrics | head
```
---

## Step 6-Check exporter logs

If exporter fails to start, inspect logs

```bash
aws ssm send-command \
 --instance-ids "$INSTANCE_ID" \
 --document-name AWS-RunShellScript \
 --parameters commands="sudo journalctl -u node_exporter -n 50 --no-pager" \
 --region us-east-1
```
Review logs for startup errors.

---

Step 7-Confirm Prometheus Scrape Recovery

After exporter restart, verify Prometheus target health.

```bash
http://localhost:9090/targets
```
Expected:

```bash
UP
```
Prometheus should begin scrapting metrics again.

---

Step 8-Validate Grafana dashboards 

Open Grafana:

```bash
http://localhost:3000
```
Ensure:

- Prometheus data source is connected
- Dashboard instance variable is set to:

```bash
<ELASTIC_IP>:9100
```
Metrics should populate within a few seconds.

---

## Root Causes

Common causes of exporter connectivity issues include:

- Security Group ingress rule mismatch
- exporter service stopped or crashed
- incorrect Elastic IP reference
- Prometheus target misconfiguration
- local IP address changed (common on residential networks)

---

## Preventive Recommendations

To reduce recurrence:

- periodically verify Security Group ingress rule
- monitor exporter process health
- use automated remediation via Alertmanager webhook
- maintain runbooks for monitoring incidents

---

## Related Documentation

Operational runbook:

```bash
docs/runbooks/node-exporter-down.md
```
Monitoring architecture:

```bash
README.md
```
Incident postmortem example:

```bash
docs/postmortem/
```






































