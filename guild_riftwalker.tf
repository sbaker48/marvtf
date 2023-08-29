
; Configurable parameters for the status line. Set these in your .tfrc (or wherever) to customize the colors of the status line.
/set rw_status_stats_color=white
/set rw_status_stats_attr=
/set rw_status_command_color=cyan
/set rw_status_command_attr=B
/set rw_status_effects_color=yellow
/set rw_status_effects_attr=B

/set status_height=2
/eval /status_add -r1 -c :2 "entity [" entitystatus:9 "]" rw_first:1 :2 entityskill::%{rw_status_command_attr}C%{rw_status_command_color} :1 rw_last:1
/set entitystatus=         
/set entityskill=

/def -i rw_addstatus = \
    /let stcolor=%{rw_status_effects_color}%;\
    /let side=-Brw_last%;\
    /if ( {1} =~ "-B" ) \
        /shift%;\
    /endif%;\
    /if ( {1} =~ "-F" ) \
        /test side := "-Arw_first"%;\
        /shift%;\
    /endif%;\
    /if ( {2} !~ "" ) \
        /let stcolor=%{2}%;\
    /endif%;\
    /let x=$[ replace( ":", "_", {1} ) ]%;\
    /if /test {rw_flag_%{x}} == 1%; /then \
        /eval /status_rm rw_status_%{x}%;\
        /eval /status_add %{side} rw_status_%{x}:$[ strlen({1}) ]:%{rw_status_effects_attr}C%{stcolor}%;\
    /else \
        /eval /set rw_status_%{x}=%{1}%;\
        /eval /status_add %{side} rw_status_%{x}:$[ strlen({1}) ]:%{rw_status_effects_attr}C%{stcolor}%;\
        /eval /set rw_flag_%{x}=1%;\
        /trigger %{x}_UP%;\
    /endif

/def -i rw_rmstatus = \
    /let x=$[ replace( ":", "_", {1} ) ]%;\
    /if /test {rw_flag_%{x}} == 1%; /then \
        /eval /status_rm rw_status_%{x}%;\
        /eval /set rw_flag_%{x}=0%;\
        /trigger %{x}_DOWN%;\
    /endif

/def -i rw_hasstatus = \
    /let x=$[ replace( ":", "_", {1} ) ]%;\
    /return ( ( {rw_flag_%{x}} == 1 ) ? 1 : 0 )



/def -i -F -mregexp -t'^--= .*  HP:([0-9]*)\(([0-9]*)\) \[.*\] \[([a-z]*)\] \[.*\].*=--' entity_status = \
    /test entitystatus := pad(%P1,4,"/",1,%P2,4)%;\
    /if ( {P3} =~ "controlled" ) \
        /rw_addstatus -F EC%;\
    /else \
        /rw_rmstatus EC%;\
    /endif


/def -i -F -t'{Fire|Air|Earth|Water} entity starts concentrating on a new offensive skill.' entity_skill_check1 = /send @@cast info
/def -i -F -t'{Fire|Air|Earth|Water} entity starts concentrating on a new skill.' entity_skill_check1a = /send @@cast info
/def -i -F -t'Your entity is prepared to do the skill.' entity_skill_check2 = /set entityskill=%;/send @@cast info
/def -i -F -t'Your entity breaks its skill attempt.' entity_skill_check3 = /set entityskill=
/def -i -F -p9 -ag -t'Your entity is not doing anything at the moment.' entity_skill0 = /set entityskill=
/def -i -F -p9 -ag -mregexp -t'^Your entity is using \'(.*)\'' entity_skill1 = /set entityskill=%P1
/def -i -F -p9 -ag -mregexp -t'Your entity is maintaining \'(.*)\'' entity_skill_maintain = /set entityskill=[%P1]

/def -i -F -t'Your earth entity hunches down looking much less solid than a second ago.' entity_maintain_earth_done = /set entityskill=



