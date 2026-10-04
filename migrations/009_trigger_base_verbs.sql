-- 009: trigger vocabulary v2 — base-verb phrases.
-- 008 froze the vocabulary in 3rd-person / subject-prefixed form
-- ("hugs to defend", "opponent grapevines"), which renders as broken
-- headings: "If they hugs to defend", "If they opponent grapevines".
-- The convention (007) is that trigger = the OTHER player's observable
-- action; the text now reads as the complement of "If they ".
-- Renames both trigger text and the trigger_norm slug (internal anchors
-- follow); family is unchanged. Idempotent: re-running is a no-op.
-- New slugs are still added by the content packet that first uses them.
CREATE TEMP TABLE trigmap (
  old_slug TEXT PRIMARY KEY, new_slug TEXT NOT NULL, new_display TEXT NOT NULL
);
INSERT INTO trigmap VALUES
  ('answers-the-phone', 'answer-the-phone', 'answer the phone'),
  ('bends-the-knee', 'bend-the-knee', 'bend the knee'),
  ('bridges-hard', 'bridge-hard', 'bridge hard'),
  ('clasps-hands-to-stall', 'clasp-hands-to-stall', 'clasp hands to stall'),
  ('defends-the-hooks', 'defend-the-hooks', 'defend the hooks'),
  ('dives-for-the-underhook', 'dive-for-the-underhook', 'dive for the underhook'),
  ('falls-flat', 'fall-flat', 'fall flat'),
  ('gives-the-back', 'give-the-back', 'give the back'),
  ('grabs-the-choking-arm', 'grab-the-choking-arm', 'grab the choking arm'),
  ('grips-to-open', 'grip-to-open', 'grip to open'),
  ('hugs-to-defend', 'hug-to-defend', 'hug to defend'),
  ('leans-back', 'lean-back', 'lean back'),
  ('leans-forward', 'lean-forward', 'lean forward'),
  ('leans-to-one-side', 'lean-to-one-side', 'lean to one side'),
  ('lifts-chin-to-breathe', 'lift-chin-to-breathe', 'lift chin to breathe'),
  ('locks-hands', 'lock-hands', 'lock hands'),
  ('opponent-attacks-the-near-arm', 'attack-the-near-arm', 'attack the near arm'),
  ('opponent-chases-the-far-arm', 'chase-the-far-arm', 'chase the far arm'),
  ('opponent-drives-forward', 'drive-forward', 'drive forward'),
  ('opponent-falls-back-for-the-armbar', 'fall-back-for-the-armbar', 'fall back for the armbar'),
  ('opponent-flattens-out', 'flatten-out', 'flatten out'),
  ('opponent-grapevines', 'grapevine', 'grapevine'),
  ('opponent-isolates-an-arm', 'isolate-an-arm', 'isolate an arm'),
  ('opponent-leans-back-to-finish', 'lean-back-to-finish', 'lean back to finish'),
  ('opponent-releases-a-hook', 'release-a-hook', 'release a hook'),
  ('opponent-sits-back', 'sit-back', 'sit back'),
  ('opponent-sits-high-to-attack', 'sit-high-to-attack', 'sit high to attack'),
  ('opponent-steps-off-to-dismount', 'step-off-to-dismount', 'step off to dismount'),
  ('posts-with-the-free-hand', 'post-with-the-free-hand', 'post with the free hand'),
  ('postures-up', 'posture-up', 'posture up'),
  ('pushes-on-the-chest', 'push-on-the-chest', 'push on the chest'),
  ('pushes-on-the-shoulder', 'push-on-the-shoulder', 'push on the shoulder'),
  ('pushes-the-knees-down', 'push-the-knees-down', 'push the knees down'),
  ('reaches-across', 'reach-across', 'reach across'),
  ('reaches-for-a-leg', 'reach-for-a-leg', 'reach for a leg'),
  ('rolls-away', 'roll-away', 'roll away'),
  ('rolls-to-defend', 'roll-to-defend', 'roll to defend'),
  ('shoots-for-a-leg', 'shoot-for-a-leg', 'shoot for a leg'),
  ('shrimps-toward-an-elbow-escape', 'shrimp-toward-an-elbow-escape', 'shrimp toward an elbow escape'),
  ('sits-up', 'sit-up', 'sit up'),
  ('stacks-to-defend', 'stack-to-defend', 'stack to defend'),
  ('stands-tall', 'stand-tall', 'stand tall'),
  ('stands-to-open', 'stand-to-open', 'stand to open'),
  ('straightens-the-leg', 'straighten-the-leg', 'straighten the leg'),
  ('strips-the-hands', 'strip-the-hands', 'strip the hands'),
  ('tucks-chin-to-defend', 'tuck-chin-to-defend', 'tuck chin to defend'),
  ('turns-away', 'turn-away', 'turn away'),
  ('turns-away-hard', 'turn-away-hard', 'turn away hard'),
  ('turns-belly-down', 'turn-belly-down', 'turn belly-down'),
  ('turns-in', 'turn-in', 'turn in'),
  ('turns-the-knee-out', 'turn-the-knee-out', 'turn the knee out'),
  ('whizzers-hard', 'whizzer-hard', 'whizzer hard'),
  ('wraps-closed-guard', 'wrap-closed-guard', 'wrap closed guard'),
  ('yanks-arm-from-leg-trap', 'yank-arm-from-leg-trap', 'yank arm from leg trap'),
  ('yanks-the-hand-free', 'yank-the-hand-free', 'yank the hand free');

UPDATE trigger_taxonomy SET
  slug = (SELECT new_slug FROM trigmap WHERE old_slug = trigger_taxonomy.slug),
  display = (SELECT new_display FROM trigmap WHERE old_slug = trigger_taxonomy.slug)
 WHERE slug IN (SELECT old_slug FROM trigmap);

UPDATE edges SET
  trigger = (SELECT new_display FROM trigmap WHERE old_slug = edges.trigger_norm),
  trigger_norm = (SELECT new_slug FROM trigmap WHERE old_slug = edges.trigger_norm)
 WHERE trigger_norm IN (SELECT old_slug FROM trigmap);

DROP TABLE trigmap;
