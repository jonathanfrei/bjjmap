import sqlite3, os
DB = os.path.join(os.path.dirname(__file__), "bjj.db")

NODES = [
 ("side_control_top", "Side Control (Top)", "top", "position", "Dominant pin. Stabilize, isolate arms, advance to mount or submit.", 0),
 ("side_control_bottom", "Side Control (Bottom)", "bottom", "position", "Pinned. Survive, create frames, escape to guard or turtle.", 0),
 ("mount_top", "Mount (Top)", "top", "position", "Top scoring position. Stabilize, threaten submissions.", 0),
 ("mount_bottom", "Mount (Bottom)", "bottom", "position", "Worst spot. Bridge, elbow escape, survive.", 0),
 ("escape_bridge", "Bridge Escape (Upa)", "na", "escape", "Fundamental mount-bottom escape chaining to guard.", 0),
 ("armbar_mount", "Armbar from Mount", "na", "submission", "Classic finish from mount. Terminal node.", 1),
]
VIDEOS = [
 ("side_control_top", "JgMXOa0_99M", "Side Control Basics (No-Gi)", "Establishes pin + transition options.", "nogi"),
 ("mount_top", "6yo5AyHx4vM", "Mount Control Basics (No-Gi)", "Stabilization before submissions.", "nogi"),
 ("mount_bottom", "3GHH8N8y8e8", "Mount Escapes Basics (No-Gi)", "Survival concepts from bottom.", "nogi"),
 ("armbar_mount", "44zYu1s9gwM", "Armbar from Mount (No-Gi)", "Core finish for the POC chain.", "nogi"),
]
EDGES = [
 ("side_control_top", "mount_top", "transition to", "Slide/knee-drive up to mount."),
 ("side_control_bottom", "escape_bridge", "escape via", "Frames then bridge to create space."),
 ("mount_bottom", "escape_bridge", "escape via", "Upa bridge escape."),
 ("escape_bridge", "side_control_bottom", "returns to", "Failed escape can land back pinned; keep framing."),
 ("mount_top", "armbar_mount", "submit with", "Isolate arm, finish armbar."),
]

con = sqlite3.connect(DB)
con.executescript(open(os.path.join(os.path.dirname(__file__), "schema.sql")).read())
for n in NODES:
    con.execute("INSERT OR REPLACE INTO nodes (id,name,side,kind,description,is_terminal) VALUES (?,?,?,?,?,?)", n)
for v in VIDEOS:
    con.execute("INSERT OR IGNORE INTO videos (node_id,youtube_id,title,why_this_one,rule_set) VALUES (?,?,?,?,?)", v)
for e in EDGES:
    con.execute("INSERT OR IGNORE INTO edges (from_node,to_node,label,description) VALUES (?,?,?,?)", e)
con.commit()
print(f"seeded {DB}")
