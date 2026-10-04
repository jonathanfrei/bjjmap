-- Open-guard + takedown packet 10 (agent:open-10). 8 triggered edges,
-- 2 new taxonomy slugs. No new nodes. Leaves takedown landings reactive.
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('stand-tall', 'posture-movement', 'stand tall'),
  ('wrap-closed-guard', 'posture-movement', 'wrap closed guard');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('butterfly_top', 'knee_cut', 'pass with',
   'Once they flatten out to kill the hooks, split the middle with the knee cut.',
   'agent:open-10', 'flatten out', 'flatten-out'),
  ('butterfly_top', 'backstep_pass', 'pass with',
   'When they whizzer to stop the elevation, backstep around the block.',
   'agent:open-10', 'whizzer hard', 'whizzer-hard'),
  ('open_guard_top', 'knee_cut', 'pass with',
   'When they sit up to engage, cut through the middle before they set grips.',
   'agent:open-10', 'sit up', 'sit-up'),
  ('open_guard_top', 'backstep_pass', 'pass with',
   'When they turn away to disengage, backstep into the opening.',
   'agent:open-10', 'turn away', 'turn-away'),
  ('open_guard_bottom', 'tripod_sweep', 'sweep with',
   'When they stand tall to disengage, tripod them over the posted leg.',
   'agent:open-10', 'stand tall', 'stand-tall'),
  ('x_guard', 'straight_ankle', 'attack with',
   'When they posture up to pull the leg free, lock the straight ankle before it escapes.',
   'agent:open-10', 'posture up', 'posture-up'),
  ('takedown_top', 'guard_closed_top', 'lands in',
   'When they wrap closed guard on the way down, land inside and start breaking.',
   'agent:open-10', 'wrap closed guard', 'wrap-closed-guard');
