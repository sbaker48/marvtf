/loaded marvtf/array.tf

; /make_array name
;     Creates a new array with the given name. Returns a reference to the new
;     array.
;
; /make_array arref subname
; /make_array name [index1..indexN] subname
;     Creates a new sub-array with the given name to an existing array. The
;     existing array can be referenced by 'arref', or by the name of the array
;     and any number of indexes to existing sub-arrays. Returns a reference to
;     the new array.
;
; /add_array arref
; /add_array name [index1..indexN]
;     Adds a new sub-array to the end of an existing array or sub-array. This
;     is similar to /make_array, except that the index of the array is
;     automatically set to the next available number ( the highest used number
;     + 1 ). Array indexes start at 1. Returns a reference to the new array.
;
; /get_array name
; /get_array arref subname|index
; /get_array name [index1..indexN] subname|index
;     Returns a reference to an existing array or sub-array with the given name
;     or index.
;
; /set_array_val arref index value
; /set_array_val name [index1..indexN] index value
;     Sets the value of an array entry at the given index. The index can be a
;     string or a number.
;
; /add_array_val arref value
; /add_array_val name [index1..indexN] value
;     Adds a new array entry to the end of an existing array or sub-array. This
;     is similar to /set_array_val, except that the index of the entry is
;     automatically set to the next available number ( the highest used number
;     + 1 ). Array indexes start at 1.
;
; /get_array_val arref index
; /get_array_val name [index1..indexN] index
;     Gets the value of an array entry at the given index. The index can be a
;     string or a number.
;
; /get_array_count arref
; /get_array_count name [index1..indexN]
;     Returns the highest index number used in an array or sub-array. This is
;     not necessarily the same as the number of entries in the array, since
;     it does not include indexes that are not numbers, and index numbers may
;     also be skipped when set manually.
;
; /copy_array arref1 arref2
;     Copies an array
;
; /purge_array name
;     Removes the array with the given name.
;


; /make_array name
; /make_array arref subname
; /make_array name [index1..indexN] subname
/def -i make_array = \
    /let arref=%;\
    /let arcnt=%;\
    /let index=%L1%;\
    /test arref := to_arref( {*} )%;\
    /if ( arref =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return ""%;\
    /endif%;\
    /if ( {#} > 1 ) \
        /test arcnt := to_arcnt( {-L1} )%;\
        /if /test index > {%arcnt}%; /then \
            /test %arcnt := index%;\
        /endif%;\
    /endif%;\
    /result arref


; /get_array name
; /get_array arref subname|index
; /get_array name [index1..indexN] subname|index
/def -i get_array = \
    /result make_array( {*} )


; /add_array arref
; /add_array name [index1..indexN]
/def -i add_array = \
    /let arcnt=%;\
    /let index=%;\
    /test arcnt := to_arcnt( {*} )%;\
    /if ( arcnt =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return ""%;\
    /endif%;\
    /test index := 1 + %arcnt%;\
    /test %arcnt := index%;\
    /result to_arref( {*}, index )


; /set_array_val arref index value
; /set_array_val name [index1..indexN] index value
/def -i set_array_val = \
    /let arref=%;\
    /let arcnt=%;\
    /let index=%L2%;\
    /let value=%L1%;\
    /test arref := to_arref( {-L1} )%;\
    /test arcnt := to_arcnt( {-L2} )%;\
    /if ( arref =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return ""%;\
    /endif%;\
    /test %arref := value%;\
    /if /test index > {%arcnt}%; /then \
        /test %arcnt := index%;\
    /endif


; /add_array_val arref value
; /add_array_val name [index1..indexN] value
/def -i add_array_val = \
    /let arref=%;\
    /let arcnt=%;\
    /let index=%;\
    /let value=%L1%;\
    /test arcnt := to_arcnt( {-L1} )%;\
    /if ( arcnt =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return ""%;\
    /endif%;\
    /test index := 1 + %arcnt%;\
    /test %arcnt := index%;\
    /test arref := to_arref( {-L1}, index )%;\
    /test %arref := value%;\
    /result arref


; /get_array_val arref index
; /get_array_val name [index1..indexN] index
/def -i get_array_val = \
    /let arref=%;\
    /test arref := to_arref( {*} )%;\
    /if ( arref =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return ""%;\
    /endif%;\
    /result %arref


; /get_array_count
/def -i get_array_count = \
    /let arcnt=%;\
    /test arcnt := to_arcnt( {*} )%;\
    /if ( arcnt =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return ""%;\
    /endif%;\
    /result 0 + %arcnt
    

; /copy_array arref1 arref2
/def -i copy_array = \
    /let arrfrom=%;\
    /let arrto=%;\
    /test arrfrom := to_arref( {1} )%;\
    /test arrto := to_arref( {2} )%;\
    /if ( arrfrom =~ "" | arrto =~ "" ) \
        /echo %0: Bad argument (%*)%;\
        /return%;\
    /endif%;\
    /quote -S /_copy_array1 %arrfrom %arrto `/listvar -s -mglob %{arrfrom}_*%;\
    /test arrfrom := to_arcnt( arrfrom )%;\
    /test arrto := to_arcnt( arrto )%;\
    /if /test {%arrfrom} !~ ""%; /then \
        /_copy_array1 %arrfrom %arrto %arrfrom%;\
    /endif%;\
    /quote -S /_copy_array1 %arrfrom %arrto `/listvar -s -mglob %{arrfrom}_*

/def -i _copy_array1 = \
    /let arrfrom=%{1}%;\
    /let arrto=%{2}%;\
    /let var=%{-2}%;\
    /let s=%;\
    /test s := replace( "%{arrfrom}", "%{arrto}", var )%;\
    /test %{s} := %var


; /purge_array name
/def -i purge_array = \
    /if ( {#} == 1 ) \
        /quote -S /unset `/listvar -mglob -s _ARRAY_%1_* %;\
        /quote -S /unset `/listvar -mglob -s _ARCNT_%1_* %;\
	/unset _ARCNT_%1%;\
    /else \
        /echo %0: Invalid number of arguments ( %* )%;\
    /endif


; Helper methods
/def -i arr_is_valid = \
    /let arref=%{*}%;\
    /if ( regmatch( "^[A-Za-z0-9_]*$", arref ) != 0 ) \
        /return arref%;\
    else \
        /return ""%;\
    /endif

/def -i to_arref = \
    /let arref=%;\
    /if ( {*} =~ "" ) \
        /return ""%;\
    /else \
        /if ( substr( {1}, 0, 7 ) =~ "_ARRAY_" ) \
            /test arref := replace( " ", "_", {*} )%;\
        /else \
            /test arref := strcat( "_ARRAY_", replace( " ", "_", {*} ) )%;\
        /endif%;\
	/result arr_is_valid( arref )%;\
    /endif

/def -i to_arcnt = \
    /let arref=%;\
    /test arref := to_arref( {*} )%;\
    /if ( arref =~ "" ) \
        /return ""%;\
    /else \
        /result strcat( "_ARCNT_", substr( arref, 7 ) )%;\
    /endif


/def array_test = \
    /purge_array wpt%;\
    /test wptarr := make_array( "wpt" )%;\
    /eval /echo wptarr = %wptarr%;\
    /test wptarr2 := add_array( wptarr )%;\
    /eval /echo wptarr2 = %wptarr2%;\
    /test set_array_val( wptarr2, "name", "laenor1" )%;\
    /test set_array_val( wptarr2, "cont", "laen" )%;\
    /test set_array_val( wptarr2, "x", 8442 )%;\
    /test set_array_val( wptarr2, "y", 8502 )%;\
    /test connarr := make_array( wptarr2, "connection" )%;\
    /eval /echo connarr = %connarr%;\
    /test connarr2 := add_array( connarr )%;\
    /eval /echo connarr2 = %connarr2%;\
    /test set_array_val( connarr2, "dest", 2 )%;\
    /test set_array_val( connarr2, "cost", 240 )%;\
    /test connarr2 := add_array( connarr )%;\
    /eval /echo connarr2 = %connarr2%;\
    /test set_array_val( connarr2, "dest", 11 )%;\
    /test set_array_val( connarr2, "cost", 50 )%;\
    /listvar ARRAY_*%;\
    /listvar ARCNT_*%;\
    /if ( get_array_count( "wpt" ) == 1 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_count( wptarr ) == 1 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( "wpt", 1, "name" ) =~ "laenor1" ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( "wpt", 1, "cont" ) =~ "laen" ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( wptarr2, "x" ) == 8442 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( wptarr2, "y" ) == 8502 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_count( "wpt", 1, "connection" ) == 2 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_count( connarr ) == 2 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( "wpt", 1, "connection", 1, "dest" ) == 2 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( "wpt", 1, "connection", 1, "cost" ) == 240 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /if ( get_array_val( "wpt", 1, "connection", 2, "dest" ) == 11 ) /echo PASS%;/else /echo FAIL%;/endif%;\
    /IF ( get_array_val( connarr2, "cost" ) == 50 ) /echo PASS%;/else /echo FAIL%;/endif


