/if ( {bat_logfile} =~ "" ) \
    /eval /sys mkdir -p $[ftime("~/tf-dir/logs/%Y",time())]%;\
    /eval /set bat_logfile=$[ftime("~/tf-dir/logs/%Y/%Y-%m-%d_%H-%M-%S.log",time())]%;\
    /eval /log %{bat_logfile}%;\
    /eval /log -l %{bat_logfile}%;\
    /eval /log -i %{bat_logfile}%;\
/endif
/log
