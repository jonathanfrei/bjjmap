-- Tier 4C: the two missing position nodes.
-- slx closes the X-guard != single-leg X gap (aliases move to their
-- rightful node); north_south_bottom closes the missing bottom side of
-- the north-south pin. source='agent:positions-14'.

INSERT OR IGNORE INTO trigger_taxonomy VALUES
  ('circles-to-the-head', 'posture-movement', 'circles to the head');

------------------------------------------------------------------------
-- Nodes
------------------------------------------------------------------------
INSERT OR IGNORE INTO nodes
  (id, name, side, kind, description, is_terminal, points, scores_as,
   phase, source)
VALUES
  ('slx', 'Single-Leg X', 'bottom', 'position',
   'The outside ashi on the standing opponent''s thigh: sweeps, straight ankles, and the step-through to the saddle. Distinct from X-guard, which rides underneath.',
   0, 0, NULL, 'legs', 'agent:positions-14'),
  ('north_south_bottom', 'North-South (Bottom)', 'bottom', 'position',
   'Pinned chest-to-chest inverted: frame the hips, swing the legs to re-square, and get the hips back underneath before the choke closes.',
   0, 0, NULL, 'side', 'agent:positions-14');

-- X-guard is not ashi garami; the aliases belong on the real ashi.
UPDATE node_aliases SET node_id = 'slx', note = 'Family name for the entanglement; standard ashi = single-leg X'
 WHERE alias = 'ashi garami';
UPDATE node_aliases SET node_id = 'slx', note = 'Common name'
 WHERE alias = 'single leg X';
INSERT OR IGNORE INTO node_aliases (alias, node_id, note) VALUES
  ('outside ashi', 'slx', 'Opposite of the inside sankaku (saddle)');

------------------------------------------------------------------------
-- Edges: entries and exits
------------------------------------------------------------------------
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('open_guard_bottom', 'slx', 'enter',
   'Off the feet-on-hips, pummel under the thigh and lock the outside ashi — the single-leg X is the standard no-gi entanglement from open guard.',
   'agent:positions-14', '', ''),
  ('x_guard', 'slx', 'enter',
   'When the standing opponent strips the bottom hook, slide down to the outside ashi instead of losing the leg entirely.',
   'agent:positions-14', '', ''),
  ('slx', 'sweep_condition', 'sweep with',
   'Elevate the trapped leg and come up on top — the classic single-leg X sweep scores 2.',
   'agent:positions-14', '', ''),
  ('slx', 'straight_ankle', 'attack with',
   'The foot is right there: lock the ashi, hide the heel, and extend the ankle.',
   'agent:positions-14', '', ''),
  ('slx', 'saddle', 'advance to',
   'Reap across to the inside sankaku when the heel is the goal — the step-through from outside ashi to the saddle.',
   'agent:positions-14', '', ''),
  ('slx', 'fifty_fifty', 'transition to',
   'Sit through to the mirrored entanglement when they clear the hip line and the outside ashi is failing.',
   'agent:positions-14', '', ''),
  ('open_guard_bottom', 'saddle', 'enter',
   'From shin-to-shin or the ashi, reap across the thigh line and lock the inside sankaku.',
   'agent:positions-14', '', ''),
  ('half_guard_bottom', 'saddle', 'enter',
   'Deep half or the waiter: invert under the hips and come up on the legs in the saddle.',
   'agent:positions-14', '', ''),
  ('side_control_bottom', 'north_south_bottom', 'transition to',
   'When they circle toward the head to hunt the north-south choke, the pin changes but the framing problem stays the same.',
   'agent:positions-14', 'circles to the head', 'circles-to-the-head'),
  ('north_south_bottom', 'guard_closed_bottom', 'recover to',
   'Frame the hips, swing the legs, and spin underneath — pull the guard back before the choke closes.',
   'agent:positions-14', '', ''),
  ('north_south_bottom', 'side_control_bottom', 'escape to',
   'Square back up to the side pin when the north-south angle is too deep to spin out of.',
   'agent:positions-14', '', ''),
  ('north_south_bottom', 'turtle_bottom', 'escape to',
   'Turn to the knees and take the turtle rather than carrying the cross-face pressure.',
   'agent:positions-14', '', '');

------------------------------------------------------------------------
-- Videos (rule of three, all IDs oEmbed-verified)
------------------------------------------------------------------------
INSERT OR IGNORE INTO videos
  (node_id, youtube_id, title, why_this_one, rule_set, role, source)
VALUES
  -- slx
  ('slx', 's56p7sV6qE4', 'This is how to play Single Leg X',
   'Giles'' gym class footage covers the whole single-leg X picture — building the position, the rear sweep, the hand fight, and recovery when the foot is stripped.',
   'both', 'concept', 'agent:positions-14'),
  ('slx', 'LQul2ZvHyms', 'Single leg X:  Forcing their hands to the mat (Lachlan Giles)',
   'The off-balancing detail that makes the position offensive rather than decorative: forcing the posts to the mat to open the sweep and the foot attack. Gi grips appear, but the control transfers completely to no-gi.',
   'both', 'howto', 'agent:positions-14'),
  ('slx', 'Dgqb5f6VhKg', 'Powerful Single Leg X-Guard Sweep (The Assis Sweep) Ashi Garami Fundamentals Online Course',
   'The assis sweep is the highest-percentage finish from here — elevate the far leg and come up on top for the 2.',
   'both', 'howto', 'agent:positions-14'),
  -- north_south_bottom
  ('north_south_bottom', 'fY2GTuMOsnI', 'How to Escape the North-South Position in BJJ and No Gi Grappling',
   'Kesting works all three hand-position variants of the pin, so the escape framework matches whichever north-south you are stuck in.',
   'both', 'concept', 'agent:positions-14'),
  ('north_south_bottom', 'RDUvVeVtMxM', 'Escaping North South Pin in Jiu Jitsu',
   'The pendulum-and-spin escape is exactly the recover-to-guard path this node maps.',
   'both', 'howto', 'agent:positions-14'),
  ('north_south_bottom', 'A9PAlXwclPI', 'How to Escape a Tight North South in BJJ (2 BJJ Effective Options)',
   'Two answers for the tight version where the standard frame is already beaten — the failure mode that keeps people stuck.',
   'both', 'troubleshoot', 'agent:positions-14');
