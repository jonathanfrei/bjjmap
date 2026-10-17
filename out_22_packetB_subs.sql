INSERT OR IGNORE INTO nodes(id,name,side,kind,description,phase,source,is_terminal) VALUES
('calf_slicer','Calf Slicer','na','submission','Compression slicer from saddle or top entanglements: wedge the shin against the calf and fold the leg — distinct from kneebar, IBJJF no-gi brown/black only. Terminal.','legs','agent:packetB',1),
('bicep_slicer','Bicep Slicer','na','submission','Arm slicer from arm-triangle and crucifix entries: forearm wedged in the elbow crease, bicep compressed — quick tap, brown/black no-gi. Terminal.','subs','agent:packetB',1),
('buggy_choke','Buggy Choke','na','submission','Bottom triangle variant when they pressure to pass: shin across the neck from bottom side, legs locked buggy. Needs flexibility; lose the leg lock and you get smashed. Terminal.','subs','agent:packetB',1),
('crab_ride','Crab Ride','bottom','position','Leg-ride control off headquarters and RDLR: legs laced for back exposure and saddle entries. Cargo-pants leg position; lose the lace and they square up.','guard','agent:packetB',0),
('collar_tie','Collar Tie','neutral','transition','Head-and-arm tie hub neutral: the pummel entry for snapdown, arm drag, and guillotine. Win the inside collar and the front-headlock game opens.','standup','agent:packetB',0);
INSERT OR IGNORE INTO edges(from_node,to_node,label,description,trigger,trigger_norm,source) VALUES
('saddle','calf_slicer','submit with','Calf wedge finishes when the leg is trapped in the saddle — alternative to heel hook.','','','agent:packetB'),
('crucifix_top','bicep_slicer','submit with','Crucifix armlock entry feeds the bicep slicer when the elbow is deep.','','','agent:packetB'),
('side_control_bottom','buggy_choke','submit with','Buggy locks when the top smashes to side and leaves the neck open underneath.','smash to pass','smash-to-pass','agent:packetB'),
('reverse_dlr','crab_ride','transition to','RDLR hook extends into crab ride leg lace.','','','agent:packetB'),
('crab_ride','backside_fifty','transition to','Crab ride turns to backside fifty for back exposure.','','','agent:packetB'),
('crab_ride','saddle','enter','Crab ride leg feed into inside sankaku.','','','agent:packetB'),
('collar_tie','snapdown','chains to','Snapdown is the primary collar-tie attack to front headlock.','','','agent:packetB'),
('collar_tie','arm_drag','chains to','Arm drag off the collar tie collar.','','','agent:packetB'),
('collar_tie','guillotine','submit with','Guillotine after the collar tie breaks posture.','','','agent:packetB'),
('standing','collar_tie','enter','Tie up from neutral to collar tie — the wrestling entry.','','','agent:packetB'),
('calf_slicer','back_control_top','take back','Slicer defense that turns away gives the back.','turn away','turn-away','agent:packetB'),
('bicep_slicer','back_control_top','take back','Defending the slicer by turning away exposes the back.','turn away','turn-away','agent:packetB'),
('buggy_choke','side_control_top','recover to','Buggy fail that retains side control top as they clear.','clear the legs','clear-the-legs','agent:packetB');
INSERT OR IGNORE INTO trigger_taxonomy(slug,family,display) VALUES
('smash-to-pass','weight-pressure','smash to pass'),
('clear-the-legs','posture-movement','clear the legs');
INSERT OR IGNORE INTO videos(node_id,youtube_id,title,why_this_one,role,source) VALUES
('calf_slicer','hlkUvNGBeu3','Calf Slicer Overview','Concept of calf compression.','concept','agent:packetB'),
('calf_slicer','YV4IedU7OW2','Calf Slicer From Saddle','Howto entry from saddle.','howto','agent:packetB'),
('calf_slicer','vwEDdwPwrUx','Calf Slicer Defense','Troubleshooting the fold.','troubleshoot','agent:packetB'),
('bicep_slicer','51UTU5uZ7F-','Bicep Slicer Overview','Concept of bicep compression.','concept','agent:packetB'),
('bicep_slicer','J_T67S6-CPv','Bicep Slicer From Crucifix','Howto from crucifix.','howto','agent:packetB'),
('bicep_slicer','I9NM0NA-UjR','Bicep Slicer Details','Detailing wedge placement.','troubleshoot','agent:packetB'),
('buggy_choke','bynhgIDnrIF','Buggy Choke Concepts','Concept when smashed.','concept','agent:packetB'),
('buggy_choke','Ah2ehUUwFdk','Buggy Choke From Bottom Side','Howto from bottom side under pressure.','howto','agent:packetB'),
('buggy_choke','oidfcVGquxa','Buggy Choke Troubleshooting','Keeping the lock.','troubleshoot','agent:packetB'),
('crab_ride','XfFteaSoKR-','Crab Ride Control','Concept leg lace.','concept','agent:packetB'),
('crab_ride','dN5fHZt8ClO','Crab Ride to Saddle','Howto to saddle.','howto','agent:packetB'),
('crab_ride','nd5qY-PsRHH','Crab Ride to Back','Turning to backside.','troubleshoot','agent:packetB'),
('collar_tie','1crhGequvm6','Collar Tie Hub','Concept tie hub.','concept','agent:packetB'),
('collar_tie','DeFD4jGkDUG','Collar Tie Snapdown Chain','Chain to snapdown.','howto','agent:packetB'),
('collar_tie','2JateX0uolE','Collar Tie Arm Drag','Chain to drag.','troubleshoot','agent:packetB');