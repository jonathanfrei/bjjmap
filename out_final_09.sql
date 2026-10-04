-- Final-chains packet 09 (agent:final-09). 12 triggered edges,
-- 4 new taxonomy slugs. No new nodes. Closes every open submission.
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('grab-the-choking-arm', 'frames-grips', 'grab the choking arm'),
  ('bend-the-knee', 'limb-exposure', 'bend the knee'),
  ('shoot-for-a-leg', 'posture-movement', 'shoot for a leg'),
  ('fall-flat', 'posture-movement', 'fall flat');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- closing the last open submissions.
  ('triangle', 'omoplata', 'chains to',
   'When they stack to crush the triangle, swing the hips through into the omoplata.',
   'agent:final-09', 'stack to defend', 'stack-to-defend'),
  ('kimura', 'back_control_top', 'take back',
   'When they rip the arm free of the figure-four, follow the rotation and take the back.',
   'agent:final-09', 'yank the hand free', 'yank-the-hand-free'),
  ('omoplata', 'triangle', 'chains to',
   'When they posture up out of the shoulder lock, the legs are already set for the triangle.',
   'agent:final-09', 'posture up', 'posture-up'),
  ('darce', 'back_control_top', 'take back',
   'When they spin out of the choke, keep the harness grip and take the back.',
   'agent:final-09', 'turn away', 'turn-away'),
  ('anaconda', 'back_control_top', 'take back',
   'When they roll through the choke, sit back with the seatbelt and take the back.',
   'agent:final-09', 'roll to defend', 'roll-to-defend'),
  ('rnc', 'crucifix_top', 'transition to',
   'When they commit both hands to the choking arm, trap one with the legs and take the crucifix.',
   'agent:final-09', 'grab the choking arm', 'grab-the-choking-arm'),
  ('kneebar', 'toe_hold', 'chains to',
   'When they bend the knee to relieve the extension, switch to the toe hold.',
   'agent:final-09', 'bend the knee', 'bend-the-knee'),
  ('toe_hold', 'heel_hook', 'chains to',
   'When they straighten the leg to slip the toe hold, re-attack the exposed heel.',
   'agent:final-09', 'straighten the leg', 'straighten-the-leg'),
  -- standup and transition reactions.
  ('standing', 'sprawl', 'defend with',
   'When they shoot for a leg, sprawl the hips back and crossface before they connect.',
   'agent:final-09', 'shoot for a leg', 'shoot-for-a-leg'),
  ('standing', 'snapdown', 'attack with',
   'When they lean forward head-down, snap them down to the front headlock.',
   'agent:final-09', 'lean forward', 'lean-forward'),
  ('sweep_condition', 'side_control_top', 'lands in',
   'When the sweep dumps them flat instead of turning, settle directly into side control.',
   'agent:final-09', 'fall flat', 'fall-flat'),
  ('guard_pass', 'mount_top', 'stabilize to',
   'When they bridge mid-pass, run past the hips and stabilize in mount.',
   'agent:final-09', 'bridge hard', 'bridge-hard');
