-- Submission-answers packet 08 (agent:subs-08). 11 triggered edges,
-- 4 new taxonomy slugs (first use of limb-exposure). No new nodes.
-- All statements idempotent (INSERT OR IGNORE).
INSERT OR IGNORE INTO trigger_taxonomy (slug, family, display) VALUES
  ('roll-to-defend', 'posture-movement', 'roll to defend'),
  ('yank-the-hand-free', 'frames-grips', 'yank the hand free'),
  ('straighten-the-leg', 'limb-exposure', 'straighten the leg'),
  ('turn-the-knee-out', 'limb-exposure', 'turn the knee out');

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  -- choke answers.
  ('guillotine', 'anaconda', 'chains to',
   'When they roll to relieve the choke, follow the neck into the anaconda.',
   'agent:subs-08', 'roll to defend', 'roll-to-defend'),
  ('ezekiel', 'back_control_top', 'take back',
   'When they bridge explosively under the forearm, ride the turn and take the back.',
   'agent:subs-08', 'bridge hard', 'bridge-hard'),
  ('von_flue', 'darce', 'chains to',
   'When they turn in to relieve the shoulder pressure, the arm slides into the darce.',
   'agent:subs-08', 'turn in', 'turn-in'),
  ('ns_choke', 'back_control_top', 'take back',
   'When they bridge to dislodge the armpit choke, ride the turn and take the back.',
   'agent:subs-08', 'bridge hard', 'bridge-hard'),
  ('peruvian_necktie', 'back_control_top', 'take back',
   'When they sit up to relieve the leg pressure, slide the seatbelt in around the back.',
   'agent:subs-08', 'sit up', 'sit-up'),
  -- joint-lock answers.
  ('wrist_lock', 'kimura', 'chains to',
   'When they rip the trapped hand free, follow the arm into the kimura.',
   'agent:subs-08', 'yank the hand free', 'yank-the-hand-free'),
  ('gogoplata', 'omoplata', 'chains to',
   'When they posture up out of the rubber guard, swing the hips through into the omoplata.',
   'agent:subs-08', 'posture up', 'posture-up'),
  -- leg-entanglement answers.
  ('saddle', 'kneebar', 'attack with',
   'When they straighten the trapped leg to slip the heel, switch to the kneebar.',
   'agent:subs-08', 'straighten the leg', 'straighten-the-leg'),
  ('fifty_fifty', 'toe_hold', 'attack with',
   'When they turn the knee outward to hide the heel, take the exposed toe hold.',
   'agent:subs-08', 'turn the knee out', 'turn-the-knee-out'),
  ('heel_hook', 'kneebar', 'chains to',
   'When they roll to relieve the heel hook, follow the leg into the kneebar.',
   'agent:subs-08', 'roll to defend', 'roll-to-defend'),
  ('straight_ankle', 'toe_hold', 'chains to',
   'When they rotate the knee outward to slip the ankle lock, switch to the toe hold.',
   'agent:subs-08', 'turn the knee out', 'turn-the-knee-out');
