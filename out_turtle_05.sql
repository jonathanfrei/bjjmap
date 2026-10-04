-- Turtle + front-headlock packet 05 (agent:turtle-05). 7 triggered
-- edges, 5 new taxonomy slugs. No new nodes (all targets exist).
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('sits-up', 'posture-movement', 'sits up'),
  ('reaches-for-a-leg', 'frames-grips', 'reaches for a leg'),
  ('opponent-chases-the-far-arm', 'posture-movement', 'opponent chases the far arm'),
  ('opponent-drives-forward', 'weight-pressure', 'opponent drives forward'),
  ('rolls-away', 'posture-movement', 'rolls away');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- turtle_top: attacker answers (defender's actions).
  ('turtle_top', 'back_control_top', 'take back',
   'When they sit up to face you, slide the seatbelt in around the exposed back.',
   'agent:turtle-05', 'sits up', 'sits-up'),
  ('turtle_top', 'anaconda', 'submit with',
   'When they reach back for your leg to start the sit-out, feed the trapped arm in and gator roll.',
   'agent:turtle-05', 'reaches for a leg', 'reaches-for-a-leg'),
  -- turtle_bottom: defender answers (attacker's actions).
  ('turtle_bottom', 'guard_closed_bottom', 'recover to',
   'When they abandon chest contact to chase the far arm, granby roll back into closed guard.',
   'agent:turtle-05', 'opponent chases the far arm',
   'opponent-chases-the-far-arm'),
  ('turtle_bottom', 'half_guard_bottom', 'recover to',
   'When they drive in hard for the seatbelt, shoot a leg through and recover half guard underneath.',
   'agent:turtle-05', 'opponent drives forward', 'opponent-drives-forward'),
  -- front_headlock: choke chains.
  ('front_headlock', 'darce', 'submit with',
   'When they tuck the chin to kill the guillotine, drop off to the darce side and lock the triangle.',
   'agent:turtle-05', 'tucks chin to defend', 'tucks-chin-to-defend'),
  ('front_headlock', 'anaconda', 'submit with',
   'When they roll away from the choke pressure, follow the roll and lock the anaconda.',
   'agent:turtle-05', 'rolls away', 'rolls-away');
