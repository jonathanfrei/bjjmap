-- 001: POC bootstrap. Original three tables; kind had no
-- condition/technique yet; no provenance columns.
CREATE TABLE nodes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  side TEXT NOT NULL CHECK (side IN ('top','bottom','neutral','na')),
  kind TEXT NOT NULL CHECK (kind IN ('position','submission','escape','transition')),
  description TEXT DEFAULT '',
  is_terminal INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now'))
);
CREATE TABLE videos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  node_id TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  youtube_id TEXT NOT NULL,
  title TEXT NOT NULL,
  why_this_one TEXT DEFAULT '',
  rule_set TEXT DEFAULT 'nogi' CHECK (rule_set IN ('gi','nogi','both')),
  rejected INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  UNIQUE(node_id, youtube_id)
);
CREATE TABLE edges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  from_node TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  to_node TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  label TEXT NOT NULL,
  description TEXT DEFAULT '',
  UNIQUE(from_node, to_node, label)
);
CREATE INDEX idx_edges_from ON edges(from_node);
CREATE INDEX idx_edges_to ON edges(to_node);
