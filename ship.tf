/loaded marvtf/ship.tf
/require marvtf/array.tf
/require marvtf/whereami.tf
/require marvtf/areadata.tf
/require marvtf/shippaths.tf

/set shipname=binkley

; Ship events
/def -i -F -t'There is a ripple in space, and after a moment, the ship * appears.' ship_summon = /trigger SHIP_SUMMON
/def -i -F -t'The crew rescue you!' ship_rescue = /trigger SHIP_RESCUE
/def -i -F -t'[A-Z]* tells you \'Bringin\' tha ship to a halt.\'' ship_halt = /trigger SHIP_SAIL_DONE
/def -i -F -t'[A-Z]* tells you \'Comin\' to a stop, *' ship_stop = /trigger SHIP_SAIL_STOP
/def -i -F -t'[A-Z]* tells you \'I am sorry, *, but I don\'t know where * is\\!\'' ship_fail = /trigger SHIP_SAIL_FAIL
/def -i -F -t'[A-Z]* tells you \'We\'ve arr\'ved at signal, *' ship_arrive = /trigger SHIP_ARRIVE_SIGNAL
/def -i -F -t'[A-Z]* tells you \'All repairs finish\'d, *' ship_repair_done = /trigger SHIP_REPAIR_DONE
/def -i -F -t'[A-Z]* tells you \'Your hull is already fully repaired\\!\'' ship_repair_none = /trigger SHIP_REPAIR_DONE

; Ship event handling
/def -i -F -t'SHIP_SUMMON' on_ship_summon = whereami%;/repeat -1 1 console info condition
/def -i -F -t'SHIP_RESCUE' on_ship_rescue = whereami%;/repeat -1 1 console info condition
/def -i -F -t'SHIP_SAIL_DONE' on_ship_sail_done = whereami%;view%;/repeat -1 1 console info condition
/def -i -F -t'SHIP_SAIL_STOP' on_ship_sail_stop = whereami%;view
/def -i -F -t'SHIP_SAIL_FAIL' on_ship_sail_fail = whereami%;view
/def -i -F -t'SHIP_ARRIVE_SIGNAL' on_ship_arrive_signal = /repeat -1 1 rescue %{shipname}
/def -i -F -t'SHIP_REPAIR_DONE' on_repair_done = /repeat -3 1 sailor gangway raise

/def -i sail = \
    /def -n1 -t'HELM' helm_done = /sail2 %*%;\
    /move_to_helm

/def -i sail2 = \
    /def -n1 -t'LAUNCH' launch_done = /sail3 %*%;\
    /ship_launch

/def -i sail3 = \
    /let path=%;\
    /test path := ship_build_path( {1} )%;\
    /echo -aBCYellow %{path}%;\
    /eval %{path}

/def -i move_to_helm = \
    /def -n1 -t'WHEREAMI' = /move_to_helm2%;\
    whereami

/def -i move_to_helm2 = \
    /if ( substr( area, strlen( area ) - 6, 6 ) !~ "(ship)" ) \
        /echo #####  NOT ON SHIP!  #####%;\
    /elseif ( ( room =~ "main deck" ) | ( substr( {room}, 0, 11 ) =~ "(main deck)" ) ) \
        3 gagoutput aft%;\
    /elseif ( room =~ "cargo hold" ) \
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

/def -i ship_launch = \
    /let ship_launch_dirs=%;\
    /let curloc=%;\
    /test curloc := ( {1} !~ "" ) ? {1} : get_cur_loc()%;\
    /test ship_launch_dirs := launch_dirs( curloc )%;\
    /if ( ship_launch_dirs !~ "" ) \
        /eval /echo -aBCYellow sail %{ship_launch_dirs}%;\
        ship launch%;\
        /def -n1 -t'*Done sailin*' sail_trig = /eval view;whereami%%;/trigger LAUNCH%;\
        /eval sail %{ship_launch_dirs}%;\
    /else \
        ship launch%;\
        /trigger LAUNCH%;\
    /endif%;\

; TODO:
; /def -i cont_switch
; /def -i nav_to_label
; /def -i nav_to_coords

/def -i ship_build_path = \
    /let dest=%;\
    /let dirs=%;\
    /test dest := dest_aliases( {1} )%;\
    /test dirs := find_path0( dest )%;\
    /if ( dirs !~ "" ) \
        /test dirs := strcat( "cruise ", dirs )%;\
        /test dirs := strcat( dirs, dock_dirs( dest ) )%;\
        /test dirs := strcat( dirs, ",*secure" )%;\
    /endif%;\
    /result dirs

;    /let curloc=%;\
;    /let curcont=%;\
;    /let dest=%;\
;    /let destcont=%;\
;    /test curloc := get_cur_loc()%;\
;    /test curcont := get_cur_cont()%;\
;    /test dest := dest_aliases( {1} )%;\
;    /test destcont := get_dest_cont( dest )%;\
;    /test ship_run_dirs := "cruise "%;\
;    /test ship_run_dirs := strcat( ship_run_dirs, continent_dirs( curcont, destcont ) )%;\
;    /test ship_run_dirs := strcat( ship_run_dirs, dest_dirs( dest ) )%;\
;    /test ship_run_dirs := strcat( ship_run_dirs, dock_dirs( dest ) )%;\
;    /test ship_run_dirs := strcat( ship_run_dirs, "*secure" )%;\
;    /result ship_run_dirs

/def -i dest_aliases = \
    /let name=%1%;\
    /let alias=%;\
    /test alias := get_array_val( "aliases", name )%;\
    /if ( alias !~ "" ) \
        /test name := alias%;\
    /endif%;\
    /result name

/def -i launch_dirs = \
    /let curloc=%{1}%;\
    /return {launch_%{curloc}}

/def -i dock_dirs = \
    /let dest=%{1}%;\
    /let dirs=%;\
    /test dirs := {dock_%{dest}}%;\
    /if ( dirs !~ "" ) \
        /test dirs := strcat( ",", dirs )%;\
    /endif%;\
    /result dirs

;/def -i continent_dirs = \
;    /let curcont=%{1}%;\
;    /let destcont=%{2}%;\
;    /let dirs=%;\
;    /if ( destcont =~ "xxx" ) \
;        /echo UNKNOWN CONT%;\
;    /elseif ( curcont !~ destcont ) \
;        /echo CONT SWITCH: %{curcont} to %{destcont}%;\
;        /test dirs := strcat( {%{curcont}_%{destcont}}, "," )%;\
;    /endif%;\
;    /result dirs

;/def -i dest_dirs = \
;    /let dest=%{1}%;\
;    /let dirs=%;\
;    /test dirs := {dest_%{dest}}%;\
;    /if ( dirs =~ "" ) \
;        /test dirs := dest%;\
;    /endif%;\
;    /test dirs := strcat( dirs, "," )%;\
;    /result dirs


; Determines the current location. Only areas with launch or dock dirs or sellall locations need to be added.
; TODO: This could come from areadata
/def -i get_cur_loc = \
    /let curloc=%;\
    /if ( gcoord_x == 7869 & gcoord_y == 10674 ) /let curloc=rsf%;\
    /elseif ( gcoord_x == 7954 & gcoord_y == 10550 ) /let curloc=luce_ferry%;\
    /elseif ( gcoord_x == 8493 & gcoord_y ==  8553 ) /let curloc=laen_ferry%;\
    /elseif ( gcoord_x == 7412 & gcoord_y ==  9456 ) /let curloc=deso_ferry%;\
    /elseif ( gcoord_x == 9766 & gcoord_y ==  7366 ) /let curloc=roth_ferry%;\
    /elseif ( gcoord_x == 9592 & gcoord_y ==  9427 ) /let curloc=furn_ferry%;\
    /elseif ( gcoord_x == 7970 & gcoord_y == 10687 ) /let curloc=lorenchia_harbor%;\
    /elseif ( gcoord_x == 9726 & gcoord_y ==  7205 ) /let curloc=shadowkeep_harbor%;\
    /elseif ( gcoord_x == 8097 & gcoord_y == 10775 ) /let curloc=silverlake%;\
    /elseif ( gcoord_x == 7998 & gcoord_y == 10814 ) /let curloc=oystria%;\
    /elseif ( gcoord_x == 9651 & gcoord_y ==  7186 ) /let curloc=crabfroth%;\
    /else /let curloc=xxx%;\
    /endif%;\
    /return {curloc}

; Gets current continent from whereami data
;/def -i get_cur_cont = \
;    /return tolower( substr( {continent},0,4 ) )

; Get continent of a given area
;/def -i get_dest_cont = \
;    /let adest=%{1}%;\
;    /let acont=%;\
;    /let v=%;\
;    /test v := strcat( "areacont_",adest )%;\
;    /test acont := %{v}%;\
;    /if ( acont =~ "" ) \
;        /let acont=xxx%;\
;    /endif%;\
;    /return {acont}

; Directions to get out of harbors
/set launch_luce_ferry=n
/set launch_laen_ferry=nw
/set launch_deso_ferry=e
/set launch_roth_ferry=w
/set launch_furn_ferry=w
/set launch_lorenchia_harbor=sea
/set launch_shadowkeep_harbor=river
/set launch_silverlake=2 n
; pcity harbors
/set launch_rsf=2 n
/set launch_crabfroth=2 w

; Directions to get into harbors
/set dock_luce_ferry=2 *s
/set dock_laen_ferry=2 *se
/set dock_deso_ferry=2 *w
/set dock_roth_ferry=5 *e
/set dock_furn_ferry=2 *e
/set dock_lorenchia_harbor=*e
/set dock_shadowkeep_harbor=*n
/set dock_silverlake=2 *s
/set dock_oystria=*whirlpool
; pcity harbors
/set dock_rsf=2 *s
/set dock_crabfroth=2 *e

; inter-continential paths
;/set luce_deso=wpt_lucentium1,wpt_desolathya-lucentium2,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
;/set luce_laen=wpt_lucentium1,wpt_laenor-lucentium,wpt_daerwon
;/set luce_roth=wpt_lucentium1,wpt_laenor-lucentium,wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
;/set luce_furn=wpt_lucentium1,wpt_laenor-lucentium,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
;/set deso_furn=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
;/set deso_laen=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_daerwon
;/set deso_luce=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_desolathya-lucentium2,wpt_lucentium1
;/set deso_roth=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
;/set furn_deso=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
;/set furn_laen=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_daerwon
;/set furn_luce=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_laenor-lucentium,wpt_lucentium1
;/set furn_roth=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
;/set laen_deso=wpt_daerwon,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
;/set laen_furn=wpt_daerwon,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
;/set laen_luce=wpt_daerwon,wpt_laenor-lucentium,wpt_lucentium1
;/set laen_roth=wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
;/set roth_deso=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
;/set roth_furn=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
;/set roth_laen=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon
;/set roth_luce=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon,wpt_laenor-lucentium,wpt_lucentium1

; Set this if the scroll name is different than the area name
/set dest_luce_ferry=wpt_lucentium1
/set dest_laen_ferry=wpt_daerwon
/set dest_deso_ferry=wpt_windhamkeep
/set dest_roth_ferry=wpt_rothikgen1
/set dest_furn_ferry=wpt_furnachia2
;/set dest_lorenchia=lorenchia_harbor
;/set dest_shadowkeep=shadowkeep_harbor

; Set area continents for locations not in the area database ( like pcities )
/set areacont_sc=laen
/set areacont_rsf=luce
/set areacont_crabfroth=roth
/set alias_crab=crabfroth


/def -i sellall = \
    /let curloc=%;\
    /test curloc := get_cur_loc()%;\
    /eval d;get all coins;u%;\
    /eval gagoutput set look_on_move off%;\
    /if ( curloc =~ "lorenchia_harbor" ) \
        /eval shipout e;3 e;2 E;e;3 ne;2 e;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;9 e;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;w;sw;s;sw;w;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;14 w;n;deposit change;s;W;3 w;%{shipname}%;\
    /elseif ( curloc =~ "shadowkeep_harbor" ) \
        /eval shipout n;n;3 e;3 n;2 w;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;2 w;n;w;manifest %{shipname}%;\
        /eval y%;\
        /eval e;3 n;2 w;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;2 e;4 s;w;s;deposit change;n;w;3 s;3 e;s;%{shipname}%;\
    /elseif ( curloc =~ "deso_ferry" ) \
        /eval shipout w;4 w;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;2 w;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;w;s;w;manifest %{shipname}%;\
        /eval y%;\
        /eval e;n;7 e;%{shipname}%;\
    /elseif ( curloc =~ "furn_ferry" ) \
        /eval shipout e;3 s;2 se;14 e;E;E;6 s;e;manifest %{shipname}%;\
        /eval y%;\
        /eval w;3 sw;s;e;manifest %{shipname}%;\
        /eval y%;\
        /eval w;2 nw;4 w;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;N;W;6 w;3 nw;3 n;w;deposit change;e;6 s;W;6 w;2 nw;3 n;%{shipname}%;\
    /elseif ( curloc =~ "rsf" ) \
        /eval shipout s;2 w;3 s;manifest %{shipname}%;\
        /eval y%;\
        /eval 3 n;e;manifest %{shipname}%;\
        /eval y%;\
        /eval 2 e;manifest %{shipname}%;\
        /eval y%;\
        /eval e;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;deposit change;2 w;%{shipname}%;\
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
/DEF -mregexp -F -i -t"^This disc is really a very large ring" ship_disc8_sub = /ECHO -p @{BCwhite}Disc 9@{n}
/DEF -mregexp -F -i -t"^This disc is really a huge ring" ship_disc9_sub = /ECHO -p @{BCwhite}Disc 9@{n}
/DEF -mregexp -F -i -t"^This disc is really a massive ring" ship_disc10_sub = /ECHO -p @{BCwhite}Disc 10@{n}

