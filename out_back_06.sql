-- Back-control packet 06 (agent:back-06). 3 triggered edges,
-- 2 new taxonomy slugs. No new nodes (all targets exist).
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('strips-the-hands', 'frames-grips', 'strips the hands'),
  ('defends-the-hooks', 'posture-movement', 'defends the hooks');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- back_control_top: attacker answers (defender's actions).
  ('back_control_top', 'mount_top', 'transition to',
   'When they strip both hands to stall the choke, abandon the finish and take mount before the escape develops.',
   'agent:back-06', 'strips the hands', 'strips-the-hands'),
  ('back_control_top', 'crucifix_top', 'transition to',
   'When hook defense shuts down the seatbelt, trap one arm between the legs and keep the other — the crucifix holds the back without hooks.',
   'agent:back-06', 'defends the hooks', 'defends-the-hooks'),
  -- back_control_bottom: defender answer (attacker's action).
  ('back_control_bottom', 'turtle_bottom', 'escape to',
   'When they release a hook to chase the finish, peel the remaining hook and turn into turtle.',
   'agent:back-06', 'opponent releases a hook',
   'opponent-releases-a-hook');
