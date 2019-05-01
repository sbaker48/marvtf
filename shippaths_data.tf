/loaded marvtf/shippaths_data.tf
/require marvtf/array.tf

/set TRADELINE_BONUS=5.0

/def -i shippaths_init = \
    /purge_array wpt%;\
    /add_wpt 1 laenor1 laen 8442 8502%;\
    /add_wpt 2 laenor2 laen 8442 8262%;\
    /add_wpt 3 laenor3 laen 8502 8202%;\
    /add_wpt 4 laenor4 laen 8972 8202%;\
    /add_wpt 5 laenor5 laen 8972 8836%;\
    /add_wpt 6 laenor6 laen 8856 8952%;\
    /add_wpt 7 laenor7 laen 8397 8952%;\
    /add_wpt 8 laenor8 laen 8337 8892%;\
    /add_wpt 9 laenor9 laen 8337 8707%;\
    /add_wpt 10 laenor10 laen 8926 8202%;\
    /add_wpt 11 daerwon laen 8492 8552%;\
    /add_wpt 12 arelium1 laen 8503 8552%;\
    /add_wpt 13 arelium2 laen 8556 8605%;\
    /add_wpt 14 arelium3 laen 8556 8658%;\
    /add_wpt 15 desolathya1 deso 7513 9107%;\
    /add_wpt 16 desolathya2 deso 7513 9486%;\
    /add_wpt 17 desolathya3 deso 7443 9486%;\
    /add_wpt 18 desolathya4 deso 7444 9038%;\
    /add_wpt 19 desolathya5 deso 7199 9038%;\
    /add_wpt 20 desolathya6 deso 7003 9234%;\
    /add_wpt 21 desolathya7 deso 7003 9429%;\
    /add_wpt 22 desolathya8 deso 7095 9521%;\
    /add_wpt 23 desolathya9 deso 7350 9521%;\
    /add_wpt 24 desolathya10 deso 7003 9093%;\
    /add_wpt 25 desolathya11 deso 7414 9457%;\
    /add_wpt 26 desocrater1 deso 7402 9218%;\
    /add_wpt 27 desocrater2 deso 7259 9218%;\
    /add_wpt 28 windhamkeep deso 7413 9456%;\
    /add_wpt 29 lucentium1 luce 7954 10549%;\
    /add_wpt 30 lucentium2 luce 8031 10549%;\
    /add_wpt 31 lucentium3 luce 8031 11016%;\
    /add_wpt 32 lucentium4 luce 7606 10897%;\
    /add_wpt 33 lucentium5 luce 8031 10703%;\
    /add_wpt 34 lucentium6 luce 7978 10703%;\
    /add_wpt 35 lucentium7 luce 7968 10693%;\
    /add_wpt 36 rothikgen1 roth 9764 7364%;\
    /add_wpt 37 rothikgen2 roth 9524 7124%;\
    /add_wpt 38 rothikgen3 roth 9524 7026%;\
    /add_wpt 39 rothikgen4 roth 9963 7165%;\
    /add_wpt 40 rothikgen5 roth 9963 6969%;\
    /add_wpt 41 rothikgen6 roth 9638 7238%;\
    /add_wpt 42 rothikgen7 roth 9688 7188%;\
    /add_wpt 43 rothikgen8 roth 9697 7197%;\
    /add_wpt 44 furnachia1 furn 9500 9427%;\
    /add_wpt 45 furnachia2 furn 9590 9427%;\
    /add_wpt 46 desolathya-lucentium1 deepsea 7558 9486%;\
    /add_wpt 47 desolathya-lucentium2 deepsea 7558 10153%;\
    /add_wpt 48 laenor-desolathya deepsea 7597 9107%;\
    /add_wpt 49 laenor-furnachia deepsea 9025 8952%;\
    /add_wpt 50 laenor-lucentium deepsea 7954 9090%;\
; non-standard waypoints
    /add_wpt 51 desolathya4a deso 7262 9038%;\
    /add_wpt 52 lucentium4a luce 7844 10659%;\
    /add_wpt 53 lucentium4b luce 7704 10799%;\
    /add_wpt_link 1 2 240%;\
    /add_wpt_link 1 11 50%;\
    /add_wpt_link 2 3 60%;\
    /add_wpt_link 2 48 845%;\
    /add_wpt_link 3 4 470%;\
    /add_wpt_link 3 10 424%;\
    /add_wpt_link 4 5 634%;\
    /add_wpt_link 4 10 46%;\
    /add_wpt_link 5 6 116%;\
    /add_wpt_link 6 7 459%;\
    /add_wpt_link 6 49 169%;\
    /add_wpt_link 7 8 60%;\
    /add_wpt_link 7 49 628%;\
    /add_wpt_link 8 9 185%;\
    /add_wpt_link 9 11 155%;\
    /add_wpt_link 9 46 779%;\
    /add_wpt_link 9 50 383%;\
    /add_wpt_link 10 36 838%;\
    /add_wpt_link 11 12 11%;\
    /add_wpt_link 12 13 53%;\
    /add_wpt_link 13 14 53%;\
    /add_wpt_link 15 16 379%;\
    /add_wpt_link 15 18 69%;\
    /add_wpt_link 15 48 84%;\
    /add_wpt_link 16 17 70%;\
    /add_wpt_link 16 46 45%;\
    /add_wpt_link 17 25 29%;\
    /add_wpt_link 17 28 30%;\
    /add_wpt_link 17 46 115%;\
    /add_wpt_link 18 19 245%;\
    /add_wpt_link 19 20 196%;\
    /add_wpt_link 20 21 195%;\
    /add_wpt_link 20 24 141%;\
    /add_wpt_link 21 22 92%;\
    /add_wpt_link 21 24 336%;\
    /add_wpt_link 22 23 255%;\
    /add_wpt_link 23 25 64%;\
    /add_wpt_link 25 28 1%;\
    /add_wpt_link 26 27 143%;\
    /add_wpt_link 29 30 77%;\
    /add_wpt_link 29 32 348%;\
    /add_wpt_link 29 47 396%;\
    /add_wpt_link 29 50 1459%;\
    /add_wpt_link 30 31 467%;\
    /add_wpt_link 30 33 154%;\
    /add_wpt_link 31 33 313%;\
    /add_wpt_link 33 34 53%;\
    /add_wpt_link 34 35 10%;\
    /add_wpt_link 36 37 240%;\
    /add_wpt_link 36 39 199%;\
    /add_wpt_link 36 41 126%;\
    /add_wpt_link 37 38 98%;\
    /add_wpt_link 37 41 114%;\
    /add_wpt_link 39 40 196%;\
    /add_wpt_link 41 42 50%;\
    /add_wpt_link 42 43 9%;\
    /add_wpt_link 44 45 90%;\
    /add_wpt_link 44 49 475%;\
    /add_wpt_link 46 47 667%;\
    /add_wpt_link 46 50 396%;\
; non-standard waypoints
    /add_wpt_link 18 51 182%;\
    /add_wpt_link 19 51 63%;\
    /add_wpt_link 29 52 110%;\
    /add_wpt_link 29 53 250%;\
    /add_wpt_link 32 52 238%;\
    /add_wpt_link 32 53 98%;\
    /add_wpt_link 52 53 140%;\


/def -i add_wpt = \
    /let num=%1%;\
    /let name=%2%;\
    /let scont=%3%;\
    /let xcoord=%4%;\
    /let ycoord=%5%;\
    /let ref=%;\
    /test ref := make_array( "wpt", num )%;\
    /test set_array_val( ref, "name", strcat( "wpt_", name ) )%;\
    /test set_array_val( ref, "cont", scont )%;\
    /test set_array_val( ref, "gx", xcoord )%;\
    /test set_array_val( ref, "gy", ycoord )%;\
    /test add_array_val( "wpt", scont, ref )

/def -i add_wpt_link = \
    /let index1=%1%;\
    /let index2=%2%;\
    /let cost=%3%;\
    /let link1=%;\
    /let link2=%;\
    /test cost := ceil( cost / TRADELINE_BONUS )%;\
    /test link1 := add_array( "wpt", index1, "links" )%;\
    /test link2 := add_array( "wpt", index2, "links" )%;\
    /test set_array_val( link1, "dest", index2 )%;\
    /test set_array_val( link2, "dest", index1 )%;\
    /test set_array_val( link1, "cost", cost )%;\
    /test set_array_val( link2, "cost", cost )

/def -i ceil = \
    /let val=%1%;\
    /let tr=%;\
    /test tr := trunc( val )%;\
    /if ( val != tr ) \
        /result tr + 1%;\
    /else \
        /result tr%;\
    /endif

; Load data
/shippaths_init

