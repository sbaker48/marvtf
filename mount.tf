
; requires alias MOUNT

/def -i -F -aBCYellow -t'* cannot carry the *. It goes to the floor.' mount_full

/set mounted=0
/def -i -F -t'You get up on * and begin to ride.' mount = /set mounted=1
/def -i -F -t'You get down from *.' dismount1 = /set mounted=0
/def -i -F -t'The crew rescue you!' dismount2 = /set mounted=0%;/repeat -0:00:02 1 ride MOUNT

/def -i -F -aBCbgred,Cwhite -t'You are now off your mount.' dismount3 = /if ( {mounted}==1 ) ride MOUNT%;/endif
/def -i -F -aBCbgred,Cwhite -t'You are knocked off your mount!' dismount4 = /set mounted=0%;lead MOUNT%;party say >>> Dismounted! <<<
/def -i -F -aBCbgred,Cwhite -t'Your mount throws you!' dismount5 = /set mounted=0%;lead MOUNT%;party say >>> Dismounted! <<<
/def -i -F -t'Ride what?*' dismount6 = /if ( mounted == 1 ) /set mounted=0%;party say >>> Lost my mount! <<<%;/endif

/def -i -F -aBCbgyellow,Cblack -t'Your mount must be present to do that!' mount5
/def -i -F -aBCbggreen,Cwhite -t'Your mount is teleported with you.' mount6

/def -i -F -q -h"send {fire}" mount_fire_swap = dismount;lead MOUNT 
/def -i -F -q -h"send {med}" mount_med_swap = dismount;lead MOUNT 
/def -i -F -q -h"send {camp}" mount_camp_swap = dismount;lead MOUNT
/def -i -F -q -h"send {sleep}" mount_sleep_swap = dismount;lead MOUNT

/def -i -F -t'CAMPDONE' campdone_mount = /repeat -0:00:01 1 ride MOUNT
/def -i -F -t'MEDDONE' meddone_mount = /repeat -0:00:01 1 ride MOUNT
/def -i -F -t'HEALDONE' healdone_mount = /repeat -0:00:01 1 ride MOUNT

