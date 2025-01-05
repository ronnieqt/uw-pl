(* ========== Records ========== *)

(* Records are similar to Tuples: (4,7,9) vs. {f=4, g=7, h=9} *)
(* Tuples are Records with particular field names 1,2,...,n *)
(* Tuples are just syntactic sugar for Records *)
(* Records and Tuples are each-of types; e.g. a type (int * bool) value contains each of int bool *)

val x = { bar=(1+2,true andalso true), foo=3+4, baz=(false,9) };
val y = #bar x;

val a_pair = (1+2, 3+4);
val record1 = {first=1+2, second=3+4};
(* NOTE: tuple is just a different way of writing records *)
val record2 = {1=1+2, 2=3+4};  (* a record's type becomes int * int - a tuple *)
val record2 = {1=1+2, 3=3+4};

(* ========== Datetype ========== *)

(* datatype is a one-of type *)

(* any value of MyType is made from one of the ctors *)
datatype MyType = TwoInts of int * int
                | Str of string
                | Pizza;  (* Pizza is a value *)

val a = Str "hi";
val b = Str;
val c = Pizza;
val d = TwoInts(1+2, 3+4);
val e = a;

fun f (x : MyType) : int =
    (* type-checker will check if we have left any "case" out *)
    case x of
        Pizza => 3                    (* p1: ctor name          *)
        | Str s => 8                  (* p2: ctor name + 1 var  *)
        | TwoInts(i1,i2) => i1 + i2;  (* p3: ctor name + 2 vars *)

val res1 = f Pizza;
val res2 = f (Str "hi");
val res3 = f (TwoInts(10,20));

(* enumerations *)
datatype Suit = Club | Diamond | Heart | Spade;
datatype Rank = Jack | Queen | King | Ace | Num of int;
type Card = Suit * Rank;  (* type synonyms: Card and Suit * Rank can be used interchangeably *)

val c: Card = (Club, King);

datatype id = StudentNum of int
            | Name of string;

(* expression trees *)
datatype Expr = Constant of int
              | Negate   of Expr
              | Add      of Expr * Expr
              | Multiply of Expr * Expr;

fun eval(e : Expr): int =
    case e of
        Constant i        => i
        | Negate e2       => ~(eval e2)
        | Add(e1,e2)      => (eval e1) + (eval e2)
        | Multiply(e1,e2) => (eval e1) * (eval e2);

val res_expr_eval = eval( Negate( Add(Constant(1), Constant(2)) ) );

(* fun max_const(e: Expr): int =
    let
        fun max_of_two(e1,e2) =
            let
                val m1 = max_const(e1);
                val m2 = max_const(e2);
            in
                if m1 > m2 then m1 else m2
            end
    in
        case e of
            Constant i        => i
            | Negate e2       => max_const(e2)
            | Add(e1,e2)      => max_of_two(e1,e2)
            | Multiply(e1,e2) => max_of_two(e1,e2)
    end *)

fun max_const(e: Expr): int =
    case e of
        Constant i        => i
        | Negate e2       => max_const(e2)
        | Add(e1,e2)      => Int.max(max_const e1, max_const e2)
        | Multiply(e1,e2) => Int.max(max_const e1, max_const e2)

val test_expr = Add(Constant(19), Negate(Constant(4)));
val nineteen = max_const(test_expr);

(* options are just a pre-defined datatype binding; NONE and SOME are ctors *)
(* datatype 'a option = NONE | SOME of 'a *)
fun inc_or_zero(int_opt) =
    case int_opt of
        NONE => 0
        | SOME i => i + 1;

(* MyIntOption *)
datatype MyIntOption = MyNone
                     | MySome of int;

val my_int_opt = MySome 10;

fun get_val_from_my_opt(x : MyIntOption) =
    case x of
        MyNone => ~1
        | MySome(v) => v;

val my_val = get_val_from_my_opt(my_int_opt);

(* MyIntList *)
datatype MyIntList = EmptyInt
                   | ConsInt of int * MyIntList;

fun sum_my_int_list (xs : MyIntList) =
    case xs of
        EmptyInt => 0
        | ConsInt(x,xs') => x + sum_my_int_list(xs')

val my_int_list = ConsInt(4, ConsInt(23, ConsInt(2008, EmptyInt)));
val sum_my_int_list = sum_my_int_list(my_int_list);

datatype 'a MyList = Empty | Cons of 'a * 'a MyList;
val my_list_int = Cons(1, Cons(2, Cons(3, Empty)));
val my_list_real = Cons(1.1, Cons(2.2, Cons(3.3, Empty)));

(* Lists are also pre-defined datatype bindings; [] and :: are ctors *)
fun sum_list (xs) =
    case xs of
        [] => 0
        | x::xs' => x + sum_list(xs');

val res4 = sum_list([1,2,3]);

(* polymorphic datatypes *)

datatype ('a,'b) MyTree = MyNode of 'a * ('a,'b) MyTree * ('a,'b) MyTree
                        | MyLeaf of 'b;

fun num_leaves(tr) =
    case tr of
        MyLeaf(i) => 1
        | MyNode(i,lft,rgt) => num_leaves(lft) + num_leaves(rgt)

(* ========== Function Argument Patterns ========== *)

(* fun p = e *)
fun full_name {first=x, last=y} =
    x ^ " " ^ y

val my_name = full_name {first="Tom", last="Cruise"};

(* a function taking 3 int args <=> a function taking 1 3-element tuple arg *)
(* NOTE: in ML, every function takes exactly 1 argument *)
fun sum_triple (x,y,z) =
    x + y + z

val res5 = sum_triple (1,2,3);

(* ========== Nested Patterns ========== *)

exception ListLengthMismatch

fun zip3 list_triple =
    case list_triple of
        ([], [], []) => []
        | (hd1::tl1, hd2::tl2, hd3::tl3) => (hd1,hd2,hd3)::zip3(tl1,tl2,tl3)
        | _ => raise ListLengthMismatch

val res6 = zip3 ([1,2,3,4], [5,6,7,8], [9,10,11,12])

fun unzip3 lst =
    case lst of
        [] => ([],[],[])
        | (a,b,c)::tl_lst =>  (* nested patterns: x::xs -> (a,b,c)::tl_lst *)
            let
                val (l1,l2,l3) = unzip3 tl_lst
            in
                (a::l1, b::l2, c::l3)
            end

val res7 = unzip3([(1,2,3),(4,5,6)])

fun non_desc xs =
    case xs of
        [] => true
        | _::[] => true  (* _: wildcard *)
        | x::(y::zs) => (x <= y) andalso (non_desc (y::zs))

val res8 = non_desc [1,2,3]
val res9 = non_desc [2,1,3]

(* ========== Exceptions ========== *)

exception MyException1
exception MyException2 of int * int  (* an exception carrying value(s) *)

fun my_hd xs =
    case xs of
          [] => raise List.Empty
        | x::_ => x

fun max_list (xs,ex) =
    case xs of
        [] => raise ex
        | x::[] => x
        | x::xs' => Int.max(x, max_list(xs',ex))

val res10 = max_list([1,20,3], MyException1)
val res11 = max_list([], MyException2(4,5))
            handle MyException2(4,5) => 42  (* catching exceptions *)
val res12 = max_list([], MyException2(4,5))
            handle MyException2(_,_) => 43  (* pattern matching *)

(* ========== Tail Recursions ========== *)

(* stack-frames store information like
    - the value of local variables and
    - "what is left to do" in the function *)

(* Tail recursion:
    - no more work to do by the caller after we complete the recursive call
    - nothing left for caller to do *)

(* Purposes of the accumulator:
       1. combine answers as we go along
       2. hold the answer so far
   It works when we can combine the results in any order *)

(* initial value of the accumulator: base case of the "vanilla" recursion
   the result of this recursive function will be: the final value stored in the accumulator *)

fun fact n =
    let
        fun aux (n,acc) =
            if n = 0  (* base case *)
            then acc
            else aux (n-1, acc*n)
    in
        aux(n,1)  (* 1: base case *)
    end

val res13 = fact 5

fun sum_tailr xs =
    let
        fun aux (xs,acc) =
            case xs of
                [] => acc
                | x::xs' => aux(xs',acc+x)
    in
        aux(xs,0)
    end

val res14 = sum_tailr [1,3,5]
