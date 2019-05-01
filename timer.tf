/loaded marvtf/timer.tf

; Usage:
;    /timer_start TEST
;    /timer_stop TEST
;
; This will display:
;    ## TEST: 2 min, 15 sec ##

/def -i timer_start = /eval /set timer_%{1}_start=$[time()]

/def -i timer_display = \
    /let name=%{1}%;\
    /let start=%;\
    /test start := {timer_%{name}_start}%;\
    /let end=$[time()]%;\
    /let min=$[trunc(({end}-{start})/60)]%;\
    /let sec=$[mod({end}-{start},60)]%;\
    /echo -aBCRed ## %{name}: %{min} min, %{sec} sec ##

/def -i timer_stop = \
    /timer_display %{1}%;\
    /unset timer_%{1}_start

