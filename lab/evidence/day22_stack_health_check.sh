#!/usr/bin/env bash
set -euo pipefail

echo "=== Day 22 Meta-Monitoring Health Check ==="

echo
echo "[1] Docker Compose services"
docker compose ps

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
