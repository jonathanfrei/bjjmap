-- Packet 18: intermediate-critical hub nodes missing from the map.
-- 6 new nodes (headquarters, dogfight, knee shield, deep half, outside
-- ashi, cross ashi), 18 curated no-gi videos (rule of three: 1 concept +
-- 2 howto, or concept/howto/troubleshoot), 44 edges wiring them into the
-- existing map. No new taxonomy slugs — all 7 triggers reuse existing
-- ones (turn-away, push-the-knee-off, drive-forward, posture-up,
-- bend-the-knee, turn-in, straighten-the-leg). Idempotent: INSERT OR
-- IGNORE throughout, source='agent:packet-18'.

INSERT OR IGNORE INTO nodes (id, name, side, kind, description, is_terminal, points, scores_as, phase, source) VALUES
  ('headquarters', 'Headquarters', 'top', 'position',
   'The hub between the knees: one leg pinned with the knee, the other free. Every classic pass — knee cut, toreando, leg drag, backstep — starts here, so treat it as a control station, not a pause.',
   0, 0, NULL, 'guard', 'agent:packet-18'),
  ('dogfight', 'Dogfight', 'neutral', 'position',
   'The half-guard standup: your underhook against their whizzer, both on a knee. Win the angle and come up on top or take the back; lose it and you get flattened back to bottom half.',
   0, 0, NULL, 'guard', 'agent:packet-18'),
  ('knee_shield', 'Knee Shield (Bottom Half)', 'bottom', 'position',
   'Bottom half with the knee across their hip: frames their upper body off so the crossface never lands. Sweep or come up to the dogfight before they flatten you out.',
   0, 0, NULL, 'guard', 'agent:packet-18'),
  ('deep_half', 'Deep Half Guard', 'bottom', 'position',
   'Bottom half swept underneath them, head under their hip: the answer to heavy top pressure. Stay on your side, get the far-leg underhook, and come up to a single or sweep when they posture.',
   0, 0, NULL, 'guard', 'agent:packet-18'),
  ('outside_ashi', 'Outside Ashi-Garami', 'neutral', 'position',
   'The outside entanglement: your legs control their leg hip-to-hip from the outside. Straight ankle and toe hold live here, and it feeds the saddle — distinct from single-leg X, which rides underneath.',
   0, 0, NULL, 'legs', 'agent:packet-18'),
  ('cross_ashi', 'Cross Ashi-Garami', 'top', 'position',
   'The inside entanglement: your legs cross inside their hip line, pinning one leg while trapping the other. The saddle''s sibling — kneebars and heel hooks when they straighten or hide the heel.',
   0, 0, NULL, 'legs', 'agent:packet-18');

-- Videos: all IDs verified alive via YouTube oEmbed at packet time; none
-- collide with existing rows (cross-node reuse fails verify --strict).

INSERT OR IGNORE INTO videos (node_id, youtube_id, title, why_this_one, rule_set, role, source) VALUES
  ('headquarters', 'quM3u9Jxthg', 'Headquarters Guard Passing Simplified | No Gi Jiu-Jitsu',
   'Frames headquarters as a control hub with a pass menu rather than a single pass — which is how top players actually use it.', 'nogi', 'concept', 'agent:packet-18'),
  ('headquarters', '1hdUOVhsFuI', 'Guard Passing from Headquarters: The Knee Cut',
   'Clean knee-cut mechanics from the hub: the pass every headquarters player needs first.', 'nogi', 'howto', 'agent:packet-18'),
  ('headquarters', 'hCGLrC6q2yM', 'Headquarters to a Knee Cut or Hip Switch Pass - Ffion Davies',
   'Ffion''s hip-switch answer for when the knee cut gets stuffed — keeps the hub alive instead of resetting to open guard.', 'nogi', 'howto', 'agent:packet-18');

INSERT OR IGNORE INTO videos (node_id, youtube_id, title, why_this_one, rule_set, role, source) VALUES
  ('dogfight', 'dwi9GxgqV8w', 'Dogfight Position (Seatbelt vs Whizzer): Breakdown to Mount and Armlock (No Gi BJJ)',
   'Names the two grips that decide the position and what each side is actually fighting for.', 'nogi', 'concept', 'agent:packet-18'),
  ('dogfight', 'TcRu7E2IrYw', 'Wrestle-Jitsu 101: 3 Ways To Win Dogfight Position',
   'Three concrete wins from the dogfight (front headlock, back take, dump) — a menu, not a single Technique.', 'nogi', 'howto', 'agent:packet-18'),
  ('dogfight', 'pFDaEFAo7ak', 'Options from the Dogfight Position NoGi BJJ | Grappling Education',
   'No-gi specific: what changes from the gi when the underhook battle starts.', 'nogi', 'howto', 'agent:packet-18');

INSERT OR IGNORE INTO videos (node_id, youtube_id, title, why_this_one, rule_set, role, source) VALUES
  ('knee_shield', 'aL8RfesQL5k', 'Knee Shield Guard Retention Concepts | Cobrinha BJJ',
   'Retention-first framing: what the knee shield is for before any sweep is shown.', 'nogi', 'concept', 'agent:packet-18'),
  ('knee_shield', 'qnCtO5ZVRcY', 'Timeless No Gi Knee Shield in Jiu Jitsu with Rafael Lovato Jr',
   'No-gi knee shield from one of the best half-guard players alive: frames and the underhook battle.', 'nogi', 'howto', 'agent:packet-18'),
  ('knee_shield', '1H8SPgg7mv4', 'GUARD RETENTION KNEE THROUGH DRILL by Lachlan Giles',
   'The drill for the #1 failure mode: getting flattened and losing the shield entirely.', 'nogi', 'troubleshoot', 'agent:packet-18');

INSERT OR IGNORE INTO videos (node_id, youtube_id, title, why_this_one, rule_set, role, source) VALUES
  ('deep_half', 'LkX4oAIZ48k', 'Deep Half Guard Concept, Entry & Sweeping',
   'Explains the position''s purpose — getting underneath their pressure — instead of treating it as just another sweep.', 'nogi', 'concept', 'agent:packet-18'),
  ('deep_half', 'WNXrZjz8nFU', 'Super Efficient BJJ Deep Half Guard Sweep No Gi by Jeff Glover',
   'Glover''s no-gi deep-half sweep: the highest-percentage finish from underneath.', 'nogi', 'howto', 'agent:packet-18'),
  ('deep_half', '0MnbWcnlwQY', 'HOW TO use the DEEP HALF GUARD in BJJ',
   'Entry and frame details so you actually get deep before they settle their weight.', 'nogi', 'howto', 'agent:packet-18');

INSERT OR IGNORE INTO videos (node_id, youtube_id, title, why_this_one, rule_set, role, source) VALUES
  ('outside_ashi', 'xWrEk9MbvUc', 'A Guide To The Main Leglock Positions: Ashi Garami, Saddle, Leg Knot, 50/50, Outside Ashi',
   'Places outside ashi in the entanglement map — what it is and what it is not.', 'nogi', 'concept', 'agent:packet-18'),
  ('outside_ashi', 'zsnGef5-N2g', 'Attacking the Toehold from Outside Ashi Garami (No Gi BJJ/Jiu-Jitsu)',
   'The highest-percentage finish from outside ashi, with the grip detail that makes it work.', 'nogi', 'howto', 'agent:packet-18'),
  ('outside_ashi', 'cdhCmLV8tCQ', 'Stop the stack from outside Ashi | BJJ Leg Locks',
   'Answers the #1 failure: getting stacked out of the entanglement before any attack starts.', 'nogi', 'troubleshoot', 'agent:packet-18');

INSERT OR IGNORE INTO videos (node_id, youtube_id, title, why_this_one, rule_set, role, source) VALUES
  ('cross_ashi', 'q_MJy_g42LM', 'Understanding Cross Ashi in Jiu Jitsu by Firas Zahabi',
   'Zahabi on what cross ashi is for versus the saddle, and when to take it.', 'nogi', 'concept', 'agent:packet-18'),
  ('cross_ashi', 'WqJnBWij11E', 'Opponent Posts Leg -> Cross Ashi Garami by John Danaher',
   'The entry that matters: converting their posted leg into the entanglement.', 'nogi', 'howto', 'agent:packet-18'),
  ('cross_ashi', 'dNpWQWWsWb8', 'Avoiding getting smashed in cross ashi garami.',
   'The failure mode from the top: losing the entanglement to their pressure before you finish.', 'nogi', 'troubleshoot', 'agent:packet-18');

-- Edges. Untriggered first, then triggered; every triggered edge explains
-- causality per CURATION.md.

INSERT OR IGNORE INTO edges (from_node, to_node, label, description, source) VALUES
  -- headquarters entries
  ('guard_closed_top', 'headquarters', 'advance to',
   'Pop the guard open to a combat base and step between the knees — hub established, pass menu open.', 'agent:packet-18'),
  ('open_guard_top', 'headquarters', 'advance to',
   'Circle past the feet and frames into the knee-pinch hub instead of engaging in their open guard.', 'agent:packet-18'),
  ('half_guard_top', 'headquarters', 'advance to',
   'Come up on top in the half and drive to the hub rather than sinking the crossface immediately.', 'agent:packet-18'),
  ('butterfly_top', 'headquarters', 'advance to',
   'Stand or rise out of the hooks and establish the knee pinch — the smash is optional, the hub is not.', 'agent:packet-18'),
  ('sweep_condition', 'headquarters', 'lands in',
   'Sweeping from bottom half or butterfly often lands you standing between their knees — settle into the hub.', 'agent:packet-18'),
  -- headquarters exits
  ('headquarters', 'knee_cut', 'pass with',
   'Slice the knee across the thigh from the knee pinch — the signature exit from the hub.', 'agent:packet-18'),
  ('headquarters', 'toreando', 'pass with',
   'Bullfighter grip and lateral movement — best when they sit back and stop tracking your knees.', 'agent:packet-18'),
  ('headquarters', 'guard_pass', 'pass with',
   'Any hub exit that clears the legs and stabilizes for 3s scores the pass — pick the reaction, not the move.', 'agent:packet-18'),
  -- dogfight entries
  ('half_guard_bottom', 'dogfight', 'enter',
   'Come up to a knee and fight for the underhook — the standup battle from bottom half.', 'agent:packet-18'),
  ('half_guard_top', 'dogfight', 'enter',
   'They come up to a knee: meet them in the dogfight and fight the whizzer rather than flattening.', 'agent:packet-18'),
  -- dogfight exits
  ('dogfight', 'dogfight_dump', 'sweep with',
   'Win the underhook, sit out, and dump them head-and-arm to the far side.', 'agent:packet-18'),
  ('dogfight', 'single_leg', 'attack with',
   'Come up to the single when they posture out of the underhook battle.', 'agent:packet-18'),
  ('dogfight', 'half_guard_bottom', 'recover to',
   'Lose the underhook and get stretched out: reset to bottom half before they pass.', 'agent:packet-18'),
  ('dogfight', 'half_guard_top', 'recover to',
   'Win the battle but lose the angle: settle back into top half and restart the pass.', 'agent:packet-18'),
  -- knee shield entries
  ('half_guard_bottom', 'knee_shield', 'transition to',
   'Get the knee across their hip as they settle their weight — frames the crossface off before it lands.', 'agent:packet-18'),
  ('side_control_bottom', 'knee_shield', 'recover to',
   'Frame on the hip, shrimp, and insert the knee shield on the way back to half.', 'agent:packet-18'),
  -- knee shield exits
  ('knee_shield', 'dogfight', 'enter',
   'Come up to the knee when they lean back to kill the shield.', 'agent:packet-18'),
  ('knee_shield', 'deep_half', 'transition to',
   'If they flatten you despite the shield, duck underneath into deep half.', 'agent:packet-18'),
  ('knee_shield', 'back_take_half', 'take back',
   'Come up to the dogfight and slip behind when they turn to pass.', 'agent:packet-18'),
  -- deep half entries
  ('half_guard_bottom', 'deep_half', 'transition to',
   'Get underneath them: head under their hip, frame the far leg, and wait for the pressure.', 'agent:packet-18'),
  ('knee_shield', 'deep_half', 'transition to',
   'When they flatten the shield, duck under rather than fighting from the bottom of half.', 'agent:packet-18'),
  -- deep half exits
  ('deep_half', 'sweep_condition', 'sweep with',
   'Waiter sweep or the old-school variant: get the underhook on the far leg and come up as they widen their base.', 'agent:packet-18'),
  ('deep_half', 'half_guard_bottom', 'recover to',
   'Lose the underneath position: come back to plain bottom half before they whizzer you flat.', 'agent:packet-18'),
  -- outside ashi entries
  ('slx', 'outside_ashi', 'transition to',
   'From the single-leg X, unwind your hips to the outside — same leg, inside entanglement.', 'agent:packet-18'),
  ('open_guard_bottom', 'outside_ashi', 'enter',
   'Off a foot-on-hip frame, hug the lead leg and unwind into the outside entanglement.', 'agent:packet-18'),
  ('fifty_fifty', 'outside_ashi', 'transition to',
   'When they peel out of the mirrored entanglement, take the outside position on their free leg.', 'agent:packet-18'),
  -- outside ashi exits
  ('outside_ashi', 'straight_ankle', 'attack with',
   'The straight ankle is the on-node finish: Achilles grip, hips in, foot across the hip.', 'agent:packet-18'),
  ('outside_ashi', 'saddle', 'advance to',
   'Step through to the saddle when they turn the knee out — the inside position is one step away.', 'agent:packet-18'),
  ('outside_ashi', 'slx', 'recover to',
   'Lose the entanglement: unwind back to the single-leg X and re-enter from the outside.', 'agent:packet-18'),
  -- cross ashi entries
  ('saddle', 'cross_ashi', 'transition to',
   'When they hide the heel in the saddle, reconfigure to cross ashi — the knee-line pin plus the other leg trap makes the finish accessible.', 'agent:packet-18'),
  ('fifty_fifty', 'cross_ashi', 'transition to',
   'Win the inside position from the mirrored entanglement: cross your legs inside their hip line.', 'agent:packet-18'),
  -- cross ashi exits
  ('cross_ashi', 'heel_hook', 'attack with',
   'Expose the heel by pinning the knee line and peeling their leg free of their own hands.', 'agent:packet-18'),
  ('cross_ashi', 'saddle', 'recover to',
   'Lose the cross: back out to the saddle rather than forcing a finish from a broken entanglement.', 'agent:packet-18'),
  ('cross_ashi', 'side_control_top', 'recover to',
   'Disengage cleanly and pass instead of wrestling a lost entanglement — side control is still points.', 'agent:packet-18');

INSERT OR IGNORE INTO edges (from_node, to_node, label, description, source, trigger, trigger_norm) VALUES
  -- headquarters: reaction-gated exits
  ('headquarters', 'leg_drag', 'pass with',
   'If they turn away to reconnect guard, drag the pinned leg across and staple — their turn feeds the angle.',
   'agent:packet-18', 'turn away', 'turn-away'),
  ('headquarters', 'backstep_pass', 'pass with',
   'If they push the knee off to kill the knee cut, backstep around instead of forcing it.',
   'agent:packet-18', 'push the knee off', 'push-the-knee-off'),
  -- dogfight: the cheapest back take in the map
  ('dogfight', 'back_control_top', 'take back',
   'If they turn away to escape the whizzer, go behind them — their rotation hands you the back.',
   'agent:packet-18', 'turn away', 'turn-away'),
  -- knee shield: sweep as a reaction, not a move
  ('knee_shield', 'sweep_condition', 'sweep with',
   'If they drive forward to kill the frame, meet their pressure with the knee lever and sweep as they commit.',
   'agent:packet-18', 'drive forward', 'drive-forward'),
  -- deep half: pressure creates the single
  ('deep_half', 'single_leg', 'attack with',
   'If they posture up to rip the underhook off, come up to the single underneath them — deep half is a takedown position too.',
   'agent:packet-18', 'posture up', 'posture-up'),
  -- leg entanglements: defensive reactions open the partner attack
  ('outside_ashi', 'toe_hold', 'attack with',
   'If they bend the knee to hide the heel, take the toe hold instead — the defensive bend exposes the foot.',
   'agent:packet-18', 'bend the knee', 'bend-the-knee'),
  ('outside_ashi', 'cross_ashi', 'advance to',
   'If they turn in to defend the outside ankle, switch your legs to cross ashi and trap the near leg.',
   'agent:packet-18', 'turn in', 'turn-in'),
  ('cross_ashi', 'kneebar', 'attack with',
   'If they straighten the leg to hide the heel, take the kneebar — the extension defense feeds the hip lock.',
   'agent:packet-18', 'straighten the leg', 'straighten-the-leg');
