"""Trigger vocabulary audit. Read-only; exits nonzero on failure.

Reports edge trigger_norms missing from trigger_taxonomy (also a
verify.py --strict error) plus near-duplicate slugs that may want merging
(difflib suggestions only — a human decides). Stdlib only.

Usage: python3 normalize_triggers.py [path/to/bjj.db]
Honours BJJ_DB env (see store.py) when no path is given.
"""
import difflib
import os
import sqlite3
import sys

BASE = os.path.dirname(os.path.abspath(__file__))


def main():
    db = sys.argv[1] if len(sys.argv) > 1 else os.environ.get(
        "BJJ_DB", os.path.join(BASE, "bjj.db"))
    c = sqlite3.connect(db)
    c.row_factory = sqlite3.Row
    known = [r["slug"] for r in
             c.execute("SELECT slug FROM trigger_taxonomy ORDER BY slug")]
    fams = {}
    for r in c.execute("SELECT slug, family FROM trigger_taxonomy"):
        fams.setdefault(r["family"], []).append(r["slug"])
    used = [r["trigger_norm"] for r in c.execute(
        "SELECT DISTINCT trigger_norm FROM edges WHERE trigger_norm<>''")]

    print(f"{len(known)} taxonomy slugs in "
          f"{len(fams)} families ({', '.join(sorted(fams))})")
    print(f"{len(used)} slugs used on edges")
    errors = 0
    for slug in sorted(set(used) - set(known)):
        errors += 1
        print(f"UNMAPPED: {slug}")
        near = difflib.get_close_matches(slug, known, n=3, cutoff=0.55)
        if near:
            print(f"  maybe: {', '.join(near)}")
    for slug in sorted(set(known) - set(used)):
        print(f"UNUSED: {slug}")
    c.close()
    print(f"{errors} unmapped slug(s)")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
