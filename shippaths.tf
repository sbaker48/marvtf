/loaded marvtf/shippaths.tf
/require marvtf/shippaths_data.tf
/require marvtf/whereami.tf
/require marvtf/areadata.tf
/require marvtf/array.tf

/set MAXCOST=999999

/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'We\'ve arr\'ved at ([^ ]*), .*\\.\'' on_ship_cruise1 = /set ship_cur_loc=%{P1}
/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'Continuin\' on ta (.*)\\.\'' on_ship_cruise2 = /set ship_next_loc=%{P1}
;/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'Bringin\' tha ship to a halt.\'' on_ship_halt = /set ship_next_loc=
;/def -i -F -mregexp -t'^[A-Z][a-z]* tells you \'Comin\' to a stop, *' on_ship_stop = /set ship_next_loc=
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
;    /test pf_add_temporary_nodes( nodes, destarea )%;\
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
    /test set_array_val( newnode, "gx", gcoord_x )%;\
    /test set_array_val( newnode, "gy", gcoord_y )%;\
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
    /test set_array_val( newnode, "gx", get_array_val( destarea, "gx" ) )%;\
    /test set_array_val( newnode, "gy", get_array_val( destarea, "gy" ) )%;\
    /test pf_add_dest_links( nodes, newnode, get_array_count( nodes ) )%;\
    /result newnode


; Add link to each waypoint.
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
        /if ( node !~ curnode ) \
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


; For each node, add a link to the dest node
/def -i pf_add_dest_links = \
    /let nodes=%1%;\
    /let destnode=%2%;\
    /let destindex=%3%;\
    /let node=%;\
    /let cost=%;\
    /let link=%;\
    /let count=%;\
    /let i=1%;\
    /test count := get_array_count( nodes )%;\
    /while ( i <= count ) \
        /test node := get_array( nodes, i )%;\
        /if ( node !~ destnode ) \
            /test cost := pf_calculate_cost( node, destnode )%;\
            /test link := add_array( node, "links" )%;\
            /test set_array_val( link, "dest", destindex )%;\
            /test set_array_val( link, "cost", cost )%;\
        /endif%;\
        /test ++i%;\
    /done


/def -i pf_add_temporary_nodes = \
    /let nodes=%1%;\
    /let destarea=%2%;\
    /let ax=$[ get_array_val( destarea, "gx" ) ]%;\
    /let ay=$[ get_array_val( destarea, "gy" ) ]%;\
    /pf_add_temporary_nodes1 %nodes %gcoord_x %gcoord_y%;\
    /pf_add_temporary_nodes1 %nodes %ax %ay


/def -i pf_add_temporary_nodes1 = \
    /echo %0 %*%;\
    /let nodes=%1%;\
    /let ax=%2%;\
    /let ay=%3%;\
    /let node=%;\
    /let nodecount=$[ get_array_count( nodes ) ]%;\
    /let i=1%;\
    /while ( i <= nodecount ) \
        /test node := get_array( nodes, i )%;\
        /let linkcount=$[ get_array_count( node, "links" ) ]%;\
        /let j=1%;\
        /while ( j <= linkcount ) \
            /let link=$[ get_array_val( node, "links", j, "dest" ) ]%;\
;           Only add node once...
            /if ( i < link ) \
            /pf_add_temporary_nodes2 %nodes %i %link %ax %ay%;\
            /endif%;\
            /test ++j%;\
        /done%;\
        /test ++i%;\
    /done


/def -i pf_add_temporary_nodes2 = \
    /echo %0 %*%;\
    /let nodes=%1%;\
    /let n1=%2%;\
    /let n2=%3%;\
    /let ax=%4%;\
    /let ay=%5%;\
    /let x1=$[get_array_val( nodes, n1, "gx" )]%;\
    /let y1=$[get_array_val( nodes, n1, "gy" )]%;\
    /let x2=$[get_array_val( nodes, n2, "gx" )]%;\
    /let y2=$[get_array_val( nodes, n2, "gy" )]%;\
    /let dx=$[x2-x1]%;\
    /let dy=$[y2-y1]%;\
    /let x=0%;\
    /let y=0%;\
    /let newnode=%;\
    /let link=%;\
    /let cost=%;\
    /echo a(%ax,%ay) w1(%x1,%y1) w2(%x2,%y2) [%dx,%dy]%;\
    /if ( dx == 0 & dy == 0 ) \
    /elseif ( dx == 0 ) \
        /test x := x1%;\
        /test y := ay%;\
	/test dx := abs( x - ax )%;\
        /if ( between( y - dx, y1, y2 ) ) \
            /test pf_add_temporary_nodes3( nodes, n1, n2, x, y - dx )%;\
        /endif%;\
        /if ( between( y + dx, y1, y2 ) ) \
            /test pf_add_temporary_nodes3( nodes, n1, n2, x, y + dx )%;\
        /endif%;\
    /elseif ( dy == 0 ) \
        /test y := y1%;\
        /test x := ax%;\
	/test dy := abs( y - ay )%;\
        /if ( between( x - dy, x1, x2 ) ) \
            /test pf_add_temporary_nodes3( nodes, n1, n2, x - dy, y )%;\
        /endif%;\
        /if ( between( x + dy, x1, x2 ) ) \
            /test pf_add_temporary_nodes3( nodes, n1, n2, x + dy, y )%;\
        /endif%;\
    /else \
        /let m=$[dy / dx]%;\
        /let c=$[(-1 * m * x1) + y1]%;\
        /let ma=$[-1 / m]%;\
        /let ca=$[(-1 * ma * ax) + ay]%;\
;        /echo m=%m c=%c ma=%ma ca=%ca%;\
        /let x=$[(c - ca) / ( ma - m )]%;\
        /let y=$[(m * x) + c]%;\
        /if ( between( x, x1, x2 ) & between( y, y1, y2 ) ) \
            /test pf_add_temporary_nodes3( nodes, n1, n2, x, y )%;\
        /endif%;\
    /endif


/def -i pf_add_temporary_nodes3 = \
    /let nodes=%1%;\
    /let n1=%2%;\
    /let n2=%3%;\
    /let x=%4%;\
    /let y=%5%;\
    /test newnode := add_array( nodes )%;\
    /let n=$[ get_array_count( nodes ) ]%;\
    /echo ADDING %x,%y (%n)%;\
    /test set_array_val( newnode, "name", "TEMP-%{x}-%{y}" )%;\
    /test set_array_val( newnode, "cont", "temp" )%;\
    /test set_array_val( newnode, "gx", x )%;\
    /test set_array_val( newnode, "gy", y )%;\
    /test pf_insert_link( nodes, n, n1, 1 )%;\
    /test pf_insert_link( nodes, n, n2, 1 )%;\


/def -i between = \
    /let x=%1%;\
    /let x1=%2%;\
    /let x2=%3%;\
    /if ( x1 <= x2 ) \
        /result ( x1 < x & x < x2 )%;\
    /else \
        /result ( x2 < x & x < x1 )%;\
    /endif


/def -i pf_insert_link = \
    /let nodes=%1%;\
    /let n1=%2%;\
    /let n2=%3%;\
    /let is_tradeline=%4%;\
    /let node1=$[get_array( nodes, n1 )]%;\
    /let node2=$[get_array( nodes, n2 )]%;\
    /let cost=$[pf_calculate_cost( node1, node2 )]%;\
    /if ( is_tradeline ) \
        /test cost := ceil( cost / TRADELINE_BONUS )%;\
    /endif%;\
    /let link=%;\
    /test link := add_array( node1, "links" )%;\
    /test set_array_val( link, "dest", n2 )%;\
    /test set_array_val( link, "cost", cost )%;\
    /test link := add_array( node2, "links" )%;\
    /test set_array_val( link, "dest", n1 )%;\
    /test set_array_val( link, "cost", cost )




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
    /test x0 := get_array_val( arr1, "gx" )%;\
    /test y0 := get_array_val( arr1, "gy" )%;\
    /test x1 := get_array_val( arr2, "gx" )%;\
    /test y1 := get_array_val( arr2, "gy" )%;\
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
        /if ( n =~ "" ) \
            /echo Cannot reach destination node!%;\
            /return ""%;\
        /elseif ( n =~ destnode ) \
            /test done := 1%;\
            /test path := get_array_val( destnode, "path" )%;\
            /test path := substr( path, 1 )%;\
        /else \
            /test set_array_val( n, "visited", 1 )%;\
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
;           /echo %0 --- Node %node has cost %cost%;\
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
    /let linkdest=%;\
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
        /test linkdest := get_array_val( links, i, "dest" )%;\
        /test node := get_array( nodes, linkdest )%;\
        /test cost := cost0 + get_array_val( links, i, "cost" )%;\
        /if ( cost < get_array_val( node, "cost" ) ) \
            /test path := strcat( get_array_val( curnode, "path" ), ",", get_array_val( node, "name" ) )%;\
            /test set_array_val( node, "cost", cost )%;\
            /test set_array_val( node, "path", path )%;\
	    /test set_array_val( node, "from", linkdest )%;\
;           /echo %0 --- updated node %node to cost %cost (%path)%;\
        /endif%;\
        /test ++i%;\
    /done



