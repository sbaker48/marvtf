
/set status_height=2
/status_add -r1 -c :2 "entity [" entitystatus:9 "]" :2
/set entitystatus=         
/def -i -F -mregexp -t'--= .* entity  HP:([0-9]*)\(([0-9]*)\) .* =--' entity_status = /test entitystatus := pad(%P1,4,"/",1,%P2,4)

