(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw/hw2.sml";

(* ========== Problem 1: first-name substitutions ========== *)

val test1_1 = all_except_option ("string", ["string"]) = SOME []
val test1_2 = all_except_option ("str2", ["str1","str2","str3"]) = SOME ["str1","str3"]
val test1_3 = all_except_option ("str4", ["str1","str2","str3"]) = NONE

val test2_1 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test2_2 = get_substitutions1 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred") = ["Fredrick","Freddie","F"]
val test2_3 = get_substitutions1 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred1") = []
val test2_4 = get_substitutions1 ([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") = ["Jeffrey","Geoff","Jeffrey"]

val test3_1 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test3_2 = get_substitutions2 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred") = ["Fredrick","Freddie","F"]
val test3_3 = get_substitutions2 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred1") = []
val test3_4 = get_substitutions2 ([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") = ["Jeffrey","Geoff","Jeffrey"]

val test4_1 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]
val test4_2 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred1", middle="W", last="Smith"}) =
        [{first="Fred1", middle="W", last="Smith"}]
val test4_3 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Elizabeth", middle="A", last="Wong"}) =
        [{first="Elizabeth", middle="A", last="Wong"}, {first="Betty", middle="A", last="Wong"}]

(* ========== Problem 2: solitaire card game ========== *)

val test5_1 = card_color (Clubs, Num 2) = Black
val test5_2 = card_color (Diamonds, Num 6) = Red

val test6_1 = card_value (Clubs, Num 2) = 2
val test6_2 = card_value (Hearts, Num 5) = 5
val test6_3 = card_value (Spades, Ace) = 11
val test6_4 = card_value (Spades, King) = 10

val test7_1 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
val test7_2 = remove_card ([(Hearts, Ace), (Clubs, Num 3), (Diamonds, King), (Clubs, Num 3)], (Clubs, Num 3), IllegalMove) =
    [(Hearts, Ace), (Diamonds, King), (Clubs, Num 3)]
val test7_3 = (remove_card ([(Hearts, Ace)], (Hearts, Queen), IllegalMove) handle IllegalMove => []) = []

val test8_1 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test8_2 = all_same_color [(Spades, Ace), (Clubs, King)] = true
val test8_3 = all_same_color [(Diamonds, Ace), (Hearts, King)] = true
val test8_4 = all_same_color [(Diamonds, Ace), (Clubs, King)] = false

val test9_1 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test9_2 = sum_cards [] = 0
val test9_3 = sum_cards [(Clubs, Num 1),(Hearts, Num 2)] = 3
val test9_4 = sum_cards [(Clubs, Num 1),(Hearts, Num 2),(Spades, Ace)] = 14
val test9_5 = sum_cards [(Clubs, Queen),(Hearts, King),(Spades, Ace)] = 31

val test10_1 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test10_2 = score ([(Hearts, Num 8),(Clubs, Num 4)],10) = 6
val test10_3 = score ([(Spades, Num 8),(Clubs, Num 4)],10) = 3
val test10_4 = score ([],10) = 5

val test11_1 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6
val test11_2 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                          [Draw,Draw,Draw,Draw,Draw], 42) = 3
val test11_3 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                           [Draw,Discard(Hearts,Jack)],
                           42); false) handle IllegalMove => true)
