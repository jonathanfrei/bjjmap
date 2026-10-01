"""BJJ Map — stdlib only (no deps). Run: python3 app.py (serves :8000).
Thin HTTP layer over store.py (data) and render.py (HTML). BASE_PATH env
prefixes all links when serving under a subpath.
"""
import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, unquote, urlparse

import render
import store

BASE = os.path.dirname(__file__)
BASE_PATH = os.environ.get("BASE_PATH", "")

MIME = {".js": "text/javascript", ".html": "text/html; charset=utf-8",
        ".css": "text/css", ".json": "application/json",
        ".svg": "image/svg+xml", ".xml": "application/xml",
        ".txt": "text/plain"}


def strip_base(path):
    if BASE_PATH and path.startswith(BASE_PATH):
        return path[len(BASE_PATH):] or "/"
    return path


class H(BaseHTTPRequestHandler):
    server_version = "BJJMap"

    def do_GET(self):
        u = urlparse(self.path)
        path = strip_base(u.path)
        c = store.connect()
        try:
            if path == "/":
                nodes = store.all_nodes(c)
                phases = store.phases(c)
                by_phase = {}
                for r in nodes:
                    by_phase.setdefault(r["phase"], []).append(r)
                self.send(200, render.page(
                    BASE_PATH, "BJJ Map (No-Gi POC)",
                    render.index_body(BASE_PATH, phases, by_phase)))
            elif path == "/search" or path == "/search/":
                q = parse_qs(u.query).get("q", [""])[0].strip()[:120]
                hits = store.search(c, q) if q else []
                self.send(200, render.page(
                    BASE_PATH, f"Search: {q}",
                    render.search_body(BASE_PATH, q, hits)))
            elif path.startswith("/node/"):
                nid = unquote(path[len("/node/"):]).strip("/")
                self.node_page(c, nid)
            elif path in ("/graph", "/graph/"):
                with open(os.path.join(BASE, "graph.html"), "rb") as f:
                    html_text = f.read().decode("utf-8").replace(
                        "__BASE__", BASE_PATH)
                self.send_raw(200, html_text.encode(), MIME[".html"])
            elif path == "/favicon.ico":
                with open(os.path.join(BASE, "static",
                                       "favicon.svg"), "rb") as f:
                    self.send_raw(200, f.read(), "image/svg+xml")
            elif path in ("/api/graph", "/api/graph.json"):
                payload = json.dumps(store.graph_data(c)).encode()
                self.send_raw(200, payload, MIME[".json"])
            elif path.startswith("/static/"):
                self.serve_static(path)
            elif path in ("/coverage", "/health", "/health/"):
                # /coverage is the legacy path; canonical is /health/
                if path == "/coverage":
                    self.redirect(render.u(BASE_PATH, "/health/"))
                    return
                self.send(200, render.page(
                    BASE_PATH, "Map health",
                    render.coverage_body(BASE_PATH, store.coverage(c))))
            else:
                self.send(404, render.page(
                    BASE_PATH, "Not found", "<p>Unknown path.</p>"))
        finally:
            c.close()

    def node_page(self, c, nid):
        n = store.get_node(c, nid)
        if not n:
            self.send(404, render.page(
                BASE_PATH, "Not found", "<p>Unknown node.</p>"))
            return
        vids = store.videos_for(c, nid)
        body = render.node_body(
            BASE_PATH, n, vids, store.aliases_for(c, nid),
            store.techniques_for(c, nid) if n["kind"] == "condition" else [],
            store.edges_in(c, nid), store.edges_out(c, nid))
        self.send(200, render.page(BASE_PATH, n["name"], body))

    def serve_static(self, path):
        safe = os.path.normpath(path).lstrip("/")
        parts = safe.split("/")
        full = os.path.join(BASE, *parts)
        allowed = os.path.join(BASE, "static") + os.sep
        if parts[0] != "static" or not full.startswith(allowed) \
                or not os.path.isfile(full):
            self.send(404, render.page(
                BASE_PATH, "Not found", "<p>Unknown path.</p>"))
            return
        ext = os.path.splitext(full)[1]
        with open(full, "rb") as f:
            self.send_raw(200, f.read(),
                           MIME.get(ext, "application/octet-stream"))

    def redirect(self, location):
        self.send_response(301)
        self.send_header("Location", location)
        self.end_headers()

    def send(self, code, data):
        if isinstance(data, str):
            data = data.encode()
        self.send_raw(code, data, "text/html; charset=utf-8")

    def send_raw(self, code, data, ctype):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, *a):
        pass


if __name__ == "__main__":
    if not os.path.exists(store.DB):
        print("bjj.db missing — run: python3 seed.py path/to/new.db first")
    ThreadingHTTPServer(("127.0.0.1", 8000), H).serve_forever()
