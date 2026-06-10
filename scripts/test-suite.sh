#!/usr/bin/env bash
set -e

REPORT=./test-report.txt
: > "$REPORT"

echo "[1] CPU stress on host1" | tee -a "$REPORT"
docker exec host1 bash -lc 'timeout 30 stress-ng --cpu 2 --cpu-load 90' || true
echo "status=started" | tee -a "$REPORT"

echo "[2] Log error on host2" | tee -a "$REPORT"
docker exec host2 bash -lc 'logger "CRITICAL test error 500 detected"'
echo "status=sent" | tee -a "$REPORT"

echo "[3] Random network/service fault on host3" | tee -a "$REPORT"
if [ $((RANDOM % 2)) -eq 0 ]; then
  docker exec host3 bash -lc 'pkill apache2 || true'
  echo "status=apache_killed" | tee -a "$REPORT"
else
  docker pause host3 && sleep 10 && docker unpause host3
  echo "status=host_paused" | tee -a "$REPORT"
fi