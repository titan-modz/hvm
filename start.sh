#!/usr/bin/env bash
set -e

: "${PORT:=3000}"

echo "Starting HVM app on 0.0.0.0:${PORT}"

if command -v gunicorn >/dev/null 2>&1; then
  exec gunicorn --bind "0.0.0.0:${PORT}" --workers 2 --threads 2 "hvm:app"
else
  exec python3 hvm/hvm.py
fi
