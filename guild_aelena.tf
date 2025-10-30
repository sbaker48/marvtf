/require marvtf/bat_prots.tf
/require marvtf/bat_stuff.tf
/require marvtf/timer.tf
/require marvtf/spawn.tf

/setupprot SHADOW 0 cast the shadow
/setupprot TRANCE 1 aelena poison black trance;cast sting of aelena at me
;/setupprot RUSTBLD 0 pblade RWEAPON
;/setupprot CMDBLD 0 /cer cast command blade


/def -i -F -aBCBlue -t'You feel the shadows embrace you.' shadowon = /addstatus SHADOW
/def -i -F -aBCbgred,Cwhite -t'The shadows clear off.' shadowoff = /rmstatus SHADOW

/def -i -F -aBCBlue -t'Pushing your mind into the blade, you create a mental connection to it*' cmdblade_up = /addstatus CMDBLD%;/timer_start CMDBLD
/def -i -F -aBCbgred,Cwhite -t'The connection between you and your blade fades away.' cmdblade_down = /rmstatus CMDBLD%;/timer_stop CMDBLD

/def -i -F -aBCBlue -t'You trace magical runes over a beating heart and squeeze its fluids down your throat, gagging slightly as you swallow.' trance_up = /addstatus TRANCE%;/timer_start TRANCE
/def -i -F -aBCbgred,Cwhite -t'Your mind feels calm and normal once again.' trance_down = /rmstatus TRANCE%;/timer_stop TRANCE

/def -i -F -aBCBlue -t'You spread your own blood over your *, causing it to glow slightly and form a layer of decay on its surface.' rustbld_up = /addstatus RUSTBLD%;/timer_start RUSTBLD%;wield RWEAPON
/def -i -F -aBCbgred,Cwhite -t'The layers of decay turn back into blood and fall off your * harmlessly to the ground.' rustbld_down = /rmstatus RUSTBLD%;/timer_stop RUSTBLD

/def -i -F -aBCBlue -t'Your Shadow Familiar flows over your weapons and opens a conduit to the void. Shortly the weapons are imbued *' chaos_weapon_up = /addstatus CHAOSWEP%;wield RWEAPON;wield LWEAPON
/def -i -F -aBCbgred,Cwhite -t'Your * is no longer powered by Chaos!' chaos_weapon_down = /rmstatus CHAOSWEP

/def -i -F -aBCWhite,CbgRed -t'Your Shadow Familiar shrieks as it advances a level!' famadvance


/def -i -ag -t'You don\'t have a reagent for *' fam_ignore1
/def -i -ag -t'Consume what?' fam_ignore2

/def -i handle_organ = \
    /if     ( {1} =~ "heart"  ) /send @@familiar store iron barbs%;\
    /elseif ( {1} =~ "kidney" ) /send @@familiar store rabid thoughts;familiar store slow death%;\
    /elseif ( {1} =~ "eye"    ) /send @@familiar store rusted blade%;\
    /elseif ( {1} =~ "liver"  ) /send @@familiar store black trance%;\
    /elseif ( {1} =~ "lung"   ) /send @@familiar store toxic barbs;familiar store defiled agility%;\
    /elseif ( {1} =~ "brain"  ) /send @@familiar store shimmering barbs%;\
    /endif%;\
    /repeat -2 1 /send @@familiar consume %{1}

/def -i -F -mregexp -t'^You carefully remove a bloody bodypart \'([a-z]*)\'.' dissect1 = /send @@get %P1%;/handle_organ %P1
/def -i -F -mregexp -t'^ ..and slicing expertly, you cut out a second organ \'([a-z]*)\'.' dissect2 = /send @@get %P1%;/handle_organ %P1
/def -i -F -mregexp -t'^and harvests a bloody bodypart \'([a-z]*)\'.' famharvest1 = /handle_organ %P1
/def -i -F -mregexp -t' ..it also manages to find a second organ \'([a-z]*)\'.' famharvest2 = /handle_organ %P1

/def -i -F -t'.. but corpse of * does not seem to have * organ *' famharvestfail = /send @@familiar consume corpse

/def -i -F -mregexp -t'^Your familiar envelopes the [a-z]* and turns it into [a-z]* chaos energy for (.*), leaving only rotten flesh behind.' famstore = \
    /let poi=$[strcat(toupper(substr({P1},0,1)),substr({P1},1))]%;\
    /send @@grep '%{poi}' familiar reagents

