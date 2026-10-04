-- Side-control cluster packet 04 (agent:side-04). 11 triggered edges,
-- 4 new taxonomy slugs. No new nodes (all targets exist).
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('reaches-across', 'frames-grips', 'reaches across'),
  ('pushes-on-the-shoulder', 'frames-grips', 'pushes on the shoulder'),
  ('opponent-flattens-out', 'weight-pressure', 'opponent flattens out'),
  ('opponent-sits-back', 'posture-movement', 'opponent sits back');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- side_control_top: attacker answers (defender's actions).
  ('side_control_top', 'back_control_top', 'take back',
   'When they turn away to escape the crossface, the far side opens — take the back instead of resetting the pin.',
   'agent:side-04', 'turns away', 'turns-away'),
  ('side_control_top', 'kimura', 'submit with',
   'When they reach across your body to post or push, the extended arm feeds straight into the kimura grip.',
   'agent:side-04', 'reaches across', 'reaches-across'),
  ('side_control_top', 'arm_triangle', 'submit with',
   'When they bench-press your shoulder to make space, sprawl the pushing arm in and lock the arm triangle.',
   'agent:side-04', 'pushes on the shoulder', 'pushes-on-the-shoulder'),
  ('side_control_top', 'darce', 'submit with',
   'When they turn into you to relieve the crossface, the near arm slides into the darce entry.',
   'agent:side-04', 'turns in', 'turns-in'),
  -- side_control_bottom: defender answers (attacker's actions).
  ('side_control_bottom', 'escape_bridge', 'escape via',
   'Once they settle their weight to flatten you, bridge explosively into them — the committed weight topples.',
   'agent:side-04', 'opponent flattens out', 'opponent-flattens-out'),
  ('side_control_bottom', 'half_guard_bottom', 'recover to',
   'When they sit back to free their hips, shrimp a leg back in and downgrade the pin to half guard.',
   'agent:side-04', 'opponent sits back', 'opponent-sits-back'),
  ('side_control_bottom', 'turtle_bottom', 'escape to',
   'When they commit both hands to isolating an arm for the armlock, turn to turtle before the shoulder locks.',
   'agent:side-04', 'opponent isolates an arm', 'opponent-isolates-an-arm'),
  -- knee_on_belly: ride answers.
  ('knee_on_belly', 'back_control_top', 'take back',
   'When they spin away from the knee ride, ride the rotation and lock the seatbelt.',
   'agent:side-04', 'turns away', 'turns-away'),
  ('knee_on_belly', 'mount_top', 'advance to',
   'When they bridge into the knee, slide off into mount and settle before they recover.',
   'agent:side-04', 'bridges hard', 'bridges-hard'),
  -- north_south_top: pin answers.
  ('north_south_top', 'back_control_top', 'transition to',
   'When they turn into you to escape the armpit pressure, keep the kimura grip and spin to the back.',
   'agent:side-04', 'turns in', 'turns-in'),
  ('north_south_top', 'mount_top', 'transition to',
   'When they bridge to dislodge the pin, walk the hips around into full mount.',
   'agent:side-04', 'bridges hard', 'bridges-hard');
