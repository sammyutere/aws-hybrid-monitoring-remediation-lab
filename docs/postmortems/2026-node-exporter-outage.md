# Incident Postmortem: Node Exporter Monitoring Outage

## Incident Summary

Node exporter stopped responding on the EC2 monitoring node.

Prometheus detected the failure and fired the NodeExporterDown alert.

Automated remediation triggered via Alertmanager webhook and AWS SSM.

Exporter service was restarted automatically.

---

## Timeline

| Time | Event |
|-----|------|
| T0 | node_exporter service stopped |
| T+15s | Prometheus scrape failure detected |
| T+2m | NodeExporterDown alert fired |
| T+2m | Alertmanager triggered webhook |
| T+2m | Automation script executed |
| T+3m | node_exporter restarted via SSM |

---

## Detection

Prometheus alert rule:
up{job="aws-node"} == 0

Alert severity:
page


---

## Impact

Monitoring visibility temporarily lost.

No service impact.

---

## Root Cause

Exporter service failure.

Possible causes:

- process crash
- configuration change
- host reboot

---

## Resolution

Automated remediation triggered restart:
sudo systemctl restart node_exporter

Exporter service recovered.

---

## Lessons Learned

Monitoring automation significantly reduced recovery time.

Automation prevented manual intervention.

---

## Preventive Improvements

Potential improvements:

- health checks for exporter process
- exporter restart policy
- infrastructure drift detection

---

## Evidence

Evidence artifacts stored in:

lab/evidence/

Files:

- day12_prometheus_alerts.json
- day12_alertmanager_alerts.json
- day12_automation_log.txt 


