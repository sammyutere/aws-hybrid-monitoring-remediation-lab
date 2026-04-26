#!/usr/bin/env bash
set -euo pipefail

BACKUP_ARCHIVE="backups/day26-monitoring-stack.tar.gz"
CHECKSUM_FILE="lab/evidence/day26_backup_checksum.txt"
RESTORE_DIR="/tmp/day28-monitoring-restore-test"
EVIDENCE_DIR="lab/evidence"

echo "=== Day 28 Automated Restore Validation ==="

echo "[1] Checking backup archive exists"
test -f "$BACKUP_ARCHIVE"

echo "[2] Checking checksum file exists"
test -f "$CHECKSUM_FILE"

echo "[3] Verifying backup checksum"
shasum -a 256 -c "$CHECKSUM_FILE"

echo "[4] Preparing clean restore directory"
rm -rf "$RESTORE_DIR"
mkdir -p "$RESTORE_DIR"

echo "[5] Extracting backup archive"
tar -xzf "$BACKUP_ARCHIVE" -C "$RESTORE_DIR"

echo "[6] Listing restored files"
find "$RESTORE_DIR" -type f | sort

RESTORED_BASE="$RESTORE_DIR/backups/day26-monitoring-stack"

echo "[7] Validating restored required files"
test -f "$RESTORED_BASE/docker-compose.yml"
test -f "$RESTORED_BASE/prometheus/prometheus.yml"
test -f "$RESTORED_BASE/alertmanager/alertmanager.yml"
test -d "$RESTORED_BASE/grafana/dashboards"
test -d "$RESTORED_BASE/grafana/provisioning"

echo "[8] Validating restored Docker Compose config"
docker compose -f "$RESTORED_BASE/docker-compose.yml" config >/tmp/day28_restored_compose_config.txt

echo "[9] Comparing restored config with live config"
diff -u monitoring/docker-compose.yml "$RESTORED_BASE/docker-compose.yml" >/tmp/day28_compose_diff.txt || true
diff -u monitoring/prometheus/prometheus.yml "$RESTORED_BASE/prometheus/prometheus.yml" >/tmp/day28_prometheus_diff.txt || true
diff -u monitoring/alertmanager/alertmanager.yml "$RESTORED_BASE/alertmanager/alertmanager.yml" >/tmp/day28_alertmanager_diff.txt || true

echo "[10] Validating running Prometheus config"
docker compose -f monitoring/docker-compose.yml exec prometheus \
  promtool check config /etc/prometheus/prometheus.yml

echo "[11] Validating running Prometheus rules"
docker compose -f monitoring/docker-compose.yml exec prometheus \
  sh -c 'promtool check rules /etc/prometheus/rules/*.yml'

echo "[12] Checking monitoring stack services"
docker compose -f monitoring/docker-compose.yml ps

echo "[13] Checking meta-health metrics"
curl -sG http://localhost:9090/api/v1/query --data-urlencode 'query=meta_prometheus_up'
echo
curl -sG http://localhost:9090/api/v1/query --data-urlencode 'query=meta_alertmanager_up'
echo
curl -sG http://localhost:9090/api/v1/query --data-urlencode 'query=meta_grafana_up'
echo
curl -sG http://localhost:9090/api/v1/query --data-urlencode 'query=meta_test_receiver_up'
echo

echo "=== Day 28 restore validation complete ==="
