/require marvtf/mount.tf

/set mount=x

/def -i -F -mregexp -t'^You get up on (.*) and begin to ride.$' beastmaster_setmount = \
    /let m=$[tolower({P1})]%;\
    /if (m !~ mount) \
        /test mount:=m%;\
	/eval alias MOUNT %{mount}%;\
    /endif

/def -i -F -mregexp -t'^use heel at (.*)$' beastmaster_setheel = /send alias MOUNT_HEEL %{P1}
/def -i -F -t'* gives you a big slobbery lick.' beastmaster_heelarrived = /send ride MOUNT

/def -i -F -t'You think that * should be worried about being underground right about now.' rug0 = /addstatus RUG Red
/def -i -F -t'* responds to the motivation and reluctantly slinks forward.' rug1 = /rmstatus RUG%;/send ride MOUNT


