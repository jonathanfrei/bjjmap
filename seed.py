"""Schema bootstrap only — creates an EMPTY database from schema.sql.

Content lives in bjj.db (committed to git). Do NOT add INSERTs here;
historical content seeding is preserved in git history, and the schema
evolution is documented in migrations/.
Usage: python3 seed.py [path/to/new.db]
"""
import os
import sqlite3
import sys

BASE = os.path.dirname(os.path.abspath(__file__))


def main(dest=None):
    dest = dest or os.path.join(BASE, "bjj.db")
    if os.path.exists(dest):
        print(f"refusing to overwrite existing {dest}")
        sys.exit(1)
    with open(os.path.join(BASE, "schema.sql")) as f:
        sqlite3.connect(dest).executescript(f.read())
    print(f"created empty schema at {dest}; run verify.py to check it")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else None)
