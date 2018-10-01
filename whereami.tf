/loaded marvtf/whereami.tf

/set room=unknown
/set area=unknown
/set continent=unknown
/set cont=unknown
/set coord_x=0
/set coord_y=0
/set gcoord_x=0
/set gcoord_y=0

/def -i -F -p9 -mregexp -t'^You are in \'(.*)\' in (.*) on the continent of (.*)\\. \\(Coordinates: ([0-9]*)x, ([0-9]*)y; Global: ([0-9]*)x, ([0-9]*)y' whereami = \
    /set room=%P1%;\
    /set area=%P2%;\
    /set continent=%P3%;\
    /set cont=$[tolower(substr({P3},0,4))]%;\
    /set coord_x=%P4%;\
    /set coord_y=%P5%;\
    /set gcoord_x=%P6%;\
    /set gcoord_y=%P7%;\
    /trigger WHEREAMI

/def -i -F -p9 -mregexp -t'^You are in \'(.*)\', which is on the continent of (.*)\\. \\(Coordinates: ([0-9]*)x, ([0-9]*)y; Global: ([0-9]*)x, ([0-9]*)y' whereami2 = \
    /set room=%P1%;\
    /set area=%P2%;\
    /set continent=%P2%;\
    /set cont=$[tolower(substr({P2},0,4))]%;\
    /set coord_x=%P3%;\
    /set coord_y=%P4%;\
    /set gcoord_x=%P5%;\
    /set gcoord_y=%P6%;\
    /trigger WHEREAMI

/def -i -F -p9 -mregexp -t'^You are in \'(.*)\' in (.*)\\. \\(Global: ([0-9]*)x, ([0-9]*)y' whereami3 = \
    /set room=%P1%;\
    /set area=%P2%;\
    /set continent=Deep Sea%;\
    /set cont=deepsea%;\
    /set coord_x=0%;\
    /set coord_y=0%;\
    /set gcoord_x=%P3%;\
    /set gcoord_y=%P4%;\
    /trigger WHEREAMI

