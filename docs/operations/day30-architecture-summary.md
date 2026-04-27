# Day 30 Architecture Summary

## Project

AWS Hybrid Monitoring and Remediation Lab

## Final Architecture

The lab implements a hybrid monitoring stack using:

- EC2 node_exporter
- Prometheus
- Alertmanager
- Grafana
- containerized test receiver
- containerized meta-health exporter
- Git-based evidence and documentation workflow

## Core Capabilities

- EC2 host monitoring
- Prometheus scrape validation
- SLO and burn-rate rules
- Alertmanager routing by severity
- alert silences and inhibition
- webhook receiver testing
- Grafana dashboard provisioning
- meta-monitoring of the monitoring stack
- backup and restore validation
- automated restore validation
- audit bundle packaging

## Operational Recovery Model

The lab distinguishes between:

- operational recovery: system is healthy now
- statistical recovery: time-window alert history has decayed

Long-window alerts may remain active after service recovery if their evaluation window still includes earlier downtime.

## Final State

The monitoring system can:

- detect EC2 exporter failure
- route alerts by severity
- visualize health in Grafana
- monitor its own components
- validate backup restore readiness
- package evidence for audit review
