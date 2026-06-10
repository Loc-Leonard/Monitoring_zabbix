#!/usr/bin/env bash
set -e

TARGET=${1:-host1}

docker exec "$TARGET" bash -lc 'systemctl restart apache2 || apachectl restart || true; find /tmp -type f -delete || true'

echo "auto-reaction executed for $TARGET"