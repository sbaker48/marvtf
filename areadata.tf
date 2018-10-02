/loaded marvtf/areadata.tf
/require marvtf/array.tf

/def -i add_areadata = \
    /let name=%1%;\
    /let scont=%2%;\
    /let xcoord=%3%;\
    /let ycoord=%4%;\
    /let alias=%5%;\
    /let arref=%;\
    /test arref := make_array( "area", name )%;\
    /test set_array_val( arref, "cont", scont )%;\
    /test set_array_val( arref, "x", xcoord )%;\
    /test set_array_val( arref, "y", ycoord )%;\
    /test add_area_alias( name, alias )


/def -i add_area_alias = \
    /let name=%1%;\
    /let alias=%2%;\
    /if ( alias !~ "" ) \
        /test set_array_val( "aliases", alias, name )%;\
    /endif


/def -i load_area_data = \
    /let f=%;\
    /let line=%;\
    /test purge_array( "area" )%;\
    /test purge_array( "aliases" )%;\
    /test f := tfopen("marvtf/areas.csv","r")%;\
    /while (tfread(f, line) >= 0) \
        /if (regmatch("^([A-Za-z_]*),([A-Za-z_]*),([0-9]*),([0-9]*),([A-Za-z_]*)", line)) \
	    /add_areadata %{P1} %{P2} %{P3} %{P4} %{P5}%;\
	/else \
	    /echo no match for %{line}%;\
	/endif%;\
    /done%;\
    /test tfclose(f)

/def -i load_custom_area_data = \
    /add_areadata sc laen 8556 8667%;\
    /add_areadata rsf luce 7869 10673%;\
    /add_areadata crabfroth deso 9650 7186%;\
    /add_area_alias crabfroth crab


/load_area_data
/load_custom_area_data
