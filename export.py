"""Static export for GitHub Pages. `python3 export.py [--out site] [--base '']`
verify.py --strict should pass before exporting. Stdlib only.
"""
import argparse
import json
import os
import shutil

import render
import store

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


def write(out, rel, data):
    if isinstance(data, str):
        data = data.encode()
    full = os.path.join(out, rel)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "wb") as f:
        f.write(data)
    return rel


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(BASE_DIR, "site"))
    ap.add_argument("--base", default="")
    ap.add_argument("--site", default="https://jonathanfrei.github.io/bjjmap")
    args = ap.parse_args()
    base = args.base.rstrip("/")
    site = args.site.rstrip("/")
    out = args.out

    c = store.connect()
    nodes = store.all_nodes(c)
    phases = store.phases(c)
    by_phase = {}
    for r in nodes:
        by_phase.setdefault(r["phase"], []).append(r)

    write(out, "index.html", render.page(
        base, "BJJ Map (No-Gi POC)",
        render.index_body(base, phases, by_phase)))

    for n in nodes:
        nid = n["id"]
        vids = store.videos_for(c, nid)
        body = render.node_body(
            base, n, vids, store.aliases_for(c, nid),
            store.techniques_for(c, nid) if n["kind"] == "condition" else [],
            store.edges_in(c, nid), store.edges_out(c, nid))
        write(out, f"node/{nid}/index.html",
              render.page(base, n["name"], body))

    with open(os.path.join(BASE_DIR, "graph.html")) as f:
        write(out, "graph/index.html",
              f.read().replace("__BASE__", base))
    with open(os.path.join(BASE_DIR, "search.html")) as f:
        write(out, "search/index.html",
              f.read().replace("__BASE__", base))
    write(out, "health/index.html", render.page(
        base, "Map health",
        render.coverage_body(base, store.coverage(c)), active="health"))

    write(out, "api/graph.json",
          json.dumps(store.graph_data(c)).encode())
    index = []
    for n in nodes:
        index.append({
            "id": n["id"], "name": n["name"], "kind": n["kind"],
            "side": n["side"], "description": n["description"] or "",
            "aliases": [a["alias"]
                        for a in store.aliases_for(c, n["id"])],
            "triggers": store.triggers_for(c, n["id"]),
        })
    write(out, "api/search-index.json", json.dumps(index).encode())

    for fn in sorted(os.listdir(os.path.join(BASE_DIR, "static"))):
        with open(os.path.join(BASE_DIR, "static", fn), "rb") as f:
            write(out, f"static/{fn}", f.read())
    with open(os.path.join(BASE_DIR, "static", "favicon.svg"), "rb") as f:
        write(out, "favicon.ico", f.read())

    site = base if base.startswith("http") else args.site.rstrip("/")
    urls = [f"{site}/"] + [f"{site}/node/{n['id']}/" for n in nodes] + \
        [f"{site}/graph/", f"{site}/search/", f"{site}/health/"]
    write(out, "sitemap.xml",
          "<?xml version='1.0' encoding='UTF-8'?>\n"
          "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>\n" +
          "".join(f"<url><loc>{u}</loc></url>\n" for u in urls) + "</urlset>\n")
    write(out, "robots.txt", "User-agent: *\nAllow: /\n"
                             f"Sitemap: {site}/sitemap.xml\n")
    write(out, "404.html", render.page(
        base, "Not found",
        f"<p>Unknown path. <a href='{render.u(base, '/')}'>Back to the map</a>.</p>",
        active=""))
    c.close()
    print(f"exported {len(nodes)} nodes to {out} (base={base or '/'})")


if __name__ == "__main__":
    main()
