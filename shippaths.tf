/loaded marvtf/shippaths.tf
/require marvtf/shippaths_data.tf
/require marvtf/whereami.tf
/require marvtf/areadata.tf
/require marvtf/array.tf

/set MAXCOST=999999

/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'We\'ve arr\'ved at ([^ ]*), .*\\.\'' on_ship_cruise1 = /set ship_cur_loc=%{P1}
/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'Continuin\' on ta (.*)\\.\'' on_ship_cruise2 = /set ship_next_loc=%{P1}
/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'Bringin\' tha ship to a halt.\'' on_ship_halt = /set ship_next_loc=
/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'Comin\' to a stop, *' on_ship_stop = /set ship_next_loc=
/def -i -F -mregexp -t'^The ship cruises [a-z]* along the tradelane\.' ship_tradeline1 = /set ship_on_tradeline=1
/def -i -F -mregexp -t'^The ship cruises [a-z]*\.' ship_tradeline2 = /set ship_on_tradeline=0
/def -i -F -t'The ship sails *.' ship_tradeline3 = /set ship_on_tradeline=0

; /find_path "area"
/def -i find_path = \
    /def -n1 -t'WHEREAMI' = /find_path0 %{*}%;\
    whereami

/def -i find_path0 = \
    /let destname=%1%;\
    /let destarea=%;\
    /let nodes=%;\
    /let curlocnode=%;\
    /let destnode=%;\
    /test destname := pf_find_alias( destname )%;\
    /test destarea := get_array( "area", destname )%;\
    /if ( get_array_val( destarea, "cont" ) =~ "" ) \
        /echo Invalid area%;\
	/return ""%;\
    /endif%;\
    /test purge_array( "path" )%;\
    /test nodes := make_array( "path", "nodes" )%;\
    /test pf_create_waypoint_nodes( nodes )%;\
    /test curlocnode := pf_create_curloc_node( nodes )%;\
    /test destnode := pf_create_dest_node( nodes, destarea, destname )%;\
    /result pf_do_pathfinding( nodes, curlocnode, destnode )


; Note, this must be called before create_curloc_node or create_dest_node
; or else the indexes will be messed up.
/def -i pf_create_waypoint_nodes = \
    /let nodes=%1%;\
    /let wpts=%;\
    /let count=%;\
    /let i=1%;\
    /test wpts := get_array( "wpt" )%;\
    /test count := get_array_count( wpts )%;\
    /while ( i <= count ) \
        /test copy_array( get_array( wpts, i ), add_array( nodes ) )%;\
        /test ++i%;\
    /done


/def -i pf_create_curloc_node = \
    /let nodes=%1%;\
    /let newnode=%;\
    /test newnode := add_array( nodes )%;\
    /test set_array_val( newnode, "name", "HERE" )%;\
    /test set_array_val( newnode, "cont", cont )%;\
    /test set_array_val( newnode, "x", gcoord_x )%;\
    /test set_array_val( newnode, "y", gcoord_y )%;\
    /test pf_add_curloc_links( nodes, newnode, get_array_count( nodes ) )%;\
    /result newnode


/def -i pf_create_dest_node = \
    /let nodes=%1%;\
    /let destarea=%2%;\
    /let destname=%3%;\
    /let newnode=%;\
    /test newnode := add_array( nodes )%;\
    /test set_array_val( newnode, "name", destname )%;\
    /test set_array_val( newnode, "cont", get_array_val( destarea, "cont" ) )%;\
    /test set_array_val( newnode, "x", get_array_val( destarea, "x" ) )%;\
    /test set_array_val( newnode, "y", get_array_val( destarea, "y" ) )%;\
    /test pf_add_dest_links( nodes, newnode, get_array_count( nodes ) )%;\
    /result newnode


; Add link to each waypoint that is on the same continent.
; If you are in deepsea, add links to all waypoints.
; If you are currently on a tradeline (ship_on_tradeline=1) then the cost between
; the two ends of the tradeline (ship_cur_loc, ship_next_loc) is reduced.
/def -i pf_add_curloc_links = \
    /let nodes=%1%;\
    /let curnode=%2%;\
    /let curindex=%3%;\
    /let node=%;\
    /let cost=%;\
    /let link=%;\
    /let count=%;\
    /let i=1%;\
    /test count := get_array_count( nodes )%;\
    /while ( i <= count ) \
        /test node := get_array( nodes, i )%;\
        /if ( node !~ curnode & ( cont =~ "deepsea" | get_array_val( node, "cont" ) =~ cont ) ) \
	    /test cost := pf_calculate_cost( curnode, node )%;\
	    /if ( ship_on_tradeline == 1 ) \
	        /let name=$[get_array_val( node, "name" )]%;\
		/if ( name =~ ship_cur_loc | name =~ ship_next_loc ) \
		    /test cost := ceil( cost / TRADELINE_BONUS )%;\
		/endif%;\
	    /endif%;\
	    /test link := add_array( curnode, "links" )%;\
	    /test set_array_val( link, "dest", i )%;\
	    /test set_array_val( link, "cost", cost )%;\
	/endif%;\
        /test ++i%;\
    /done


; For each node, add a link to the dest node if it is on the same continent
/def -i pf_add_dest_links = \
    /let nodes=%1%;\
    /let destnode=%2%;\
    /let destindex=%3%;\
    /let destcont=%;\
    /let node=%;\
    /let cost=%;\
    /let link=%;\
    /let count=%;\
    /let i=1%;\
    /test destcont := get_array_val( destnode, "cont" )%;\
    /test count := get_array_count( nodes )%;\
    /while ( i <= count ) \
        /test node := get_array( nodes, i )%;\
        /if ( node !~ destnode & get_array_val( node, "cont" ) =~ destcont ) \
	    /test cost := pf_calculate_cost( node, destnode )%;\
	    /test link := add_array( node, "links" )%;\
	    /test set_array_val( link, "dest", destindex )%;\
	    /test set_array_val( link, "cost", cost )%;\
	/endif%;\
        /test ++i%;\
    /done


/def -i pf_calculate_cost = \
    /let arr1=%1%;\
    /let arr2=%2%;\
    /let xdist=%;\
    /let ydist=%;\
    /let x0=%;\
    /let y0=%;\
    /let x1=%;\
    /let y1=%;\
    /let dist=%;\
    /test x0 := get_array_val( arr1, "x" )%;\
    /test y0 := get_array_val( arr1, "y" )%;\
    /test x1 := get_array_val( arr2, "x" )%;\
    /test y1 := get_array_val( arr2, "y" )%;\
    /test xdist := abs( x0 - x1 )%;\
    /test ydist := abs( y0 - y1 )%;\
    /test dist := xdist%;\
    /if ( ydist > xdist ) \
        /test dist := ydist%;\
    /endif%;\
    /result dist


/def -i pf_find_alias = \
    /let name=%1%;\
    /let alias=%;\
    /test alias := get_array_val( "aliases", name )%;\
    /if ( alias !~ "" ) \
        /test name := alias%;\
    /endif%;\
    /result name


/def -i pf_do_pathfinding = \
    /let nodes=%1%;\
    /let curnode=%2%;\
    /let destnode=%3%;\
    /let done=0%;\
    /let path=%;\
    /let n=%;\
    /test pf_init( nodes, curnode )%;\
    /while ( !done ) \
        /test n := pf_find_least_cost_node( nodes )%;\
	/test set_array_val( n, "visited", 1 )%;\
	/if ( n =~ "" ) \
	    /echo Cannot reach destination node!%;\
	    /return ""%;\
	/elseif ( n =~ destnode ) \
	    /test done := 1%;\
	    /test path := get_array_val( destnode, "path" )%;\
	    /test path := substr( path, 1 )%;\
;	    /echo %0 --- DONE!! Least cost path is %path%;\
        /else \
	    /test pf_update_neighbors( nodes, n )%;\
        /endif%;\
    /done%;\
    /result path


/def -i pf_init = \
;    /echo %0 %*%;\
    /let nodes=%1%;\
    /let curnode=%2%;\
    /let node=%;\
    /let count=%;\
    /let i=1%;\
    /test count := get_array_count( nodes )%;\
    /while ( i <= count ) \
        /test node := get_array( nodes, i )%;\
	/test set_array_val( node, "visited", 0 )%;\
	/test set_array_val( node, "path", "" )%;\
	/test set_array_val( node, "cost", MAXCOST )%;\
        /test ++i%;\
    /done%;\
    /test set_array_val( curnode, "cost", 0 )


/def -i pf_find_least_cost_node = \
;    /echo %0 %*%;\
    /let nodes=%1%;\
    /let leastcost=%MAXCOST%;\
    /let leastnode=%;\
    /let node=%;\
    /let cost=%;\
    /let count=%;\
    /let i=1%;\
    /test count := get_array_count( nodes )%;\
    /while ( i <= count ) \
        /test node := get_array( nodes, i )%;\
	/if ( !get_array_val( node, "visited" ) ) \
            /test cost := get_array_val( node, "cost" )%;\
;	    /echo %0 --- Node %node has cost %cost%;\
	    /if ( cost < leastcost ) \
	        /test leastcost := cost%;\
	        /test leastnode := node%;\
	    /endif%;\
	/endif%;\
        /test ++i%;\
    /done%;\
;    /echo %0 --- %leastnode%;\
    /result leastnode
    
/def -i pf_update_neighbors = \
;    /echo %0 %*%;\
    /let nodes=%1%;\
    /let curnode=%2%;\
    /let links=%;\
    /let node=%;\
    /let cost0=%;\
    /let cost=%;\
    /let path=%;\
    /let count=%;\
    /let i=1%;\
    /test links := get_array( curnode, "links" )%;\
    /test cost0 := get_array_val( curnode, "cost" )%;\
    /test count := get_array_count( links )%;\
    /while ( i <= count ) \
        /test node := get_array( nodes, get_array_val( links, i, "dest" ) )%;\
	/test cost := cost0 + get_array_val( links, i, "cost" )%;\
	/if ( cost < get_array_val( node, "cost" ) ) \
	    /test path := strcat( get_array_val( curnode, "path" ), ",", get_array_val( node, "name" ) )%;\
	    /test set_array_val( node, "cost", cost )%;\
	    /test set_array_val( node, "path", path )%;\
;	    /echo %0 --- updated node %node to cost %cost (%path)%;\
	/endif%;\
        /test ++i%;\
    /done%;\







