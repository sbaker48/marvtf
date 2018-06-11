/require marvtf/bat_prots.tf

/def -i -F -t'You perform the ceremony.' cer1 = /addstatus CER
/def -i -F -aBCblue -t'You have an unusual feeling as you cast the spell.' cer2 = /rmstatus CER

/def -i -F -t'You perform the kata.' kata1 = /addstatus KATA
/def -i -F -aBCblue -t'You have a strong confidence in your skill.' kata2 = /rmstatus KATA

/set parrystr=
/def -i set_parrystr=/rmstatus %{parrystr}%;/if ( {1} > 0 ) /eval /set parrystr=PARRY:%{1}%;/addstatus %{parrystr}%;/endif
/def -i -F -mregexp -t'^You currently have ([0-9]*)/51 points in parry' parry1 = /set_parrystr %P1
/def -i -F -mregexp -t'^You put your parry factor to ([0-9]*)' parry2 = /set_parrystr %P1

/def -i -F -aBCYellow -t'You suddenly can\'t see yourself.' invis1 = /addstatus INVIS
/def -i -F -aBCYellow -t'You turn visible.' invis2 = /rmstatus INVIS

/def -i -F -aBCYellow -t'You feel light.' ww1 = /addstatus WW%;party report WW up
/def -i -F -aBCYellow -t'You feel heavier.' ww2 = /rmstatus WW%;party report WW DOWN!

/def -i -F -aBCYellow -t'You feel strong - like you could carry the whole flat world on your back!' bot1 = /addstatus BOT%;party report BOT up
/def -i -F -aBCYellow -t'You feel weaker.' bot2 = /rmstatus BOT%;party report BOT DOWN!

/def -i -F -aBCYellow -t'You feel your metabolism speed up.' regen1 = /addstatus REGEN%;party report Regen up
/def -i -F -aBCYellow -t'You no longer have an active regeneration spell on you.' regen2 = /rmstatus REGEN%;party report Regen DOWN!

/def -i -F -aBCYellow -t'You sense a powerful protective aura around you.' fabs1 = /addstatus FABS%;party report Fabs up
/def -i -F -aBCYellow -t'A skin brown flash momentarily surrounds you and then vanishes.' fabs2 = /rmstatus FABS%;party report Fabs DOWN!

/def -i -F -aBCYellow -t'You cast the blurred image successfully.' blur1 = /addstatus BLUR%;party report Blur up
/def -i -F -aBCYellow -t'You feel less invisible.' blur2 = /rmstatus BLUR%;party report Blur DOWN!

/def -i -F -aBCYellow -t'You cast the displacement successfully.' disp1 = /addstatus DISP%;party report Disp up
/def -i -F -aBCYellow -t'You feel much less invisible.' disp2 = /rmstatus DISP%;party report Disp DOWN!

/def -i -F -aBCYellow -t'You sense a flex shield covering your body like a second skin.' flex1 = /addstatus FLEX%;party report Flex up
/def -i -F -aBCYellow -t'Your flex shield wobbles, PINGs and vanishes.' flex2 = /rmstatus FLEX%;party report Flex DOWN!

/def -i -F -aBCYellow -t'You feel your skin harden.' eskin1 = /addstatus ESKIN%;party report Eskin up
/def -i -F -aBCYellow -t'Your skin returns to its original texture.' eskin2 = /rmstatus ESKIN%;party report Eskin DOWN!

/def -i -F -aBCYellow -t'You form a psionic shield of force around your body.' fshield1 = /addstatus FSHIELD%;party report Fshield up
/def -i -F -aBCYellow -t'Your armour feels thinner.' fshield2 = /rmstatus FSHIELD%;party report Fshield DOWN!

/def -i -F -aBCYellow -t'The world seems to slow down.' haste1 = /addstatus HASTE%;party report Haste up
/def -i -F -aBCYellow -t'The world seems to speed up.' haste2 = /rmstatus HASTE%;/addstatus SLOW%;party report Haste Slowdown!
/def -i -F -aBCYellow -t'The world seems to slow down again.' haste3 = /rmstatus SLOW%;party report Haste DOWN!

/def -i -F -aBCYellow -t'You feel full of battle rage! Victory is CERTAIN!' wares1 = /addstatus WARES
/def -i -F -aBCYellow -t'The effect of war ensemble wears off.' wares2 = /rmstatus WARES

/def -i -F -aBCYellow -t'Your body swells in anticipation of the battles to come.' glory1 = /addstatus GLORY
/def -i -F -aBCYellow -t'The destructive forces leave your body.' glory2 = /rmstatus GLORY

/def -i -F -aBCYellow -t'You feel burning hatred and rage erupt within you!' aoh1 = /addstatus AOH
/def -i -F -aBCYellow -t'You feel your anger and hate of the world recede.' aoh2 = /rmstatus AOH

/def -i -F -aBCYellow -t'For some reason you want to run on the walls for a little while.' spwalk1 = /addstatus SPWALK
/def -i -F -aBCYellow -t'The walls don\'t look so inviting anymore.' spwalk2 = /rmstatus SPWALK

/def -i -F -aBCYellow -t'You feel slightly protected.' minorprot1 = /addstatus MINOR%;party report Minor prot up
/def -i -F -aBCYellow -t'The minor protection fades away.' minorprot2 = /rmstatus MINOR%;party report Minor prot DOWN!
/def -i -F -aBCYellow -t'You feel unprotected.' minorprot3 = /rmstatus MINOR

/def -i -p2 -aBCYellow -t'You feel protected from animals.' zooprot1 = /addstatus ZOO%;party report Zoo prot up
/def -i -F -aBCYellow -t'The zoological protection fades away.' zooprot2 = /rmstatus ZOO%;party report Zoo prot DOWN!
/def -i -F -aBCYellow -t'You destroyed Zoological protection.' zooprot3 = /rmstatus ZOO

/def -i -p2 -aBCYellow -t'You feel protected from mythical creatures.' cryptoprot1 = /addstatus CRYPTO%;party report Crypto prot up
/def -i -F -aBCYellow -t'The cryptozoological protection fades away.' cryptoprot2 = /rmstatus CRYPTO%;party report Crypto prot DOWN!
/def -i -F -aBCYellow -t'You destroyed Cryptozoological protection.' cryptoprot3 = /rmstatus CRYPTO

/def -i -p2 -aBCYellow -t'You feel protected from undead creatures.' undeadprot1 = /addstatus UNDEAD%;party report Undead prot up
/def -i -F -aBCYellow -t'The kinemortological protection fades away.' undeadprot2 = /rmstatus UNDEAD%;party report Undead prot DOWN!
/def -i -F -aBCYellow -t'You destroyed Kinemortological protection.' undeadprot3 = /rmstatus UNDEAD

/def -i -p1 -aBCYellow -t'You feel protected from *' raceprot1 = /addstatus RACE%;party report Racial prot up
/def -i -F -aBCYellow -t'The racial protection fades away.' raceprot2 = /rmstatus RACE%;party report Racial prot DOWN!
/def -i -F -aBCYellow -t'You destroyed Racial protection.' raceprot3 = /rmstatus RACE


/def -i -F -aBCYellow -t'You lie down and begin to rest for a while.' camp1 = /addstatus CAMP
/def -i -F -aBCYellow -t'You feel like camping a little.' camp2 = /rmstatus CAMP
/def -i -F -aBCYellow -t'You feel a bit tired.' camp3 = /rmstatus CAMP
/def -i -F -aBCYellow -t'You stretch yourself and consider camping.' camp4 = /rmstatus CAMP

/def -i -t'You sit down and start meditating.' med1 = /addstatus MED%;/repeat -360 1 /rmstatus MED


; Unstun handling

/set unstun_pid=0
/def -i check_unstun = \
    /eval /set unstun_pid=$[repeat("-3 1 /unstun_down")]%;\
    grep -q "Unstun" show effects

/def -i -F -t'| Unstun         * | For now    * |' unstun_status = /unstun_up

/def -i unstun_up = \
    /if ( !hasstatus("UNSTUN") ) \
        /addstatus UNSTUN%;\
        party report Unstun up%;\
        /if ( {unstun_pid} > 0 )\
            /kill %{unstun_pid}%;\
        /endif%;\
    /endif

/def -i unstun_down = \
    /if ( hasstatus("UNSTUN") ) \
        /rmstatus UNSTUN%;\
        party report Unstun DOWN!%;\
    /endif

/def -i -F -aBCYellow -t'* chanting appears to do absolutely nothing.' unstun1 = /check_unstun
/def -i -F -aBCYellow -t'It doesn\'t hurt as much as it normally does!' unstun2 = /check_unstun
/def -i -F -aBCYellow -t'It doesn\'t hurt at all!' unstun3 = /check_unstun


; Floating disc timer

/set disc_pid=0
/set disc_time=0
/def -i disc_time_update = \
    /if ( {disc_pid} == 0 | {disc_time} != {1} ) \
        /if ( {disc_pid} > 0 ) \
            /kill %{disc_pid}%;\
            /rmstatus DISC:%{disc_time}%;\
        /endif%;\
        /set disc_time=%{1}%;\
        /let i1=$[{disc_time}+1]%;\
        /let i2=$[{disc_time}-1]%;\
        /rmstatus DISC:%{i1}%;\
        /if ( {disc_time} >= 0 ) \
            /addstatus DISC:%{disc_time}%;\
            /eval /set disc_pid=$[repeat(strcat("-60 1 /disc_time_update ",{i2}))]%;\
        /else \
            /set disc_pid=0%;\
        /endif%;\
    /endif

/def -i get_disc_time = \
    /def -i -n1 -mregexp -t'floating about (.*) centimetres' disctime0 = /disc_time_update %{P1}%;\
    grep "centimetres" l at my disc

/def -i -F -t'You summon a floating disc that starts following you.' discload1 = /get_disc_time
/def -i -F -t'You reload magical energy to the disc that is floating in the air.' discload2 = /get_disc_time


; Spawn timer

/set spawn_pid=0
/set spawn_sec=0
/set spawn_min=0
/def -i spawn_time_update = \
    /if ( {spawn_pid} > 0 ) \
        /kill %{spawn_pid}%;\
        /set spawn_pid=0%;\
        /rmstatus SPAWN:%{spawn_min}%;\
    /endif%;\
    /set spawn_sec=%{1}%;\
    /if ( spawn_sec > 0 ) \
        /eval /set spawn_min=$[trunc((spawn_sec - 1) / 60)]%;\
        /let update_time=$[spawn_sec - (spawn_min * 60)]%;\
        /let update_sec=$[spawn_sec - update_time]%;\
        /if ( spawn_sec > 120 ) \
           /addstatus SPAWN:%{spawn_min}%;\
        /else \
           /addstatus SPAWN:%{spawn_min} bgred,Cwhite%;\
        /endif%;\
        /eval /set spawn_pid=$[repeat(strcat("-",update_time," 1 /spawn_time_update ",update_sec))]%;\
    /endif

/def -i spawn_time_update_min_sec = \
    /let sec=$[({1} * 60) + {2}]%;\
    /spawn_time_update %{sec}

/def -i -mregexp -t'^\\| Polymorph spawn    * \\| ([0-9]*)min and ([0-9]*)s  *\\|$' spawn_time1 = /spawn_time_update_min_sec %P1 %P2
/def -i -mregexp -t'^\\| Polymorph spawn    * \\| ([0-9]*)min  *\\|$' spawn_time2 = /spawn_time_update_min_sec %P1 0

/def -i -F -aBCBlue -t'The pain increases as your body starts to push out organs and limbs that should not be there.' spawn_up1 = grep "Polymorph spawn" show effects%;/trigger SPAWN_UP
/def -i -F -aBCBlue -t'You force yourself deeper into the chaos frenzy!' spawn_up2 = grep "Polymorph spawn" show effects%;/trigger SPAWN_RELOAD
/def -i -F -aBCbgred,Cwhite -t'The extra organs retract back into your body.' spawn_dropped = /spawn_time_update 0%;/trigger SPAWN_DOWN

