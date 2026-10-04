-- Final-chains packet 09 (agent:final-09). 12 triggered edges,
-- 4 new taxonomy slugs. No new nodes. Closes every open submission.
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('grabs-the-choking-arm', 'frames-grips', 'grabs the choking arm'),
  ('bends-the-knee', 'limb-exposure', 'bends the knee'),
  ('shoots-for-a-leg', 'posture-movement', 'shoots for a leg'),
  ('falls-flat', 'posture-movement', 'falls flat');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- closing the last open submissions.
  ('triangle', 'omoplata', 'chains to',
   'When they stack to crush the triangle, swing the hips through into the omoplata.',
   'agent:final-09', 'stacks to defend', 'stacks-to-defend'),
  ('kimura', 'back_control_top', 'take back',
   'When they rip the arm free of the figure-four, follow the rotation and take the back.',
   'agent:final-09', 'yanks the hand free', 'yanks-the-hand-free'),
  ('omoplata', 'triangle', 'chains to',
   'When they posture up out of the shoulder lock, the legs are already set for the triangle.',
   'agent:final-09', 'postures up', 'postures-up'),
  ('darce', 'back_control_top', 'take back',
   'When they spin out of the choke, keep the harness grip and take the back.',
   'agent:final-09', 'turns away', 'turns-away'),
  ('anaconda', 'back_control_top', 'take back',
   'When they roll through the choke, sit back with the seatbelt and take the back.',
   'agent:final-09', 'rolls to defend', 'rolls-to-defend'),
  ('rnc', 'crucifix_top', 'transition to',
   'When they commit both hands to the choking arm, trap one with the legs and take the crucifix.',
   'agent:final-09', 'grabs the choking arm', 'grabs-the-choking-arm'),
  ('kneebar', 'toe_hold', 'chains to',
   'When they bend the knee to relieve the extension, switch to the toe hold.',
   'agent:final-09', 'bends the knee', 'bends-the-knee'),
  ('toe_hold', 'heel_hook', 'chains to',
   'When they straighten the leg to slip the toe hold, re-attack the exposed heel.',
   'agent:final-09', 'straightens the leg', 'straightens-the-leg'),
  -- standup and transition reactions.
  ('standing', 'sprawl', 'defend with',
   'When they shoot for a leg, sprawl the hips back and crossface before they connect.',
   'agent:final-09', 'shoots for a leg', 'shoots-for-a-leg'),
  ('standing', 'snapdown', 'attack with',
   'When they lean forward head-down, snap them down to the front headlock.',
   'agent:final-09', 'leans forward', 'leans-forward'),
  ('sweep_condition', 'side_control_top', 'lands in',
   'When the sweep dumps them flat instead of turning, settle directly into side control.',
   'agent:final-09', 'falls flat', 'falls-flat'),
  ('guard_pass', 'mount_top', 'stabilize to',
   'When they bridge mid-pass, run past the hips and stabilize in mount.',
   'agent:final-09', 'bridges hard', 'bridges-hard');
