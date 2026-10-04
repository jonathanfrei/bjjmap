-- 007: opponent-reaction (if/then) support on edges.
-- trigger = author-facing text ("turns away"); the convention is that the
-- trigger is always the OTHER player's observable action.
-- trigger_norm = slug used for grouping, anchors, and dedup.
-- The UNIQUE swap (from,to,label) -> (from,to,label,trigger_norm) lets the
-- same technique sit under two reactions (e.g. mount_top -> ezekiel both
-- unconditional and "bridges hard").
CREATE TABLE edges_new (
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
INSERT INTO edges_new (id, from_node, to_node, label, description, source,
                       trigger, trigger_norm)
  SELECT id, from_node, to_node, label,
         COALESCE(description, ''), COALESCE(source, ''), '', ''
    FROM edges;
DROP TABLE edges;
ALTER TABLE edges_new RENAME TO edges;
CREATE INDEX idx_edges_from ON edges(from_node);
CREATE INDEX idx_edges_to ON edges(to_node);
