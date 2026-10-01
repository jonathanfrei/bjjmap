-- 003: two-layer model. Scoring conditions vs specific techniques.
-- SQLite cannot widen a CHECK in place, so the table is rebuilt and
-- scores_as records which condition each technique fulfills.
CREATE TABLE nodes_new (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  side TEXT NOT NULL CHECK (side IN ('top','bottom','neutral','na')),
  kind TEXT NOT NULL CHECK (kind IN ('position','condition','technique','submission','escape','transition')),
  description TEXT DEFAULT '',
  is_terminal INTEGER DEFAULT 0,
  points INTEGER DEFAULT 0,
  scores_as TEXT DEFAULT NULL REFERENCES nodes_new(id),
  created_at TEXT DEFAULT (datetime('now'))
);
INSERT INTO nodes_new (id,name,side,kind,description,is_terminal,points,scores_as,created_at)
  SELECT id,name,side,kind,description,is_terminal,points,NULL,created_at FROM nodes;
DROP TABLE nodes;
ALTER TABLE nodes_new RENAME TO nodes;
