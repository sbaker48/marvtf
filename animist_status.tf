
/set status_height=2
/status_add -r1 -c :2 "soul [" soulstatus:20 "]  mount [" mountstatus:20 "]" :2
/set soulstatus=
/set mountstatus=

/set healrep=0
/set soul_health=100
/set mount_health=100

/def -i -F -mregexp -t'^Your soul companion:.*\(([0-9]*)%\)' soul_health = \
    /set soul_health=%{P1}%;\
    /let x=$[soul_health / 5]%;\
    /set soulstatus=$[strcat(strrep(".",20-x),strrep("X",x))]

/def -i -F -mregexp -t'^Your soul mount:.*\(([0-9]*)%\)' mount_health = \
    /set mount_health=%{P1}%;\
    /let x=$[mount_health / 5]%;\
    /set mountstatus=$[strcat(strrep(".",20-x),strrep("X",x))]


/def -i -F -t'Your soul companion is struck by a beam of divine light from above. *' soul_separate = \
    /set soul_health=100%;\
    /set soulstatus=

/def -i -F -t'You clap your hands together, and with great exertion pull them apart.*' mount_dismiss = \
    /set mount_health=100%;\
    /set mountstatus=

