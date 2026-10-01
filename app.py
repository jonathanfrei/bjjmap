"""BJJ Map — stdlib only (no deps). Run: python3 app.py (serves :8000)."""
import html
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, unquote, urlparse

import store

BASE = os.path.dirname(__file__)

CSS = (
    "<style>"
    "body{font-family:system-ui,sans-serif;max-width:760px;margin:2rem auto;"
    "padding:0 1rem;line-height:1.5}"
    "nav a{margin-right:1rem}"
    ".card{border:1px solid #ddd;border-radius:8px;padding:1rem;margin:1rem 0}"
    "iframe{max-width:100%}"
    ".muted{color:#666}"
    ".pill{display:inline-block;background:#eee;border-radius:1em;"
    "padding:.1em .7em;margin:.1em;font-size:.85em}"
    ".facade{position:relative;max-width:560px;cursor:pointer;"
    "background:#000;border-radius:4px;overflow:hidden}"
    ".facade img{width:100%;display:block;aspect-ratio:16/9;object-fit:cover}"
    ".facade .play{position:absolute;top:50%;left:50%;"
    "transform:translate(-50%,-50%);width:68px;height:48px;"
    "background:rgba(0,0,0,.75);border-radius:12px;border:0;cursor:pointer}"
    ".facade .play:after{content:'';position:absolute;top:50%;left:50%;"
    "transform:translate(-35%,-50%);border-left:22px solid #fff;"
    "border-top:14px solid transparent;border-bottom:14px solid transparent}"
    ".facade iframe{width:100%;aspect-ratio:16/9;height:auto;display:block}"
    "</style>"
)

MIME = {".js": "text/javascript", ".html": "text/html; charset=utf-8",
        ".css": "text/css", ".json": "application/json"}


def page(title, body):
    return (
        "<!doctype html><html><head><meta charset=utf-8>"
        "<meta name=viewport content='width=device-width,initial-scale=1'>"
        f"<title>{html.escape(title)}</title>{CSS}</head><body>"
        "<nav><a href='/'>Map</a><a href='/graph'>Graph</a>"
        "<a href='/coverage'>Health</a></nav>"
        f"<h1>{html.escape(title)}</h1>{body}</body></html>"
    ).encode()


def search_box(term=""):
    t = html.escape(term)
    return (
        f"<form method=get action=/search>"
        f"<input name=q value='{t}' placeholder='Search positions, techniques…'"
        " style='width:70%'> <button>Search</button></form>"
    )


def node_summary(r):
    bits = [r["kind"], r["side"]]
    if r["points"]:
        bits.append(f"{r['points']} pts")
    if r["is_terminal"]:
        bits.append("terminal")
    return (
        f"<div class=card><a href='/node/{r['id']}'>"
        f"<b>{html.escape(r['name'])}</b></a> "
        f"<span class=muted>{' · '.join(bits)}</span><br>"
        f"{html.escape(r['description'] or '')}</div>"
    )


def video_card(v):
    stale = " <b>[stale link?]</b>" if v["stale"] else ""
    yid = v["youtube_id"]
    return (
        f"<div class=card><b>{html.escape(v['title'])}</b> "
        f"<span class=muted>[{v['role']}]</span>{stale}<br>"
        f"<div class=facade data-yid='{yid}'>"
        f"<img loading=lazy src='https://i.ytimg.com/vi/{yid}/maxresdefault.jpg' "
        f"onerror=\"this.onerror=null;this.src="
        f"'https://i.ytimg.com/vi/{yid}/hqdefault.jpg'\" "
        f"alt='Video thumbnail'>"
        f"<button class=play aria-label='Play video'></button></div>"
        f"<p class=muted>{html.escape(v['why_this_one'] or '')}</p></div>"
    )


FACADE_JS = (
    "<script>"
    "document.addEventListener('click',function(e){"
    "var f=e.target.closest('.facade');if(!f||f.dataset.loaded)return;"
    "f.dataset.loaded='1';"
    "var y=f.dataset.yid;"
    "f.innerHTML=\"<iframe src='https://www.youtube-nocookie.com/embed/\"+y+"
    "\"?autoplay=1&rel=0' frameborder=0 "
    "allow='accelerometer;autoplay;encrypted-media;picture-in-picture' "
    "allowfullscreen></iframe>\";"
    "});"
    "</script>"
)


def edge_list(rows, col):
    if not rows:
        return "<li class=muted>None</li>"
    return "".join(
        f"<li><a href='/node/{r[col]}'>{html.escape(r['name'])}</a> — "
        f"<i>{html.escape(r['label'])}</i> "
        f"{html.escape(r['description'] or '')}</li>"
        for r in rows
    )


class H(BaseHTTPRequestHandler):
    def do_GET(self):
        u = urlparse(self.path)
        c = store.connect()
        try:
            if u.path == "/":
                self.index(c)
            elif u.path == "/search":
                q = parse_qs(u.query).get("q", [""])[0].strip()
                self.do_search(c, q)
            elif u.path.startswith("/node/"):
                self.node_page(c, unquote(u.path[len("/node/"):]))
            elif u.path == "/graph":
                with open(os.path.join(BASE, "graph.html"), "rb") as f:
                    self.send_raw(200, f.read(), MIME[".html"])
            elif u.path == "/api/graph":
                payload = json.dumps(store.graph_data(c)).encode()
                self.send_raw(200, payload, MIME[".json"])
            elif u.path.startswith("/static/"):
                self.serve_static(u.path)
            elif u.path == "/coverage":
                self.coverage_page(c)
            else:
                self.send(404, page("Not found", "<p>Unknown path.</p>"))
        finally:
            c.close()

    def index(self, c):
        nodes = store.all_nodes(c)
        phases = store.phases(c)
        by_phase = {}
        for r in nodes:
            by_phase.setdefault(r["phase"], []).append(r)
        parts = [search_box()]
        known = set()
        for p in phases:
            known.add(p["key"])
            group = sorted(
                by_phase.get(p["key"], []),
                key=lambda r: (-(r["points"] or 0), r["kind"], r["name"]),
            )
            if group:
                parts.append(f"<h2>{html.escape(p['title'])}</h2>")
                parts.extend(node_summary(r) for r in group)
        rest = sorted(
            (r for ph, rs in by_phase.items() for r in rs if ph not in known),
            key=lambda r: r["name"],
        )
        if rest:
            parts.append("<h2>Other</h2>")
            parts.extend(node_summary(r) for r in rest)
        self.send(200, page("BJJ Map (No-Gi POC)", "".join(parts)))

    def do_search(self, c, q):
        body = search_box(q)
        if q:
            hits = store.search(c, q)
            body += f"<p class=muted>{len(hits)} result(s)</p>"
            body += "".join(node_summary(r) for r in hits)
        self.send(200, page(f"Search: {q}", body))

    def node_page(self, c, nid):
        n = store.get_node(c, nid)
        if not n:
            self.send(404, page("Not found", "<p>Unknown node.</p>"))
            return
        vids = store.videos_for(c, nid)
        aliases = store.aliases_for(c, nid)
        bits = [n["kind"], n["side"]]
        if n["points"]:
            bits.append(f"{n['points']} pts")
        if n["scores_as"]:
            bits.append(
                f"scores as <a href='/node/{n['scores_as']}'>"
                f"{html.escape(n['scores_as'])}</a>")
        body = f"<p class=muted>{' · '.join(bits)}</p>"
        if aliases:
            pills = "".join(
                f"<span class=pill>{html.escape(a['alias'])}</span>"
                for a in aliases)
            body += f"<p>Also called: {pills}</p>"
        body += f"<p>{html.escape(n['description'] or '')}</p>"
        body += "<h2>Instruction</h2>"
        body += "".join(video_card(dict(v)) for v in vids) or \
            "<p class=muted>No videos yet — stub, curation pending.</p>"
        body += "<h2>How you got here</h2><ul>"
        body += edge_list(store.edges_in(c, nid), "from_node") + "</ul>"
        body += "<h2>Where you can go</h2><ul>"
        body += edge_list(store.edges_out(c, nid), "to_node") + "</ul>"
        body += f"<p><a href='/graph?focus={nid}'>View in graph</a></p>"
        body += FACADE_JS
        self.send(200, page(n["name"], body))

    def coverage_page(self, c):
        rep = store.coverage(c)
        body = "<p class=muted>Map health — fix these as content grows.</p>"
        for key, title in [
                ("no_incoming", "Nodes with no entries"),
                ("no_outgoing", "Nodes with no exits (non-terminal)"),
                ("bare_conditions", "Conditions with no techniques"),
                ("no_videos", "Nodes with no videos (stubs)"),
                ("stale_videos", "Videos flagged stale")]:
            items = rep[key]
            body += f"<h2>{title} ({len(items)})</h2>"
            if key == "stale_videos":
                body += "<ul>" + "".join(
                    f"<li><a href='/node/{v['node_id']}'>"
                    f"{html.escape(v['title'])}</a></li>" for v in items
                ) + "</ul>" if items else "<p class=muted>None</p>"
            else:
                body += "<ul>" + "".join(
                    f"<li><a href='/node/{i}'>{i}</a></li>"
                    for i in items) + "</ul>" if items else \
                    "<p class=muted>None</p>"
        self.send(200, page("Map health", body))

    def serve_static(self, path):
        safe = os.path.normpath(path).lstrip("/")
        full = os.path.join(BASE, safe)
        if not full.startswith(os.path.join(BASE, "static")) \
                or not os.path.isfile(full):
            self.send(404, page("Not found", "<p>Unknown path.</p>"))
            return
        ext = os.path.splitext(full)[1]
        with open(full, "rb") as f:
            self.send_raw(200, f.read(), MIME.get(ext, "application/octet-stream"))

    def send(self, code, data):
        self.send_raw(code, data, "text/html; charset=utf-8")

    def send_raw(self, code, data, ctype):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, *a):
        pass


if __name__ == "__main__":
    if not os.path.exists(store.DB):
        print("bjj.db missing — run: python3 seed.py first")
    HTTPServer(("127.0.0.1", 8000), H).serve_forever()
