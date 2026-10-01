# BJJ Map

Live: **https://jonathanfrei.github.io/bjjmap/** (static export via GitHub Pages)

A connection map for Brazilian jiu-jitsu: not instructional content, but the
connective tissue between positions and techniques. Each node links to curated
free YouTube instruction; edges show how you get there and where you can go.

No-gi focus for v1. Scoring anchors follow the IBJJF rulebook (June 2024).
See CONTENT.md for content/licensing notes, CURATION.md for the video rubric.

## Quick start

```bash
./backup.sh          # timestamped .db + .sql dump into backups/ (run before curation)
python3 seed.py path/to/new.db  # empty schema bootstrap (content lives in bjj.db)
python3 verify.py --strict  # integrity gate (CI runs this before export)
python3 app.py    # serve on http://127.0.0.1:8000 (stdlib only, no deps)
python3 check_links.py  # monthly: oEmbed sweep, sets videos.stale=1 on dead embeds
```

On the VPS the app runs in the background and is exposed via
`tailscale serve` at `https://omarchy.tail44804f.ts.net/`.
See AGENTS.md for restart commands.

## Routes

- `/` — node index, grouped by phase; search box on top
- `/search?q=` — full-text-ish search across names, ids, descriptions, aliases
- `/node/:id` — detail: description, aliases ("also called"), videos by role,
  incoming/outgoing edges, "View in graph"
- `/graph` — interactive graph, vis-network vendored in `static/` (works offline)
- `/graph?focus=:id` — graph centered on one node
- `/api/graph` — nodes + edges + aliases + phases JSON
- `/coverage` — map-health report (missing entries/exits, bare conditions,
  stubs, stale videos)

## Code layout

- `app.py` — HTTP routes only (threaded); all HTML comes from `render.py`
- `render.py` — shared rendering used by the server AND `export.py`
  (live and static output are byte-identical; verified by diff)
- `export.py` — static export (`--out site --base /bjjmap`); CI deploys it
- `store.py` — all SQLite queries + `coverage()` health report
- `verify.py` — integrity gate; `verify.py --strict` must pass before export
- `graph.html` / `search.html` — templates with `__BASE__` placeholders
- `schema.sql` + `migrations/` — canonical schema and its history
- `check_links.py` — monthly dead-embed sweep (`stale=1`)
- `backup.sh` — timestamped backups before curation work

## Deploy

Push to `main` → Actions runs `verify.py --strict` → `export.py` →
GitHub Pages. A red X means nothing ships. `check_links.py` stays a local
monthly job (polite to YouTube from one IP), then fix → push → redeploy.

## Data model (SQLite, `bjj.db`)

- `nodes(id, name, side, kind, description, is_terminal, points, scores_as)`
  - `side`: top | bottom | neutral | na (top/bottom are distinct nodes)
  - `kind`: position | condition | technique | submission | escape | transition
  - `condition` = IBJJF scoring anchor with `points` (2/3/4)
  - `technique` = specific how (double leg, toreando…), with `scores_as`
    pointing at its parent condition
  - `is_terminal` = 1 for finished submissions (no outgoing edges)
- `videos(node_id, youtube_id, title, why_this_one, rule_set, rejected)`
  - `youtube_id` is the 11-char ID; embedded via youtube-nocookie
  - `rule_set`: gi | nogi | both (v1 = nogi)
  - `role`: concept | howto | roll | troubleshoot (rendered concept-first)
  - `rejected` = 1 hides without deleting (veto flag)
  - `stale` = 1 set by `check_links.py` on dead embeds (shown as [stale link?])
  - `source` = packet tag, e.g. `agent:halfguard-packet` (authorship trail)
- `edges(from_node, to_node, label, description)` — directed, many-to-many;
  chains (escape → guard → sweep → …) are just consecutive rows.
  `source` column mirrors videos.
- `node_aliases(alias PK, node_id, note)` — same mechanics, different names.
  Shown as pills on node pages; searched by `/search`.
- `phases(key, title, pos)` — homepage grouping is data, not code.
  Unknown phases render under "Other" automatically.

## Current content

75 nodes / 130+ edges across Standup, Guard, Control, Mount, Back, Submissions,
and Leg Entanglements phases. Every node carries curated no-gi video;
`/coverage` tracks map health (missing entries/exits, bare conditions, stubs,
stale embeds).

## Roadmap

- Graph filters when nodes cross ~60 (by phase/subtree, via `/api/graph`)
- Search ranking (currently unordered LIKE matches)
- Phase 3: video research for stub nodes, user suggestions,
  gi expansion (edge-level gi-only flags if needed)
