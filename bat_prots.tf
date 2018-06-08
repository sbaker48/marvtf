/loaded marvtf/bat_prots.tf
/require marvtf/bat_status.tf

; Sets up a list of prots (or other effects), and can check and re-apply missing prots.
;
; Example usage:
;
;  /setupprot UNSTUN 1 cast unstun at me
;  /setupprot BOT    0 cast blessing of tarmalen at me
;  /setupprot FABS   0 get force_absorption from pack;drink flask
;
;  /prots
;     - This will display the list of prots and show which are currently active
;
;  /reprot
;     - This will apply all missing protections that are currently enabled
;
;  /protoff #
;     - Disable the application of a prot
;
;  /proton #
;     - Enable the application of a prot
;

; /setupprot name initial_state command
;   name -  The status effect name (see bat_effects.tf and bat_status.tf)
;   initial_state - 0=OFF, 1=ON 
;   command - The command to apply the protection/effect
/def -i setupprot = \
    /let p=%{1}%;\
    /if /test {prot_%{p}} == 0%; /then \
        /eval /set numprots=$[{numprots}+1]%;\
        /eval /set prot_%{p}=%{numprots}%;\
    /endif%;\
    /eval /set prot%%{prot_%{p}}=%%{1}%;\
    /eval /set do_prot%%{prot_%{p}}=%%{2}%;\
    /eval /set prot%%{prot_%{p}}_cmd=%%{-2}%;\
    /def -i -t%{p}_UP on_%{p}_up = /reprot_continue

/def -i proton = /eval -s0 /set do_prot%{1}=1%;/prots
/def -i protoff = /eval -s0 /set do_prot%{1}=0%;/prots

/def -i prots = \
    /echo #############%;\
    /for i 1 {numprots} \
        /test echo( pad( \
        {i}, 3,\
        {prot%%{i}}, 10,\
        "", 2,\
        hasstatus({prot%%{i}})  ?\
            "@{Cgreen}[UP]@{n}" :\
            {do_prot%%{i}}=0 ?\
                "[OFF]"      :\
                "@{Cred}[DOWN]@{n}", -18,\
        "", 1), "B", 1)%;\
    /echo #############

/set do_reprot=0
/def -i reprot = \
    /prots%;\
    /set do_reprot=1%;\
    /set stop=0%;\
    /for i 1 {numprots} \
        /if /test {stop} == 0 & {do_prot%%{i}}=1 & !hasstatus({prot%%{i}})%%; /then \
            /set stop=1%%;\
            /eval /eval /eval %%%{prot%%{i}_cmd}%%;\
        /endif%;\
    /if ( {stop} == 0 ) /eval \
        /set do_reprot=0%%;\
        /repeat -1 1 /echo -aBCbggreen,Cwhite ### ALL PROTS UP ###%%;\
        show effects%%;\
	/trigger READY%;\
    /endif

/def -i reprot_continue = /if ( {do_reprot} = 1 ) /repeat -3 1 /reprot%;/else show effects%;/endif

