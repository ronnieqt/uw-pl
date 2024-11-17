(* This is a comment *)

(* ---------- Variables ---------- *)

val x = 34; (* int *)
(*  static env: x: int *)
(* dynamic env: x --> 34 *)

val y = 17;
(*  static env: x: int, y: int *)
(* dynamic env: x --> 34, y --> 17 *)

val z = (x+y) + (y+2);
(*  static env: x: int, y: int, z: int *)
(* dynamic env: x --> 34, y --> 17, z --> 70 *)

val abs_of_z = if z < 0 then 0 - z else z;

(* ---------- Functions ---------- *)

(* works only if y>=0 *)
fun pow(x: int, y: int) =
    if y = 0
    then 1
    else x * pow(x, y-1)

fun cube(x:int) = pow(x, 3);

val sixty_four = cube 4;

(* ---------- Data ---------- *)

(* Tuples : fixed number of pieces that may have different types *)
(* Pairs  : 2-tuples; (e1, e2) *)

val nested_tuple = (7, (true,9));

fun swap (pr: int*bool) = (#2 pr, #1 pr);

fun div_mod (x: int, y: int) =
    (x div y, x mod y)

(* Lists  : any number of pieces that all have the same type *)

val int_list = [7, 8, 9];
val int_list_appended = 5::6::int_list;  (* cons *)
val is_list_empty = null int_list;
val first_element = hd int_list;
val other_elements = tl int_list;

(* ---------- Function over a List ---------- *)

fun sum_list (xs: int list) =
    if null xs then 0
    else hd(xs) + sum_list(tl xs)

fun prod_list (xs: int list) =
    if null xs then 1
    else hd(xs) * prod_list(tl xs)

fun count_down (x: int) =
    if x = 0 then []
    else x::count_down(x-1)

fun append (xs: int list, ys: int list) =
    if null xs then ys
    else (hd xs) :: append((tl xs), ys)

(* val res = append([1,2,3], [4,5,6,7]) *)

(* ---------- Function over Pairs of Lists ---------- *)

fun sum_pair_list (xs: (int * int) list) =
    if null xs then 0
    else (#1 (hd xs)) + (#2 (hd xs)) + sum_pair_list(tl xs)

(* val res = sum_pair_list [(1,2), (3,4)] *)

fun firsts (xs: (int * int) list) =
    if null xs then []
    else (#1 (hd xs)) :: (firsts (tl xs))

(* val res = firsts [(1,2),(3,4)] *)

(* ---------- Let Expression ---------- *)
(* Purpose: create local bindings/variables *)
(* Syntax : let b1 b2 ... bn in e end *)

fun silly1 (z: int) =
    let
      val x = if z > 0 then z else 34
      val y = x + z + 9
    in
      if x > y then x * 2 else y * y
    end

fun silly2 () =
    let
        val x = 1
    in
        (let val x = 2 in x + 1 end)
        + (let val y = x + 2 in y + 1 end)
    end

(* val res = silly2(); *)

(* ---------- Nested Function ---------- *)
(* define helper functions inside the functions they helper if they are
 * unlikely to be useful elsewhere
 * likely to be misused if available elsewhere
 * likely to be changed or removed later *)

(* fun countup_from1 (x: int) =
    let
        fun count (from: int, to: int) =
            if from=to then to::[]
            else from::count(from+1,to)
    in
        count(1,x)
    end *)

fun countup_from1 (x: int) =
    let
        fun count (from: int) =
            if from=x then x::[]
            else from::count(from+1)
    in
        count(1)
    end

(* val res = countup_from1 7; *)

(* ---------- Options ---------- *)
(* like a list with 0/1 element *)

(* fn : int list -> int option *)
fun max1 (xs: int list) =
    if null xs
    then NONE
    else
        let
            val tl_max = max1(tl xs)
        in
            if isSome tl_max andalso valOf tl_max > hd xs
            then tl_max
            else SOME (hd xs)
        end

fun max2 (xs: int list) =
    if null xs
    then NONE
    else
        let
            fun max_nonempty (xs: int list) =
                if null (tl xs)
                then hd xs
                else
                    let
                        val tl_max = max_nonempty(tl xs)
                    in
                        if hd xs > tl_max
                        then hd xs
                        else tl_max
                    end
        in
            SOME (max_nonempty xs)
        end

val res = max2 [3, 7, 5]

