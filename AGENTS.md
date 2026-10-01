# AGENTS.md — working notes for future agents

## Environment

- VPS on tailnet as `omarchy` (100.97.46.91). App served via
  `tailscale serve --bg --set-path / http://127.0.0.1:8000`.
- Private preview (tailnet only): `https://omarchy.tail44804f.ts.net/`
- Public site: `https://jonathanfrei.github.io/bjjmap/` (Pages, auto-deployed)
- Shell quirk: `HOME` is unset in tool shells — `export HOME=/home/jfrei`
  first, or `gh`/git-credential can't find auth. The `gh` binary lives at
  `~/.local/share/mise/installs/gh/2.101.0/gh_2.101.0_linux_amd64/bin/gh`;
  if git push fails on credentials, reset the helper to that path
  (a stale mise `latest` symlink broke it once).
- Python 3.14, **no pip** (`No module named pip`), no venv. Stdlib only:
  `sqlite3`, `http.server`. Do NOT add dependencies without asking.
- PDF tools available: `pdftotext` etc. (poppler). `python3` is NOT on the
  default PATH in some shells — `export PATH=$PATH:/usr/bin:/usr/local/bin` first.
- `curl` to `127.0.0.1:8000` works; the signed-URL rulebook link in chat
  history is expired. Local rulebook copy was at
  `/home/jfrei/.paseo/uploads/upload_6109d7b4-…/2024JUN_IBJJF_Rules_EN.pdf`
  (may be gone); extracted text was dumped to `/tmp/opencode/ibjjf.txt`
  (also ephemeral — re-extract if needed).

## Restarting the server (DANGER: pkill footguns)

- The shell tool matches its own command line with `pgrep/pkill -f` patterns
  containing `app.py` — this has killed the calling shell twice. NEVER use
  `pkill -f "app.py"` or `pgrep -f "python3 app.py"`.
- Safe: `pkill -x python3` (shell is bash, only this app uses python3), or
  `kill <PID>` with the exact PID from `pgrep -x python3`.
- Start: `cd /home/jfrei/VPS-Projects/bjj3 && nohup python3 app.py > /tmp/opencode/bjj.log 2>&1 &`
- Verify: `curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8000/`
- Keep each shell invocation short; background `&` + `sleep` in the same
  command has caused 120s timeouts. Start the server in one call, curl in the next.

## Editing app.py

- Split: `app.py` = routes + HTML, `store.py` = all SQL + `coverage()`.
  Put new queries in `store.py`, new rendering in `app.py`.
- Homepage phases come from the `phases` table (no code edit needed).
- After edits, restart the server (above) — no autoreload.
- Static files live in `static/` and are served allow-listed from that dir
  only (`/static/...`); graph JS is vendored there, no CDN.

## Conventions / decisions (don't regress)

- Top/bottom are separate nodes (different goals/options). Terminal nodes =
  finished submissions (`is_terminal=1`).
- `kind`: position | condition | technique | submission | escape | transition.
  Conditions are the 6 IBJJF scoring anchors (points 2/3/4); techniques hang
  off them via `scores_as`. Rulebook defines conditions, NOT techniques —
  don't go looking for toreando in the PDF.
- Videos: agent inserts directly, no approval gate; owner vetoes via
  `rejected=1`. `rule_set` defaults to `nogi`. `youtube_id` = 11-char ID only.
- Keep styling minimal — design system comes later.
- `seed.py` is the POC seed; later seeds used inline `sqlite3` heredocs.
  Prefer idempotent SQL (`INSERT OR IGNORE`) so re-runs are safe.
- Run `./backup.sh` before any curation batch. `backups/` holds .db + .sql.
- New content rows should carry `source='agent:<packet>'`.
- Check `/coverage` after curation to catch missing entries/exits.
- Run `verify.py --strict` before committing; CI enforces it anyway.
- To preview the static build: `python3 export.py --out /tmp/site --base ''`
  then diff a page against the live server — they must be identical.
- Run `python3 check_links.py` monthly; it sets `videos.stale=1`.
- Graph page (`graph.html`) uses vis-network 9.1.9 vendored in `static/`.
  Deep-link format: `/graph/?focus=<node_id>`.
  Canonical routes use trailing slashes (`/node/<id>/`, `/health/`);
  `/coverage` and `/node/<id>` redirect for compat.
