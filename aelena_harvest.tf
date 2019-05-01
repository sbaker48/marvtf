
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
    /send @@grep '%{poi}' familiar organs
