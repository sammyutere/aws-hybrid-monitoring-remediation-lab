# Day 29 Runbook — Evidence Packaging and Audit Bundle

## Objective

Create a repeatable audit bundle containing lab evidence, documentation, monitoring configuration, Grafana assets, and operational scripts.

## Script

scripts/day29_create_audit_bundle.sh

## Output Directory

audit-bundles/

## Bundle Contents

- lab/evidence
- docs/runbooks
- docs/operations
- monitoring/prometheus
- monitoring/alertmanager
- monitoring/docker-compose.yml
- grafana assets
- scripts
- manifest
- Git metadata

## Validation Workflow

1. Create audit bundle
2. Generate checksum
3. Verify checksum
4. List archive contents
5. Extract archive to temporary directory
6. Validate manifest exists
7. Validate included Compose config
8. Confirm monitoring stack health
9. Capture current alert state

## Recovery Interpretation

Operational success means the bundle was created, verified, extracted, and validated.

Statistical recovery means long-window alerts have decayed and cleared.

Long-window SLO or burn-rate alerts may remain visible if they reflect historical downtime.

## Failure Modes

| Issue | Cause |
|------|------|
| bundle missing | packaging script failed |
| checksum mismatch | bundle changed after creation |
| manifest missing | script did not generate manifest |
| evidence missing | evidence directory not copied |
| Compose validation fails | invalid config included in bundle |
| extraction fails | archive is corrupt |
