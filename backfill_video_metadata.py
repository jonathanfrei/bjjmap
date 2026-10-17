"""Backfill video metadata (channel, duration_s, published_at) from YouTube
watch pages. Run locally and throttled — watch pages are ~1.4 MB each and
YouTube rate-limits datacenter IPs fast (HTTP 429), so do NOT run this from
CI:

    python3 backfill_video_metadata.py [delay_seconds]

Only fetches rows missing any of the three fields, so re-runs are cheap.
Stdlib only.
"""
import json
import re
import sys
import time
import urllib.request

import store

UA = "Mozilla/5.0 (compatible; bjj-map-metadata/1.0)"
DEFAULT_DELAY = 2.0


def meta(yid):
    try:
        req = urllib.request.Request(
            "https://www.youtube.com/watch?v=" + yid,
            headers={"User-Agent": UA, "Accept-Language": "en-US,en;q=0.9"})
        with urllib.request.urlopen(req, timeout=20) as r:
            html = r.read().decode("utf-8", "replace")
    except Exception:
        return None
    # duration may be missing in new YT HTML; try multiple patterns
    dur = re.search(r'"lengthSeconds"\s*:\s*"(\d+)"', html)
    if not dur:
        dur = re.search(r'"lengthSeconds"\s*:\s*(\d+)', html)
    pub = re.search(r'"publishDate"\s*:\s*"([^"]+)"', html)
    if not pub:
        pub = re.search(r'"publishDate"\s*:\s*\{[^}]*"simpleText"\s*:\s*"([^"]+)"', html)
    chan = re.search(r'"ownerChannelName"\s*:\s*"((?:[^"\\]|\\.)*)"', html)
    # channel fallback via oEmbed (reliable)
    if not chan:
        try:
            import urllib.request as _ur
            _req = _ur.Request("https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v="+yid+"&format=json", headers={"User-Agent": UA})
            with _ur.urlopen(_req, timeout=10) as _r:
                import json as _js
                _j = _js.loads(_r.read().decode())
                _chan = _j.get("author_name","")
                if _chan:
                    chan = type('o', (), {'group': lambda s,n, _c=_chan: _c})()
        except: pass
    if not (pub and chan):
        return None
    if not dur:
        # duration unavailable in this HTML variant — keep 0, let caller still fill channel/date
        dur = type('o', (), {'group': lambda s,n: '0'})()
    # ownerChannelName is JSON-escaped (e.g. \u0026 for &).
    raw_chan = chan.group(1)
    try: channel = json.loads('"' + raw_chan + '"')
    except: channel = raw_chan
    # pub may be "May 5, 2021" -> convert to YYYY-MM-DD
    raw_pub = pub.group(1)
    if "-" not in raw_pub:
        try:
            import datetime
            dt = datetime.datetime.strptime(raw_pub.strip(), "%b %d, %Y")
            raw_pub = dt.strftime("%Y-%m-%d")
        except:
            try: dt = datetime.datetime.strptime(raw_pub.strip(), "%B %d, %Y")
            except: pass
            else: raw_pub = dt.strftime("%Y-%m-%d")
    return {"channel": channel,
            "duration_s": int(dur.group(1)),
            "published_at": raw_pub[:10]}


def main():
    delay = float(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_DELAY
    c = store.connect()
    rows = c.execute(
        "SELECT youtube_id FROM videos WHERE rejected=0 AND "
        "(channel='' OR duration_s=0 OR published_at='')"
    ).fetchall()
    print(f"{len(rows)} video(s) need metadata")
    filled = 0
    for (yid,) in rows:
        m = meta(yid)
        if m:
            c.execute(
                "UPDATE videos SET channel=?, duration_s=?, published_at=? "
                "WHERE youtube_id=?", (m["channel"], m["duration_s"],
                                        m["published_at"], yid))
            c.commit()
            filled += 1
            print(f"OK   {yid}  {m['channel']}  "
                  f"{m['duration_s']}s  {m['published_at']}")
        else:
            print(f"MISS {yid}")
        time.sleep(delay)
    print(f"{filled}/{len(rows)} filled")
    c.close()


if __name__ == "__main__":
    main()
