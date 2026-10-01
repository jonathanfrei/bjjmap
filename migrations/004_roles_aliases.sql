-- 004: video roles (concept-first rendering) + alias table for
-- same-mechanics-different-name (keylock=americana, not kimura).
ALTER TABLE videos ADD COLUMN role TEXT DEFAULT 'howto'
  CHECK (role IN ('concept','howto','roll','troubleshoot'));
CREATE TABLE node_aliases (
  alias TEXT PRIMARY KEY,
  node_id TEXT NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
  note TEXT DEFAULT ''
);
