#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP="$(date -u +"%Y%m%dT%H%M%SZ")"
BUNDLE_NAME="day29-audit-bundle-${TIMESTAMP}"
BUNDLE_DIR="/tmp/${BUNDLE_NAME}"
OUTPUT_DIR="audit-bundles"
EVIDENCE_DIR="lab/evidence"

echo "=== Day 29 Evidence Packaging ==="

echo "[1] Creating temporary bundle directory"
rm -rf "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR"

echo "[2] Copying evidence"
mkdir -p "$BUNDLE_DIR/lab"
cp -R "$EVIDENCE_DIR" "$BUNDLE_DIR/lab/evidence"

echo "[3] Copying documentation"
mkdir -p "$BUNDLE_DIR/docs"
cp -R docs/runbooks "$BUNDLE_DIR/docs/runbooks"
cp -R docs/operations "$BUNDLE_DIR/docs/operations"

echo "[4] Copying monitoring configs"
mkdir -p "$BUNDLE_DIR/monitoring"
cp -R monitoring/prometheus "$BUNDLE_DIR/monitoring/prometheus"
cp -R monitoring/alertmanager "$BUNDLE_DIR/monitoring/alertmanager"
cp monitoring/docker-compose.yml "$BUNDLE_DIR/monitoring/docker-compose.yml"

echo "[5] Copying Grafana assets if present"
if [ -d "grafana" ]; then
  cp -R grafana "$BUNDLE_DIR/grafana"
fi

echo "[6] Copying scripts"
cp -R scripts "$BUNDLE_DIR/scripts"

echo "[7] Creating manifest"
find "$BUNDLE_DIR" -type f | sort > "$BUNDLE_DIR/MANIFEST.txt"

echo "[8] Capturing Git metadata"
{
  echo "Generated UTC: $TIMESTAMP"
  echo "Git commit: $(git rev-parse HEAD)"
  echo "Git branch: $(git branch --show-current)"
  echo
  echo "Tags:"
  git tag --list | sort
} > "$BUNDLE_DIR/GIT_METADATA.txt"

echo "[9] Creating archive"
mkdir -p "$OUTPUT_DIR"
tar -czf "$OUTPUT_DIR/${BUNDLE_NAME}.tar.gz" -C /tmp "$BUNDLE_NAME"

echo "[10] Creating checksum"
shasum -a 256 "$OUTPUT_DIR/${BUNDLE_NAME}.tar.gz" > "$OUTPUT_DIR/${BUNDLE_NAME}.sha256"

echo "[11] Writing latest pointer"
{
  echo "Bundle: $OUTPUT_DIR/${BUNDLE_NAME}.tar.gz"
  echo "Checksum: $OUTPUT_DIR/${BUNDLE_NAME}.sha256"
} > "$OUTPUT_DIR/latest-day29-bundle.txt"

echo "=== Bundle created ==="
cat "$OUTPUT_DIR/latest-day29-bundle.txt"
