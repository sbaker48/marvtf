; ============================================================
; String functions
; ============================================================

; pad0([s, i, v]...)
; Similar to the built-in pad() function.
; There may be any number of (<s>, <i>, <c>) sets.  For each set, <s> is padded
; with <c> to a length equal to the absolute value of <i>.  If <i> is positive,
; <s> is right-justified (left-padded); If <i> is negative, <s> is left-justified
; (right-padded).  The result is the concatenation of all the padded strings.
;
/def -i pad0 = \
    /let str=%;\
    /while ( {#} >= 3 ) \
        /let s=%1%;\
        /let i=%2%;\
        /let c=%3%;\
	/shift 3%;\
	/let c=$[substr(c,0,1)]%;\
	/let l=$[strlen(s)]%;\
	/if ( l < abs(i) ) \
	    /if ( i > 0 ) \
	        /test str := strcat(str, strrep(c, abs(i)-l), s)%;\
	    /else \
	        /test str := strcat(str, s, strrep(c, abs(i)-l))%;\
	    /endif%;\
        /else \
	    /test str := strcat(str, s)%;\
	/endif%;\
    /done%;\
    /result str


; choose(s...) 
; Returns one of the string arguments selected at random.
; Examples:
;    /choose dog cat pig cow
;    choose("hamburger", "hot dog", "french fries", "salad")
/def -i choose = \
    /if ({#} > 0) \
        /let r=$[rand({#})]%;\
        /while (r > 0) \
            /test r -= 1%;\
            /shift%;\
        /done%;\
        /result "%1"%;\
    /endif


; ============================================================
; File functions
; ============================================================

; file_exists(s)
; Returns true if a file exists on the filesystem.
/def -i file_exists = \
    /let f=$[filename({1})]%;\
    /sys [ -e "%f" ]%;\
    /result !%?


; catfile(s)
; Echos a file to the screen, but supports inline attributes, eg. @{Cred}testing@{n}
/def -i catfile = \
    /let f=$[filename({1})]%;\
    /let line=%;\
    /let s=$[tfopen(f, "r")]%;\
    /if (s != -1) \
        /while (tfread(s, line) >= 0) \
            /test echo(line, "", 1)%;\
        /done%;\
        /test tfclose(s)%;\
    /endif


; ============================================================
; Time functions
; ============================================================

; time_to_sec(s)
; Converts time format ("MM:SS" or "HH:MM:SS") to seconds
/def -i time_to_sec = \
    /let str=%{1}%;\
    /if ( regmatch("([0-9]*):([0-9]*):([0-9]*)",str) >= 3 ) \
        /result (({P1}*3600)+({P2}*60)+{P3})%;\
    /elseif ( regmatch("([0-9]*):([0-9]*)",str) >= 2 ) \
        /result (({P1}*60)+{P2})%;\
    /else \
        /result "INVALID FORMAT"%;\
    /endif


; sec_to_time(n)
; Converts seconds to time format ("MM:SS" or "HH:MM:SS")
/def -i sec_to_time = \
   /let sec=%1%;\
   /let hour=$[sec/3600]%;\
   /test sec-=(hour*3600)%;\
   /let min=$[sec/60]%;\
   /test sec-=(min*60)%;\
   /if ( hour != 0 ) \
       /result strcat(pad0(hour,2,"0"), ":", pad0(min,2,"0"), ":", pad0(sec,2,"0"))%;\
   /else \
       /result strcat(pad0(min,2,"0"), ":", pad0(sec,2,"0"))%;\
   /endif


