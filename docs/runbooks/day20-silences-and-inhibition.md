# Runbook: Alertmanager Silences and Inhibition

## Objective

Reduce alert noise by using maintenance silences and severity-based inhibition.

## Silence Use Case

Planned maintenance on the aws-node target.

Silence matcher:
job="aws-node"

## Inhibition Rules

- critical suppresses page for the same alertname, job, and instance
- page suppresses ticket for the same job and instance

## Validation

1. Create a silence for aws-node
2. Trigger an alert condition
3. Confirm the alert exists but receiver delivery is suppressed
4. Remove the silence
5. Trigger the same condition again
6. Confirm receiver delivery resumes

## Investigation

1. Check Alertmanager silences
2. Check Alertmanager alerts
3. Check test-receiver logs
4. Check severity labels
5. Confirm exporter recovery on EC2

## Failure Modes

| Failure | Cause |
|--------|------|
| silence not applied | matcher does not match alert labels |
| delivery not suppressed | silence not active or wrong matcher |
| inhibition not observed | higher and lower severity alerts not active at same time |
| no receiver logs | delivery path issue or no alert sent |
