-- Content audit packet (descriptions + edge logic), part of the
-- audit-fixes batch. Trigger vocabulary v2 lives in migrations/009;
-- apply that first so this packet's new slugs sit in a consistent vocab.
-- source='agent:content-audit-11'.

------------------------------------------------------------------------
-- Tier 1: description accuracy (IBJJF facts + terminology)
------------------------------------------------------------------------

-- Heel hooks: legal in no-gi at brown/black, illegal in the gi at all belts.
UPDATE nodes SET description =
  'Rotational knee attack off the saddle. IBJJF: legal in no-gi at brown and black only; illegal in the gi at every belt. ADCC-legal. Terminal.'
 WHERE id = 'heel_hook';

-- The saddle is the INSIDE entanglement (inside sankaku), not outside.
UPDATE nodes SET description =
  'Inside leg entanglement (honey hole / 411 / inside sankaku): heel hooks and kneebars live here. IBJJF: heel hooks and knee reaping legal in no-gi at brown and black only.'
 WHERE id = 'saddle';

-- X-guard is not single-leg X / ashi garami.
UPDATE nodes SET description =
  'Underneath X on the standing opponent''s lead leg: the classic sweep hub. Distinct from single-leg X (ashi garami) — step through to it for foot attacks.'
 WHERE id = 'x_guard';

-- Inside trip is ouchi gari, not uchi-mata.
UPDATE nodes SET description =
  'Ouchi gari style major inner reap from the clinch. Scores as takedown (2).'
 WHERE id = 'inside_trip';

-- Sweep scores from guard or half-guard, not only closed guard.
UPDATE nodes SET description =
  '2 pts: reverse the opponent from guard or half-guard to top and hold 3s. Reversals from other positions do not score.'
 WHERE id = 'sweep_condition';

-- A pass can stabilize in mount too (which then adds its own 4).
UPDATE nodes SET description =
  '3 pts: clear the legs and stabilize in side control, north-south, or mount for 3s (mount then adds its own 4).'
 WHERE id = 'guard_pass';

-- Only condition that omitted its point value.
UPDATE nodes SET description =
  '4 pts: stabilize the mount, threaten submissions.'
 WHERE id = 'mount_top';

-- Wrist is not a small joint; legality is brown/black in IBJJF.
UPDATE nodes SET description =
  'Wrist compression off any control: IBJJF-legal at brown and black, easy to ignore until it is not. Terminal.'
 WHERE id = 'wrist_lock';

-- Head can be inside or on the hip.
UPDATE nodes SET description =
  'Level change, head inside or on the hip, drive through. Scores as takedown (2).'
 WHERE id = 'dbl_leg';

-- Backstep and long-step are the same pass family.
UPDATE nodes SET description =
  'Backstep (long-step) around the open-guard legs. Scores as guard pass (3).'
 WHERE id = 'backstep_pass';

-- It is the opponent who is standing.
UPDATE nodes SET description =
  'Sweep against a standing opponent from open guard. Scores as sweep (2).'
 WHERE id = 'tripod_sweep';

-- Works from half and open guard; the knee slices, it does not wiper.
UPDATE nodes SET description =
  'The signature half- and open-guard pass: slice the knee across the thigh. Scores as guard pass (3).'
 WHERE id = 'knee_cut';

-- "Knee slide" is the pass name (knee_cut); this is the mount advance.
UPDATE nodes SET name = 'Slide to Mount',
  description =
  'The classic side-control-to-mount advance: slide the knee across the belly without getting caught in three-quarter mount. Scores as mount (4).'
 WHERE id = 'mount_slide';

------------------------------------------------------------------------
-- Tier 2: edge logic — success exits, missing landings, wrong framing
------------------------------------------------------------------------

-- The upa succeeds by rolling them over and landing on top in their guard;
-- the existing edge is only the failure case (back to the pin).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('escape_bridge', 'guard_closed_top', 'escape to',
   'Successful upa: trap the arm and foot, bridge and roll them over — you land on top in their closed guard and the pass chain starts.',
   'agent:content-audit-11', '', '');

-- Hitchhiker success comes up on top; the existing edge is the failure case.
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('hitchhiker_escape', 'side_control_top', 'escape to',
   'Thumb down, bridge and roll over the leg before the elbow locks — you come up on top, ready to control.',
   'agent:content-audit-11', '', '');

-- Default closed-guard sweep outcome was missing (guard_closed_top's only
-- entries were takedowns).
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('sweep_condition', 'guard_closed_top', 'lands in',
   'The default guard-sweep outcome: you land on top in their closed guard and the pass chain starts.',
   'agent:content-audit-11', '', '');

-- North-south is normally entered from side control, not only off a pass.
INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('side_control_top', 'north_south_top', 'transition to',
   'Circle toward the head to kill the frames and hunt the north-south choke.',
   'agent:content-audit-11', '', '');

-- Being mounted from flattened side control is THEIR advance, not a
-- destination you choose — it belongs under a reaction group.
INSERT OR IGNORE INTO trigger_taxonomy VALUES
  ('slide-to-mount', 'posture-movement', 'slide to mount');
UPDATE edges SET
  trigger = 'slide to mount',
  trigger_norm = 'slide-to-mount',
  description = 'When they drop the knee across before you frame, the pin deepens into mount — accept it and work the mount-bottom escapes.'
 WHERE from_node = 'side_control_bottom' AND to_node = 'mount_bottom'
   AND trigger_norm = '';

-- Position -> condition edges used the technique-only label "scores as";
-- every other position routes through the generic "sweep with"/"pass with"
-- edge (guard_closed_bottom -> sweep_condition, guard_closed_top ->
-- guard_pass). Match that vocabulary so "Where you can go" reads the same.
UPDATE edges SET label = 'sweep with',
  description = 'X-guard sweeps against the standing opponent score 2.'
 WHERE from_node = 'x_guard' AND to_node = 'sweep_condition'
   AND label = 'scores as';
UPDATE edges SET label = 'pass with'
 WHERE from_node = 'half_guard_top' AND to_node = 'guard_pass'
   AND label = 'scores as';
