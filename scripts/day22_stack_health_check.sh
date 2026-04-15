#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root and monitoring directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MONITORING_DIR="$REPO_ROOT/monitoring"

echo "=== Day 22 Meta-Monitoring Health Check ==="

echo
echo "[1] Docker Compose services"
docker compose -f "$MONITORING_DIR/docker-compose.yml" ps

echo
echo "[2] Prometheus health"
curl -s http://localhost:9090/-/healthy || true

echo
echo "[3] Alertmanager health"
curl -s http://localhost:9093/-/healthy || true

echo
echo "[4] Grafana status code"
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000 || true

echo
echo "[5] Test receiver status code"
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:5001 || true

echo
echo "[6] Prometheus target query for aws-node"
curl -sG http://localhost:9090/api/v1/query \
  --data-urlencode 'query=up{job="aws-node"}' || true

echo
echo "=== End of health check ==="
