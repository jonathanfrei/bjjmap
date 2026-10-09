"""SQLite access layer for BJJ Map. No HTTP, no HTML here."""
import os
import sqlite3

BASE = os.path.dirname(__file__)
DB = os.path.join(BASE, "bjj.db")

ROLE_ORDER = {"concept": 0, "howto": 1, "troubleshoot": 2}


def connect():
    # BJJ_DB overrides the live DB so packets can be staged and verified
    # against a copy (see stage_packet.sh) without touching live content.
    c = sqlite3.connect(os.environ.get("BJJ_DB", DB))
    c.row_factory = sqlite3.Row
    return c


def phases(c):
    return c.execute("SELECT * FROM phases ORDER BY pos").fetchall()


def phase_title(c, key):
    """Display title for a phase key — used for node-page breadcrumbs."""
    r = c.execute("SELECT title FROM phases WHERE key=?", (key,)).fetchone()
    return r["title"] if r else None


def all_nodes(c):
    return c.execute("SELECT * FROM nodes").fetchall()


def get_node(c, nid):
    return c.execute("SELECT * FROM nodes WHERE id=?", (nid,)).fetchone()


def aliases_for(c, nid):
    return c.execute(
        "SELECT alias FROM node_aliases WHERE node_id=? ORDER BY alias",
        (nid,),
    ).fetchall()


def videos_for(c, nid, include_rejected=False):
    q = ("SELECT * FROM videos WHERE node_id=? "
         "AND rule_set IN ('nogi','both')")
    if not include_rejected:
        q += " AND rejected=0"
    rows = c.execute(q, (nid,)).fetchall()
    return sorted(rows, key=lambda v: ROLE_ORDER.get(v["role"], 3))


def edges_in(c, nid):
    return c.execute(
        "SELECT e.*, n.name FROM edges e JOIN nodes n ON n.id=e.from_node "
        "WHERE e.to_node=? ORDER BY n.name",
        (nid,),
    ).fetchall()


def edges_out(c, nid):
    # Unconditional edges first, then grouped by reaction trigger.
    # trigger_norm='' sorts via the (trigger_norm='') DESC key.
    return c.execute(
        "SELECT e.*, n.name FROM edges e JOIN nodes n ON n.id=e.to_node "
        "WHERE e.from_node=? ORDER BY (e.trigger_norm='') DESC, "
        "e.trigger_norm, n.name",
        (nid,),
    ).fetchall()


def techniques_for(c, nid):
    """Techniques that score as this condition (reverse of scores_as)."""
    return c.execute(
        "SELECT * FROM nodes WHERE scores_as=? ORDER BY name",
        (nid,),
    ).fetchall()


def search(c, term):
    """Ranked fallback for the no-JS /search route on the live server.

    Tiers mirror the static client search in search.html (name prefix,
    then alias prefix, then id prefix, then alphabetical). Keep the two in
    sync; the static page additionally does typo-tolerant matching.
    """
    like = f"%{term}%"
    prefix = f"{term}%"
    return c.execute(
        "SELECT DISTINCT n.* FROM nodes n "
        "LEFT JOIN node_aliases a ON a.node_id=n.id "
        "WHERE n.name LIKE ? OR n.id LIKE ? OR n.description LIKE ? "
        "OR a.alias LIKE ? OR EXISTS (SELECT 1 FROM edges e "
        "WHERE e.from_node=n.id AND (e.trigger LIKE ? "
        "OR e.trigger_norm LIKE ?)) "
        "ORDER BY (n.name LIKE ?) DESC, (a.alias LIKE ?) DESC, "
        "(n.id LIKE ?) DESC, n.name",
        (like, like, like, like, like, like, prefix, prefix, prefix),
    ).fetchall()


def triggers_for(c, nid):
    """Distinct opponent-reaction triggers on this node's outgoing edges."""
    return [r["trigger"] for r in c.execute(
        "SELECT DISTINCT trigger FROM edges WHERE from_node=? "
        "AND trigger_norm<>'' ORDER BY trigger", (nid,))]


def graph_data(c):
    return {
        "nodes": [dict(r) for r in all_nodes(c)],
        "edges": [dict(r) for r in c.execute("SELECT * FROM edges")],
        "aliases": [dict(r) for r in c.execute("SELECT * FROM node_aliases")],
        "phases": [dict(r) for r in phases(c)],
    }


def coverage(c):
    """Map-health report: missing edges, bare conditions, stale videos."""
    report = {"no_incoming": [], "no_outgoing": [],
              "bare_conditions": [], "no_videos": [], "stale_videos": [],
              "subs_without_answers": []}
    nodes = all_nodes(c)
    for n in nodes:
        nid = n["id"]
        has_in = c.execute("SELECT 1 FROM edges WHERE to_node=?",
                           (nid,)).fetchone()
        has_out = c.execute("SELECT 1 FROM edges WHERE from_node=?",
                            (nid,)).fetchone()
        if not has_in and not n["is_terminal"]:
            # entries: standing is a true root; techniques enter via edges
            if nid != "standing":
                report["no_incoming"].append(nid)
        if not has_out and not n["is_terminal"]:
            report["no_outgoing"].append(nid)
        nv = c.execute("SELECT count(*) c FROM videos "
                       "WHERE node_id=? AND rejected=0", (nid,)).fetchone()["c"]
        if nv == 0:
            report["no_videos"].append(nid)
    for cond in c.execute("SELECT * FROM nodes WHERE kind='condition'"):
        ntech = c.execute("SELECT count(*) c FROM nodes WHERE scores_as=?",
                          (cond["id"],)).fetchone()["c"]
        if ntech == 0:
            report["bare_conditions"].append(cond["id"])
    for v in c.execute("SELECT node_id, youtube_id, title FROM videos "
                       "WHERE stale=1 AND rejected=0"):
        report["stale_videos"].append(dict(v))
    for s in c.execute("SELECT id FROM nodes WHERE kind='submission'"):
        has_answer = c.execute(
            "SELECT 1 FROM edges WHERE from_node=? "
            "AND trigger_norm IS NOT NULL AND trigger_norm<>''",
            (s["id"],)).fetchone()
        if not has_answer:
            report["subs_without_answers"].append(s["id"])
    report["trigger_stats"] = {
        "nodes_with_triggers": c.execute(
            "SELECT COUNT(DISTINCT from_node) FROM edges "
            "WHERE trigger_norm<>''").fetchone()[0],
        "triggered_edges": c.execute(
            "SELECT COUNT(*) FROM edges "
            "WHERE trigger_norm<>''").fetchone()[0],
        "taxonomy_slugs": c.execute(
            "SELECT COUNT(*) FROM trigger_taxonomy").fetchone()[0],
        "subs_total": c.execute(
            "SELECT COUNT(*) FROM nodes "
            "WHERE kind='submission'").fetchone()[0],
    }
    return report
