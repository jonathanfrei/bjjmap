"""Shared HTML rendering for BJJ Map. Used by app.py (live server) and
export.py (static site) so both emit identical markup. No I/O here.
"""
import html

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

ROLE_ORDER = {"concept": 0, "howto": 1, "troubleshoot": 2}

# Tokens verify.py requires in static/style.css (single source of truth).
TOKENS = ["--bg", "--surface", "--ink", "--muted", "--line", "--accent",
          "--accent-ink", "--c-condition", "--c-position", "--c-technique",
          "--c-submission", "--c-neutral", "--radius", "--maxw", "--focus"]


def u(base, path):
    """Prefix a root-absolute path with the deploy base path."""
    return base.rstrip("/") + path


def page(base, title, body, extra_head=""):
    return (
        "<!doctype html><html lang=en><head><meta charset=utf-8>"
        "<meta name=viewport content='width=device-width,initial-scale=1'>"
        "<meta name=theme-color content='#fdfdfb' "
        "media='(prefers-color-scheme: light)'>"
        "<meta name=theme-color content='#141412' "
        "media='(prefers-color-scheme: dark)'>"
        f"<meta name=description content='{html.escape(title)} — BJJ Map, "
        "a no-gi connection map of positions and techniques.'>"
        f"<link rel=stylesheet href='{base}/static/style.css'>"
        f"<link rel=icon href='{base}/static/favicon.svg' type='image/svg+xml'>"
        f"<title>{html.escape(title)}</title>{extra_head}</head><body>"
        f"<nav class=top><a href='{u(base, '/')}'>Map</a>"
        f"<a href='{u(base, '/graph/')}'>Graph</a>"
        f"<a href='{u(base, '/health/')}'>Health</a></nav>"
        f"<div class=wrap><h1>{html.escape(title)}</h1>{body}</div></body></html>"
    )


def search_box(base, term=""):
    t = html.escape(term)
    return (
        f"<form method=get action='{u(base, '/search/')}'>"
        f"<input name=q value='{t}' placeholder='Search positions, techniques…'"
        " style='width:70%' maxlength=120> <button>Search</button></form>"
    )


def node_summary(base, r):
    bits = [r["kind"], r["side"]]
    if r["points"]:
        bits.append(f"{r['points']} pts")
    if r["is_terminal"]:
        bits.append("terminal")
    return (
        f"<div class='card kind-{r['kind']}'>"
        f"<span class='badge badge-{r['kind']}'>{r['kind']}</span>"
        f"<a href='{u(base, '/node/')}{r['id']}/'>"
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


def edge_list(base, rows, col):
    if not rows:
        return "<li class=muted>None</li>"
    return "".join(
        f"<li><a href='{u(base, '/node/')}{r[col]}/'>"
        f"{html.escape(r['name'])}</a> — "
        f"<i>{html.escape(r['label'])}</i> "
        f"{html.escape(r['description'] or '')}</li>"
        for r in rows
    )


def index_body(base, phases, by_phase):
    parts = [search_box(base),
             "<p class=muted>A no-gi connection map: positions, scoring "
             "conditions, and the techniques that link them. Pick a phase, "
             "follow the edges.</p>"]
    known = set()
    for p in phases:
        known.add(p["key"])
        group = sorted(
            by_phase.get(p["key"], []),
            key=lambda r: (-(r["points"] or 0), r["kind"], r["name"]),
        )
        if group:
            parts.append(f"<h2>{html.escape(p['title'])}</h2>")
            parts.extend(node_summary(base, r) for r in group)
    rest = sorted(
        (r for ph, rs in by_phase.items() for r in rs if ph not in known),
        key=lambda r: r["name"],
    )
    if rest:
        parts.append("<h2>Other</h2>")
        parts.extend(node_summary(base, r) for r in rest)
    return "".join(parts)


def node_body(base, n, vids, aliases, techs, incoming, outgoing):
    bits = [n["kind"], n["side"]]
    if n["points"]:
        bits.append(f"{n['points']} pts")
    if n["scores_as"]:
        bits.append(
            f"scores as <a href='{u(base, '/node/')}{n['scores_as']}/'>"
            f"{html.escape(n['scores_as'])}</a>")
    body = f"<p class=muted>{' · '.join(bits)}</p>"
    if aliases:
        pills = "".join(
            f"<span class=pill>{html.escape(a['alias'])}</span>"
            for a in aliases)
        body += f"<p>Also called: {pills}</p>"
    body += f"<p>{html.escape(n['description'] or '')}</p>"
    if n["kind"] == "condition" and techs:
        body += "<h2>Ways to score it</h2><ul>" + "".join(
            f"<li><a href='{u(base, '/node/')}{t['id']}/'>"
            f"{html.escape(t['name'])}</a> "
            f"<span class=muted>— {html.escape(t['description'] or '')}"
            f"</span></li>" for t in techs) + "</ul>"
    body += "<h2>Instruction</h2>"
    body += "".join(video_card(dict(v)) for v in vids) or \
        "<p class=muted>No videos yet — stub, curation pending.</p>"
    main = "<main>" + body + "</main>"
    nav = "<aside><h2>Where you can go</h2><ul>"
    nav += edge_list(base, outgoing, "to_node") + "</ul>"
    nav += f"<p><a href='{u(base, '/graph/')}?focus={n['id']}'>" \
        "View in graph</a></p>"
    nav += "<h2>How you got here</h2><ul>"
    nav += edge_list(base, incoming, "from_node") + "</ul></aside>"
    return "<div class=node-layout>" + main + nav + "</div>" + FACADE_JS


def coverage_body(base, rep):
    body = "<p class=muted>Known gaps in the map — fixed as content grows. " \
        "See the curation rubric in the repo.</p>"
    for key, title in [
            ("no_incoming", "Nodes with no entries"),
            ("no_outgoing", "Nodes with no exits (non-terminal)"),
            ("bare_conditions", "Conditions with no techniques"),
            ("no_videos", "Nodes with no videos (stubs)"),
            ("stale_videos", "Videos flagged stale")]:
        items = rep[key]
        body += f"<h2>{title} ({len(items)})</h2>"
        if key == "stale_videos":
            lis = "".join(
                f"<li><a href='{u(base, '/node/')}{v['node_id']}/'>"
                f"{html.escape(v['title'])}</a></li>" for v in items)
        else:
            lis = "".join(
                f"<li><a href='{u(base, '/node/')}{i}/'>{i}</a></li>"
                for i in items)
        body += f"<ul>{lis}</ul>" if items else "<p class=muted>None</p>"
    return body


def search_body(base, q, hits):
    body = search_box(base, q)
    if q:
        body += f"<p class=muted>{len(hits)} result(s)</p>"
        body += "".join(node_summary(base, r) for r in hits)
    return body
