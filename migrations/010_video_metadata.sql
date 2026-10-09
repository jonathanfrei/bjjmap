-- 010: video metadata for curation display. channel = YouTube channel
-- (attribution), duration_s = runtime in seconds, published_at = YYYY-MM-DD
-- (recency signal). All default empty so existing rows stay valid.
ALTER TABLE videos ADD COLUMN channel TEXT NOT NULL DEFAULT '';
ALTER TABLE videos ADD COLUMN duration_s INTEGER NOT NULL DEFAULT 0;
ALTER TABLE videos ADD COLUMN published_at TEXT NOT NULL DEFAULT '';
