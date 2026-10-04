#!/bin/bash
# Stage a content packet against a DB copy, verify it, and show exactly
# which pages would change — without touching the live bjj.db.
# Usage: ./stage_packet.sh out_NN.sql
# Exit 0 = packet is safe to apply (then: sqlite3 bjj.db < out_NN.sql).
set -e
test -n "$1" || { echo "usage: $0 out_NN.sql"; exit 2; }
test -f "$1" || { echo "no such file: $1"; exit 2; }
export PATH="$PATH:/usr/bin:/usr/local/bin"
STAGE=/tmp/opencode/stage_bjj.db
rm -f "$STAGE" "$STAGE-journal"
cp bjj.db "$STAGE"
sqlite3 "$STAGE" < "$1"
export BJJ_DB="$STAGE"
python3 verify.py --strict
python3 normalize_triggers.py "$STAGE"
python3 export.py --out /tmp/opencode/stage_new --base '' >/dev/null
unset BJJ_DB
python3 export.py --out /tmp/opencode/stage_live --base '' >/dev/null
echo "--- pages that would change ---"
diff -rq /tmp/opencode/stage_live/node /tmp/opencode/stage_new/node \
  | grep -v "^Only in /tmp/opencode/stage_live" || true
diff -rq /tmp/opencode/stage_live/node /tmp/opencode/stage_new/node \
  | grep "^Only in /tmp/opencode/stage_new" || true
echo "--- done: apply with: sqlite3 bjj.db < $1 ---"
