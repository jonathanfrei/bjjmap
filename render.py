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
    "title='YouTube video player' "
    "allow='accelerometer;autoplay;encrypted-media;picture-in-picture' "
    "allowfullscreen></iframe>\";"
    "});"
    "</script>"
)

ROLE_ORDER = {"concept": 0, "howto": 1, "troubleshoot": 2}

# Tokens verify.py requires in static/style.css (single source of truth).
TOKENS = [
    "--bg", "--surface", "--surface-raised", "--ink", "--muted", "--line",
    "--accent", "--accent-hover", "--accent-ink", "--focus",
    "--c-condition", "--c-condition-soft", "--on-condition",
    "--c-position", "--c-position-soft", "--on-position",
    "--c-technique", "--c-technique-soft", "--on-technique",
    "--c-submission", "--c-submission-soft", "--on-submission",
    "--c-neutral", "--c-neutral-soft", "--on-neutral",
    "--graph-condition", "--graph-condition-ink", "--graph-position",
    "--graph-position-ink", "--graph-technique", "--graph-technique-ink",
    "--graph-submission", "--graph-submission-ink", "--graph-neutral",
    "--graph-neutral-ink", "--space-1", "--space-2",
    "--space-3", "--space-4", "--space-6", "--radius-sm", "--radius-md",
    "--radius-lg", "--shadow-sm", "--shadow-md", "--maxw",
]

THEME_BOOT = (
    "<script>(function(){try{var t=localStorage.getItem('bjjmap-theme');"
    "if(t==='light'||t==='dark')document.documentElement.dataset.theme=t;"
    "}catch(e){}})();</script>"
)


def u(base, path):
    """Prefix a root-absolute path with the deploy base path."""
    return base.rstrip("/") + path


def nav(base, active=""):
    def link(path, label, key):
        current = " aria-current=page" if active == key else ""
        return (f"<a class=nav-link href='{u(base, path)}'{current}>"
                f"{label}</a>")

    return (
        "<header class=site-header><div class='wrap nav-shell'>"
        f"<a class=brand href='{u(base, '/')}' aria-label='BJJ Map home'>"
        "<span class=brand-mark aria-hidden=true><span></span></span>"
        "<span class=brand-name>BJJ Map</span><span class=brand-tag>No-Gi</span>"
        "</a><nav class=primary-nav aria-label=Primary>"
        f"{link('/', 'Map', 'map')}{link('/graph/', 'Graph', 'graph')}"
        f"{link('/health/', 'Health', 'health')}</nav>"
        "<button class=theme-toggle type=button aria-label='Change color theme' "
        "title='Change color theme'><span aria-hidden=true></span>"
        "<span class=theme-label>Theme</span></button>"
        "</div></header>"
    )


def page(base, title, body, extra_head="", active="map"):
    return (
        "<!doctype html><html lang=en><head><meta charset=utf-8>"
        "<meta name=viewport content='width=device-width,initial-scale=1'>"
        "<meta name=theme-color content='#f5f7fa' "
        "media='(prefers-color-scheme: light)'>"
        "<meta name=theme-color content='#0b1118' "
        "media='(prefers-color-scheme: dark)'>"
        f"<meta name=description content='{html.escape(title)} — BJJ Map, "
        "a no-gi connection map of positions and techniques.'>"
        f"{THEME_BOOT}<link rel=stylesheet href='{base}/static/style.css'>"
        f"<link rel=icon href='{base}/static/favicon.svg' type='image/svg+xml'>"
        f"<title>{html.escape(title)}</title>{extra_head}</head><body>"
        f"{nav(base, active)}<main class='wrap page-main'>"
        f"<h1>{html.escape(title)}</h1>{body}</main>"
        f"<script src='{base}/static/theme.js' defer></script></body></html>"
    )


def search_box(base, term=""):
    t = html.escape(term)
    return (
        f"<form class=search-form method=get action='{u(base, '/search/')}'>"
        "<label class=sr-only for=site-search>Search the BJJ Map</label>"
        "<span class=search-icon aria-hidden=true></span>"
        f"<input id=site-search name=q value='{t}' "
        "placeholder='Search positions, techniques…' maxlength=120>"
        "<button type=submit>Search</button></form>"
    )


def node_summary(base, r):
    bits = []
    if r["side"] and r["side"] != "na":
        bits.append(r["side"])
    if r["points"]:
        bits.append(f"{r['points']} pts")
    if r["is_terminal"]:
        bits.append("terminal")
    meta = "".join(f"<span>{html.escape(str(bit))}</span>" for bit in bits)
    return (
        f"<article class='node-card kind-{r['kind']}'>"
        f"<span class='badge badge-{r['kind']}'>{r['kind']}</span>"
        f"<h3><a class=card-link href='{u(base, '/node/')}{r['id']}/'>"
        f"{html.escape(r['name'])}</a></h3>"
        f"<div class=node-meta>{meta}</div>"
        f"<p>{html.escape(r['description'] or '')}</p></article>"
    )


def video_card(v):
    stale = " <b>[stale link?]</b>" if v["stale"] else ""
    yid = v["youtube_id"]
    return (
        "<article class=video-card><div class=video-heading>"
        f"<h3>{html.escape(v['title'])}</h3>"
        f"<span class=role-chip>{html.escape(v['role'])}</span>{stale}</div>"
        f"<div class=facade data-yid='{yid}'>"
        f"<img loading=lazy src='https://i.ytimg.com/vi/{yid}/maxresdefault.jpg' "
        f"onerror=\"this.onerror=null;this.src="
        f"'https://i.ytimg.com/vi/{yid}/hqdefault.jpg'\" "
        f"alt='Video thumbnail'>"
        f"<button class=play aria-label='Play video'></button></div>"
        f"<p class=video-note>{html.escape(v['why_this_one'] or '')}</p>"
        "</article>"
    )


def edge_list(base, rows, col):
    if not rows:
        return "<li class='connection-empty muted'>No connections yet.</li>"
    return "".join(
        f"<li class=connection-item><a href='{u(base, '/node/')}{r[col]}/'>"
        f"{html.escape(r['name'])}</a>"
        f"<span class=connection-label>{html.escape(r['label'])}</span>"
        f"<p>{html.escape(r['description'] or '')}</p></li>"
        for r in rows
    )


def index_body(base, phases, by_phase):
    parts = [search_box(base),
             "<p class='lede muted'>A no-gi connection map: positions, scoring "
             "conditions, and the techniques that link them. Pick a phase, "
             "follow the edges.</p>"]
    available = [p for p in phases if by_phase.get(p["key"])]
    if available:
        parts.append("<nav class=phase-nav aria-label='Jump to phase'>")
        parts.extend(
            f"<a href='#phase-{html.escape(p['key'])}'>{html.escape(p['title'])}</a>"
            for p in available)
        parts.append("</nav>")
    known = set()
    for p in phases:
        known.add(p["key"])
        group = sorted(
            by_phase.get(p["key"], []),
            key=lambda r: (-(r["points"] or 0), r["kind"], r["name"]),
        )
        if group:
            parts.append(
                f"<section class=phase-section aria-labelledby='phase-{p['key']}'>"
                f"<h2 id='phase-{html.escape(p['key'])}'>"
                f"{html.escape(p['title'])}</h2><div class=node-grid>")
            parts.extend(node_summary(base, r) for r in group)
            parts.append("</div></section>")
    rest = sorted(
        (r for ph, rs in by_phase.items() for r in rs if ph not in known),
        key=lambda r: r["name"],
    )
    if rest:
        parts.append("<section class=phase-section><h2>Other</h2>"
                     "<div class=node-grid>")
        parts.extend(node_summary(base, r) for r in rest)
        parts.append("</div></section>")
    return "".join(parts)


def node_body(base, n, vids, aliases, techs, incoming, outgoing):
    bits = [n["kind"], n["side"]]
    if n["points"]:
        bits.append(f"{n['points']} pts")
    if n["scores_as"]:
        bits.append(
            f"scores as <a href='{u(base, '/node/')}{n['scores_as']}/'>"
            f"{html.escape(n['scores_as'])}</a>")
    graph_url = f"{u(base, '/graph/')}?focus={n['id']}"
    body = f"<div class=node-meta>{''.join(f'<span>{b}</span>' for b in bits)}" \
        f"<a class=meta-link href='{graph_url}'>View in graph <span aria-hidden=true>↗</span></a></div>"
    if aliases:
        pills = "".join(
            f"<span class=pill>{html.escape(a['alias'])}</span>"
            for a in aliases)
        body += f"<div class=aliases><b>Also called</b>{pills}</div>"
    body += f"<p class=node-description>{html.escape(n['description'] or '')}</p>"
    if n["kind"] == "condition" and techs:
        body += "<section class=score-paths><h2>Ways to score it</h2><ul>" + "".join(
            f"<li><a href='{u(base, '/node/')}{t['id']}/'>"
            f"{html.escape(t['name'])}</a> "
            f"<span class=muted>— {html.escape(t['description'] or '')}"
            f"</span></li>" for t in techs) + "</ul></section>"
    overview = "<section class=node-overview>" + body + "</section>"
    instruction = "<section class=node-instruction><h2>Instruction</h2>"
    instruction += "".join(video_card(dict(v)) for v in vids) or \
        "<div class=empty-state>No videos yet — curation pending.</div>"
    instruction += "</section>"
    outgoing_nav = "<aside class='connections connections-out' aria-label='Outgoing position connections'>"
    outgoing_nav += "<h2>Where you can go</h2><ul>"
    outgoing_nav += edge_list(base, outgoing, "to_node") + "</ul></aside>"
    incoming_nav = "<aside class='connections connections-in' aria-label='Incoming position connections'>"
    incoming_nav += "<h2>How you got here</h2><ul>"
    incoming_nav += edge_list(base, incoming, "from_node") + "</ul></aside>"
    connections = "<div class=connections-column>" + outgoing_nav + incoming_nav + "</div>"
    return ("<div class=node-layout>" + overview + connections + instruction +
            "</div>" + FACADE_JS)


def coverage_body(base, rep):
    body = "<p class='lede muted'>Known gaps in the map — fixed as content grows. " \
        "See the curation rubric in the repo.</p>"
    for key, title in [
            ("no_incoming", "Nodes with no entries"),
            ("no_outgoing", "Nodes with no exits (non-terminal)"),
            ("bare_conditions", "Conditions with no techniques"),
            ("no_videos", "Nodes with no videos (stubs)"),
            ("stale_videos", "Videos flagged stale")]:
        items = rep[key]
        body += f"<section class=health-section><h2>{title} " \
                f"<span class=count>{len(items)}</span></h2>"
        if key == "stale_videos":
            lis = "".join(
                f"<li><a href='{u(base, '/node/')}{v['node_id']}/'>"
                f"{html.escape(v['title'])}</a></li>" for v in items)
        else:
            lis = "".join(
                f"<li><a href='{u(base, '/node/')}{i}/'>{i}</a></li>"
                for i in items)
        body += (f"<ul>{lis}</ul>" if items else
                 "<p class=empty-state>No gaps here.</p>")
        body += "</section>"
    return body


def search_body(base, q, hits):
    body = search_box(base, q)
    if q:
        body += f"<p class='result-count muted'>{len(hits)} result(s)</p>"
        body += "<div class=node-grid>" + \
            "".join(node_summary(base, r) for r in hits) + "</div>"
    return body
