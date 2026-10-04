-- Tier 4A: connect the thin hubs and add the marquee missing exits.
-- Edges only — no new nodes, no videos. source='agent:edges-12'.
-- One new trigger slug ('push-the-knee-off') rides along per the
-- migrations/008 convention: slugs ship with the packet that first uses them.

INSERT OR IGNORE INTO trigger_taxonomy VALUES
  ('push-the-knee-off', 'frames-grips', 'push the knee off');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- Marquee submissions missing from their hubs.
  ('mount_top', 'kimura', 'submit with',
   'The figure-four is waiting whenever the far arm can be isolated — grip the wrist, sit up into the hip, finish or take the back.',
   'agent:edges-12', '', ''),
  ('back_control_top', 'kimura', 'submit with',
   'Hunting the choke often leaves the near wrist isolated — two-on-one the hand and finish the figure-four without giving up the back.',
   'agent:edges-12', '', ''),
  ('north_south_top', 'kimura', 'submit with',
   'Sprawled out, the near arm is easy to catch — grip the wrist and spin to the figure-four before they recover a frame.',
   'agent:edges-12', '', ''),
  ('knee_on_belly', 'kimura', 'submit with',
   'The knee ride forces a push reaction — catch the near wrist and step over into the figure-four.',
   'agent:edges-12', '', ''),
  ('turtle_top', 'kimura', 'submit with',
   'The far arm hangs when they post on it — step over the head and rip the figure-four.',
   'agent:edges-12', '', ''),
  ('butterfly_bottom', 'kimura', 'submit with',
   'Posture broken and the near arm floats up: catch the two-on-one and finish the figure-four seated.',
   'agent:edges-12', '', ''),
  ('half_guard_bottom', 'kimura', 'attack with',
   'The kimura trap lives here: two-on-one the far wrist across the back and then sweep, take the back, or finish.',
   'agent:edges-12', '', ''),
  ('butterfly_bottom', 'guillotine', 'submit with',
   'When the head dips low over the hooks, wrap it — the arm-in guillotine is there without leaving the seat.',
   'agent:edges-12', '', ''),
  ('fifty_fifty', 'heel_hook', 'attack with',
   'When the toes clear the hip line the near heel is exposed — the same entanglement that serves the toe hold serves the heel hook (brown/black no-gi).',
   'agent:edges-12', '', ''),
  ('front_headlock', 'back_control_top', 'take back',
   'The go-behind is the default when they stay turtled: spin behind, seatbelt, and insert the hooks instead of squeezing a low-percentage choke.',
   'agent:edges-12', '', ''),

  -- Position transitions and returns.
  ('north_south_top', 'side_control_top', 'transition to',
   'Drop back to the hip and re-pin when the north-south squeeze is not there.',
   'agent:edges-12', '', ''),
  ('turtle_top', 'front_headlock', 'transition to',
   'When they rise to the knees or stand up, the head and arm are there — sit through to the front headlock rather than chasing the back.',
   'agent:edges-12', '', ''),
  ('knee_on_belly', 'side_control_top', 'transition to',
   'When they uproot the knee to breathe, settle back to side control instead of losing top position entirely.',
   'agent:edges-12', 'push the knee off', 'push-the-knee-off'),
  ('takedown_top', 'mount_top', 'lands in',
   'Some trips and mat returns drop you straight into mount — stabilize the same 3s and bank the extra 4.',
   'agent:edges-12', '', ''),
  ('takedown_top', 'back_control_top', 'lands in',
   'Force them to the belly or all fours and the scoring wants back control rather than hooks: control the back for 3s and the takedown scores.',
   'agent:edges-12', '', ''),

  -- Bottom-side recoveries that were missing.
  ('back_control_bottom', 'guard_closed_bottom', 'recover to',
   'Win the hand fight, clear a hook, and turn in — closed guard is a full recovery from the worst spot.',
   'agent:edges-12', '', ''),
  ('back_control_bottom', 'half_guard_bottom', 'recover to',
   'Insert the half guard on the way in when the full turn is not there.',
   'agent:edges-12', '', ''),
  ('turtle_bottom', 'standing', 'recover to',
   'Build the base: post, stand up, and wrestle back to neutral instead of waiting for the next attack.',
   'agent:edges-12', '', ''),
  ('turtle_bottom', 'open_guard_bottom', 'recover to',
   'Granby or shoulder-roll through to put the feet back between you — open guard rather than staying shelled up.',
   'agent:edges-12', '', ''),
  ('side_control_bottom', 'guard_closed_bottom', 'recover to',
   'Frame, shrimp, and walk the hips back to re-close the guard — the classic reset when the half guard is not there.',
   'agent:edges-12', '', ''),
  ('side_control_bottom', 'single_leg', 'attack with',
   'Underhook to the dogfight, come up to the knee, and drive the single leg before they settle their weight.',
   'agent:edges-12', '', ''),

  -- Guard and standing gaps.
  ('open_guard_bottom', 'x_guard', 'enter',
   'Off the hip shield, thread the legs to the standing opponent''s lead leg and pull into the X.',
   'agent:edges-12', '', ''),
  ('guard_closed_top', 'knee_cut', 'pass with',
   'Open the guard to a combat base and slice the knee across the thigh — the standard closed-guard pass once the ankles open.',
   'agent:edges-12', '', '');

-- Description tweaks now that these hubs carry their marquee options.
UPDATE nodes SET description =
  'Feet on hips and frames: butterfly, X, and single-leg X live here in no-gi; de la Riva and spider in the gi.'
 WHERE id = 'open_guard_bottom';
UPDATE nodes SET description =
  'Attacking the turtle: clock chokes in the gi; darce, anaconda, kimura, and back takes in no-gi.'
 WHERE id = 'turtle_top';
