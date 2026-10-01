"""SQLite access layer for BJJ Map. No HTTP, no HTML here."""
import os
import sqlite3

BASE = os.path.dirname(__file__)
DB = os.path.join(BASE, "bjj.db")

ROLE_ORDER = {"concept": 0, "howto": 1, "troubleshoot": 2}


def connect():
    c = sqlite3.connect(DB)
    c.row_factory = sqlite3.Row
    return c


def phases(c):
    return c.execute("SELECT * FROM phases ORDER BY pos").fetchall()


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
    return c.execute(
        "SELECT e.*, n.name FROM edges e JOIN nodes n ON n.id=e.to_node "
        "WHERE e.from_node=? ORDER BY n.name",
        (nid,),
    ).fetchall()


def search(c, term):
    like = f"%{term}%"
    return c.execute(
        "SELECT DISTINCT n.* FROM nodes n "
        "LEFT JOIN node_aliases a ON a.node_id=n.id "
        "WHERE n.name LIKE ? OR n.id LIKE ? OR n.description LIKE ? "
        "OR a.alias LIKE ? ORDER BY n.name",
        (like, like, like, like),
    ).fetchall()


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
              "bare_conditions": [], "no_videos": [], "stale_videos": []}
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
    return report
