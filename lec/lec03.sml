(* Functional Programming
    1. avoid mutation in most/all cases
    2. using functions as values
    -  encourage recursion and recursive data structures *)

(*  First-Class Functions: functions that can be used wherever we use values *)
(* Higher-Order Functions: functions whose argument/result is a first-class function
                           it's a powerful way to factor out common functionalities *)
(*     Function Closure  : functions can use bindings from outside the function definition
                           (in scope where function is defined) *)

(* ========== Anonymous Functions ========== *)

(* fun triple_n_times (n,x) = n_times (let fun triple x = 3*x in triple end, n, x) *)

(* an expression form for anonymous function: fn [arguments] => [function body] *)
val triple = fn x => 3*x
val x0 = triple 10

(* ========== Higher-Order Functions ========== *)

(* f(f(...f(x)...)): apply f on x n times *)
fun n_times (f,n,x) =
    if n = 0
    then x
    else f (n_times (f,n-1,x))

fun increment x = x + 1
fun double x = x + x

val x1 = n_times (increment, 5, 10)
val x2 = n_times (double, 3, 5)

fun triple_n_times (n,x) = n_times ((fn x => 3*x), n, x)

val x3 = triple_n_times (3,2)

(* f each xs *)
fun map (f,xs) =
    case xs of
          [] => []
        | x::xs' => (f x)::map(f,xs')

(* xs where f[xs] *)
fun filter (f,xs) =
    case xs of
        [] => []
        | x::xs' => if f x
                    then x::(filter (f,xs'))
                    else filter (f,xs')

fun double_or_triple f =
    if f 7
    then fn x => x * 2
    else fn x => x * 3

val double = double_or_triple (fn x => x - 3 = 4)
val x4 = double 15

datatype Expr = Constant of int
              | Negate of Expr
              | Add of Expr * Expr
              | Multiply of Expr * Expr

fun true_of_all_const (f,e) =
    case e of
          Constant i       => f i
        | Negate e1        => true_of_all_const (f,e1)
        | Add (e1,e2)      => true_of_all_const(f,e1) andalso true_of_all_const (f,e2)
        | Multiply (e1,e2) => true_of_all_const(f,e1) andalso true_of_all_const (f,e2)

val e = Add (Constant 2, Constant 3)
val x5 = true_of_all_const (fn x => x mod 2 = 0, e)

(* f(f(...f(f(acc,x[1]),x[2])...,x[n-1]),x[n]) *)
(* acc f/ xs *)
fun fold (f,acc,xs) =
    case xs of
          [] => acc
        | x::xs' => fold (f, f(acc,x), xs')

val x6 = fold (fn (acc,x) => acc+x, 10, [1,2,3])

(* do all elements of the list produce true when passed to g *)
fun all_true (g,xs) =
    fold (fn (acc,x) => acc andalso g x, true, xs)

(* ========== Lexical Scope ==========  *)

(* Lexical Scope: function body can access bindings in the scope where the function was defined/created *)
(* Function Closure: a function value has 2 parts
    (1) the function code, and
    (2) the environment that was current when the function was defined/created *)
(* A function call will evaluate the code part in the environment part *)
(* The advantage of lexical scope is:
    We can understand a function just by looking at its definition and what is in its environment.
    We never have to look at how it's called. *)

(* Function Composition *)
fun compose (f,g) = fn x => f (g x)

val abs_of_sqrt_compo = Math.sqrt o Real.fromInt o abs
val x7 = abs_of_sqrt_compo ~3

fun backup (f,g) =
    fn x => case f x of
                  NONE => g x
                | SOME y => y

(* Pipeline Operator *)
infix !>
fun x !> f = f x

fun abs_of_sqrt_pipe x =
    x !> abs !> Real.fromInt !> Math.sqrt

val x8 = abs_of_sqrt_pipe ~3

(* ========== Currying ========== *)

(* currying: a way to (conceptually) deal with multi-argument function *)
(* multi-args function: func takes 1 arg and returns a func that takes the next arg, and ... *)

val sorted3_curried = fn x => fn y => fn z => (z >= y) andalso (y >= x)
fun sorted3_nicer x y z = (z >= y) andalso (y >= x)  (* a syntactic sugar of the above def *)

val x9 = ((sorted3_curried 7) 9) 11
val x10 = sorted3_curried 7 9 11
val x11 = sorted3_nicer 7 9 11

fun curry f x y = f (x,y)
fun uncurry f (x,y) = f x y
fun other_curry f x y = f y x

(* ========== Partial Application ========== *)

fun fold_curried f acc xs =
    case xs of
          [] => acc
        | x::xs' => fold_curried f (f(acc,x)) xs'

val sum = fold_curried (fn (x,y) => x+y) 0
val x12 = sum [1,2,3]

fun range i j = if i > j then [] else i::range (i+1) j
val count_up = range 1
val x13 = count_up 6

fun exists predicate xs =
    case xs of
        [] => false 
        | x::xs' => (predicate x) orelse exists predicate xs'

val has_zero = exists (fn x => x = 0)
val x14 = has_zero [1,0,3]

(* ========== Callbacks ========== *)

(* Callback Idiom: lib takes functions to apply later, when an event occurs *)

(* mutable global states *)
val cbs : (int -> unit) list ref = ref []
val times_pressed = ref 0

(* := update the content of a reference *)
(* ! retrieve the content of a reference *)
fun register_cb f = cbs := f::(!cbs)

fun on_event i =
    let
        fun loop fs =
            case fs of
                  [] => ()
                | f::fs' => (f i; loop fs')
    in 
        loop (!cbs)
    end

fun print_if_pressed i =
    register_cb (fn j => if i=j then print ("pressed " ^ Int.toString(i) ^ "\n") else ())

(* register callbacks *)
val _ = register_cb (fn _ => times_pressed := (!times_pressed) + 1)
val _ = print_if_pressed 4
val _ = print_if_pressed 11
val _ = print_if_pressed 23
val _ = print_if_pressed 4

(* trigger callbacks when some events happen *)
val _ = on_event 1
val _ = on_event 4

(* ========== Abstract Data Types ========== *)

datatype set = S of { insert : int -> set,
                      member : int -> bool,
                      size   : unit -> int }

val empty_set = 
    let
        fun make_set xs =
            let
                fun contains i = List.exists (fn j => i=j) xs  (* a private method *)
            in
                S { insert = fn i => if contains i then make_set xs else make_set (i::xs),
                    member = contains,
                    size   = fn () => length xs }
            end
    in
        make_set []
    end

fun use_sets () =
    let
        val S s1 = empty_set
        val S s2 = (#insert s1) 34
        val S s3 = (#insert s2) 42
        val S s4 = (#insert s3) 18
    in
        if (#member s4) 56
        then 99
        else if (#member s4) 42
        then 17 + (#size s4) ()
        else 0
    end

val x15 = use_sets ()
