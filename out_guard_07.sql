-- Guard cluster packet 07 (agent:guard-07). 11 triggered edges,
-- 9 new taxonomy slugs. No new nodes (all targets exist).
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('posture-up', 'posture-movement', 'posture up'),
  ('grip-to-open', 'frames-grips', 'grip to open'),
  ('lean-back', 'posture-movement', 'lean back'),
  ('lean-to-one-side', 'posture-movement', 'lean to one side'),
  ('lean-forward', 'posture-movement', 'lean forward'),
  ('stand-to-open', 'posture-movement', 'stand to open'),
  ('push-the-knees-down', 'frames-grips', 'push the knees down'),
  ('whizzer-hard', 'frames-grips', 'whizzer hard'),
  ('dive-for-the-underhook', 'posture-movement', 'dive for the underhook');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- guard_closed_bottom: attacker answers (passer's actions).
  ('guard_closed_bottom', 'triangle', 'submit with',
   'When they posture up to escape the hips, the space opens — shoot the triangle before they settle.',
   'agent:guard-07', 'posture up', 'posture-up'),
  ('guard_closed_bottom', 'kimura', 'submit with',
   'When they grip to pry the guard open, the reaching arm feeds straight into the kimura.',
   'agent:guard-07', 'grip to open', 'grip-to-open'),
  ('guard_closed_bottom', 'omoplata', 'submit with',
   'When they lean to pass to one side, swing the hips through into the omoplata.',
   'agent:guard-07', 'lean to one side', 'lean-to-one-side'),
  ('guard_closed_bottom', 'hip_bump_sweep', 'sweep with',
   'When they lean back to avoid your hips, sit up into the hip bump and topple them.',
   'agent:guard-07', 'lean back', 'lean-back'),
  -- guard_closed_top: passer answers (guard player's actions).
  ('guard_closed_top', 'guard_break', 'break with',
   'When they stand to break open, control a leg and run the standing break before they establish base.',
   'agent:guard-07', 'stand to open', 'stand-to-open'),
  ('guard_closed_top', 'guard_pass', 'pass with',
   'When they push the knees down to stuff your posture, pin the legs and run the pass through the opening.',
   'agent:guard-07', 'push the knees down', 'push-the-knees-down'),
  -- half_guard_bottom: underhook battle answers.
  ('half_guard_bottom', 'old_school', 'sweep with',
   'When they whizzer hard to kill the underhook, change direction and run the old school under their base.',
   'agent:guard-07', 'whizzer hard', 'whizzer-hard'),
  -- half_guard_top: front-headlock answers.
  ('half_guard_top', 'darce', 'submit with',
   'When they dive for the underhook, sprawl your weight down and lock the darce.',
   'agent:guard-07', 'dive for the underhook', 'dive-for-the-underhook'),
  -- butterfly_bottom: smash answers.
  ('butterfly_bottom', 'butterfly_sweep', 'sweep with',
   'When they lean forward to smash the hooks, load them on and sweep with their pressure.',
   'agent:guard-07', 'lean forward', 'lean-forward');
