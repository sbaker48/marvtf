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
    /set cont=$[tolower(substr(continent,0,4))]%;\
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

/def -i -F -p9 -ag -mregexp -t'^@COORDS@ ([A-Za-z]*) (-*[0-9]*),(-*[0-9]*)$' sc_coords = \
    /set continent=%P1%;\
    /set cont=$[tolower(substr({P1},0,4))]%;\
    /set coord_x=%P2%;\
    /set coord_y=%P3%;\
    /if ( continent =~ "Laenor" | continent =~ "Nexus" ) \
        /set gcoord_x=$[coord_x+8192]%;\
        /set gcoord_y=$[coord_y+8192]%;\
    /elseif ( continent =~ "Lucentium" ) \
        /set gcoord_x=$[coord_x+7557]%;\
        /set gcoord_y=$[coord_y+10536]%;\
    /elseif ( continent =~ "Desolathya" ) \
        /set gcoord_x=$[coord_x+6981]%;\
        /set gcoord_y=$[coord_y+9011]%;\
    /elseif ( continent =~ "Rothikgen" ) \
        /set gcoord_x=$[coord_x+9502]%;\
        /set gcoord_y=$[coord_y+6936]%;\
    /elseif ( continent =~ "Furnachia" ) \
        /set gcoord_x=$[coord_x+9402]%;\
        /set gcoord_y=$[coord_y+9346]%;\
    /elseif ( continent =~ "Renardy" ) \
        /set gcoord_x=$[coord_x+10261]%;\
        /set gcoord_y=$[coord_y+7281]%;\
    /elseif ( continent =~ "Ocean" ) \
        /set continent=Deep Sea%;\
        /set cont=deepsea%;\
        /set gcoord_x=$[coord_x+8192]%;\
        /set gcoord_y=$[coord_y+8192]%;\
    /else \
        /echo UNKNOWN CONTINENT FIX WHEREAMI%;\
    /endif%;\
    /trigger COORDS


