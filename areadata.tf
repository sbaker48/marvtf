/loaded marvtf/areadata.tf
/require marvtf/array.tf

/def -i add_areadata = \
    /let name=%1%;\
    /let scont=%2%;\
    /let xcoord=%3%;\
    /let ycoord=%4%;\
    /let gxcoord=%5%;\
    /let gycoord=%6%;\
    /let alias=%7%;\
    /let arref=%;\
    /test arref := make_array( "area", name )%;\
    /test set_array_val( arref, "cont", scont )%;\
    /test set_array_val( arref, "x", xcoord )%;\
    /test set_array_val( arref, "y", ycoord )%;\
    /test set_array_val( arref, "gx", gxcoord )%;\
    /test set_array_val( arref, "gy", gycoord )%;\
    /if ( alias !~ "" ) \
        /let i0=0%;\
	/let i1=0%;\
	/test i1 := strchr( alias, "|" )%;\
	/while ( i1 != -1 ) \
            /test add_area_alias( name, substr( alias, i0, i1-i0 ) )%;\
	    /test i0 := i1 + 1%;\
	    /test i1 := strchr( alias, "|", i0 )%;\
	/done%;\
        /test add_area_alias( name, substr( alias, i0 ) )%;\
    /endif

/def -i add_areadata_cont = \
    /let name=%1%;\
    /let scont=%2%;\
    /let xcoord=%3%;\
    /let ycoord=%4%;\
    /let alias=%5%;\
    /if (scont =~ "laen")\
        /let gxcoord=$[xcoord+8192]%;\
        /let gycoord=$[ycoord+8192]%;\
    /elseif (scont =~ "deso")\
        /let gxcoord=$[xcoord+6981]%;\
        /let gycoord=$[ycoord+9011]%;\
    /elseif (scont =~ "roth")\
        /let gxcoord=$[xcoord+9502]%;\
        /let gycoord=$[ycoord+6936]%;\
    /elseif (scont =~ "luce")\
        /let gxcoord=$[xcoord+7557]%;\
        /let gycoord=$[ycoord+10536]%;\
    /elseif (scont =~ "furn")\
        /let gxcoord=$[xcoord+9402]%;\
        /let gycoord=$[ycoord+9346]%;\
    /elseif (scont =~ "renardy")\
        /let gxcoord=$[xcoord+10261]%;\
        /let gycoord=$[ycoord+7281]%;\
    /else \
        /let gxcoord=0%;\
        /let gycoord=0%;\
    /endif%;\
    /add_areadata %{name} %{scont} %{xcoord} %{ycoord} %{gxcoord} %{gycoord} %{alias}

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
        /if (regmatch("^([A-Za-z_]*),([A-Za-z_]*),([0-9]*),([0-9]*),([A-Za-z_|]*)", line)) \
	    /add_areadata_cont %{P1} %{P2} %{P3} %{P4} %{P5}%;\
	/else \
	    /echo no match for %{line}%;\
	/endif%;\
    /done%;\
    /test tfclose(f)

/def -i load_custom_area_data = \
    /add_areadata_cont sc laen 364 475%;\
    /add_areadata_cont rsf luce 312 137%;\
    /add_areadata_cont crabfroth roth 148 250%;\
    /add_area_alias crabfroth crab

/load_area_data
/load_custom_area_data
