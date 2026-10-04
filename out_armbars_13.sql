-- Tier 4B: the armbar family + the crucifix armlock.
-- 4 new submission nodes, position-specific per AGENTS.md (armbar_mount
-- precedent). Every outgoing edge carries a trigger (terminal rule).
-- source='agent:armbars-13'.

INSERT OR IGNORE INTO trigger_taxonomy VALUES
  ('rip-the-arm-free', 'frames-grips', 'rip the arm free');

------------------------------------------------------------------------
-- Nodes
------------------------------------------------------------------------
INSERT OR IGNORE INTO nodes
  (id, name, side, kind, description, is_terminal, points, scores_as,
   phase, source)
VALUES
  ('armbar_guard', 'Armbar from Guard', 'na', 'submission',
   'The closed guard''s signature finish: break the posture, walk the elbow past your hip line, crossface leg over the head. Terminal.',
   1, 0, NULL, 'guard', 'agent:armbars-13'),
  ('armbar_side', 'Armbar from Side Control', 'na', 'submission',
   'Straight armlock off the pin: spin under the far arm or step over the head, keeping the elbow past your hip line. Terminal.',
   1, 0, NULL, 'side', 'agent:armbars-13'),
  ('armbar_back', 'Armbar from Back', 'na', 'submission',
   'The chair-sit finish from the seatbelt: figure-four the near arm, kick the hips down, leg over the head. Terminal.',
   1, 0, NULL, 'back', 'agent:armbars-13'),
  ('crucifix_armlock', 'Crucifix Armlock', 'na', 'submission',
   'Straight armlock off the leg triangle: flare the top knee across the forearm and bridge, or spin to the armbar when they defend. Terminal.',
   1, 0, NULL, 'back', 'agent:armbars-13');

INSERT OR IGNORE INTO node_aliases (alias, node_id, note) VALUES
  ('straight armbar from guard', 'armbar_guard', 'Common name'),
  ('cross-body armbar', 'armbar_guard', 'Old-school name'),
  ('spinning armbar', 'armbar_side', 'Step-over-the-head variant'),
  ('far side armbar', 'armbar_side', 'Marcelo''s underhook version'),
  ('step over armbar', 'armbar_side', ''),
  ('back armbar', 'armbar_back', ''),
  ('chair sit armbar', 'armbar_back', ''),
  ('crucifix armbar', 'crucifix_armlock', ''),
  ('triangle armbar', 'crucifix_armlock', 'Kesting''s name for the leg-triangle finish'),
  ('straight armlock', 'crucifix_armlock', '');

------------------------------------------------------------------------
-- Edges: entries (unconditional)
------------------------------------------------------------------------
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('guard_closed_bottom', 'armbar_guard', 'submit with',
   'Break the posture, elbow past the hip line, crossface leg over the head — the closed guard''s signature finish.',
   'agent:armbars-13', '', ''),
  ('side_control_top', 'armbar_side', 'submit with',
   'Kill the near-side frame, step over the head or spin to the far arm — the pin converts straight into the armlock.',
   'agent:armbars-13', '', ''),
  ('knee_on_belly', 'armbar_side', 'submit with',
   'The knee ride draws the push reaction that opens the far arm — spin under for the same armbar Marcelo used from the pin.',
   'agent:armbars-13', '', ''),
  ('back_control_top', 'armbar_back', 'submit with',
   'When the choke hands are being fought, trap the near arm in the figure-four and lever the hips down for the armbar.',
   'agent:armbars-13', '', ''),
  ('crucifix_top', 'crucifix_armlock', 'submit with',
   'With the arm in the leg triangle, flare the knee across the forearm and bridge — the armlock finishes what the choke started.',
   'agent:armbars-13', '', '');

------------------------------------------------------------------------
-- Edges: reactions (triggered only — these nodes are terminal)
------------------------------------------------------------------------
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('armbar_guard', 'triangle', 'chains to',
   'When they stack to shut the extension down, the crossface leg is already over the shoulder — fall back to the triangle instead of prying.',
   'agent:armbars-13', 'stack to defend', 'stack-to-defend'),
  ('armbar_guard', 'guard_closed_bottom', 'recover to',
   'When they rip the elbow back inside before the leg crosses the head, re-close the guard and reset the angle rather than chasing a lost position.',
   'agent:armbars-13', 'rip the arm free', 'rip-the-arm-free'),
  ('armbar_side', 'kimura', 'chains to',
   'When they clasp hands to hide the wrist, the figure-four is sitting right there — switch to the kimura instead of fighting the grip.',
   'agent:armbars-13', 'clasp hands to stall', 'clasp-hands-to-stall'),
  ('armbar_side', 'back_control_top', 'take back',
   'When they turn away to relieve the arm, follow the rotation past the head and take the back.',
   'agent:armbars-13', 'turn away', 'turn-away'),
  ('armbar_back', 'rnc', 'chains to',
   'When they hug the arm to their chest to stop the extension, the neck is exposed on the other side — go back to the choke.',
   'agent:armbars-13', 'hug to defend', 'hug-to-defend'),
  ('armbar_back', 'back_control_top', 'take back',
   'When the arm slips out mid-transition, sit back to the seatbelt and re-establish the hooks before attacking again.',
   'agent:armbars-13', 'rip the arm free', 'rip-the-arm-free'),
  ('crucifix_armlock', 'rnc', 'chains to',
   'When they tuck the chin while hiding the arm, the near side of the neck is still open — go back to the short choke.',
   'agent:armbars-13', 'tuck chin to defend', 'tuck-chin-to-defend'),
  ('crucifix_armlock', 'back_control_top', 'take back',
   'When they yank the arm out of the leg trap, the armlock is gone — fall back to the seatbelt and re-trap.',
   'agent:armbars-13', 'yank arm from leg trap', 'yank-arm-from-leg-trap');

------------------------------------------------------------------------
-- Videos (rule of three, all IDs oEmbed-verified)
------------------------------------------------------------------------
INSERT OR IGNORE INTO videos
  (node_id, youtube_id, title, why_this_one, rule_set, role, source)
VALUES
  -- armbar_guard
  ('armbar_guard', 'pQ43Oy5k9yQ', 'BJJ Moves: Arm Bar From Guard by John Danaher',
   'Danaher''s head/elbow/hip relationship is the diagnostic for why the basic entry works or fails — the principle behind every guard armbar on this page.',
   'nogi', 'concept', 'agent:armbars-13'),
  ('armbar_guard', 'tZa73s0RmAY', 'No-Gi Arm bar from closed guard to triangle Choke by BJJ Legend Andre Galvao',
   'Galvao''s no-gi climb over the shoulder is the same closed-guard entry this node maps, and it lands in the triangle chain this page links to.',
   'nogi', 'howto', 'agent:armbars-13'),
  ('armbar_guard', 'yyZjAk7vnL8', 'Beyond Basic Arm Bars: A Complete Guard Attack System',
   'Covers the failed-armbar-to-triangle dilemma — the most common way this attack unravels — plus shotgun and choi-bar answers to a defended elbow.',
   'nogi', 'troubleshoot', 'agent:armbars-13'),
  -- armbar_side
  ('armbar_side', 'Zd7mlya1vgU', 'Far armbar from side control (Lachlan Giles)',
   'The cleanest no-gi breakdown of the pin-to-armbar transition, with the shoulder-grip detail that keeps the opponent on their side instead of flattening out.',
   'nogi', 'howto', 'agent:armbars-13'),
  ('armbar_side', 'iO9Za94xHfE', 'Basic Spinning Arm Bar from Side Mount for NoGi',
   'The step-over-the-head spinning version taught explicitly for no-gi, including the kimura-trap detour that hides the spin.',
   'nogi', 'howto', 'agent:armbars-13'),
  ('armbar_side', 'SuPY_vzFp1o', 'Powerful Armbar from Side Control with a Sneaky Setup (Part 1)',
   'Solves the hip-frame problem that normally shuts down side-control armbars; the wedge and step-over mechanics use no grips so they transfer completely to no-gi.',
   'both', 'troubleshoot', 'agent:armbars-13'),
  -- armbar_back
  ('armbar_back', 'jrgCS-699-E', 'Arm Bar From Back Control (Kimura Seatbelt Armbar)',
   'The kimura-seatbelt entry with the bicep grip break — the exact path this node maps from back control to the finish.',
   'nogi', 'howto', 'agent:armbars-13'),
  ('armbar_back', 'im-xwLCUN8U', 'Back Control Secrets | Chokes + Armbar',
   'Frames the armbar as the arm-attack half of the back-control dilemma alongside the choke, which is how the position is actually fought.',
   'nogi', 'concept', 'agent:armbars-13'),
  ('armbar_back', 'HCb7bCVor08', 'Back Control Fundamentals - Armbar, Single Wing Choke',
   'Fundamentals-format back armbar finished against a defending partner; the armlock portion uses no grips and transfers fully to no-gi.',
   'both', 'howto', 'agent:armbars-13'),
  -- crucifix_armlock
  ('crucifix_armlock', 'AA-EkjXf8s4', 'CRUCIFIX ARMBAR',
   'A dedicated no-gi crucifix armbar from Kieran Davern: the leg-triangle flare into the straight armlock, start to finish.',
   'nogi', 'howto', 'agent:armbars-13'),
  ('crucifix_armlock', 'JYidW7LkYiI', 'Americana and Straight Armbar from the Mounted Crucifix position.',
   'Teaches the straight armlock with the forearm-fulcrum finish from top crucifix — the same lever the back-crucifix version uses.',
   'both', 'howto', 'agent:armbars-13'),
  ('crucifix_armlock', '3w2TJp9euoo', 'Crucifix Armbar',
   'A third angle on the same finish so the knee-flare and hip-bridge details are unambiguous.',
   'nogi', 'howto', 'agent:armbars-13');
