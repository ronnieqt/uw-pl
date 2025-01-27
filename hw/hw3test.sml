(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw/hw3.sml";

val test1_1 = only_capitals ["A","B","C"] = ["A","B","C"]
val test1_2 = only_capitals ["Abc","bcd","Cde"] = ["Abc","Cde"]
val test1_3 = only_capitals ["a","b","c"] = []

val test2_1 = longest_string1 ["A","bc","C"] = "bc"
val test2_2 = longest_string1 ["A","bc","C","ef","D"] = "bc"
val test2_3 = longest_string1 [] = ""

val test3_1 = longest_string2 ["A","bc","C"] = "bc"
val test3_2 = longest_string2 ["A","bc","C","ef","D"] = "ef"
val test3_3 = longest_string2 [] = ""

val test4a_1 = longest_string3 ["A","bc","C"] = "bc"
val test4a_2 = longest_string3 ["A","bc","C","ef","D"] = "bc"
val test4a_3 = longest_string3 [] = ""

val test4b_1 = longest_string4 ["A","bc","C"] = "bc"
val test4b_2 = longest_string4 ["A","bc","C","ef","D"] = "ef"
val test4b_3 = longest_string4 ["A","B","C"] = "C"
val test4b_4 = longest_string4 [] = ""

val test5_1 = longest_capitalized ["A","bc","D"] = "A"
val test5_2 = longest_capitalized ["a","bc","d"] = ""
val test5_3 = longest_capitalized ["Abc","def","GhIj","Kl"] = "GhIj"

val test6_1 = rev_string "abc" = "cba"
val test6_2 = rev_string "" = ""
val test6_3 = rev_string "aBCde" = "edCBa"

val test7_1 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test7_2 = first_answer (fn x => if x > 5 then SOME x else NONE) [1,2,3,4,5] handle NoAnswer => 1

val test8_1 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8_2 = all_answers (fn x => if x < 3 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8_3 = all_answers (fn x => if x > 1 then SOME [x,10] else NONE) [2,3,4] = SOME [2,10,3,10,4,10]

val test9a_1 = count_wildcards Wildcard = 1
val test9a_2 = count_wildcards (Variable("x")) = 0
val test9a_3 = count_wildcards UnitP = 0
val test9a_4 = count_wildcards (ConstP(42)) = 0
val test9a_5 = count_wildcards (TupleP([Variable("x"),UnitP,ConstP(10)])) = 0
val test9a_6 = count_wildcards (TupleP([Variable("x"),UnitP,Wildcard,ConstP(10)])) = 1
val test9a_7 = count_wildcards (ConstructorP("Ctor0",TupleP([Variable("x"),UnitP,ConstP(10)]))) = 0
val test9a_8 = count_wildcards (ConstructorP("Ctor2",TupleP([Wildcard,UnitP,Wildcard,ConstP(10)]))) = 2

val test9b_1 = count_wild_and_variable_lengths (Variable("a")) = 1
val test9b_2 = count_wild_and_variable_lengths (Variable("")) = 0
val test9b_3 = count_wild_and_variable_lengths (Variable("abc")) = 3
val test9b_4 = count_wild_and_variable_lengths Wildcard = 1
val test9b_5 = count_wild_and_variable_lengths UnitP = 0
val test9b_6 = count_wild_and_variable_lengths (ConstP(42)) = 0
val test9b_7 = count_wild_and_variable_lengths (TupleP([Variable("x"),UnitP,ConstP(10)])) = 1
val test9b_8 = count_wild_and_variable_lengths (ConstructorP("Ctor",TupleP([Variable("xyz"),Wildcard,UnitP,Wildcard,ConstP(10)]))) = 5

val test9c_1 = count_some_var ("xyz", Wildcard) = 0
val test9c_2 = count_some_var ("xyz", Variable("xyz")) = 1
val test9c_3 = count_some_var ("xyz", UnitP) = 0
val test9c_4 = count_some_var ("xyz", ConstP(10)) = 0
val test9c_5 = count_some_var ("xyz", TupleP([Variable("x"),UnitP,ConstP(10),Variable("xyz")])) = 1
val test9c_6 = count_some_var ("xyz", ConstructorP("xyz",TupleP([Variable("x"),UnitP,ConstP(10),Variable("xy")]))) = 0
val test9c_7 = count_some_var ("xyz", ConstructorP("xyz",TupleP([Variable("xyz"),UnitP,ConstP(10),Variable("xyz")]))) = 2

val test10_1 = check_pat (Variable("x")) = true
val test10_2 = check_pat (TupleP([Wildcard,Variable("abc"),ConstructorP("def",UnitP),Variable("ghi")])) = true
val test10_3 = check_pat (TupleP([Wildcard,Variable("abc"),ConstructorP("def",UnitP),Variable("abc")])) = false
val test10_4 = check_pat (TupleP([Wildcard,ConstructorP("def",UnitP)])) = true
val test10_5 = check_pat Wildcard = true
val test10_6 = check_pat (ConstructorP("abc",TupleP([Variable("abc"),Variable("def")]))) = true

val test11_1 = match (Const(1), UnitP) = NONE
val test11_2 = match (Const(1), ConstP(2)) = NONE
val test11_3 = match (Const(1), ConstP(1)) = SOME []
val test11_4 = match (Unit, UnitP) = SOME []
val test11_5 = match (Unit, ConstP(1)) = NONE
val test11_6 = match (Const(42), Variable("x")) = SOME [("x",Const(42))]
val test11_7 = match (Tuple([Const(1),Unit]), TupleP([ConstP(1),Variable("y")])) = SOME [("y",Unit)]
val test11_8 = match (Constructor("ctor",Tuple([Const(1),Unit,Tuple([Const(2),Const(3)])])),
                      ConstructorP("ctor",TupleP([Variable("a"),Wildcard,TupleP([Variable("b"),Variable("c")])])))
                      = SOME [("a",Const(1)), ("b",Const(2)), ("c",Const(3))]
val test11_9 = match (Constructor("ctor",Tuple([Const(1),Unit,Tuple([Const(2),Const(3)])])),
                      ConstructorP("ctor1",TupleP([Variable("a"),Wildcard,TupleP([Variable("b"),Variable("c")])])))
                      = NONE
val test11_10 = match (Tuple[Const 17,Unit,Const 4,Constructor ("egg",Const 4),Constructor ("egg",Constructor ("egg",Const 4))],
                       TupleP[Wildcard,Wildcard]) = NONE

val test12_1 = first_match Unit [UnitP] = SOME []
val test12_2 = first_match (Const(2)) [UnitP,ConstP(1),ConstP(2)] = SOME []
val test12_3 = first_match (Const(2)) [UnitP,ConstP(1),Variable("x"),ConstP(2)] = SOME [("x",Const(2))]
val test12_4 = first_match (Const(2)) [UnitP,ConstP(1)] = NONE
