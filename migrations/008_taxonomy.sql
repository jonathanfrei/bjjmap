-- 008: freeze the reaction vocabulary. Every trigger_norm used on an edge
-- must exist here (enforced by verify.py). New slugs are added with
-- INSERT OR IGNORE in the same content packet that first uses them.
CREATE TABLE trigger_taxonomy (
  slug TEXT PRIMARY KEY,
  family TEXT NOT NULL,
  display TEXT NOT NULL
);
INSERT INTO trigger_taxonomy VALUES
  -- posture-movement: whole-body motion, turns, base changes
  ('bridges-hard', 'posture-movement', 'bridges hard'),
  ('gives-the-back', 'posture-movement', 'gives the back'),
  ('opponent-falls-back-for-the-armbar', 'posture-movement', 'opponent falls back for the armbar'),
  ('opponent-leans-back-to-finish', 'posture-movement', 'opponent leans back to finish'),
  ('opponent-releases-a-hook', 'posture-movement', 'opponent releases a hook'),
  ('opponent-sits-high-to-attack', 'posture-movement', 'opponent sits high to attack'),
  ('opponent-steps-off-to-dismount', 'posture-movement', 'opponent steps off to dismount'),
  ('shrimps-toward-an-elbow-escape', 'posture-movement', 'shrimps toward an elbow escape'),
  ('stacks-to-defend', 'posture-movement', 'stacks to defend'),
  ('turns-away', 'posture-movement', 'turns away'),
  ('turns-away-hard', 'posture-movement', 'turns away hard'),
  ('turns-belly-down', 'posture-movement', 'turns belly-down'),
  ('turns-in', 'posture-movement', 'turns in'),
  -- frames-grips: arm, hand, and grip fighting
  ('answers-the-phone', 'frames-grips', 'answers the phone'),
  ('clasps-hands-to-stall', 'frames-grips', 'clasps hands to stall'),
  ('hugs-to-defend', 'frames-grips', 'hugs to defend'),
  ('locks-hands', 'frames-grips', 'locks hands'),
  ('opponent-attacks-the-near-arm', 'frames-grips', 'opponent attacks the near arm'),
  ('opponent-isolates-an-arm', 'frames-grips', 'opponent isolates an arm'),
  ('posts-with-the-free-hand', 'frames-grips', 'posts with the free hand'),
  ('pushes-on-the-chest', 'frames-grips', 'pushes on the chest'),
  ('yanks-arm-from-leg-trap', 'frames-grips', 'yanks arm from leg trap'),
  -- defense-commit: head position and stalling commits
  ('lifts-chin-to-breathe', 'defense-commit', 'lifts chin to breathe'),
  ('tucks-chin-to-defend', 'defense-commit', 'tucks chin to defend'),
  -- weight-pressure: flattening rides and leg control
  ('opponent-grapevines', 'weight-pressure', 'opponent grapevines');
-- Family 'limb-exposure' (isolated/extended limbs, open necks) is reserved;
-- its first slug will be added by the packet that needs it.
