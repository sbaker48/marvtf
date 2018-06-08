/loaded marvtf/bat_prots.tf
/require marvtf/bat_status.tf

/def -i setupprot = \
    /let p=%{1}%;\
    /if /test {prot_%{p}} == 0%; /then \
        /eval /set numprots=$[{numprots}+1]%;\
        /eval /set prot_%{p}=%{numprots}%;\
    /endif%;\
    /eval /set prot%%{prot_%{p}}=%%{1}%;\
    /eval /set do_prot%%{prot_%{p}}=%%{2}%;\
    /eval /set prot%%{prot_%{p}}_cmd=%%{-2}%;\
    /def -t%{p}_UP on_%{p}_up = /reprot_continue

/def -i proton = /eval -s0 /set do_prot%{1}=1%;/prots
/def -i protoff = /eval -s0 /set do_prot%{1}=0%;/prots

/def -i prots = \
    /echo #############%;\
    /for i 1 {numprots} \
        /test echo( pad( \
        {i}, 3,\
        {prot%%{i}}, 10,\
        "", 2,\
        {do_prot%%{i}}=0 ?\
            "[OFF]"         :\
            hasstatus({prot%%{i}}) ?\
                "@{Cgreen}[UP]@{n}"   :\
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

