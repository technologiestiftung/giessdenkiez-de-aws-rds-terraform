#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

pg_restore --no-owner --clean --if-exists --verbose --host="$TARGET_HOST" --username="$TARGET_USER" --dbname="$TARGET_DBNAME" ../backup/out.dump
