-- Open-guard + takedown packet 10 (agent:open-10). 8 triggered edges,
-- 2 new taxonomy slugs. No new nodes. Leaves takedown landings reactive.
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('stands-tall', 'posture-movement', 'stands tall'),
  ('wraps-closed-guard', 'posture-movement', 'wraps closed guard');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('butterfly_top', 'knee_cut', 'pass with',
   'Once they flatten out to kill the hooks, split the middle with the knee cut.',
   'agent:open-10', 'opponent flattens out', 'opponent-flattens-out'),
  ('butterfly_top', 'backstep_pass', 'pass with',
   'When they whizzer to stop the elevation, backstep around the block.',
   'agent:open-10', 'whizzers hard', 'whizzers-hard'),
  ('open_guard_top', 'knee_cut', 'pass with',
   'When they sit up to engage, cut through the middle before they set grips.',
   'agent:open-10', 'sits up', 'sits-up'),
  ('open_guard_top', 'backstep_pass', 'pass with',
   'When they turn away to disengage, backstep into the opening.',
   'agent:open-10', 'turns away', 'turns-away'),
  ('open_guard_bottom', 'tripod_sweep', 'sweep with',
   'When they stand tall to disengage, tripod them over the posted leg.',
   'agent:open-10', 'stands tall', 'stands-tall'),
  ('x_guard', 'straight_ankle', 'attack with',
   'When they posture up to pull the leg free, lock the straight ankle before it escapes.',
   'agent:open-10', 'postures up', 'postures-up'),
  ('takedown_top', 'guard_closed_top', 'lands in',
   'When they wrap closed guard on the way down, land inside and start breaking.',
   'agent:open-10', 'wraps closed guard', 'wraps-closed-guard');
