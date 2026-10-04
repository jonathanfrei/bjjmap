-- Crucifix system packet 03: attack (agent:crucifix-attack) + defense
-- (agent:crucifix-defense) subagent packets, applied as one transaction.
-- One change vs the returned packets: crucifix_bottom concept video swapped
-- (7TcoNNl4Z6Q -> aLB-8bEnQ00) because 7TcoNNl4Z6Q is already used on
-- crucifix_top and verify.py --strict fails cross-node youtube_id reuse.
-- aLB-8bEnQ00 oEmbed-verified 2026-10-04, unused in DB.
-- All statements idempotent (INSERT OR IGNORE).

-- 3a. New nodes.
INSERT OR IGNORE INTO nodes
  (id, name, side, kind, description, is_terminal, points, phase, source)
VALUES
  ('crucifix_top', 'Crucifix (Top)', 'top', 'position',
   'Back-side pin that traps one arm between your legs and controls the other with your upper body, leaving the neck and the trapped arm defenseless. Enter it when turtle or back scrambles expose an arm, then choke or armlock without ever releasing both traps at once.',
   0, 0, 'back', 'agent:crucifix-attack'),
  ('crucifix_bottom', 'Crucifix (Bottom)', 'bottom', 'position',
   'Pinned face-down with one arm snared by the attacker''s legs and the other controlled up high, usually after a failed turtle escape or an arm isolated from side control. With both of your arms occupied you cannot defend your neck, leaving the attacker free to hunt the one-armed choke and the straight armlock.',
   0, 0, 'back', 'agent:crucifix-defense');

-- 3b. Videos (rule of three per node; all IDs oEmbed-verified).
INSERT OR IGNORE INTO videos
  (node_id, youtube_id, title, why_this_one, rule_set, role, source)
VALUES
  ('crucifix_top', 'rCQsaENYkTE', 'Your Guide to the Crucifix Position in No Gi, from Basic Grips to Advanced Submissions',
   'Kesting''s no-gi overview maps the whole position — leg-triangle clamp plus short-choke and triangle-armbar progression — the both-arms-trapped control idea before any single finish.',
   'nogi', 'concept', 'agent:crucifix-attack'),
  ('crucifix_top', '_HGvjRpfh8Y', 'The Perfect Jiu Jitsu Crucifix Attack by Marcelo Garcia',
   'Marcelo, the signature crucifix attacker, shows the turtle entry into the leg trap and the choke finish; the control uses zero gi grips so it transfers completely.',
   'both', 'howto', 'agent:crucifix-attack'),
  ('crucifix_top', '7TcoNNl4Z6Q', 'How to Do the Crucifix Submission in BJJ and No Gi',
   'Lisboa (Marcelo Garcia student) attacks the armbar first because everyone protects the neck, then answers the two common failures: hand-connection and sitting up into the legs.',
   'both', 'troubleshoot', 'agent:crucifix-attack'),
  ('crucifix_bottom', 'aLB-8bEnQ00', 'Crucifix from sidecontrol',
   'Energia''s entry-to-finish overview shows the defender exactly how the trap closes and which submissions follow, so the exits below read as answers to real threats.',
   'both', 'concept', 'agent:crucifix-defense'),
  ('crucifix_bottom', 'EcXue-cD12Q', 'How to Escape the Crucifix in BJJ',
   'Kesting works every major crucifix variation with its step-by-step escape, giving the defender one mechanical answer per trap instead of a single lucky move.',
   'both', 'howto', 'agent:crucifix-defense'),
  ('crucifix_bottom', 'gUy0ycrx7mM', 'Every BJJ White Belt Needs to Know This Crucifix Escape | Quick Tutorial',
   'Short beginner framing of the most common failure -- freezing once both arms are trapped -- with a quick bail-out to drill before the position locks.',
   'both', 'troubleshoot', 'agent:crucifix-defense');

-- 3c. Entries into the crucifix (unconditional).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('turtle_top', 'crucifix_top', 'enter',
   'When they turtle and post an arm to block the hooks, thread the leg over that arm and roll them into the leg trap instead of forcing the seatbelt.',
   'agent:crucifix-attack', '', ''),
  ('side_control_top', 'crucifix_top', 'enter',
   'When they turn to their knees to escape the pin, trap the near arm with the leg and follow them over into the crucifix rather than resetting the pin.',
   'agent:crucifix-attack', '', ''),
  ('back_control_top', 'crucifix_top', 'transition to',
   'When hook defense shuts down the seatbelt, trap one arm between the legs and keep the other with the hands — the crucifix keeps back exposure without needing hooks.',
   'agent:crucifix-attack', '', ''),
  ('turtle_bottom', 'crucifix_bottom', 'transition to',
   'Sitting out or rolling without clearing the near arm lets the attacker thread their legs around it and collapse you into the crucifix.',
   'agent:crucifix-defense', '', ''),
  ('side_control_bottom', 'crucifix_bottom', 'transition to',
   'Posting with the far arm or reaching across while flattened lets the attacker trap it with their legs and take the crucifix.',
   'agent:crucifix-defense', '', '');

-- 3d. Attacks out of crucifix_top (all triggered: defender's actions).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('crucifix_top', 'rnc', 'submit with',
   'When they lift the chin to breathe, the neck opens under the choking arm — slide the one-arm strangle home while the leg clamp keeps both arms out of the defense.',
   'agent:crucifix-attack', 'lift chin to breathe', 'lift-chin-to-breathe'),
  ('crucifix_top', 'kimura', 'submit with',
   'A tucked chin seals the neck but glues the trapped arm in place — lock the figure-four on that isolated arm instead of fighting the chin.',
   'agent:crucifix-attack', 'tuck chin to defend', 'tuck-chin-to-defend'),
  ('crucifix_top', 'americana', 'submit with',
   'When they clasp their hands to stop the choke, the joined arms fix the elbow in place — paintbrush the leg-trapped arm into the americana without opening the clamp.',
   'agent:crucifix-attack', 'clasp hands to stall', 'clasp-hands-to-stall'),
  ('crucifix_top', 'back_control_top', 'take back',
   'When they rip the arm out of the leg clamp, the rotation turns the back toward you — keep chest contact and lock the seatbelt instead of chasing the lost trap.',
   'agent:crucifix-attack', 'yank arm from leg trap', 'yank-arm-from-leg-trap');

-- 3e. Escapes out of crucifix_bottom (all triggered: attacker's actions).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('crucifix_bottom', 'turtle_bottom', 'escape to',
   'Once a leg unlocks to chase the finish the trapped-side hip is free -- turn in toward the loose leg and rebuild turtle before the arm-trap resets.',
   'agent:crucifix-defense', 'release a hook',
   'release-a-hook'),
  ('crucifix_bottom', 'escape_bridge', 'escape via',
   'Both of the attacker''s hands committing to the armlock loads their weight onto your chest -- bridge explosively into them to topple the control before the elbow straightens.',
   'agent:crucifix-defense', 'attack the near arm',
   'attack-the-near-arm'),
  ('crucifix_bottom', 'elbow_escape', 'escape via',
   'Leaning back to extend the arm or find the choke lifts pressure off your hips -- shrimp the legs clear in that space and scoot out the back door.',
   'agent:crucifix-defense', 'lean back to finish',
   'lean-back-to-finish');
