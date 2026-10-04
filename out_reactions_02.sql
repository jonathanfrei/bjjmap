-- Expansion packet 02: gift_wrap + hitchhiker_escape nodes, 16 edges.
-- Convention: trigger = the OTHER player's observable action.
-- source='agent:reactions-02'. All statements idempotent (INSERT OR IGNORE).

-- 2a. New nodes (edges only would leave real gaps: the gift-wrap hub and
-- the late armbar answer have no page to hang instruction on).
INSERT OR IGNORE INTO nodes
  (id, name, side, kind, description, is_terminal, points, scores_as,
   phase, source)
VALUES
  ('gift_wrap', 'Gift Wrap', 'na', 'technique',
   'Trapping control that pins the opponent''s near arm across their own neck and shoulder. From mount or side control it forces a dilemma: turn away and give the back, or stay flat and face the choke.',
   0, 0, NULL, 'mount', 'agent:reactions-02'),
  ('hitchhiker_escape', 'Hitchhiker Escape', 'na', 'escape',
   'Last-line armbar escape: the thumb rotates down, you bridge and roll over the attacker''s leg before the arm straightens. Only works early — once the elbow locks out, the hitchhike is gone.',
   0, 0, NULL, 'mount', 'agent:reactions-02');

-- 2b. Rule-of-three videos (all IDs oEmbed-verified 2026-10-04; mechanics
-- use no gi grips, so rule_set='both' with rationale).
INSERT OR IGNORE INTO videos
  (node_id, youtube_id, title, why_this_one, rule_set, role, source)
VALUES
  ('gift_wrap', 'ZDuC4sQrxfc', 'Gift Wrap Position Details - Jiu-Jitsu Technique',
   'Eli Knight details the position itself: why the wrap controls and where it leads next.',
   'both', 'concept', 'agent:reactions-02'),
  ('gift_wrap', '5bw7poxVJ1E', 'The Gift Wrap in 2 Minutes - No GI BJJ',
   'Brian Glick''s tight no-gi overview: entries, control points, and the main attacks.',
   'both', 'howto', 'agent:reactions-02'),
  ('gift_wrap', 'UIWX13Sx-zw', '3 Back Takes From Mount Using The Gift Wrap Control',
   'MMA Leech shows three back takes off the wrap — the exact turns-away chain this page teaches.',
   'both', 'howto', 'agent:reactions-02'),
  ('hitchhiker_escape', 'ShV9jUhbyLA', 'BJJ Basics: How To Do the Hitch Hiker Arm Bar Escape',
   'Ritchie Yip teaches the core idea plainly: thumb down, bridge, roll over the leg.',
   'both', 'concept', 'agent:reactions-02'),
  ('hitchhiker_escape', 'gWfgCEvGZTo', 'BJJ | How To Hitchhiker Armbar Escape',
   'Evolve champions Fabio Da Mata and Valdir Rodrigues demo the competition-speed version.',
   'both', 'howto', 'agent:reactions-02'),
  ('hitchhiker_escape', '6dJGTnY8YWU', 'How To Do The Hitchhiker Armbar Escape #bjj',
   'Michael Foley''s short rep-reference for the thumb-down roll timing — the detail that makes or breaks it.',
   'both', 'howto', 'agent:reactions-02');

-- 2c. Attacker answers from mount_top.
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('mount_top', 'back_control_top', 'take back',
   'When they panic and spin away to escape the mount itself, ride the rotation and take the back instead of resetting.',
   'agent:reactions-02', 'give the back', 'give-the-back'),
  ('mount_top', 'armbar_mount', 'submit with',
   'When they bench-press your chest to make space, ride the extending arm straight into the armbar.',
   'agent:reactions-02', 'push on the chest', 'push-on-the-chest'),
  ('mount_top', 'gift_wrap', 'attack with',
   'When they turn away under you, feed the near arm across their body and lock the gift wrap rather than chasing mount.',
   'agent:reactions-02', 'turn belly-down', 'turn-belly-down'),
  ('mount_top', 'side_control_top', 'transition to',
   'When the elbow escape starts, ride off to side control and keep the crossface instead of fighting to hold mount.',
   'agent:reactions-02', 'shrimp toward an elbow escape',
   'shrimp-toward-an-elbow-escape');

-- 2d. Defender answers from mount_bottom (triggers = attacker's actions).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('mount_bottom', 'escape_bridge', 'escape via',
   'When they sit tall to isolate an arm, their base narrows — bridge into them and topple.',
   'agent:reactions-02', 'sit high to attack',
   'sit-high-to-attack'),
  ('mount_bottom', 'elbow_escape', 'escape via',
   'When they grapevine and flatten you out, the bridge is dead — shrimp and win a knee back inside.',
   'agent:reactions-02', 'grapevine', 'grapevine'),
  ('mount_bottom', 'hitchhiker_escape', 'escape via',
   'When they fall back with the armbar, thumb down and roll over the leg before the elbow locks.',
   'agent:reactions-02', 'fall back for the armbar',
   'fall-back-for-the-armbar'),
  ('mount_bottom', 'half_guard_bottom', 'recover to',
   'When they step a leg off toward side control, trap the ankle and recover half guard on the way out.',
   'agent:reactions-02', 'step off to dismount',
   'step-off-to-dismount');

-- 2e. Arm-triangle and americana chains (turns-in mirror, phone defense,
-- hard-spin back take, plus the stack answer that pairs the hitchhiker).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('arm_triangle', 'darce', 'chains to',
   'When they turn into you to relieve the squeeze, the near arm slides into the darce entry.',
   'agent:reactions-02', 'turn in', 'turn-in'),
  ('arm_triangle', 'kimura', 'chains to',
   'When they answer the phone to block the squeeze, the lifted elbow opens the kimura grip.',
   'agent:reactions-02', 'answer the phone', 'answer-the-phone'),
  ('americana', 'back_control_top', 'take back',
   'When they spin away hard to rip the arm free, follow the rotation and take the back.',
   'agent:reactions-02', 'turn away hard', 'turn-away-hard'),
  ('armbar_mount', 'triangle', 'chains to',
   'When they stack to crush the armbar, your legs are already in place — lock the triangle.',
   'agent:reactions-02', 'stack to defend', 'stack-to-defend');

-- 2f. Gift-wrap hub wiring + hitchhiker landing (mirrors escape_bridge).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('side_control_top', 'gift_wrap', 'attack with',
   'Feed the near arm across and lock the wrap whenever side control settles.',
   'agent:reactions-02', '', ''),
  ('gift_wrap', 'back_control_top', 'take back',
   'When they turn away from the wrap, sit back with the seatbelt and take the back.',
   'agent:reactions-02', 'turn away', 'turn-away'),
  ('gift_wrap', 'arm_triangle', 'submit with',
   'When they post to stop the back take, the wrap tightens into the arm triangle.',
   'agent:reactions-02', 'post with the free hand',
   'post-with-the-free-hand'),
  ('hitchhiker_escape', 'side_control_bottom', 'transition to',
   'Failed escape can land back pinned; keep framing.',
   'agent:reactions-02', '', '');
