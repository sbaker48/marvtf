/loaded marvtf/bat_status.tf

; The status line will look like this:

; __736/736 342/342 290/290___cast 'water walking' at 'me'__________________BOT_CER__
;
;   ^^ current stats          ^^ current skill/spell        current effects ^^^^^^^
;
; Current stats are set by the prompt/sc output (see below)
; Current skill/spell are set whenever you use skills or cast spells (also see below)
;
; The current status fields are set by your other triggers.
;   /addstatus FOO           - Adds FOO to the status effects field, in the default color (status_effects_color)
;   /addstatus FOO green     - Adds a status effect in a different color. Valid colors are: black, red, green, yellow, blue, magenta, cyan, white
;   /rmstatus FOO            - Removes the FOO status field
;   hasstatus("FOO")         - Can be used by other triggers to check if a status message is currently set

; Configurable parameters for the status line. Set these in your .tfrc (or wherever) to customize the colors of the status line.
/set status_stats_color=white
/set status_stats_attr=
/set status_command_color=cyan
/set status_command_attr=B
/set status_effects_color=yellow
/set status_effects_attr=B



/set warn_status=off
/set status_stats_width=10
/eval /set status_fields=@more:1:Br :1 statusstats:%{status_stats_width}:%{status_stats_attr}C%{status_stats_color} :2 statuscmd::%{status_command_attr}C%{status_command_color} :1 last:1

/def -i status_update_stats = \
    /if ( strlen({*}) != {status_stats_width} )\
        /eval /set status_stats_width=$[ strlen({*}) ]%;\
	/status_edit statusstats:%{status_stats_width}:%{status_stats_attr}C%{status_stats_color}%;\
    /endif%;\
    /set statusstats=%{*}

/def -i addstatus = \
    /let stcolor=%{status_effects_color}%;\
    /if ( {2} !~ "" ) \
        /let stcolor=%{2}%;\
    /endif%;\
    /let x=$[ replace( ":", "_", {1} ) ]%;\
    /if /test {flag_%{x}} == 1%; /then \
        /eval /status_rm status_%{x}%;\
        /eval /status_add -Blast status_%{x}:$[ strlen({1}) ]:%{status_effects_attr}C%{stcolor}%;\
    /else \
        /eval /set status_%{x}=%{1}%;\
        /eval /status_add -Blast status_%{x}:$[ strlen({1}) ]:%{status_effects_attr}C%{stcolor}%;\
        /eval /set flag_%{x}=1%;\
        /trigger %{x}_UP%;\
    /endif

/def -i rmstatus = \
    /let x=$[ replace( ":", "_", {1} ) ]%;\
    /if /test {flag_%{x}} == 1%; /then \
        /eval /status_rm status_%{x}%;\
        /eval /set flag_%{x}=0%;\
        /trigger %{x}_DOWN%;\
    /endif

/def -i hasstatus = \
    /let x=$[ replace( ":", "_", {1} ) ]%;\
    /return ( ( {flag_%{x}} == 1 ) ? 1 : 0 )

;##### fill stats field

; Prompt and short score should start with "@BAT@ .... <lf>"
; Whatever is after the @BAT@ will show in your status line.
; These lines will be gagged, so the actual prompt/sc you want to be displayed should be given after a <lf> tag
; For example:
; prompt @BAT@ <hp>/<maxhp> <sp>/<maxsp> <ep>/<maxep> [$<cash>] (<weight>kg) [<rooms>]<lf>>>
; sc set @BAT@ <hp>/<maxhp> <sp>/<maxsp> <ep>/<maxep> [$<cash>] (<weight>kg) [<rooms>]<lf>hp: {colorhp} {diffhp} (<maxhp>) sp: {colorsp} {diffsp} (<maxsp>) ep: {colorep} {diffep} (<maxep>)

/def -i -ag -q -p8 -mregexp -t"^@BAT@ " status_update_stats0 = /status_update_stats %PR

; This assumes that the prompt/sc messages start with '@BAT@ <hp>/<maxhp> <sp>/<maxsp> <ep>/<maxep>'
; If a different @BAT@ format is used, this trigger should be updated

/def -i -F -q -p9 -mregexp -t"^@BAT@ (-?[0-9]+)/([0-9]+) (-?[0-9]+)/([0-9]+) (-?[0-9]+)/([0-9]+) " status_capture_stats = \
    /set cur_hp=%P1%;\
    /set cur_hpmax=%P2%;\
    /set cur_sp=%P3%;\
    /set cur_spmax=%P4%;\
    /set cur_ep=%P5%;\
    /set cur_epmax=%P6


;##### fill skill/spell field

/def -i -F -p8 -t'You start chanting.' spell_start = @@cast info
/def -i -F -p8 -t'You start concentrating on the skill.' skill_start = @@cast info

/def -i -F -ag -p8 -mregexp -t'^You are casting \'(.+)\'\.$' cmdstatus1 = /set statuscmd=cast '%P1'
/def -i -F -ag -p8 -mregexp -t'^You are using \'(.+)\'\.$' cmdstatus2 = /set statuscmd=use '%P1'
/def -i -F -p8 -t'You are not doing anything at the moment.' cmdstatus3 = /set statuscmd=
/def -i -F -p8 -aCGreen -t'You are prepared to do the skill.' cmdstatus4 = /set statuscmd=
/def -i -F -p8 -aCGreen -t'You are done with the chant.' cmdstatus5 = /set statuscmd=
/def -i -F -p8 -aCYellow -t'You interrupt the spell.' cmdstatus6 = /set statuscmd=
/def -i -F -p8 -aCYellow -t'You break your skill attempt.' cmdstatus7 = /set statuscmd=
/def -i -F -p8 -aBCYellow -t'You do not have enough spell points to cast the spell.' cmdstatus8 = /set statuscmd=
/def -i -F -p8 -aBCYellow -t'Your movement prevents you from casting the spell.' cmdstatus9 = /set statuscmd=
/def -i -F -p8 -aBCYellow -t'Your movement prevents you from doing the skill.' cmdstatus10 = /set statuscmd=
/def -i -F -p8 -aBCYellow -t'You lose your concentration and cannot do the skill.' cmdstatus11 = /set statuscmd=
/def -i -F -p8 -aBCYellow -t'You lose your concentration and cannot cast the spell.' cmdstatus12 = /set statuscmd=

