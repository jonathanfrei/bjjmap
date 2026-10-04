-- Guard cluster packet 07 (agent:guard-07). 11 triggered edges,
-- 9 new taxonomy slugs. No new nodes (all targets exist).
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('postures-up', 'posture-movement', 'postures up'),
  ('grips-to-open', 'frames-grips', 'grips to open'),
  ('leans-back', 'posture-movement', 'leans back'),
  ('leans-to-one-side', 'posture-movement', 'leans to one side'),
  ('leans-forward', 'posture-movement', 'leans forward'),
  ('stands-to-open', 'posture-movement', 'stands to open'),
  ('pushes-the-knees-down', 'frames-grips', 'pushes the knees down'),
  ('whizzers-hard', 'frames-grips', 'whizzers hard'),
  ('dives-for-the-underhook', 'posture-movement', 'dives for the underhook');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- guard_closed_bottom: attacker answers (passer's actions).
  ('guard_closed_bottom', 'triangle', 'submit with',
   'When they posture up to escape the hips, the space opens — shoot the triangle before they settle.',
   'agent:guard-07', 'postures up', 'postures-up'),
  ('guard_closed_bottom', 'kimura', 'submit with',
   'When they grip to pry the guard open, the reaching arm feeds straight into the kimura.',
   'agent:guard-07', 'grips to open', 'grips-to-open'),
  ('guard_closed_bottom', 'omoplata', 'submit with',
   'When they lean to pass to one side, swing the hips through into the omoplata.',
   'agent:guard-07', 'leans to one side', 'leans-to-one-side'),
  ('guard_closed_bottom', 'hip_bump_sweep', 'sweep with',
   'When they lean back to avoid your hips, sit up into the hip bump and topple them.',
   'agent:guard-07', 'leans back', 'leans-back'),
  -- guard_closed_top: passer answers (guard player's actions).
  ('guard_closed_top', 'guard_break', 'break with',
   'When they stand to break open, control a leg and run the standing break before they establish base.',
   'agent:guard-07', 'stands to open', 'stands-to-open'),
  ('guard_closed_top', 'guard_pass', 'pass with',
   'When they push the knees down to stuff your posture, pin the legs and run the pass through the opening.',
   'agent:guard-07', 'pushes the knees down', 'pushes-the-knees-down'),
  -- half_guard_bottom: underhook battle answers.
  ('half_guard_bottom', 'old_school', 'sweep with',
   'When they whizzer hard to kill the underhook, change direction and run the old school under their base.',
   'agent:guard-07', 'whizzers hard', 'whizzers-hard'),
  -- half_guard_top: front-headlock answers.
  ('half_guard_top', 'darce', 'submit with',
   'When they dive for the underhook, sprawl your weight down and lock the darce.',
   'agent:guard-07', 'dives for the underhook', 'dives-for-the-underhook'),
  -- butterfly_bottom: smash answers.
  ('butterfly_bottom', 'butterfly_sweep', 'sweep with',
   'When they lean forward to smash the hooks, load them on and sweep with their pressure.',
   'agent:guard-07', 'leans forward', 'leans-forward');
