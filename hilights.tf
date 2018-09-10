
/def -i -F -aBCRed -t'* utters the magic words \'saugaiii\'' poison1
/def -i -F -aBCRed -t'You shiver and suffer from POISON!!' poison2
/def -i -F -aBCGreen -t'You feel the poison leaving your veins*' poison3
/def -i -F -aBCGreen -t'You feel poison leaving your veins.' poison4
/def -i -F -aBCGreen -t'The sauna cured your poison!' poison5

/def -i -F -aBCRed -t'You get hit, and your eyes lose focus slightly.' stun1
/def -i -F -aBCRed -t'You become somewhat confused, losing your edge.' stun2
/def -i -F -aBCRed -t'Your mind reels and the world becomes blurred.' stun3
/def -i -F -aBCRed -t'You get hit badly, and have problems staying in balance.' stun4
/def -i -F -aBCRed -t'You stagger helplessly in pain and confusion.' stun5
/def -i -F -aBCRed -t'You lose connection to reality, becoming truly STUNNED.' stun6

/def -i -F -aBCGreen -t'You are no longer stunned.' stun1x
/def -i -F -aBCGreen -t'...BUT you break it off with intense concentration.' stun2x
/def -i -F -aBCGreen -t'...BUT you break it off.' stun3x

/def -i -F -aBCGreen -t'Your attack causes * to lose focus slightly.' stunned1 = /echo -aBCGreen **STUN 1**
/def -i -F -aBCGreen -t'You hurt * who seems to become somewhat confused.' stunned2 = /echo -aBCGreen **STUN 2**
/def -i -F -aBCGreen -t'You cause * world to become blurred and unfocused.' stunned3 = /echo -aBCGreen **STUN 3**
/def -i -F -aBCGreen -t'* is suddenly almost unable to stay in balance.' stunned4 = /echo -aBCGreen **STUN 4**
/def -i -F -aBCGreen -t'You make * stagger helplessly in pain and confusion.' stunned5 = /echo -aBCGreen **STUN 5**
/def -i -F -aBCGreen -t'You STUN *, who loses connection to reality.' stunned6 = /echo -aBCGreen **STUN 6**

/def -i -F -aBCYellow -t'...WHO breaks the stun quickly off with intense concentration.' stunned1x

/def -i -F -aBCGreen -t'You score a CRITICAL hit!' crithit = scan

/def -i -F -aBCRed -t'* has summoned you!' summon1 = @@whereami
/def -i -F -t'You sense your surroundings distorting and then snap.' reloc1 = @@whereami
/def -i -F -t'You open up a sparkling blue dimensional rift, and step through to the *' goto_ship1 = @@whereami

/def -i -F -aBCYellow -t'This is the first time you\'ve been here.' newroom1 = @@whereami
/def -i -F -aBCYellow -t'You discovered a new room! Check your updated explore count.' newroom2 = @@whereami
/def -i -F -aBCYellow -t'Congrats! You discovered a new room!' newroom3 = @@whereami
/def -i -F -aBCYellow -t'You\'ve never been here before.' newroom4 = @@whereami
/def -i -F -aBCYellow -t'This place seems unfamiliar to you.' newroom5 = @@whereami
/def -i -F -aBCYellow -t'New room discovered -- you feel more experienced.' newroom6 = @@whereami
/def -i -F -aBCYellow -t'You\'ve never set foot here before.' newroom7 = @@whereami
/def -i -F -aBCYellow -t'Hmm, what\'s this? A new room, perhaps?' newroom8 = @@whereami
/def -i -F -aBCYellow -t'You don\'t remember being here before.' newroom9 = @@whereami
/def -i -F -aBCYellow -t'New room located -- explore count increased by one.' newroom10 = @@whereami

/def -i -F -arBCRed -t'Robin Hood arrives from the shadows, as merrily as ever.' robin_hood

/def -i -F -aBCRed -t'Tiger starts concentrating on a new offensive spell.' tiger1
/def -i -F -aBCRed -t'* assassin tiger tracking his prey' tiger2
/def -i -F -aBCRed -t'* assassin tiger tracking her prey' tiger2a
/def -i -F -aBCRed -t'Tiger starts concentrating on a new skill.' tiger3
/def -i -F -aBCRed -t'Tiger arrives *' tiger4
/def -i -F -aBCRed -t'When your eyes clear, Tiger stands before you.' tiger5

/def -i -ag -t"The crystal throbs faintly, healing some of your wounds." crystalgag

/def -i -F -aBCbgred,Cwhite -t'Your * gets damaged; it\'s now in * condition.' eqdam

/def -i -F -aBCBlue -t'* is in excellent shape.' shape1
/def -i -F -aBCCyan -t'* is in a good shape.' shape2
/def -i -F -aCGreen -t'* is slightly hurt.' shape3
/def -i -F -aBCGreen -t'* is noticeably hurt.' shape4
/def -i -F -aCYellow -t'* is not in a good shape.' shape5
/def -i -F -aBCYellow -t'* is in bad shape.' shape6
/def -i -F -aBCMagenta -t'* is in very bad shape.' shape7
/def -i -F -aBCRed -t'* is near death.' shape8

/def -i -F -aBCBlue -t'* is in excellent shape ([0-9]*%).' shape1a
/def -i -F -aBCCyan -t'* is in a good shape ([0-9]*%).' shape2a
/def -i -F -aCGreen -t'* is slightly hurt ([0-9]*%).' shape3a
/def -i -F -aBCGreen -t'* is noticeably hurt ([0-9]*%).' shape4a
/def -i -F -aCYellow -t'* is not in a good shape ([0-9]*%).' shape5a
/def -i -F -aBCYellow -t'* is in bad shape ([0-9]*%).' shape6a
/def -i -F -aBCMagenta -t'* is in very bad shape ([0-9]*%).' shape7a
/def -i -F -aBCRed -t'* is near death ([0-9]*%).' shape8a

/def -i -F -aBCBlue -t'* (in excellent shape)' shape1p
/def -i -F -aBCCyan -t'* (in a good shape)' shape2p
/def -i -F -aCGreen -t'* (slightly hurt)' shape3p
/def -i -F -aBCGreen -t'* (noticeably hurt)' shape4p
/def -i -F -aCYellow -t'* (not in a good shape)' shape5p
/def -i -F -aBCYellow -t'* (in bad shape)' shape6p
/def -i -F -aBCMagenta -t'* (in very bad shape)' shape7p
/def -i -F -aBCRed -t'* (near death)' shape8p

/def -i -F -axBCBlue -t'You feel like you just got slightly better in *' skill_raise
