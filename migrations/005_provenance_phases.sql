-- 005: provenance + homepage phases as data.
ALTER TABLE videos ADD COLUMN stale INTEGER DEFAULT 0;
ALTER TABLE videos ADD COLUMN source TEXT DEFAULT '';
ALTER TABLE edges ADD COLUMN source TEXT DEFAULT '';
ALTER TABLE nodes ADD COLUMN phase TEXT DEFAULT 'guard';
ALTER TABLE nodes ADD COLUMN source TEXT DEFAULT '';
CREATE TABLE phases (key TEXT PRIMARY KEY, title TEXT NOT NULL, pos INTEGER NOT NULL);
INSERT INTO phases VALUES
  ('standup','Standup & Takedowns',10),
  ('guard','Guard & Passing',20),
  ('side','Control',30),
  ('mount','Mount',40),
  ('back','Back & Turtle',50);
