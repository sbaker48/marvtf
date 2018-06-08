/loaded marvtf/ship.tf
/require marvtf/whereami.tf
/require marvtf/areadata.tf

/set shipname=binkley

/def -i -F -t'David tells you \'Bringin\' tha ship to a halt.\'' ship_halt = /repeat -1 1 view;whereami
/def -i -F -t'David tells you \'Comin\' to a stop, *' ship_stop = /repeat -1 1 view;whereami
/def -i -F -t'Victor tells you \'I am sorry, *, but I don\'t know where * is\\!\'' ship_fail = /repeat -1 1 view;whereami
/def -i -F -t'David tells you \'We\'ve arr\'ved at signal, *' ship_arrive = /repeat -1 1 rescue %{shipname}

/def -i -F -t'The crew rescue you!' ship_rescue = whereami%;/repeat -1 1 console info condition
/def -i -F -t'There is a ripple in space, and after a moment, the ship * appears.' ship_summon = whereami%;/repeat -1 1 console info condition

/def -i -t'David tells you \'All repairs finish\'d, *' ship_repair_done = /repeat -3 1 sailor gangway raise
/def -i -t'David tells you \'Your hull is already fully repaired\\!\'' ship_repair_none = /repeat -3 1 sailor gangway raise


/def -i sail = \
    /def -n1 -t'HELM' helm_done = /sail2 %*%;\
    /move_to_helm

/def -i sail2 = \
    /def -n1 -t'LAUNCH' launch_done = /sail3 %*%;\
    /launch

/def -i sail3 = \
    /set ship_run_dirs=%;\
    /build_path %{1}%;\
    /eval /echo -aBCYellow %{ship_run_dirs}%;\
    /eval %{ship_run_dirs}


/def -i move_to_helm = \
    /def -n1 -t'WHEREAMI' = /move_to_helm2%;\
    whereami

/def -i move_to_helm2 = \
    /if ( substr({area},strlen({area})-6,6) !~ "(ship)" ) \
        /echo #####  NOT ON SHIP!  #####%;\
    /elseif ( ({room} =~ "main deck") | (substr({room},0,11) =~ "(main deck)") ) \
        3 gagoutput aft%;\
    /elseif ( {room} =~ "cargo hold" ) \
        5 gagoutput aft;u%;\
    /elseif ( {room} =~ "captain's cabin" ) \
        deck%;\
    /elseif ( {room} =~ "lounge" ) \
        deck;2 aft%;\
    /elseif ( {room} =~ "teleportation room" ) \
        d;2 aft%;\
    /elseif ( {room} =~ "galley" ) \
        deck;aft%;\
    /elseif ( {room} =~ "crow's nest" ) \
        d;aft%;\
    /else \
        /echo #####  unknown location on ship  %{room}%;\
    /endif%;\
    /trigger HELM

/def -i launch = \
    /let ship_launch_dirs=%;\
    /let curloc=%;\
    /test curloc := ( {1} !~ "" ) ? {1} : get_cur_loc()%;\
    /test ship_launch_dirs := launch_dirs(curloc)%;\
    /if (ship_launch_dirs !~ "") \
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

/def -i build_path = \
    /let curloc=%;\
    /let curcont=%;\
    /let dest=%;\
    /let destcont=%;\
    /test curloc := get_cur_loc()%;\
    /test curcont := get_cur_cont()%;\
    /test dest := dest_aliases({1})%;\
    /test destcont := get_dest_cont(dest)%;\
    /test ship_run_dirs := "cruise "%;\
    /test ship_run_dirs := strcat(ship_run_dirs, continent_dirs(curcont, destcont))%;\
    /test ship_run_dirs := strcat(ship_run_dirs, dest_dirs(dest))%;\
    /test ship_run_dirs := strcat(ship_run_dirs, dock_dirs(dest))%;\
    /test ship_run_dirs := strcat(ship_run_dirs, "*secure")%;\
    /return {ship_run_dirs}

/def -i dest_aliases = \
    /let dest=%{1}%;\
    /if /test ({alias_%{dest}} !~ "")%; /then \
        /test dest := {alias_%{dest}}%;\
    /endif%;\
    /return {dest}

/def -i launch_dirs = \
    /let curloc=%{1}%;\
    /return {launch_%{curloc}}

/def -i dock_dirs = \
    /let dest=%{1}%;\
    /let dirs=%;\
    /test dirs := {dock_%{dest}}%;\
    /if (dirs !~ "") \
        /test dirs := strcat(dirs, ",")%;\
    /endif%;\
    /return {dirs}

/def -i continent_dirs = \
    /let curcont=%{1}%;\
    /let destcont=%{2}%;\
    /let dirs=%;\
    /if (destcont =~ "xxx") \
        /echo UNKNOWN CONT%;\
    /elseif (curcont !~ destcont) \
        /echo CONT SWITCH: %{curcont} to %{destcont}%;\
        /test dirs := strcat({%{curcont}_%{destcont}}, ",")%;\
    /endif%;\
    /return {dirs}

/def -i dest_dirs = \
    /let dest=%{1}%;\
    /let dirs=%;\
    /test dirs := {dest_%{dest}}%;\
    /if (dirs =~ "") \
        /test dirs := dest%;\
    /endif%;\
    /test dirs := strcat(dirs, ",")%;\
    /return {dirs}


; Determines the current location. Only areas with launch or dock dirs or sellall locations need to be added.
; TODO: This could come from areadata
/def -i get_cur_loc = \
    /let curloc=%;\
    /if (    gcoord_x == 7869 & gcoord_y == 10674) /let curloc=rsf%;\
    /elseif (gcoord_x == 7954 & gcoord_y == 10550) /let curloc=luce_ferry%;\
    /elseif (gcoord_x == 8493 & gcoord_y ==  8553) /let curloc=laen_ferry%;\
    /elseif (gcoord_x == 7412 & gcoord_y ==  9456) /let curloc=deso_ferry%;\
    /elseif (gcoord_x == 9766 & gcoord_y ==  7366) /let curloc=roth_ferry%;\
    /elseif (gcoord_x == 9592 & gcoord_y ==  9427) /let curloc=furn_ferry%;\
    /elseif (gcoord_x == 7970 & gcoord_y == 10687) /let curloc=lorenchia_harbor%;\
    /elseif (gcoord_x == 9726 & gcoord_y ==  7205) /let curloc=shadowkeep_harbor%;\
    /elseif (gcoord_x == 8097 & gcoord_y == 10775) /let curloc=silverlake%;\
    /elseif (gcoord_x == 9651 & gcoord_y ==  7186) /let curloc=crabfroth%;\
    /else /let curloc=xxx%;\
    /endif%;\
    /return {curloc}

; Gets current continent from whereami data
/def -i get_cur_cont = \
    /return tolower(substr({continent},0,4))

; Get continent of a given area
/def -i get_dest_cont = \
    /let dest=%{1}%;\
    /let cont=%;\
    /let v=%;\
    /test v := strcat("areacont_",dest)%;\
    /test cont := %{v}%;\
    /if (cont =~ "") \
        /let cont=xxx%;\
    /endif%;\
    /return {cont}

; Directions to get out of harbors
/set launch_luce_ferry=n
/set launch_laen_ferry=nw
/set launch_deso_ferry=e
/set launch_roth_ferry=w
/set launch_furn_ferry=w
; TODO launch_arelium_harbor
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
; TODO dock_arelium_harbor
/set dock_lorenchia_harbor=*e
/set dock_shadowkeep_harbor=*n
/set dock_silverlake=2 *s
; pcity harbors
/set dock_rsf=2 *s
/set dock_crabfroth=2 *e


; inter-continential paths
/set luce_deso=wpt_lucentium1,wpt_desolathya-lucentium2,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
/set luce_laen=wpt_lucentium1,wpt_laenor-lucentium,wpt_daerwon
/set luce_roth=wpt_lucentium1,wpt_laenor-lucentium,wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
/set luce_furn=wpt_lucentium1,wpt_laenor-lucentium,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
/set deso_furn=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
/set deso_laen=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_daerwon
/set deso_luce=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_desolathya-lucentium2,wpt_lucentium1
/set deso_roth=wpt_windhamkeep,wpt_desolathya3,wpt_desolathya-lucentium1,wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
/set furn_deso=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
/set furn_laen=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_daerwon
/set furn_luce=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_laenor-lucentium,wpt_lucentium1
/set furn_roth=wpt_furnachia2,wpt_furnachia1,wpt_laenor-furnachia,wpt_laenor7,wpt_laenor8,wpt_laenor9,wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
/set laen_deso=wpt_daerwon,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
/set laen_furn=wpt_daerwon,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
/set laen_luce=wpt_daerwon,wpt_laenor-lucentium,wpt_lucentium1
/set laen_roth=wpt_daerwon,wpt_laenor1,wpt_laenor2,wpt_laenor3,wpt_laenor10,wpt_rothikgen1
/set roth_deso=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon,wpt_desolathya-lucentium1,wpt_desolathya3,wpt_windhamkeep
/set roth_furn=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon,wpt_laenor9,wpt_laenor8,wpt_laenor7,wpt_laenor-furnachia,wpt_furnachia1,wpt_furnachia2
/set roth_laen=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon
/set roth_luce=wpt_rothikgen1,wpt_laenor10,wpt_laenor3,wpt_laenor2,wpt_laenor1,wpt_daerwon,wpt_laenor-lucentium,wpt_lucentium1

; Set this if the scroll name is different than the area name
/set dest_luce_ferry=wpt_lucentium1
/set dest_laen_ferry=wpt_daerwon
/set dest_deso_ferry=wpt_windhamkeep
/set dest_roth_ferry=wpt_rothikgen1
/set dest_furn_ferry=wpt_furnachia2
;/set dest_lorenchia=lorenchia_harbor
;/set dest_shadowkeep=shadowkeep_harbor

; Set area continents for locations not in the area database (like pcities)
/set areacont_sc=laen
/set areacont_rsf=luce
/set areacont_crabfroth=roth

/set alias_crab=crabfroth


/def -i sellall = \
    /let curloc=%;\
    /test curloc := get_cur_loc()%;\
    /eval d;get all scroll;get all coins;u%;\
    /if (curloc =~ "lorenchia_harbor") \
        /eval _START;shipout e;3 e;2 E;e;3 ne;2 e;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;9 e;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;w;sw;s;sw;w;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;14 w;n;deposit change;s;W;3 w;%{shipname};_FINISH%;\
    /elseif (curloc =~ "shadowkeep_harbor") \
        /eval _START;shipout n;n;3 e;3 n;2 w;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;2 w;n;w;manifest %{shipname}%;\
        /eval y%;\
        /eval e;3 n;2 w;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;2 e;4 s;w;s;deposit change;n;w;3 s;3 e;s;%{shipname};_FINISH%;\
    /elseif (curloc =~ "deso_ferry") \
        /eval _START;shipout w;4 w;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;2 w;n;manifest %{shipname}%;\
        /eval y%;\
        /eval s;w;s;w;manifest %{shipname}%;\
        /eval y%;\
        /eval e;n;7 e;%{shipname};_FINISH%;\
    /elseif (curloc =~ "furn_ferry") \
        /eval _START;shipout e;3 s;2 se;14 e;E;E;6 s;e;manifest %{shipname}%;\
        /eval y%;\
        /eval w;3 sw;s;e;manifest %{shipname}%;\
        /eval y%;\
        /eval w;2 nw;4 w;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;N;W;6 w;3 nw;3 n;w;deposit change;e;6 s;W;6 w;2 nw;3 n;%{shipname};_FINISH%;\
    /elseif (curloc =~ "rsf") \
        /eval _START;shipout s;2 w;3 s;manifest %{shipname}%;\
        /eval y%;\
        /eval 3 n;e;manifest %{shipname}%;\
        /eval y%;\
        /eval 2 e;manifest %{shipname}%;\
        /eval y%;\
        /eval e;s;manifest %{shipname}%;\
        /eval y%;\
        /eval n;deposit change;2 w;%{shipname};_FINISH%;\
    /else \
        /echo -aBCYellow Unknown location for sellall%;\
    /endif

