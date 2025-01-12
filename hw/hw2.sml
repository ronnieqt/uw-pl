(* Dan Grossman, Coursera PL, HW2 *)

(* ========== Problem 1: first-name substitutions ========== *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* ----- (1.a) ----- *)

(* if the string (x) is not in the list (ys), return NONE;
   else return SOME lst where lst is identical to ys except the string is not in it. *)
fun all_except_option (x,ys) =
    let
        fun aux (x,ys_prev,ys_rest) =
            case ys_rest of
                  [] => NONE
                | (y::ys') => if same_string (x,y)
                              then SOME (ys_prev @ ys')
                              else aux (x, ys_prev @ [y], ys')
    in
        aux (x,[],ys)
    end

(* ----- (1.b) ----- *)

(* The result has all the strings that are in some list in substitutions that also has s,
   but s itself should not be in the result. *)
fun get_substitutions1 (subs, s) =
    case subs of
          [] => []
        | (sub::subs') => case all_except_option (s,sub) of
                                NONE => get_substitutions1 (subs',s)
                              | SOME xs => xs @ get_substitutions1 (subs',s)

(* ----- (1.c) ----- *)

fun get_substitutions2 (subs, s) =
    let
        fun aux (subs, s, acc)  =
            case subs of
                  [] => acc
                | (sub::subs') => case all_except_option (s,sub) of
                                        NONE => aux (subs', s, acc)
                                      | SOME xs => aux (subs', s, acc @ xs)
    in
        aux (subs, s, [])
    end

(* ----- (1.d) ----- *)

fun similar_names (subs, {first=f, middle=m, last=l}) =
    let
        fun build_names (subs, m, l, acc) =
            case subs of
                  [] => acc
                | (s::subs') => build_names (subs', m, l, acc @ [{first=s, middle=m, last=l}])
    in
        build_names (get_substitutions2 (subs, f), m, l, [{first=f, middle=m, last=l}])
    end

(* ========== Problem 2: solitaire card game ========== *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* put your solutions for problem 2 here *)

(* ========== tests ========== *)

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


