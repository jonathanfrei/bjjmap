-- Tier 4D: the four missing technique nodes (distinct mechanics per the
-- CURATION.md rubric). Each anchors to its scoring condition via
-- scores_as and carries the standard "Scores as ..." description line.
-- source='agent:techniques-15'.

------------------------------------------------------------------------
-- Nodes
------------------------------------------------------------------------
INSERT OR IGNORE INTO nodes
  (id, name, side, kind, description, is_terminal, points, scores_as,
   phase, source)
VALUES
  ('stack_pass', 'Stack Pass', 'na', 'technique',
   'Fold their knees toward their nose, drive the hips over, and pass around the stacked legs. Scores as guard pass (3).',
   0, 0, 'guard_pass', 'guard', 'agent:techniques-15'),
  ('double_under_pass', 'Double-Under Pass', 'na', 'technique',
   'Both arms under the legs, hands locked: pop the hips to stack, then shuck past. Scores as guard pass (3).',
   0, 0, 'guard_pass', 'guard', 'agent:techniques-15'),
  ('dogfight_dump', 'Dogfight Dump', 'na', 'technique',
   'From the dogfight: win the underhook, sit out, and dump the head and arm to the far side. Scores as sweep (2).',
   0, 0, 'sweep_condition', 'guard', 'agent:techniques-15'),
  ('sumi_gaeshi', 'Sumi Gaeshi', 'na', 'technique',
   'Sacrifice sweep from the butterfly: overhook or shoulder-crunch the arm, load them on the hips, and flip over the shoulder. Scores as sweep (2).',
   0, 0, 'sweep_condition', 'guard', 'agent:techniques-15');

INSERT OR IGNORE INTO node_aliases (alias, node_id, note) VALUES
  ('stacking pass', 'stack_pass', ''),
  ('double unders', 'double_under_pass', 'Common name'),
  ('dogfight sweep', 'dogfight_dump', ''),
  ('underhook dump', 'dogfight_dump', ''),
  ('sacrifice sweep', 'sumi_gaeshi', '');

------------------------------------------------------------------------
-- Edges: entries from the usual hubs
------------------------------------------------------------------------
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('stack_pass', 'guard_pass', 'scores as',
   'Stabilize 3s for 3 pts.',
   'agent:techniques-15', '', ''),
  ('double_under_pass', 'guard_pass', 'scores as',
   'Stabilize 3s for 3 pts.',
   'agent:techniques-15', '', ''),
  ('dogfight_dump', 'sweep_condition', 'scores as',
   'Stabilize top 3s for 2 pts.',
   'agent:techniques-15', '', ''),
  ('sumi_gaeshi', 'sweep_condition', 'scores as',
   'Stabilize top 3s for 2 pts.',
   'agent:techniques-15', '', ''),
  ('guard_closed_top', 'stack_pass', 'pass with',
   'Break the guard, stack the legs to the nose, and walk around the pressure — the classic heavy pass once the ankles open.',
   'agent:techniques-15', '', ''),
  ('open_guard_top', 'stack_pass', 'pass with',
   'Close the distance, pin the shins together, and stack straight through the frames.',
   'agent:techniques-15', '', ''),
  ('guard_closed_top', 'double_under_pass', 'pass with',
   'Open the guard, swim both arms under the legs, lock the hands, and pop the hips over the line.',
   'agent:techniques-15', '', ''),
  ('open_guard_top', 'double_under_pass', 'pass with',
   'Deny the feet-on-hips with the double unders and run the same pop-and-shuck past the legs.',
   'agent:techniques-15', '', ''),
  ('half_guard_bottom', 'dogfight_dump', 'sweep with',
   'Win the underhook, come up to the dogfight, sit out and dump the head and arm to the far side.',
   'agent:techniques-15', '', ''),
  ('butterfly_bottom', 'sumi_gaeshi', 'sweep with',
   'Overhook or shoulder-crunch the arm, load the hips under them, and flip them over the shoulder.',
   'agent:techniques-15', '', '');

------------------------------------------------------------------------
-- Videos (rule of three, all IDs oEmbed-verified)
------------------------------------------------------------------------
INSERT OR IGNORE INTO videos
  (node_id, youtube_id, title, why_this_one, rule_set, role, source)
VALUES
  -- stack_pass
  ('stack_pass', 'i29jJKrK29M', 'How to Do the Stack Pass, by 4x  World Champion Fabio Gurgel',
   'Gurgel is the reference for this pass — the pressure model (knees to nose, walk around the hip line) is the mechanic this node maps.',
   'both', 'howto', 'agent:techniques-15'),
  ('stack_pass', 'wB2RA1TEaT4', 'Take Your BJJ Stack Pass to the Next Level with These Details (Gi & No Gi)',
   'The finishing details that separate a stalled stack from a completed pass; grip use is minimal so the whole sequence transfers to no-gi.',
   'both', 'howto', 'agent:techniques-15'),
  ('stack_pass', 'bSfdlYpIs7g', 'Stack pass and dealing with frames (Lachlan Giles)',
   'Frames are exactly what kills the stack pass — Giles works the failure mode this node hits against a good guard.',
   'both', 'troubleshoot', 'agent:techniques-15'),
  -- double_under_pass
  ('double_under_pass', 'PizdshB63kw', 'Passing With Double Unders by Jeff Glover',
   'Glover''s double-unders system covers the pop, the angle change, and the follow-ups when they frame.',
   'both', 'howto', 'agent:techniques-15'),
  ('double_under_pass', 'wBZrTpuXV50', 'No-Gi Double Under Guard Pass',
   'The pass taught explicitly for no-gi, where the hand lock has to replace sleeve grips.',
   'nogi', 'howto', 'agent:techniques-15'),
  ('double_under_pass', 'BuDGLXL8sGs', 'BJJ Training - Double Under Pass to Crucifix by Marcelo Garcia',
   'Marcelo''s double-unders finish in the crucifix — the same side-control-to-crucifix chain this map links from the pin.',
   'both', 'howto', 'agent:techniques-15'),
  -- dogfight_dump
  ('dogfight_dump', 'qwUXweab9BI', 'Underhook Half Guard to Dogfight Sweep - Ross Nicholls',
   'The full path from underhook to the dogfight to the dump, start to finish — the exact chain this node maps.',
   'both', 'howto', 'agent:techniques-15'),
  ('dogfight_dump', '-vOMyuUki8o', 'Coyote Guard Sweep by Rodnei Barbosa',
   'The coyote-guard dump with the sit-out detail that makes the head-and-arm lever work.',
   'both', 'howto', 'agent:techniques-15'),
  ('dogfight_dump', 'bhB7YonwROE', 'Secret to Coyote Half Guard from Half Guard Using Your Shoulder, NOT Elbow - Mica Galvao',
   'The shoulder-based coyote control is what holds the dogfight long enough to dump — without it the sweep gets whizzered.',
   'both', 'concept', 'agent:techniques-15'),
  -- sumi_gaeshi
  ('sumi_gaeshi', 'VFbUih8C-Lk', 'The Shoulder Crunch Sumi Gaeshi Sweep From Butterfly Guard by Gordon Ryan (ADCC 2019 Breakdown)',
   'The ADCC-level version: shoulder crunch instead of a plain overhook, which is why the sweep works on people who know the basic one.',
   'nogi', 'concept', 'agent:techniques-15'),
  ('sumi_gaeshi', 'su5aJYVr3hc', 'The Secret That Makes Sumi Gaeshi Unstoppable',
   'The loading detail that decides whether the flip lands — the most common reason the basic attempt fails.',
   'both', 'howto', 'agent:techniques-15'),
  ('sumi_gaeshi', 'Y_EMnjn9CYI', 'Sumi Gaeshi - Butterfly Guard Sweep',
   'A clean fundamentals-format run-through of the butterfly sumi gaeshi mechanics.',
   'both', 'howto', 'agent:techniques-15');
