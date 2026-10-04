-- BJJ Map canonical schema. Must match `sqlite3 bjj.db .schema`
-- (modulo comments/whitespace). Fresh builds: apply schema.sql, then
-- replay migrations/ in order (documents how the live DB evolved).
-- verify.py --strict enforces this fingerprint.

CREATE TABLE nodes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  side TEXT NOT NULL CHECK (side IN ('top','bottom','neutral','na')),
  kind TEXT NOT NULL CHECK (kind IN ('position','condition','technique','submission','escape','transition')),
  description TEXT NOT NULL DEFAULT '',
  is_terminal INTEGER NOT NULL DEFAULT 0,
  points INTEGER NOT NULL DEFAULT 0,
  scores_as TEXT DEFAULT NULL REFERENCES nodes(id),
  phase TEXT NOT NULL DEFAULT 'guard',
  source TEXT NOT NULL DEFAULT '',
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE videos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  node_id TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  youtube_id TEXT NOT NULL,
  title TEXT NOT NULL,
  why_this_one TEXT NOT NULL DEFAULT '',
  rule_set TEXT NOT NULL DEFAULT 'nogi' CHECK (rule_set IN ('gi','nogi','both')),
  role TEXT NOT NULL DEFAULT 'howto' CHECK (role IN ('concept','howto','roll','troubleshoot')),
  rejected INTEGER NOT NULL DEFAULT 0,
  stale INTEGER NOT NULL DEFAULT 0,
  source TEXT NOT NULL DEFAULT '',
  created_at TEXT DEFAULT (datetime('now')),
  UNIQUE(node_id, youtube_id)
);

CREATE TABLE edges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  from_node TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  to_node TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  label TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  source TEXT NOT NULL DEFAULT '',
  trigger TEXT NOT NULL DEFAULT '',
  trigger_norm TEXT NOT NULL DEFAULT '',
  UNIQUE(from_node, to_node, label, trigger_norm)
);
CREATE INDEX idx_edges_from ON edges(from_node);
CREATE INDEX idx_edges_to ON edges(to_node);

CREATE TABLE node_aliases (
  alias TEXT PRIMARY KEY,
  node_id TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  note TEXT NOT NULL DEFAULT ''
);

CREATE TABLE phases (
  key TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  pos INTEGER NOT NULL
);
