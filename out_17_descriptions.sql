-- Packet 17: enrich the thinnest node descriptions.
-- Copy-only: no new nodes, edges, or videos. Idempotent re-runs.
-- Follows the house voice from the good triggered-edge descriptions:
-- what the position is FOR + the primary failure mode, without restating
-- scoring (points live in the node meta and the condition pages).

UPDATE nodes SET description =
  'Bottom half: the underhook battle. Win it to sweep or take the back; lose it and you get flattened, crossfaced, and passed.'
WHERE id = 'half_guard_bottom';

UPDATE nodes SET description =
  'Top half: crossface, free the trapped leg. Expect the underhook fight and the dogfight — knee cut, underhook pass, or backstep to finish.'
WHERE id = 'half_guard_top';

UPDATE nodes SET description =
  'The back''s highest-percentage finish: seatbelt under the chin, choking arm over the shoulder. Fight the hands before it closes. Terminal.'
WHERE id = 'rnc';

UPDATE nodes SET description =
  'Back taken: fight the choking hand first, then clear hooks. Two-on-one the seatbelt arm and turn in before the RNC closes.'
WHERE id = 'back_control_bottom';

UPDATE nodes SET description =
  '4 pts: hooks in with the seatbelt, control 3s. Hunt the RNC; if they hand-fight the choking arm hard, switch to the armbar off the chair sit.'
WHERE id = 'back_control_top';

UPDATE nodes SET description =
  'Turtled under pressure: protect the neck first, then granby-roll or sit out to guard before they take the back or lock the front headlock.'
WHERE id = 'turtle_bottom';

UPDATE nodes SET description =
  'Closed guard bottom: break posture, then answer what they give you — hip bump when they post up, triangle when they posture, kimura when they grip to open.'
WHERE id = 'guard_closed_bottom';

UPDATE nodes SET description =
  'Inside their closed guard: posture up, break the ankles open, then knee cut or toreando. The break is where triangles and hip bumps get thrown.'
WHERE id = 'guard_closed_top';

UPDATE nodes SET description =
  'The front-headlock marquee finish: chin wrapped, arm in or out, hips angled off center. Low percentage unless posture is truly broken. Terminal.'
WHERE id = 'guillotine';

UPDATE nodes SET description =
  'Classic mount finish: isolate an arm, swing the leg over the head, thumb-up wrist control. Terminal — defend the hitchhiker while you still can.'
WHERE id = 'armbar_mount';

UPDATE nodes SET description =
  'Worst spot to be. Bridge and elbow-escape early, keep elbows tight; once their base settles your options narrow fast.'
WHERE id = 'mount_bottom';

UPDATE nodes SET description =
  'Elevate them over the hook and off their base — best as a reaction to forward pressure, chained with sumi gaeshi when they sprawl out.'
WHERE id = 'butterfly_sweep';
