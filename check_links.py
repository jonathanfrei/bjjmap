"""Flag dead YouTube embeds. Run monthly: python3 check_links.py
Sets videos.stale=1 when the oEmbed lookup fails. Stdlib only.
"""
import json
import sqlite3
import urllib.request

import store

OEMBED = ("https://www.youtube.com/oembed?url="
          "https://www.youtube.com/watch?v={}&format=json")


def alive(yid):
    try:
        req = urllib.request.Request(OEMBED.format(yid),
                                     headers={"User-Agent": "bjj-map/1.0"})
        with urllib.request.urlopen(req, timeout=15) as r:
            json.load(r)
        return True
    except Exception:
        return False


def main():
    c = store.connect()
    rows = c.execute("SELECT DISTINCT youtube_id FROM videos "
                     "WHERE rejected=0").fetchall()
    dead = []
    for (yid,) in rows:
        ok = alive(yid)
        print(("OK   " if ok else "DEAD ") + yid)
        if not ok:
            dead.append(yid)
    if dead:
        marks = ",".join("?" for _ in dead)
        c.execute(f"UPDATE videos SET stale=1 WHERE youtube_id IN ({marks})",
                  dead)
        c.commit()
    print(f"{len(dead)}/{len(rows)} stale")
    c.close()


if __name__ == "__main__":
    main()
