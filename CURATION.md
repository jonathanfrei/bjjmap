# Video Curation Rubric (v1 — tighten/loosen as needed)

Every video row must justify itself in `why_this_one`. If you can't write
the sentence, don't add the video.

## Hard gates (reject on sight)

1. **Rule-set fit.** v1 is no-gi. Gi videos only if the concept transfers
   completely (mark `rule_set='both'` and say so in the rationale).
2. **Embed alive.** Verify the 11-char ID resolves (YouTube oEmbed:
   `https://www.youtube.com/oembed?url=...&format=json`). Dead IDs rot the map.
3. **On-node.** The video must teach *this* node, not a neighbor. A mount
   video that is really about armbars belongs on the armbar node.

## Scoring (prefer videos that hit most)

4. **Instructor credibility.** Known competitor/coach or gym with a track
   record (Danaher/Ryan/Giles/Bodoni/Melanson tier, or equivalent). Obscure
   channels need a stronger reason.
5. **Role coverage.** Each node wants, in order:
   - `concept` (1 max) — the *idea* of the position (conditions especially)
   - `howto` (1–2) — specific mechanics for the node
   - `troubleshoot` (0–1) — answers the most common failure mode
   - `roll` (rare) — live application, only if genuinely instructive
6. **Recency/format.** Prefer <15 min, clear audio, top-down or multi-angle.
   A 90-min seminar dump loses to a tight 8-min breakdown of the same move.
7. **No duplicates.** One video per sub-technique per node. Near-identical
   double-leg tutorials don't both belong.

## Technique vs alias discipline

- Distinct mechanics = distinct `technique` nodes (americana ≠ kimura,
  toreando ≠ leg drag), even if they score as the same condition.
- Different *names* for identical mechanics = `node_aliases` rows, not nodes.
- When unsure, keep one node and note the naming dispute in its description.

## Counter-pair rule

Every control position gets its escape video; every weapon gets its counter.
Top's passes pair with bottom's frames, top's underhook answer pairs with
bottom's underhook game, back retention pairs with back escapes. When adding
a video to one side of a position, check whether the other side needs its
mirror.

## Packet workflow (per cluster, e.g. half guard)

1. Research 2–4 candidate videos per node; verify IDs via oEmbed.
2. Insert directly (no approval gate) with `why_this_one` + `role`.
3. Audit edges both directions: every technique gets a `scores as` edge to
   its condition; every position gets at least one entry and one exit path.
4. Owner vetoes via `rejected=1` — never delete, so vetoes stay visible.
