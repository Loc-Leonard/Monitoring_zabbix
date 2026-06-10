#!/usr/bin/env python3
import sys
import requests

url = sys.argv[1] if len(sys.argv) > 1 else 'http://apache-app/'

try:
    r = requests.get(url, timeout=5)
    print(1 if r.status_code == 200 else 0)
except Exception:
    print(0)