/require marvtf/bat_prots.tf

/def -i addprot = \
    /let stname=%1%;\
    /let name=%2%;\
    /let msgup=%3%;\
    /let msgdn=%4%;\
    /let noreport=%5%;\
    /let color=%6%;\
    /if ( noreport ) \
        /eval /def -i -F -aBCYellow -t"%{msgup}" %{stname}_up = /addstatus %{stname} %{color}%;\
        /eval /def -i -F -aBCYellow -t"%{msgdn}" %{stname}_down = /rmstatus %{stname}%;\
    /else \
        /eval /def -i -F -aBCYellow -t"%{msgup}" %{stname}_up = /addstatus %{stname} %{color}%%%;@@party report %{name} up%;\
        /eval /def -i -F -aBCYellow -t"%{msgdn}" %{stname}_down = /rmstatus %{stname}%%%;@@party report %{name} DOWN!%;\
    /endif

/def -i addprot_regexp = \
    /let stname=%{1}%;\
    /let name=%{2}%;\
    /let msgup=%{3}%;\
    /let msgdn=%{4}%;\
    /let noreport=%{5}%;\
    /if ( noreport ) \
        /eval /def -i -F -aBCYellow -mregexp -t"%{msgup}" %{stname}_up = /addstatus %{stname}%;\
        /eval /def -i -F -aBCYellow -mregexp -t"%{msgdn}" %{stname}_down = /rmstatus %{stname}%;\
    /else \
        /eval /def -i -F -aBCYellow -mregexp -t"%{msgup}" %{stname}_up = /addstatus %{stname}%%%;@@party report %{name} up%;\
        /eval /def -i -F -aBCYellow -mregexp -t"%{msgdn}" %{stname}_down = /rmstatus %{stname}%%%;@@party report %{name} DOWN!%;\
    /endif


/test addprot("INFRA", "Infravision", "You have infravision.", "Everything no longer seems so red.", 1)
/test addprot("SINVIS", "See Invisible", "You feel you can see more than ever.", "Your vision is less sensitive now.", 1)
/test addprot("SMAGIC", "See Magic", "You can now see magical things.", "You are no longer sensitive to magical things.", 1)
/test addprot("INVIS", "Invisibility", "You suddenly can\\\'t see yourself.", "You turn visible.", 1)
/test addprot("HW", "Heavy Weight", "You suddenly feel magically heavier.", "You feel lighter, but it doesn\\\'t seem to affect your weight!", 0)
/test addprot("WW", "Water Walking", "You feel light.", "You feel heavier.", 0)
/test addprot("FLOAT", "Floating", "You feel light, and rise into the air.", "You slowly descend until your feet are on the ground.", 0)
/test addprot("SOP", "Shield of Protection", "You feel a slight tingle.", "You feel more vulnerable now.", 0)
/test addprot("IW", "Iron Will", "You feel protected from being stunned.", "You feel no longer protected from being stunned.", 0)
/test addprot("QSILV", "Quicksilver", "You feel more agile.", "You feel less agile.", 0)
/test addprot("FABS", "Force Absorption", "You sense a powerful protective aura around you.", "A skin brown flash momentarily surrounds you and then vanishes.", 0)
/test addprot("HASTE", "Haste", "The world seems to slow down.", "The world seems to speed up.", 0)
/test addprot("EV", "Enhanced Vitality", "A bright light exctract from your hands covering your skin.", "Your skin stops glowing.", 0)
/test addprot("RENTROPY", "Resist Entropy", "You feel your life force expanding.", "You feel your hair is getting grayer.", 0)
/test addprot("PSISHLD", "Psionic Shield", "Psionic waves surge through your body and mind!", "The psionic shield vanishes.", 0)
/test addprot_regexp("FSHLD", "Force Shield", "^(You form a psionic shield of force around your body\.|.* forms a shield of force around you\.)\$", "^Your armour feels thinner\.\$", 0)
/test addprot("MINDDEV", "Mind Development", "You feel your mind developing.", "Your brain suddenly seems smaller.", 0)
/test addprot_regexp("PFE", "Protection from Evil", "^.* with sheer power as you are surrounded by protective holy aura\.\$", "^(You suddenly feel more vulnerable to evil\.|Your holy aura prevents you .* and is dispelled in the process\.)\$", 0)
/test addprot("RT", "Resist Temptation", "* with sheer power as you are surrounded by twinkling aura.", "You feel more vulnerable against flips.", 0)
/test addprot_regexp("HPROT", "Heavenly Prot", "^[A-Za-z' ]+ as you are suddenly( surrounded( by)?)?", "^Holy particles slow down, rapidly fading away\.\$", 0)
/test addprot_regexp("SOULSHLD", "Soul Shield", "^(You spiritually reach out for your soul, protecting it with holy force\.|[A-Z][a-z]+ places (his|her|its) hand over you and blesses your soul in the name of Las\.)\$", "^Your soul feels suddenly more vulnerable\.\$", 0)
/test addprot("MANASHLD", "Mana Shield", "You feel your magical power expanding.", "Your life force seems weaker.", 0)
/test addprot_regexp("LINK", "Life Link", "^(You succeed. You create a link to|You create a link to|You feel somehow linked to)", "^You hear a loud snap like sound!\$", 0)
/test addprot("GANGEL", "Guardian Angel", "A guardian angel arrives to protect you!", "Your guardian angel cannot stay for longer and flies away.", 0)
/test addprot("UNP", "Unpain", "You feel your will getting stronger.", "You feel your will returning to normal.", 0)
/test addprot("BOT", "Blessing of Tarmalen", "You feel strong - like you could carry the whole flat world on your back!", "You feel weaker.", 0)
/test addprot("LIGHT", "See the light", "Wow! Suddenly you see the Light!", "You no longer see the light!", 0)
/test addprot("REGEN", "Regeneration", "You feel your metabolism speed up.", "You no longer have an active regeneration spell on you.", 0)
/test addprot("FLEX", "Flex Shield", "You sense a flex shield covering your body like a second skin.", "Your flex shield wobbles, PINGs and vanishes.", 0)
/test addprot("EPOWER", "Earth Power", "You feel your strength changing. You flex you muscles experimentally.", "The runic sigla \\\'% !^\\\' fade away.. leaving you feeling strange.", 0)
/test addprot("EBLOOD", "Earth Blood", "An icy chill runs through your veins.", "The runic sigla \\\'!( \*)\\\' fade away.. leaving you feeling strange.", 0)
/test addprot("VINE", "Vine Mantle", "Vines entangle your body.", "The vines around your body shrink.", 0)
/test addprot("ESKIN", "Earth Skin", "You feel your skin harden.", "Your skin feels softer.", 0)
/test addprot("WARES", "War Ensemble", "You feel full of battle rage! Victory is CERTAIN!", "The effect of war ensemble wears off.", 1)
/test addprot("FAVOUR", "Arches Favour", "You feel optimistic about your near future!", "You no longer have Arches Favour on you. You feel sad.", 1)
/test addprot_regexp("MELODY", "Melodical Embracement", "^(.* wraps you into an embracing melody\.|You embrace yourself with your melody\.)\$", "^The embracing melody subsides, leaving you longing for more\.\$", 1)
/test addprot("CLAND", "Clandestine Thoughts", "[clandestine thought]: activated.*", "[clandestine thought]: scanning ended.*", 1)
/test addprot("PFG", "Protection from Good", "A vile black aura surrounds you.", "You no longer have a vile black aura around you.", 0)
/test addprot("AOH", "Aura of Hate", "You feel burning hatred and rage erupt within you!", "You feel your anger and hate of the world recede.", 0)
/test addprot("SOF", "Shield of Faith", "You are surrounded by divine glow!", "Your glow disappears.", 0)
/test addprot("PFF", "Personal Force Field", "You surround yourself by a bubble of force.", "Your field disperses with a soft \*pop\* and is gone.", 0)
/test addprot("WALK", "Spider Walk", "For some reason you want to run on the walls for a little while.", "The walls don\\\'t look so inviting anymore.", 0)
/test addprot("TOUCH", "Spider Touch", "Suddenly you don\\\'t feel too good. Your blood feels like it is on fire.", "Your blood does not burn anymore.", 0)
/test addprot("FFISTS", "Flame Fists", "Your fists are surrounded by Curath\\\'s black flames!", "Your flaming fists disappear.", 0)
/test addprot("MINORP", "Minor Protection", "You feel slightly protected.", "The minor protection fades away.", 0)
/test addprot("ZOOP", "Zoological Protection", "You feel protected from animals.", "The zoological protection fades away.", 0)
/test addprot("CRYZOOP", "Cryptozoological protection", "You feel protected from mythical creatures.", "The cryptozoological protection fades away.", 0)
/test addprot("KINEP", "Kinemortological protection", "You feel protected from undead creatures.", "The kinemortological protection fades away.", 0)
/test addprot_regexp("RACP", "Racial protection", "^You feel protected from (?!animals)[a-z]*s\.\$", "^The racial protection fades away\.\$", 0)
/test addprot("RAGE", "Destructive rage", "A veiled darkness descends over your eyes.  Sounds are oddly distorted, and", "Your massive build-up of rage slowly dissipates leaving you drained and", 0)
/test addprot("SDRAIN", "Spirit drain", "You draw some of *\\\'s spirit and use it to bolster your own!", "The effects of the spirit drain leave you.", 0)
/test addprot("ENRAGE", "Enrage", "You jump up and begin dancing around the room. You start hooting and howling loudly and begin hopping around.*", "You no longer feel enraged.", 0)
/test addprot("PAIN", "Pain threshold", "You begin to concentrate on pain threshold.", "Your concentration breaks and you feel less protected from physical damage.", 0)
/test addprot("GLORY", "Glory of destruction", "Your body swells in anticipation of the battles to come.", "The destructive forces leave your body.", 0)
/test addprot("AOA", "Armour of aether", "You see a crystal clear shield fade into existance around you.", "Your crystal clear shield fades out.", 0)

/test addprot("SUPPRESS", "Suppress magic", "Your feel excruciating pain in your head.", "You feel relieved.", 0, "magenta")
/test addprot("FORGET", "Forget", "You feel rather empty-headed.", "A fog lifts from your mind. You can remember things clearly now.", 0, "magenta")
/test addprot("HALLU", "Hallucination", "* looks at you mesmerizingly.  The world around you changes.", "Your mind clears.", 0, "magenta")


/def -i -F -t'You perform the ceremony.' cer1 = /addstatus CER
/def -i -F -aBCblue -t'You have an unusual feeling as you cast the spell.' cer2 = /rmstatus CER

/def -i -F -t'You perform the kata.' kata1 = /addstatus KATA
/def -i -F -aBCblue -t'You have a strong confidence in your skill.' kata2 = /rmstatus KATA

/set parrystr=
/def -i set_parrystr=/rmstatus %{parrystr}%;/if ( {1} > 0 ) /eval /set parrystr=PARRY:%{1}%;/addstatus %{parrystr}%;/endif
/def -i -F -mregexp -t'^You currently have ([0-9]*)/51 points in parry' parry1 = /set_parrystr %P1
/def -i -F -mregexp -t'^You put your parry factor to ([0-9]*)' parry2 = /set_parrystr %P1

/def -i -F -aBCYellow -t'You lie down and begin to rest for a while.' camp1 = /addstatus CAMP cyan
/def -i -F -aBCYellow -t'You feel like camping a little.' camp2 = /rmstatus CAMP
/def -i -F -aBCYellow -t'You feel a bit tired.' camp3 = /rmstatus CAMP
/def -i -F -aBCYellow -t'You stretch yourself and consider camping.' camp4 = /rmstatus CAMP

/def -i -t'You sit down and start meditating.' med1 = /addstatus MED cyan%;/repeat -360 1 /rmstatus MED


; Unstun handling

/set unstun_pid=0
/def -i check_unstun = \
    /eval /set unstun_pid=$[repeat("-3 1 /unstun_down")]%;\
    @@grep -q "Unstun" show effects

/def -i -F -t'| Unstun         * | For now    * |' unstun_status = /unstun_up

/def -i unstun_up = \
    /if ( !hasstatus("UNSTUN") ) \
        /addstatus UNSTUN%;\
        party report Unstun up%;\
    /endif%;\
    /if ( {unstun_pid} > 0 )\
        /kill %{unstun_pid}%;\
	/set unstun_pid=0%;\
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
    /def -i -n1 -mregexp -t'floating about ([0-9]*) centimetres' disctime0 = /disc_time_update %%{P1}%;\
    @@grep "centimetres" l at my disc

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

/def -i -F -aBCBlue -t'The pain increases as your body starts to push out organs and limbs that should not be there.' spawn_up1 = @@grep "Polymorph spawn" show effects%;/trigger SPAWN_UP
/def -i -F -aBCBlue -t'You force yourself deeper into the chaos frenzy!' spawn_up2 = @@grep "Polymorph spawn" show effects%;/trigger SPAWN_RELOAD
/def -i -F -aBCbgred,Cwhite -t'The extra organs retract back into your body.' spawn_dropped = /spawn_time_update 0%;/trigger SPAWN_DOWN

