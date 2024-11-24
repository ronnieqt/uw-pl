(* Calendar Dates *)

(* Notes:
 * There are no "assignments", there are "variable bindings".
 * Forget "for/while loops"; you can do the same with recursion instead.
 * Avoid recomputing a value when possible.
   Using #1, #2, hd, tl doesn't really cost anything,
   but other computations should probably be stored if they are repeated.
 *)

fun is_older(d1: int*int*int, d2: int*int*int) =
    if (#1 d1) <> (#1 d2)
    then (#1 d1) < (#1 d2)
    else
        if (#2 d1) <> (#2 d2)
        then (#2 d1) < (#2 d2)
        else (#3 d1) < (#3 d2)

fun is_in_month(d: int*int*int, m: int) =
    (#2 d) = m

fun number_in_month(ds: (int*int*int) list, m: int) =
    if null ds
    then 0
    else (if is_in_month(hd ds, m) then 1 else 0) + number_in_month(tl ds, m)

fun number_in_months(ds: (int*int*int) list, ms: int list) =
    if null ms
    then 0
    else number_in_month(ds, hd ms) + number_in_months(ds, tl ms)

fun dates_in_month(ds: (int*int*int) list, m: int) =
    if null ds
    then []
    else if is_in_month(hd ds, m)
    then (hd ds) :: dates_in_month(tl ds, m)
    else dates_in_month(tl ds, m)

fun dates_in_months(ds: (int*int*int) list, ms: int list) =
    if null ms
    then []
    else dates_in_month(ds, hd ms) @ dates_in_months(ds, tl ms)

fun get_nth(xs: string list, n: int) =
    if n = 1
    then hd xs
    else get_nth(tl xs, n-1)

fun month_to_string(m: int) =
    get_nth(["January","February","March","April","May","June","July","August","September","October","November","December"], m)

fun date_to_string(d: int*int*int) =
    let
        val y_str = Int.toString(#1 d)
        val m_str = month_to_string(#2 d)
        val d_str = Int.toString(#3 d)
    in
        m_str ^ " " ^ d_str ^ ", " ^ y_str
    end

fun number_before_reaching_sum(s: int, xs: int list) =
    if s <= (hd xs)
    then 0
    else 1 + number_before_reaching_sum(s - (hd xs), tl xs)

fun what_month(doy: int) =
    1 + number_before_reaching_sum(doy, [31,28,31,30,31,30,31,31,30,31,30,31])

fun month_range(doy1: int, doy2: int) =
    if doy1 > doy2
    then []
    else what_month(doy1) :: month_range(doy1+1, doy2)

fun oldest(ds: (int*int*int) list) =
    if null ds
    then NONE
    else
        let
            fun oldest_nonempty(ds: (int*int*int) list) =
                if null (tl ds)
                then hd ds
                else
                    let
                        val tl_oldest = oldest_nonempty(tl ds)
                    in
                        if is_older(hd ds, tl_oldest) then hd ds else tl_oldest
                    end
        in
            SOME (oldest_nonempty ds)
        end

fun is_in(x: int, ys: int list) =
    if null ys
    then false
    else
        if x = hd ys
        then true
        else is_in(x, tl ys)

fun remove_duplicates(xs: int list) =
    if null xs
    then []
    else
        let
            val tail_no_dup = remove_duplicates(tl xs)
            val x = hd xs
        in
            if is_in(x, tail_no_dup)
            then tail_no_dup
            else x::tail_no_dup
        end

fun number_in_months_challenge(ds: (int*int*int) list, ms: int list) =
    number_in_months(ds, remove_duplicates(ms))

fun dates_in_months_challenge(ds: (int*int*int) list, ms: int list) =
    dates_in_months(ds, remove_duplicates(ms))

fun reasonable_date(d: int*int*int) =
    let
        fun nth(xs: 'a list, n: int) =
            if n = 1
            then hd xs
            else nth(tl xs, n-1)
        fun valid_yy(d: int*int*int) =
            (#1 d) > 0
        fun valid_mm(d: int*int*int) =
            ((#2 d) >= 1) andalso ((#2 d) <= 12)
        fun valid_dd(d: int*int*int) =
            let
                val yy = #1 d
                val mm = #2 d
                val is_leap_year = ((yy mod 400) = 0) orelse (((yy mod 4) = 0) andalso ((yy mod 100) <> 0))
                val n_days = if is_leap_year
                             then nth([31,29,31,30,31,30,31,31,30,31,30,31], mm)
                             else nth([31,28,31,30,31,30,31,31,30,31,30,31], mm)
            in
                ((#3 d) > 0) andalso ((#3 d) <= n_days)
            end
    in
        valid_yy(d) andalso valid_mm(d) andalso valid_dd(d)
    end
