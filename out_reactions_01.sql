-- Pilot packet: if/then reactions on 4 nodes (edges only, no new nodes).
-- Convention: trigger = the OTHER player's observable action.
-- source='agent:reactions-pilot'.
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- arm_triangle: defender turns away to relieve pressure -> back take.
  ('arm_triangle', 'back_control_top', 'take back',
   'When they turn away to relieve the squeeze, the arm-triangle grip is already a seatbelt — take the back instead of chasing the finish.',
   'agent:reactions-pilot', 'turn away', 'turn-away'),
  -- americana: defender hugs own arm to block the paintbrush -> armbar.
  ('americana', 'armbar_mount', 'chains to',
   'When they hug their own arm to stop the paintbrush, the elbow straightens and lifts — the armbar is already there.',
   'agent:reactions-pilot', 'hug to defend', 'hug-to-defend'),
  -- americana: defender locks hands to stall -> ezekiel opening.
  ('americana', 'ezekiel', 'chains to',
   'When they lock their hands to stall the americana, their crossed wrists sit under the chin — switch to the ezekiel grip.',
   'agent:reactions-pilot', 'lock hands', 'lock-hands'),
  -- mount_top: defender bridges hard -> ezekiel without losing mount.
  ('mount_top', 'ezekiel', 'submit with',
   'When they bridge hard to escape, the chin lifts off the chest — slide the ezekiel in before they settle back down.',
   'agent:reactions-pilot', 'bridge hard', 'bridge-hard'),
  -- mount_top: defender turns belly-down -> gift-wrap arm triangle.
  ('mount_top', 'arm_triangle', 'submit with',
   'When they turn away underneath you, the gift-wrap arm triangle tightens on its own — lock it up rather than resetting to mount.',
   'agent:reactions-pilot', 'turn belly-down', 'turn-belly-down'),
  -- mount_bottom (defender view: trigger is the ATTACKER's action).
  -- Attacker commits both hands to isolate an arm -> bail to turtle.
  ('mount_bottom', 'turtle_bottom', 'escape to',
   'When they commit both hands to isolating your arm for the americana, turn to turtle before the shoulder locks — accept the worse position to save the joint.',
   'agent:reactions-pilot', 'isolate an arm',
   'isolate-an-arm');
