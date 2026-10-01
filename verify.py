"""Map integrity gate. `python3 verify.py [--strict]` exits nonzero on failure.
--strict is what CI runs before export; without it, warnings don't fail.
Stdlib only.
"""
import os
import sqlite3
import sys

import render
import store

BASE = os.path.dirname(os.path.abspath(__file__))

# Deliberate cross-node reuse (same video, different role per node).
KNOWN_REUSE = {
    "aC_6P_pp-0I": "sweep concept on sweep_condition, technique howto on butterfly_bottom",
}

# Techniques that are setups/defense, not scoring paths: allowed to have
# scores_as NULL. Everything else of kind=technique must anchor to a condition.
UNANCHORED_OK = {"arm_drag", "snapdown", "sprawl", "guard_break"}

errors, warnings = [], []


def check(cond, msg, warn=False):
    if not cond:
        (warnings if warn else errors).append(msg)


def main():
    strict = "--strict" in sys.argv
    c = store.connect()
    tables = {r[0] for r in
              c.execute("SELECT name FROM sqlite_master WHERE type='table'")}
    for t in ("nodes", "videos", "edges", "node_aliases", "phases"):
        check(t in tables, f"missing table: {t}")

    cols = lambda t: [r[1] for r in c.execute(f"PRAGMA table_info({t})")]
    for col in ("points", "scores_as", "phase", "source"):
        check(col in cols("nodes"), f"nodes missing column: {col}")
    for col in ("role", "stale", "source"):
        check(col in cols("videos"), f"videos missing column: {col}")
    check("source" in cols("edges"), "edges missing column: source")

    if errors and strict:
        pass  # schema broken; content checks would crash
    else:
        node_ids = {r["id"] for r in store.all_nodes(c)}
        kinds = {"position", "condition", "technique", "submission",
                 "escape", "transition"}
        for n in store.all_nodes(c):
            check(n["kind"] in kinds, f"{n['id']}: bad kind {n['kind']}")
            check(n["description"], f"{n['id']}: empty description")
            if n["kind"] == "technique" and not n["scores_as"] \
                    and n["id"] not in UNANCHORED_OK:
                errors.append(f"{n['id']}: unanchored technique")
            if n["scores_as"]:
                check(n["scores_as"] in node_ids,
                      f"{n['id']}: scores_as dangles ({n['scores_as']})")
            if n["is_terminal"]:
                out = c.execute("SELECT 1 FROM edges WHERE from_node=?",
                                (n["id"],)).fetchone()
                check(not out, f"{n['id']}: terminal node has outgoing edge")
            nv = c.execute("SELECT count(*) FROM videos "
                           "WHERE node_id=? AND rejected=0",
                           (n["id"],)).fetchone()[0]
            check(nv > 0, f"{n['id']}: no live videos")
            check(c.execute("SELECT 1 FROM phases WHERE key=?",
                            (n["phase"],)).fetchone(),
                  f"{n['id']}: unknown phase {n['phase']}")
        for e in c.execute("SELECT * FROM edges"):
            check(e["from_node"] in node_ids,
                  f"edge {e['id']}: orphan from {e['from_node']}")
            check(e["to_node"] in node_ids,
                  f"edge {e['id']}: orphan to {e['to_node']}")
        for v in c.execute("SELECT * FROM videos WHERE rejected=0"):
            check(len(v["youtube_id"]) == 11,
                  f"video {v['id']}: bad youtube_id {v['youtube_id']!r}")
            check(v["why_this_one"], f"video {v['id']}: empty rationale")
            check(v["node_id"] in node_ids,
                  f"video {v['id']}: orphan node {v['node_id']}")
        seen, dups = set(), 0
        for v in c.execute("SELECT youtube_id FROM videos WHERE rejected=0"):
            if v["youtube_id"] in seen and v["youtube_id"] not in KNOWN_REUSE:
                dups += 1
            seen.add(v["youtube_id"])
        check(dups == 0, f"{dups} youtube_id(s) reused across nodes", warn=True)
    c.close()

    # Theme drift gate: every token must exist in static/style.css.
    css = open(os.path.join(BASE, "static", "style.css")).read()
    for tok in render.TOKENS:
        check(tok in css, f"style.css missing token {tok}")
    for w in warnings:
        print("WARN:", w)
    for e in errors:
        print("FAIL:", e)
    print(f"{len(errors)} error(s), {len(warnings)} warning(s)")
    if errors or (strict and warnings):
        sys.exit(1)


if __name__ == "__main__":
    main()
