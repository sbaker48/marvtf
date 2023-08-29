
/set spawn_command=X

/def -i -q -msimple -h"send X" spawn_command = ps >> spawning <<
/def -i -q -msimple -h"send X despawn" despawn_command = ps >> despawning <<

/def -i -F -t'SPAWN_UP' spawn_up = \
    /set current_swap=9%;/s0%;\
    grep force spawn%;\
    pray to azzarakk

/def -i -F -t'SPAWN_RELOAD' spawn_reload = /repeat -1 1 spawn tentacle

/def -i -F -aBCbgred,Cwhite -t'You feel like the pulse of chaos inside you is slowing down!' spawn_dropping = \
    party say Spawn dropping in 2 minutes!%;\
    /if ( idle() > 90.0 & idle() < 2700.0 )\
        /CMD 5 %{spawn_command}%;\
    /endif

/def -i -F -t'You huff, and you puff.. but nothing happens.' spawn_fail = /CMD 3 %{spawn_command}

/def -i -F -q -p2 -t'*You feel devoid of chaos.*' chaos1 = /substitute -p %* @{Cmagenta}[......]@{n}
/def -i -F -q -p2 -t'*You feel a slight tingling of chaos inside you.*' chaos2 = /substitute -p %* @{Cmagenta}[#.....]@{n}
/def -i -F -q -p2 -t'*You feel chaos pulsing deep inside you.*' chaos3 = /substitute -p %* @{Cmagenta}[##....]@{n}
/def -i -F -q -p2 -t'*You feel chaos pulsing inside your veins.*' chaos4 = /substitute -p %* @{Cmagenta}[###...]@{n}
/def -i -F -q -p2 -t'*You feel chaos energizing your body.*' chaos5 = /substitute -p %* @{Cmagenta}[####..]@{n}
/def -i -F -q -p2 -t'*You feel chaos pouring out of you.*' chaos6 = /substitute -p %* @{Cmagenta}[#####.]@{n}
/def -i -F -q -p2 -t'*You feel your veins throbbing with pure chaos!*' chaos7 = /substitute -p %* @{Cmagenta}[######]@{n}

/def -i -F -q -t'*Your skin feels smooth.*' tentacle1 = /substitute -p %* @{Cmagenta}[......]@{n}
/def -i -F -q -t'*You feel a tickling in your torso.*' tentacle2 = /substitute -p %* @{Cmagenta}[#.....]@{n}
/def -i -F -q -t'*You feel a burning bump in your side.*' tentacle3 = /substitute -p %* @{Cmagenta}[##....]@{n}
/def -i -F -q -t'*There\'s a bulging mass in your side.*' tentacle4 = /substitute -p %* @{Cmagenta}[###...]@{n}
/def -i -F -q -t'*There\'s a seething mass in your side.*' tentacle5 = /substitute -p %* @{Cmagenta}[####..]@{n}
/def -i -F -q -t'*A glowing, bulging mass is burning in your side.*' tentacle6 = /substitute -p %* @{Cmagenta}[#####.]@{n}
/def -i -F -q -t'*Your side is about to burst by the seething mass lodged there!*' tentacle7 = /substitute -p %* @{Cmagenta}[######]@{n}
