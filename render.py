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

# Progressive enhancement for if/then groups: highlights the group targeted
# by #trigger-<slug>. Works with JS off (all groups visible, chips are
# plain anchors, so the static export behaves identically).
REACTION_JS = (
    "<script>"
    "(function(){"
    "function mark(){"
    "var id=(location.hash||'').slice(1);"
    "document.querySelectorAll('.reaction-group').forEach(function(g){"
    "g.classList.toggle('reaction-active',!!id&&g.id===id);});"
    "}"
    "window.addEventListener('hashchange',mark);mark();"
    "})();"
    "</script>"
)

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


REPO_URL = "https://github.com/jonathanfrei/bjjmap"


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
        f"{link('/', 'Map', 'map')}{link('/graph/', 'Graph', 'graph')}</nav>"
        "<button class=theme-toggle type=button aria-label='Change color theme' "
        "title='Change color theme'><span aria-hidden=true></span>"
        "<span class=theme-label>Theme</span></button>"
        "</div></header>"
    )


def footer(base):
    """Site-wide footer: attribution, maintenance links. Health/curation
    pages live here rather than in the primary nav — athletes want the map
    and the graph; maintainers can find the rest."""
    return (
        "<footer class=site-footer><div class='wrap footer-shell'>"
        "<p class=footer-note>Node descriptions are original text licensed "
        "<a href='https://creativecommons.org/licenses/by-sa/4.0/' "
        "rel=license>CC BY-SA 4.0</a>. Scoring anchors follow the IBJJF "
        "rulebook. Videos are third-party YouTube links, embedded only when "
        "you press play.</p>"
        "<nav class=footer-nav aria-label='Footer'>"
        f"<a href='{u(base, '/health/')}'>Content status</a>"
        f"<a href='{REPO_URL}/issues/new/choose'>Suggest an edit</a>"
        f"<a href='{REPO_URL}'>Source</a>"
        "</nav></div></footer>"
    )


def page(base, title, body, extra_head="", active="map", search=True):
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
        # Node / health / 404 pages get the search box above the h1; the
        # index and search pages already render one inside their body.
        + (search_box(base) if search else "")
        + f"<h1>{html.escape(title)}</h1>{body}</main>"
        f"{footer(base)}"
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
        f"<article class='node-card kind-{r['kind']}'"
        f" data-kind='{html.escape(r['kind'] or '')}'"
        f" data-side='{html.escape(str(r['side'] or ''))}'"
        f" data-phase='{html.escape(r['phase'] or '')}'>"
        f"<span class='badge badge-{r['kind']}'>{r['kind']}</span>"
        f"<h3><a class=card-link href='{u(base, '/node/')}{r['id']}/'>"
        f"{html.escape(r['name'])}</a></h3>"
        f"<div class=node-meta>{meta}</div>"
        f"<p>{html.escape(r['description'] or '')}</p></article>"
    )


def video_card(v):
    stale = " <b>[stale link?]</b>" if v["stale"] else ""
    yid = v["youtube_id"]
    meta = []
    if v.get("channel"):
        meta.append(html.escape(v["channel"]))
    dur = v.get("duration_s") or 0
    if dur:
        meta.append(f"{dur // 60}:{dur % 60:02d}")
    pub = (v.get("published_at") or "")[:7]
    if pub:
        meta.append(html.escape(pub))
    meta_line = (f"<p class=video-meta>{' · '.join(meta)}</p>"
                 if meta else "")
    return (
        "<article class=video-card><div class=video-heading>"
        f"<h3>{html.escape(v['title'])}</h3>"
        f"<span class=role-chip>{html.escape(v['role'])}</span>{stale}</div>"
        + meta_line +
        f"<div class=facade data-yid='{yid}'>"
        f"<img loading=lazy src='https://i.ytimg.com/vi/{yid}/maxresdefault.jpg' "
        f"onerror=\"this.onerror=null;this.src="
        f"'https://i.ytimg.com/vi/{yid}/hqdefault.jpg'\" "
        f"alt='Video thumbnail'>"
        f"<button class=play aria-label='Play video'></button></div>"
        f"<p class=video-note>{html.escape(v['why_this_one'] or '')}</p>"
        "</article>"
    )


def dedupe_links(rows, key):
    """Drop the unconditional row when the same link also has a triggered
    variant. The If-section version (with its causality description) wins;
    links that exist only unconditionally are kept as-is.
    """
    seen_triggered = set()
    for r in rows:
        if (r["trigger_norm"] or "").strip():
            seen_triggered.add(key(r))
    return [r for r in rows
            if (r["trigger_norm"] or "").strip() or key(r) not in seen_triggered]


def outgoing_section(base, outgoing):
    """Outgoing connections, grouped by opponent reaction.

    Rows with trigger_norm='' render exactly as the legacy flat list, so
    pages without reactions are byte-identical to before. Pages with
    reactions get an "Always available" group (links that exist ONLY
    unconditionally) plus one "If they…" group per trigger
    (store.edges_out already orders them). A link present in both forms
    renders only in its If-section — no duplicates.
    """
    outgoing = dedupe_links(outgoing, lambda r: (r["to_node"], r["label"]))
    groups = []  # [(norm, trigger, rows)] in first-seen order
    plain = []
    for r in outgoing:
        norm = (r["trigger_norm"] or "").strip()
        if not norm:
            plain.append(r)
            continue
        if groups and groups[-1][0] == norm:
            groups[-1][2].append(r)
        else:
            groups.append((norm, (r["trigger"] or "").strip(), [r]))
    if not groups:
        return ("<aside class='connections connections-out' "
                "aria-label='Outgoing position connections'>"
                "<h2>Where you can go</h2><ul>"
                + edge_list(base, outgoing, "to_node") + "</ul></aside>")
    parts = ["<aside class='connections connections-out' "
             "aria-label='Outgoing position connections'>",
             "<h2>Where you can go</h2>",
             "<nav class=reaction-nav aria-label='Filter by opponent reaction'>"]
    for norm, trig, _rows in groups:
        parts.append(
            f"<a class=reaction-chip href='#trigger-{html.escape(norm)}'>"
            f"If they {html.escape(trig)}</a>")
    parts.append("</nav>")
    if plain:
        parts.append("<div class=reaction-always><h3>Always available</h3><ul>"
                     + edge_list(base, plain, "to_node") + "</ul></div>")
    for norm, trig, rows in groups:
        parts.append(
            f"<section class=reaction-group id='trigger-{html.escape(norm)}'>"
            f"<h3>If they {html.escape(trig)}…</h3><ul>"
            + edge_list(base, rows, "to_node") + "</ul></section>")
    parts.append("</aside>")
    return "".join(parts)


def edge_list(base, rows, col, show_trigger=False):
    if not rows:
        return "<li class='connection-empty muted'>No connections yet.</li>"
    items = []
    for r in rows:
        trig = (r["trigger"] or "").strip()
        tag = (f"<span class=connection-trigger>if they "
               f"{html.escape(trig)}</span>"
               if show_trigger and trig else "")
        items.append(
            f"<li class=connection-item><a href='{u(base, '/node/')}{r[col]}/'>"
            f"{html.escape(r['name'])}</a>"
            f"<span class=connection-label>{html.escape(r['label'])}</span>"
            f"{tag}"
            f"<p>{html.escape(r['description'] or '')}</p></li>")
    return "".join(items)


FILTER_SIDES = [("all", "All"), ("top", "Top"), ("bottom", "Bottom"),
                ("neutral", "Neutral")]
FILTER_KINDS = [("all", "All"), ("position", "Positions"),
                ("technique", "Techniques"), ("submission", "Submissions"),
                ("condition", "Scoring conditions")]

# Homepage filters: progressive enhancement. Without JS every card stays
# visible and the buttons are inert; with JS cards carry data-side /
# data-kind attributes and the bar filters + hides emptied phase sections.
FILTER_JS = (
    "<script>"
    "(function(){"
    "var bar=document.querySelector('.filters');if(!bar)return;"
    "var phaseNav=document.querySelector('.phase-nav');"
    "var count=document.getElementById('filter-count');"
    "var total=document.querySelectorAll('.node-card[data-kind]').length;"
    "function state(group){"
    "var b=bar.querySelector('[data-filter='+group+'][aria-pressed=true]');"
    "return b?b.getAttribute('data-value'):'all';}"
    "function apply(){"
    "var side=state('side'),kind=state('kind'),shown=0;"
    "document.querySelectorAll('.node-card[data-kind]').forEach(function(c){"
    "var ok=(side==='all'||c.getAttribute('data-side')===side)&&"
    "(kind==='all'||c.getAttribute('data-kind')===kind);"
    "c.hidden=!ok;if(ok)shown++;});"
    "document.querySelectorAll('.phase-section').forEach(function(s){"
    "s.hidden=!s.querySelector('.node-card[data-kind]:not([hidden])');});"
    "if(phaseNav)phaseNav.hidden=!(side==='all'&&kind==='all');"
    "if(count)count.textContent=(side==='all'&&kind==='all')"
    "?total+' nodes':shown+' of '+total+' nodes';}"
    "bar.addEventListener('click',function(e){"
    "var btn=e.target.closest('.filter-btn');if(!btn)return;"
    "var g=btn.getAttribute('data-filter');"
    "bar.querySelectorAll('.filter-btn[data-filter='+g+']').forEach("
    "function(b){b.setAttribute('aria-pressed',b===btn?'true':'false');});"
    "apply();});"
    "})();"
    "</script>"
)


def filter_bar(total):
    def row(group, options, legend, aria):
        btns = "".join(
            f"<button type=button class=filter-btn data-filter='{group}' "
            f"data-value='{html.escape(v)}' "
            f"aria-pressed={'true' if v == 'all' else 'false'}>"
            f"{html.escape(t)}</button>"
            for v, t in options)
        return (f"<div class=filter-row role=group aria-label='{aria}'>"
                f"<span class=filter-legend>{html.escape(legend)}</span>"
                f"{btns}</div>")

    return ("<section class=filters aria-label='Filter the map'>"
            + row("side", FILTER_SIDES, "Side", "Filter by side")
            + row("kind", FILTER_KINDS, "Kind", "Filter by kind")
            + f"<p class=filter-count id=filter-count>{total} nodes</p>"
            + "</section>")


def index_body(base, phases, by_phase):
    total = sum(len(rs) for rs in by_phase.values())
    parts = [search_box(base),
             "<p class='lede muted'>A no-gi connection map: positions, scoring "
             "conditions, and the techniques that link them. Pick a phase, "
             "follow the edges.</p>",
             filter_bar(total)]
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
    parts.append(FILTER_JS)
    return "".join(parts)


def node_body(base, n, vids, aliases, techs, incoming, outgoing,
              phase_title=None):
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
    if phase_title:
        # Homepage groups are anchored (#phase-<key>); the breadcrumb links back.
        body = (f"<nav class=breadcrumb aria-label='Breadcrumb'>"
                f"<a href='{u(base, '/')}#phase-{html.escape(n['phase'])}'>"
                f"{html.escape(phase_title)}</a>"
                "<span class=breadcrumb-sep aria-hidden=true>/</span>"
                f"<span class=breadcrumb-current>{html.escape(n['name'])}"
                "</span></nav>") + body
    overview = "<section class=node-overview>" + body + "</section>"
    instruction = "<section class=node-instruction><h2>Instruction</h2>"
    instruction += "".join(video_card(dict(v)) for v in vids) or \
        "<div class=empty-state>No videos yet — curation pending.</div>"
    instruction += "</section>"
    outgoing_nav = outgoing_section(base, outgoing)
    has_reactions = any((r["trigger_norm"] or "").strip() for r in outgoing)
    incoming_nav = "<aside class='connections connections-in' aria-label='Incoming position connections'>"
    incoming_nav += "<h2>How you got here</h2><ul>"
    incoming_nav += edge_list(base, dedupe_links(
        incoming, lambda r: (r["from_node"], r["label"])),
        "from_node", show_trigger=True) + "</ul></aside>"
    connections = "<div class=connections-column>" + outgoing_nav + incoming_nav + "</div>"
    return ("<div class=node-layout>" + overview + connections + instruction +
            "</div>" + FACADE_JS + (REACTION_JS if has_reactions else ""))


def coverage_body(base, rep):
    body = "<p class='lede muted'>Known gaps in the map — fixed as content grows. " \
        "See the curation rubric in the repo.</p>"
    st = rep.get("trigger_stats") or {}
    if st:
        still_open = len(rep.get("subs_without_answers", []))
        answered = max(0, st.get("subs_total", 0) - still_open)
        body += "<section class=health-section><h2>Reaction coverage</h2>" \
            f"<p>{st.get('triggered_edges', 0)} if/then answers on " \
            f"{st.get('nodes_with_triggers', 0)} nodes · " \
            f"{st.get('taxonomy_slugs', 0)} taxonomy slugs · " \
            f"{answered} submissions answered, {still_open} still open.</p>" \
            "</section>"
    for key, title in [
            ("no_incoming", "Nodes with no entries"),
            ("no_outgoing", "Nodes with no exits (non-terminal)"),
            ("bare_conditions", "Conditions with no techniques"),
            ("no_videos", "Nodes with no videos (stubs)"),
            ("subs_without_answers", "Submissions with no follow-ups (no if/then answers)"),
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
