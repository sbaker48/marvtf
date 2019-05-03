/require marvtf/array.tf

/def -i test_check_equal = \
    /if ({1} !~ {2}) \
        /eval /echo -p TEST %testname: "%{1}" != "%{2}"  @{BCred}FAILURE@{n}%;\
    /return 1%;\
    /else \
        /eval /echo TEST %testname: "%{1}" == "%{2}"%;\
        /return 0%;\
    /endif

/def -i test_summary = \
    /if ({1} == 0) \
        /eval /echo -aBCgreen TEST %testname PASSED%;\
    /else \
        /eval /echo -aBCred TEST %testname FAILED (%{1} failures)%;\
    /endif


; TEST 1 - simple array
;
; Tested interfaces:
;   /make_array name
;   /add_array_val name value
;   /set_array_val name index value
;   /get_array_val name index
;   /get_array_count name
;   /copy_array name name
;   /purge_array name
;
/def -i test1 = \
    /set testname=Test1%;\
    /let error=0%;\
; Test creating an array with /make_array and /add_array_val
    /make_array test1a%;\
    /add_array_val test1a dog%;\
    /add_array_val test1a cat%;\
    /add_array_val test1a cow%;\
    /let v4=$[add_array_val("test1a", "some kind of pig")]%;\
    /test error += test_check_equal(get_array_count("test1a"), 4)%;\
    /test error += test_check_equal(get_array_val("test1a", 0), "")%;\
    /test error += test_check_equal(get_array_val("test1a", 1), "dog")%;\
    /test error += test_check_equal(get_array_val("test1a", 2), "cat")%;\
    /test error += test_check_equal(get_array_val("test1a", 3), "cow")%;\
    /test error += test_check_equal(get_array_val("test1a", 4), "some kind of pig")%;\
    /test error += test_check_equal(get_array_val(v4), "some kind of pig")%;\
    /test error += test_check_equal(get_array_val("test1a", 5), "")%;\
; Test changing array values with /set_array_val
    /test set_array_val("test1a", 3, "not a cow")%;\
    /test set_array_val("test1a", 1, "maybe a horse?")%;\
    /set_array_val test1a 4 ...%;\
    /test error += test_check_equal(get_array_count("test1a"), 4)%;\
    /test error += test_check_equal(get_array_val("test1a", 1), "maybe a horse?")%;\
    /test error += test_check_equal(get_array_val("test1a", 2), "cat")%;\
    /test error += test_check_equal(get_array_val("test1a", 3), "not a cow")%;\
    /test error += test_check_equal(get_array_val("test1a", 4), "...")%;\
; Test copying an array with /copy_array
; Test clearing an array with /purge_array
    /copy_array test1a test1b%;\
    /purge_array test1a%;\
    /test error += test_check_equal(get_array_count("test1a"), 0)%;\
    /test error += test_check_equal(get_array_count("test1b"), 4)%;\
    /test error += test_check_equal(get_array_val("test1a", 1), "")%;\
    /test error += test_check_equal(get_array_val("test1a", 2), "")%;\
    /test error += test_check_equal(get_array_val("test1a", 3), "")%;\
    /test error += test_check_equal(get_array_val("test1a", 4), "")%;\
    /test error += test_check_equal(get_array_val("test1b", 1), "maybe a horse?")%;\
    /test error += test_check_equal(get_array_val("test1b", 2), "cat")%;\
    /test error += test_check_equal(get_array_val("test1b", 3), "not a cow")%;\
    /test error += test_check_equal(get_array_val("test1b", 4), "...")%;\
    /purge_array test1b%;\
    /test test_summary(error)%;\
    /unset testname%;\
    /return error


; TEST 2 - multiple arrays
;
; Tested interfaces:
;   /make_array name
;   /get_array name
;   /add_array_val name value
;   /add_array_val arref value
;   /get_array_val name index
;   /get_array_val arref index
;   /get_array_count name
;   /get_array_count arref
;
/def -i test2 = \
    /set testname=Test2%;\
    /let error=0%;\
    /let arr2a=$[make_array("test2a")]%;\
    /let arr2b=$[make_array("test2b")]%;\
    /add_array_val test2a aaa%;\
    /add_array_val test2b bbb%;\
    /test add_array_val(arr2a, "ccc")%;\
    /test add_array_val(arr2b, "ddd")%;\
    /add_array_val test2a eee%;\
    /add_array_val test2b fff%;\
    /add_array_val test2b ggg%;\
    /test error += test_check_equal(get_array("test2a"), arr2a)%;\
    /test error += test_check_equal(get_array("test2b"), arr2b)%;\
    /test error += test_check_equal(get_array_count("test2a"), 3)%;\
    /test error += test_check_equal(get_array_count(arr2b), 4)%;\
    /test error += test_check_equal(get_array_val("arr2a, 1), "aaa")%;\
    /test error += test_check_equal(get_array_val("test2a", 2), "ccc")%;\
    /test error += test_check_equal(get_array_val("test2a", 3), "eee")%;\
    /test error += test_check_equal(get_array_val("test2b", 1), "bbb")%;\
    /test error += test_check_equal(get_array_val("test2b", 2), "ddd")%;\
    /test error += test_check_equal(get_array_val(arr2b, 3), "fff")%;\
    /test error += test_check_equal(get_array_val("test2b", 4), "ggg")%;\
    /if (error > 0) \
        /listvar _ARRAY_test2a_*%;\
        /listvar _ARRAY_test2b_*%;\
    /endif%;\
    /purge_array test2a%;\
    /purge_array test2b%;\
    /test test_summary(error)%;\
    /unset testname%;\
    /return error


; TEST 3 - string indexes
;
; Tested interfaces:
;   /make_array name
;   /set_array_val name index value
;   /set_array_val arref index value
;   /get_array_val name index
;   /get_array_val arref index
;
/def -i test3 = \
    /set testname=Test3%;\
    /let error=0%;\
    /let arr3a=$[make_array("test3a")]%;\
    /set_array_val test3a val1 aaa%;\
    /set_array_val test3a val2 bbb%;\
    /test set_array_val(arr3a, "val3", "ccc")%;\
    /test error += test_check_equal(get_array_val("test3a", "val1"), "aaa")%;\
    /test error += test_check_equal(get_array_val(arr3a, "val2"), "bbb")%;\
    /test error += test_check_equal(get_array_val("test3a", "val3"), "ccc")%;\
    /if (error > 0) \
        /listvar _ARRAY_test3a_*%;\
    /endif%;\
    /purge_array test3a%;\
    /test test_summary(error)%;\
    /unset testname%;\
    /return error


; TEST 4 - sparse arrays
;
; Tested interfaces:
;   /make_array name
;   /add_array_val name value
;   /set_array_val name index value
;   /get_array_val name index
;   /get_array_count name
;
/def -i test4 = \
    /set testname=Test4%;\
    /let error=0%;\
; Test creating an array with /make_array and /set_array_val
    /make_array test4a%;\
    /set_array_val test4a 1 aaa%;\
    /set_array_val test4a 2 bbb%;\
    /set_array_val test4a 3 ccc%;\
    /test error += test_check_equal(get_array_val("test4a", 1), "aaa")%;\
    /test error += test_check_equal(get_array_val("test4a", 2), "bbb")%;\
    /test error += test_check_equal(get_array_val("test4a", 3), "ccc")%;\
; Test creating an array with /make_array and /set_array_val, skipping some values
    /make_array test4b%;\
    /set_array_val test4b 4 bbb%;\
    /test error += test_check_equal(get_array_count("test4b"), 4)%;\
    /set_array_val test4b 2 aaa%;\
    /test error += test_check_equal(get_array_count("test4b"), 4)%;\
    /set_array_val test4b 7 ccc%;\
    /test error += test_check_equal(get_array_count("test4b"), 7)%;\
    /add_array_val test4b ddd%;\
    /test error += test_check_equal(get_array_count("test4b"), 8)%;\
    /test error += test_check_equal(get_array_val("test4b", 2), "aaa")%;\
    /test error += test_check_equal(get_array_val("test4b", 4), "bbb")%;\
    /test error += test_check_equal(get_array_val("test4b", 7), "ccc")%;\
    /test error += test_check_equal(get_array_val("test4b", 8), "ddd")%;\
    /if (error > 0) \
        /listvar _ARRAY_test4a_*%;\
        /listvar _ARRAY_test4b_*%;\
    /endif%;\
    /purge_array test4a%;\
    /purge_array test4b%;\
    /test test_summary(error)%;\
    /unset testname%;\
    /return error


; TEST 5 - sub-arrays
;
; Tested interfaces:
;   /make_array name
;   /make_array arref subname
;   /make_array name [index1..indexN] subname
;   /add_array arref
;   /add_array name [index1..indexN]
;   /get_array arref subname|index
;   /get_array name [index1..indexN] subname|index
;   /add_array_val arref value
;   /add_array_val name [index1..indexN] value
;   /set_array_val arref index value
;   /set_array_val name [index1..indexN] index value
;   /get_array_val arref index
;   /get_array_val name [index1..indexN] index
;   /get_array_count arref
;   /get_array_count name [index1..indexN]
;
;   "test5a" (arr5a) => [
;       "test5b" (arr5b) => [
;           1 => "dog",
;           2 => "cat",
;           3 => "cow",
;           4 => "some kind of pig"
;       ],
;       "test5c" (arr5c) => [
;           "val1" => "aaa",
;           "val2" => "bbb",
;           "val3" => "ccc",
;       ],
;       1 (arr5d) => [
;           "val" => "test1",
;           "val2" => "test1a",
;           1 (arr5e) => [
;               "val" => "test2"
;               "val2" => "test2a"
;           ],
;           2 (arr5f) => [
;               "test5g" (arr5g) => [
;                   "val" => "test3"
;                   "val2" => "test3a"
;               ]
;           ],
;           3 => "test4",
;           4 => "test5",
;       ]
;   ]
;
/def -i test5 = \
    /set testname=Test5%;\
    /let error=0%;\
    /let arr5a=$[make_array("test5a")]%;\
    /let arr5b=$[make_array(arr5a, "test5b")]%;\
    /let arr5c=$[make_array("test5a", "test5c")]%;\
    /let arr5d=$[add_array(arr5a)]%;\
    /add_array_val test5a test5b dog%;\
    /add_array_val test5a test5b cat%;\
    /test add_array_val(arr5b, "cow")%;\
    /test add_array_val(arr5b, "some kind of pig")%;\
    /set_array_val test5a test5c val1 aaa%;\
    /test set_array_val("test5a", "test5c", "val2", "bbb")%;\
    /test set_array_val(arr5c, "val3", "ccc")%;\
    /test error += test_check_equal(get_array(arr5a, "test5b"), arr5b)%;\
    /test error += test_check_equal(get_array("test5a", "test5b"), arr5b)%;\
    /test error += test_check_equal(get_array(arr5a, "test5c"), arr5c)%;\
    /test error += test_check_equal(get_array("test5a", "test5c"), arr5c)%;\
    /test error += test_check_equal(get_array(arr5a, 1), arr5d)%;\
    /test error += test_check_equal(get_array("test5a", 1), arr5d)%;\
    /test error += test_check_equal(get_array_count(arr5b), 4)%;\
    /test error += test_check_equal(get_array_count("test5a", "test5b"), 4)%;\
    /test error += test_check_equal(get_array_val(arr5b, 1), "dog")%;\
    /test error += test_check_equal(get_array_val("test5a", "test5b", 2), "cat")%;\
    /test error += test_check_equal(get_array_val(arr5b, 3), "cow")%;\
    /test error += test_check_equal(get_array_val("test5a", "test5b", 4), "some kind of pig")%;\
    /test error += test_check_equal(get_array_val("test5a", "test5c", "val1"), "aaa")%;\
    /test error += test_check_equal(get_array_val(arr5c, "val2"), "bbb")%;\
    /test error += test_check_equal(get_array_val("test5a", "test5c", "val3"), "ccc")%;\
    /let arr5e=$[add_array(arr5d)]%;\
    /let arr5f=$[make_array("test5a", 1, 2)]%;\
    /let arr5g=$[make_array("test5a", 1, 2, "test5g")]%;\
    /test set_array_val("test5a", 1, "val", "test1")%;\
    /test set_array_val("test5a", 1, 1, "val", "test2")%;\
    /test set_array_val("test5a", 1, 2, "test5g", "val", "test3")%;\
    /test set_array_val(arr5d, "val2", "test1a")%;\
    /test set_array_val(arr5e, "val2", "test2a")%;\
    /test set_array_val(arr5g, "val2", "test3a")%;\
    /test error += test_check_equal(get_array(arr5d, 1), arr5e)%;\
    /test error += test_check_equal(get_array("test5a", 1, 1), arr5e)%;\
    /test error += test_check_equal(get_array(arr5d, 2), arr5f)%;\
    /test error += test_check_equal(get_array("test5a", 1, 2), arr5f)%;\
    /test error += test_check_equal(get_array(arr5f, "test5g"), arr5g)%;\
    /test error += test_check_equal(get_array("test5a", 1, 2, "test5g"), arr5g)%;\
    /test error += test_check_equal(get_array_count(arr5d), 2)%;\
    /test error += test_check_equal(get_array_count("test5a", 1), 2)%;\
    /add_array_val test5a 1 test4%;\
    /let v5=$[add_array_val(arr5d, "test5")]%;\
    /test error += test_check_equal(get_array_count(arr5d), 4)%;\
    /test error += test_check_equal(get_array_count("test5a", 1), 4)%;\
    /test error += test_check_equal(get_array_val(arr5d, "val"), "test1")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, "val"), "test1")%;\
    /test error += test_check_equal(get_array_val(arr5d, "val2"), "test1a")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, "val2"), "test1a")%;\
    /test error += test_check_equal(get_array_val(arr5e, "val"), "test2")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, 1, "val"), "test2")%;\
    /test error += test_check_equal(get_array_val(arr5e, "val2"), "test2a")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, 1, "val2"), "test2a")%;\
    /test error += test_check_equal(get_array_val(arr5g, "val"), "test3")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, 2, "test5g", "val"), "test3")%;\
    /test error += test_check_equal(get_array_val(arr5g, "val2"), "test3a")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, 2, "test5g", "val2"), "test3a")%;\
    /test error += test_check_equal(get_array_val(arr5d, 3), "test4")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, 3), "test4")%;\
    /test error += test_check_equal(get_array_val(arr5d, 4), "test5")%;\
    /test error += test_check_equal(get_array_val("test5a", 1, 4), "test5")%;\
    /test error += test_check_equal(get_array_val(v5), "test5")%;\
    /if (error > 0) \
        /listvar _ARRAY_test5a_*%;\
    /endif%;\
    /purge_array test5a%;\
    /test test_summary(error)%;\
    /unset testname%;\
    /return error


/def run_all_tests = \
    /let er=0%;\
    /test er := er + test1()%;\
    /test er := er + test2()%;\
    /test er := er + test3()%;\
    /test er := er + test4()%;\
    /test er := er + test5()%;\
    /echo%;\
    /echo TOTAL ERRORS: %{er}
