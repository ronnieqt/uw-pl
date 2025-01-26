(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

(**** you can put all your code here ****)

(* ========== (1) ========== *)

fun only_capitals xs =
    List.filter (fn x => Char.isUpper (String.sub (x, 0))) xs

(* ========== (2) ========== *)

fun longest_string1 xs =
    List.foldl (fn (acc,x) => if String.size acc <= String.size x then x else acc) "" xs

(* ========== (3) ========== *)

fun longest_string2 xs =
    List.foldl (fn (acc,x) => if String.size acc < String.size x then x else acc) "" xs

(* ========== (4) ========== *)

fun longest_string_helper f xs =
    List.foldl (fn (acc,x) => if f (String.size acc, String.size x) then x else acc) "" xs

val longest_string3 = longest_string_helper (fn (x,y) => x <= y)
val longest_string4 = longest_string_helper (fn (x,y) => x < y)

(* ========== (5) ========== *)

val longest_capitalized = longest_string3 o only_capitals

(* ========== (6) ========== *)

val rev_string = String.implode o List.rev o String.explode

(* ========== (7) ========== *)

fun first_answer f xs =
    case xs of
          [] => raise NoAnswer
        | x::xs' => case f x of
                          SOME v => v
                        | NONE => first_answer f xs'

(* ========== (8) ========== *)

fun all_answers f xs =
    let
        fun aux (xs,acc) =
            case xs of
                  [] => SOME acc
                | x::xs' => case f x of
                                  NONE => NONE
                                | SOME v => aux(xs',acc@v)
    in
        aux(xs,[])
    end

(* ========== (9) ========== *)

datatype pattern =
          Wildcard
		| Variable of string
		| UnitP
		| ConstP of int
		| TupleP of pattern list
		| ConstructorP of string * pattern

datatype valu =
          Const of int
	    | Unit
	    | Tuple of valu list
	    | Constructor of string * valu

fun g f1 f2 p =
    let
	    val r = g f1 f2
    in
        case p of
              Wildcard          => f1 ()
            | Variable x        => f2 x
            | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
            | ConstructorP(_,p) => r p
            | _                 => 0
    end

(* ---------- (9.a) ---------- *)

val count_wildcards = g (fn () => 1) (fn x => 0)

(* ---------- (9.b) ---------- *)

val count_wild_and_variable_lengths = g (fn () => 1) (fn x => String.size x)

(* ---------- (9.c) ---------- *)

fun count_some_var (s,p) =
    g (fn () => 0) (fn x => if x=s then 1 else 0) p

(* ========== (10) ========== *)

fun check_pat p =
    let
        fun all_var_names p =
            case p of
                  Variable x => [x]
                | TupleP ps => List.foldl (fn (p,acc) => acc @ all_var_names(p)) [] ps
                | ConstructorP (_,p) => all_var_names p
                | _ => []
        fun has_repeats xs =
            let
                fun aux (xs,acc) =
                    case xs of
                          [] => false
                        | x::xs' => if List.exists (fn y => x=y) acc
                                    then true
                                    else aux (xs',x::acc)
            in
                aux (xs,[])
            end
    in
        (not o has_repeats o all_var_names) p
    end

(* ========== (11) ========== *)

fun match (v,p) =
    case (v,p) of
          (_                , Wildcard          ) => SOME []
        | (v                , Variable(s)       ) => SOME [(s,v)]
        | (Unit             , UnitP             ) => SOME []
        | (Const(x)         , ConstP(y)         ) => if x=y then SOME [] else NONE
        | (Tuple(vs)        , TupleP(ps)        ) => all_answers match (ListPair.zip (vs,ps))
        | (Constructor(s1,v), ConstructorP(s2,p)) => if s1=s2 then match (v,p) else NONE
        | _                                       => NONE

(* ========== (12) ========== *)

fun first_match v ps =
    let
        fun curry f x y = f (x,y)
    in
        SOME (first_answer (curry match v) ps) handle NoAnswer => NONE
    end

(**** for the challenge problem only ****)

datatype typ =
          Anything
	    | UnitT
	    | IntT
	    | TupleT of typ list
	    | Datatype of string
