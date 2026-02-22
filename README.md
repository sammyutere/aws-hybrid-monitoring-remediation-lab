# AWS Hybrid Monitoring & Remediation Lab

## Overview

This project extends a local Linux reliability lab into AWS.

Architecture:

- EC2 node running node_exporter
- Prometheus (local Mac) scraping AWS
- Alertmanager (local Mac)
- SNS + Lambda remediation (later phase)
- SSM for secure remote command execution

## Goals

- Infrastructure as Code with Terraform
- Cost-aware cloud operations
- Hybrid monitoring (local + AWS)
- Automated remediation pipeline
- SLO-driven reliability governance

## Architecture (Phase 1)

Mac:
- Prometheus (localhost:9090)
- Alertmanager (localhost:9093)

AWS:
- EC2 instance (node_exporter)
- Security Group (9100 restricted)
- IAM roles

## Repo Layout

Infrastructure (Terraform):
- infra/terraform

Monitoring configs:
- monitoring/prometheus
- monitoring/alertmanager

Automation:
- automation/lambda

## Cost Guardrails

See: admin/COST-GUARDRAILS.md
