# Day 25 Dashboard Plan

## Dashboard Title
Monitoring Stack Health Overview

## Panels

1. Prometheus health
   Query: meta_prometheus_up

2. Alertmanager health
   Query: meta_alertmanager_up

3. Grafana health
   Query: meta_grafana_up

4. Test receiver health
   Query: meta_test_receiver_up

5. Meta-health alert states
   Query: ALERTS{alertname=~"MetaPrometheusDown|MetaAlertmanagerDown|MetaGrafanaDown|MetaTestReceiverDown"}

6. Monitoring stack targets
   Query source: Prometheus targets API (documented as external evidence, not a panel query)

7. Receiver alert timeline
   Query: ALERTS{job="meta-monitoring"}

8. Overall stack health note
   Documentation panel / text panel
