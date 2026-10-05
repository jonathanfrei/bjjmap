-- Tier 4D follow-up: guillotine entries from the guards the audit called
-- out (it lived only on front_headlock and butterfly_bottom).
-- source='agent:guillotine-16'.

INSERT OR IGNORE INTO edges
  (from_node, to_node, label, description, source, trigger, trigger_norm)
VALUES
  ('guard_closed_bottom', 'guillotine', 'submit with',
   'Posture broken and the head dips over your chest: wrap the chin, angle out, and finish without opening the guard.',
   'agent:guillotine-16', '', ''),
  ('open_guard_bottom', 'guillotine', 'submit with',
   'When they dive into the guard to pass, the head is there for the wrap — the standing or seated guillotine is the classic counter to the pressure pass.',
   'agent:guillotine-16', '', '');
