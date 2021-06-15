#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

pg_dump --host="$SOURCE_HOST" --format=custom --no-owner --username="$SOURCE_USER" --dbname="$SOURCE_DBNAME" >../backup/out.dump
