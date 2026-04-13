# Runbook: Alertmanager Templates and Notification Standardization

## Objective

Standardize alert notification content so operators see consistent, human-readable fields.

## Template File

alertmanager/templates/day21-notification.tmpl

## Standard Fields

- alertname
- severity
- job
- instance
- summary
- description
- status
- startsAt

## Validation

1. Confirm the template file is mounted in Alertmanager
2. Trigger a known alert
3. Confirm Alertmanager receives the alert
4. Confirm the receiver path is hit
5. Confirm structured alert fields are present in evidence

## Investigation

1. Check Alertmanager logs for template load errors
2. Check test-receiver logs
3. Check structured alert summary evidence
4. Confirm exporter recovery on EC2

## Failure Modes

| Failure | Cause |
|--------|------|
| template not loaded | templates directory not mounted |
| alert routed but unreadable | receiver logging format insufficient |
| no path hit | routing/delivery issue |
| no structured summary | alert payload missing annotations or labels |
