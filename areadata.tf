/loaded marvtf/areadata.tf

/def -i load_area_data = \
    /let f=%;\
    /let line=%;\
    /let name=%;\
    /let cont=%;\
    /let xcoord=%;\
    /let ycoord=%;\
    /let alias=%;\
    /test f := tfopen("marvtf/areas.csv","r")%;\
    /while (tfread(f, line) >= 0) \
        /if (regmatch("^([A-Za-z_]*),([A-Za-z_]*),([0-9]*),([0-9]*),([A-Za-z_]*)", line)) \
	    /test name := {P1}%;\
	    /test cont := {P2}%;\
	    /test xcoord := {P3}%;\
	    /test ycoord := {P4}%;\
	    /test alias := {P5}%;\
	    /eval /set $[strcat("areacont_",{name})] %{cont}%;\
	    /eval /set $[strcat("alias_",{alias})] %{name}%;\
        /eval /set $[strcat("coord_",{name})] %{xcoord} %{ycoord}%;\
	/else \
	    /echo no match for %{line}%;\
	/endif%;\
    /done%;\
    /test tfclose(f)

/load_area_data
