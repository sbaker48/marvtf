/loaded marvtf/ship.tf
/require marvtf/array.tf
/require marvtf/whereami.tf
/require marvtf/areadata.tf
/require marvtf/shippaths.tf
/require marvtf/timer.tf

; requires alias SHIPNAME

; Ship events
/def -i -F -t'There is a ripple in space, and after a moment, the ship * appears.' ship_summon = /trigger SHIP_SUMMON
/def -i -F -t'The crew rescue you!' ship_rescue = /trigger SHIP_RESCUE
/def -i -F -t'[A-Z]* tells you \'Bringin\' tha ship to a halt.\'' ship_halt = /trigger SHIP_SAIL_DONE%;/timer_stop SAIL
/def -i -F -t'[A-Z]* tells you \'Comin\' to a stop, *' ship_stop = /trigger SHIP_SAIL_STOP
/def -i -F -t'[A-Z]* tells you \'I am sorry, *, but I don\'t know where * is\\!\'' ship_fail = /trigger SHIP_SAIL_FAIL
/def -i -F -t'[A-Z]* tells you \'We\'ve arr\'ved at signal, *' ship_arrive = /trigger SHIP_ARRIVE_SIGNAL
/def -i -F -t'[A-Z]* tells you \'All repairs finish\'d, *' ship_repair_done = /trigger SHIP_REPAIR_DONE
/def -i -F -t'[A-Z]* tells you \'Your hull is already fully repaired\\!\'' ship_repair_none = /trigger SHIP_REPAIR_DONE

; Ship event handling
/def -i -F -t'SHIP_SUMMON' on_ship_summon = @whereami%;/repeat -1 1 @console info condition
/def -i -F -t'SHIP_RESCUE' on_ship_rescue = @whereami%;/repeat -1 1 @console info condition
/def -i -F -t'SHIP_SAIL_DONE' on_ship_sail_done = @whereami%;@view%;/repeat -1 1 @console info condition
/def -i -F -t'SHIP_SAIL_STOP' on_ship_sail_stop = @whereami%;@view
/def -i -F -t'SHIP_SAIL_FAIL' on_ship_sail_fail = @whereami%;@view
/def -i -F -t'SHIP_ARRIVE_SIGNAL' on_ship_arrive_signal = /repeat -1 1 @rescue SHIPNAME
/def -i -F -t'SHIP_REPAIR_DONE' on_repair_done = /repeat -3 1 @sailor gangway raise


/def -i -F -t'[A-z]* tells you \'That\'s quite a list of destinations - I\'ll keep track of as many as possible*' ship_cruise_long = /set ship_cruise_repeat=1
/def -i -F -E"{ship_cruise_repeat}==1" -mregexp -t'^[A-Z][a-z]* tells you \'Continuin\' on ta (.*)\\.\'' ship_cruise_long2 = /set ship_cruise_repeat=0%;/repeat -5 1 /sail3 %{sail_dest}

/def -i sail = \
    /set sail_dest=%*%;\
    /def -n1 -t'HELM' helm_done = /sail2 %*%;\
    /move_to_helm

/def -i sail2 = \
    /def -n1 -t'LAUNCH' launch_done = /sail3 %*%;\
    /timer_start SAIL%;\
    /launch

/def -i sail3 = \
    /let path=%;\
    /test path := ship_build_path( {1} )%;\
    /echo -aBCYellow %{path}%;\
    /eval %{path}

/def -i move_to_helm = \
    /def -n1 -t'WHEREAMI' = /move_to_helm2%;\
    @whereami

/def -i move_to_helm2 = \
    /if ( substr( area, strlen( area ) - 6, 6 ) !~ "(ship)" ) \
        /echo #####  NOT ON SHIP!  #####%;\
    /elseif ( ( room =~ "main deck" ) | ( substr( room, 0, 11 ) =~ "(main deck)" ) ) \
        3 gagoutput aft%;\
    /elseif ( room =~ "cargo hold" | ( substr( room, 0, 12 ) =~ "(cargo hold)" ) ) \
        5 gagoutput aft;u%;\
    /elseif ( room =~ "captain's cabin" ) \
        deck%;\
    /elseif ( room =~ "lounge" ) \
        deck;2 aft%;\
    /elseif ( room =~ "teleportation room" ) \
        d;2 aft%;\
    /elseif ( room =~ "galley" ) \
        deck;aft%;\
    /elseif ( room =~ "crow's nest" ) \
        d;aft%;\
    /else \
        /echo #####  unknown location on ship  %{room}%;\
    /endif%;\
    /trigger HELM


/def -i launch = \
    /let launch_dirs=%;\
    /let curloc=%;\
    /test curloc := ( {1} !~ "" ) ? {1} : ship_cur_loc()%;\
    /test launch_dirs := ship_launch_dirs( curloc )%;\
    /if ( launch_dirs !~ "" ) \
        /eval /echo -aBCYellow sail %{launch_dirs}%;\
        ship launch%;\
        /def -n1 -t'*Done sailin*' sail_trig = /eval view;whereami%%;/trigger LAUNCH%;\
        /eval sail %{launch_dirs}%;\
    /else \
        ship launch%;\
        /trigger LAUNCH%;\
    /endif


/def -i ship_build_path = \
    /let dest=%;\
    /let dirs=%;\
    /test dest := ship_dest_aliases( {1} )%;\
    /test dirs := find_path0( dest )%;\
    /if ( dirs !~ "" ) \
        /test dirs := strcat( "cruise ", dirs )%;\
	/test dirs := ship_hack_dest( dest, dirs )%;\
        /test dirs := strcat( dirs, ship_dock_dirs( dest ) )%;\
        /test dirs := strcat( dirs, ",*secure" )%;\
    /endif%;\
    /result dirs


/def -i ship_dest_aliases = \
    /let name=%1%;\
    /let alias=%;\
    /test alias := get_array_val( "aliases", name )%;\
    /if ( alias !~ "" ) \
        /test name := alias%;\
    /endif%;\
    /result name


; Ok. This is a horrible hack, but I can't think of a cleaner way to do this at the moment.
/def -i ship_hack_dest = \
    /let dest=%1%;\
    /let dirs=%2%;\
    /test newdest := {dest_%{dest}}%;\
    /if ( newdest !~ "" ) \
        /test dirs := replace( dest, newdest, dirs )%;\
	/test dirs := replace( "%newdest,%newdest", "%newdest", dirs )%;\
    /endif%;\
    /result dirs


/def -i ship_launch_dirs = \
    /let curloc=%1%;\
    /result {launch_%{curloc}}


/def -i ship_dock_dirs = \
    /let dest=%1%;\
    /let dirs=%;\
    /test dirs := {dock_%{dest}}%;\
    /if ( dirs !~ "" ) \
        /test dirs := strcat( ",", dirs )%;\
    /endif%;\
    /result dirs


; Determines the current location. Only areas with launch or dock dirs or sellall locations need to be added.
; TODO: This could come from areadata
/def -i ship_cur_loc = \
    /let curloc=%;\
    /if ( gcoord_x == 7869 & gcoord_y == 10674 ) /let curloc=rsf%;\
    /elseif ( gcoord_x == 7954 & gcoord_y == 10550 ) /let curloc=luce_ferry%;\
    /elseif ( gcoord_x == 8493 & gcoord_y ==  8553 ) /let curloc=laen_ferry%;\
    /elseif ( gcoord_x == 7412 & gcoord_y ==  9456 ) /let curloc=deso_ferry%;\
    /elseif ( gcoord_x == 9766 & gcoord_y ==  7366 ) /let curloc=roth_ferry%;\
    /elseif ( gcoord_x == 9592 & gcoord_y ==  9427 ) /let curloc=furn_ferry%;\
    /elseif ( gcoord_x == 7970 & gcoord_y == 10687 ) /let curloc=lorenchia_harbor%;\
    /elseif ( gcoord_x == 9726 & gcoord_y ==  7205 ) /let curloc=shadowkeep_harbor%;\
    /elseif ( gcoord_x == 8557 & gcoord_y ==  8666 ) /let curloc=arelium_harbor%;\
    /elseif ( gcoord_x == 8097 & gcoord_y == 10775 ) /let curloc=silverlake%;\
    /elseif ( gcoord_x == 7998 & gcoord_y == 10814 ) /let curloc=oystria%;\
    /elseif ( gcoord_x == 9651 & gcoord_y ==  7186 ) /let curloc=crabfroth%;\
    /else /let curloc=xxx%;\
    /endif%;\
    /return {curloc}


; Directions to get out of harbors
/set launch_luce_ferry=n
/set launch_laen_ferry=nw
/set launch_deso_ferry=e
/set launch_roth_ferry=w
/set launch_furn_ferry=w
/set launch_lorenchia_harbor=sea
/set launch_shadowkeep_harbor=river
/set launch_arelium_harbor=2 n
/set launch_silverlake=2 n
; pcity harbors
/set launch_rsf=2 n
/set launch_crabfroth=2 w

; Directions to get into harbors
/set dock_luce_ferry=2 *s
/set dock_laen_ferry=2 *se
/set dock_deso_ferry=2 *w
/set dock_roth_ferry=*e
/set dock_furn_ferry=2 *e
/set dock_lorenchia_harbor=*e
/set dock_shadowkeep_harbor=*n
/set dock_arelium_harbor=2 *s
/set dock_silverlake=2 *s
/set dock_oystria=*whirlpool
; pcity harbors
/set dock_rsf=2 *s
/set dock_crabfroth=2 *e


; Set this if the scroll name is different than the area name
/set dest_luce_ferry=wpt_lucentium1
/set dest_laen_ferry=wpt_daerwon
/set dest_deso_ferry=wpt_windhamkeep
;/set dest_roth_ferry=wpt_rothikgen1
/set dest_furn_ferry=wpt_furnachia2
;/set dest_lorenchia=lorenchia_harbor
;/set dest_shadowkeep=shadowkeep_harbor


/def -i sellall = \
    /let curloc=%;\
    /test curloc := ship_cur_loc()%;\
    /eval SHIP_SELLALL_START%;\
    /eval gagoutput set look_on_move off%;\
    /if ( curloc =~ "lorenchia_harbor" ) \
        /eval gangway e;gangway;3 e;2 E;e;3 ne;2 e;n;manifest SHIPNAME%;\
        /eval y%;\
        /eval s;9 e;n;manifest SHIPNAME%;\
        /eval y%;\
        /eval s;w;sw;s;sw;w;n;manifest SHIPNAME%;\
        /eval y%;\
        /eval s;14 w;n;deposit change;s;W;3 w;SHIPNAME%;\
    /elseif ( curloc =~ "shadowkeep_harbor" ) \
        /eval gangway n;gangway;n;3 e;3 n;2 w;s;manifest SHIPNAME%;\
        /eval y%;\
        /eval n;2 w;n;w;manifest SHIPNAME%;\
        /eval y%;\
        /eval e;3 n;2 w;s;manifest SHIPNAME%;\
        /eval y%;\
        /eval n;2 e;4 s;w;s;deposit change;n;w;3 s;3 e;s;SHIPNAME%;\
    /elseif ( curloc =~ "arelium_harbor" )\
        /eval gangway e;gangway;S;se;S;4 s;13 w;n;manifest SHIPNAME%;\
	/eval y%;\
	/eval 3 s;manifest SHIPNAME%;\
	/eval y%;\
	/eval n;3 w;3 s;e;manifest SHIPNAME%;\
	/eval y%;\
	/eval w;4 s;2 sw;w;n;manifest SHIPNAME%;\
	/eval y%;\
	/eval s;14 e;ne;n;manifest SHIPNAME%;\
	/eval y%;\
	/eval s;3 w;nw;6 n;2 nw;11 w;n;deposit change;s;E;e;N;N;n;nw;7 n;SHIPNAME%;\
    /elseif ( curloc =~ "deso_ferry" ) \
        /eval gangway w;gangway;4 w;n;manifest SHIPNAME%;\
        /eval y%;\
        /eval s;2 w;n;manifest SHIPNAME%;\
        /eval y%;\
        /eval s;w;s;w;manifest SHIPNAME%;\
        /eval y%;\
        /eval e;n;7 e;SHIPNAME%;\
    /elseif ( curloc =~ "furn_ferry" ) \
        /eval gangway e;gangway;3 s;2 se;14 e;E;E;6 s;e;manifest SHIPNAME%;\
        /eval y%;\
        /eval w;3 sw;s;e;manifest SHIPNAME%;\
        /eval y%;\
        /eval w;2 nw;4 w;s;manifest SHIPNAME%;\
        /eval y%;\
        /eval n;N;W;6 w;3 nw;3 n;w;deposit change;e;6 s;W;6 w;2 nw;3 n;SHIPNAME%;\
    /elseif ( curloc =~ "rsf" ) \
        /eval gangway s;gangway;2 w;3 s;manifest SHIPNAME%;\
        /eval y%;\
        /eval 3 n;e;manifest SHIPNAME%;\
        /eval y%;\
        /eval 2 e;manifest SHIPNAME%;\
        /eval y%;\
        /eval e;s;manifest SHIPNAME%;\
        /eval y%;\
        /eval n;deposit change;2 w;SHIPNAME%;\
    /else \
        /echo -aBCYellow Unknown location for sellall%;\
    /endif%;\
    /eval gagoutput set look_on_move on


/DEF -mregexp -F -i -t"^This tiny disc is little more than a" ship_disc1_sub = /ECHO -p @{BCwhite}Disc 1@{n}
/DEF -mregexp -F -i -t"^This disc is really a tiny ring" ship_disc2_sub = /ECHO -p @{BCwhite}Disc 2@{n}
/DEF -mregexp -F -i -t"^This disc is really a very small ring" ship_disc3_sub = /ECHO -p @{BCwhite}Disc 3@{n}
/DEF -mregexp -F -i -t"^This disc is really a small ring" ship_disc4_sub = /ECHO -p @{BCwhite}Disc 4@{n}
/DEF -mregexp -F -i -t"^This disc is really a fair-sized ring" ship_disc5_sub = /ECHO -p @{BCwhite}Disc 5@{n}
/DEF -mregexp -F -i -t"^This disc is really a fairly large ring" ship_disc6_sub = /ECHO -p @{BCwhite}Disc 6@{n}
/DEF -mregexp -F -i -t"^This disc is really a large ring" ship_disc7_sub = /ECHO -p @{BCwhite}Disc 7@{n}
/DEF -mregexp -F -i -t"^This disc is really a very large ring" ship_disc8_sub = /ECHO -p @{BCwhite}Disc 8@{n}
/DEF -mregexp -F -i -t"^This disc is really a huge ring" ship_disc9_sub = /ECHO -p @{BCwhite}Disc 9@{n}
/DEF -mregexp -F -i -t"^This disc is really a massive ring" ship_disc10_sub = /ECHO -p @{BCwhite}Disc 10@{n}

/def -i -t'You gained * Merchant Navy reputation.' ship_rep = @sailor reputation

