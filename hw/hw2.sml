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

(* ----- (2.a) ----- *)

(* takes a card and returns its color *)
fun card_color c =
    case c of
          (Spades  , _) => Black
        | (Clubs   , _) => Black
        | (Diamonds, _) => Red
        | (Hearts  , _) => Red

(* ----- (2.b) ----- *)

(* takes a card and returns its value *)
fun card_value c =
    case c of
          (_, Num x) => x
        | (_, Ace  ) => 11
        | _          => 10

(* ----- (2.c) ----- *)

(* returns a list that has all the elements of cs except c
   if c is not in the list, raise the exception e *)
fun remove_card (cs, c, e) =
    let
        fun aux (cs_prev, cs_next, c, e) =
            case cs_next of
                  [] => raise e
                | (c'::cs') => if c=c'
                               then cs_prev @ cs'
                               else aux (cs_prev @ [c'], cs', c, e)
    in
        aux ([], cs, c, e)
    end

(* ----- (2.d) ----- *)

(* takes a list of cards and returns true if all the cards in the list are the same color *)
fun all_same_color cs =
    case cs of
          [] => true
        | _::[] => true
        | c1::(c2::rest) => card_color(c1) = card_color(c2) andalso all_same_color (c2::rest)

(* ----- (2.e) ----- *)

(* takes a list of cards and returns the sum of their values *)
fun sum_cards cs =
    let
        fun aux (cs, acc) =
            case cs of
                  [] => acc
                | c::cs' => aux(cs', acc + card_value c)
    in
        aux (cs, 0)
    end

(* ----- (2.f) ----- *)

(* sum of the values of the held-cards.
   if sum is greater than goal, the preliminary score is three times (sum−goal),
   else the preliminary score is (goal − sum). *)
(* the score is the preliminary score unless all the held-cards are the same color,
   in which case the score is the preliminary score divided by 2 *)
fun score (cs,g) =
    let
        val s = sum_cards cs;
        val ps = if s>g then 3*(s-g) else (g-s)
    in
        if all_same_color (cs) then (ps div 2) else ps
    end

(* ----- (2.g) ----- *)

(* runs a game and returns the score at the end of the game
   cs : card list
   hs : held-card list
   ms : move list
   g  : goal *)
fun officiate (cs, ms, g) =
    let
        fun step (cs, hs, ms, g) =
            case ms of
                  [] => score (hs,g)
                | (m::ms') => case m of
                                    Discard x => step (cs, remove_card (hs,x,IllegalMove), ms', g)
                                  | Draw => case cs of
                                                  [] => score (hs,g)
                                                | (c::cs') => let
                                                                  val hs_new = hs @ [c]
                                                              in
                                                                  if sum_cards (hs_new) > g
                                                                  then score (hs_new,g)
                                                                  else step (cs', hs_new, ms', g)
                                                              end
    in
        step (cs, [], ms, g)
    end
