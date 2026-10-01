#!/bin/bash
# Timestamped SQLite backup (file copy + SQL dump). Run before curation work.
cd "$(dirname "$0")" || exit 1
STAMP=$(date +%F_%H%M)
mkdir -p backups
sqlite3 bjj.db ".backup 'backups/bjj_${STAMP}.db'"
sqlite3 bjj.db ".dump" > "backups/bjj_${STAMP}.sql"
ls -la "backups/bjj_${STAMP}.db" "backups/bjj_${STAMP}.sql"
