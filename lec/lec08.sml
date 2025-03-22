datatype Expr = 
      Int    of int 
    | Negate of Expr
    | Add    of Expr * Expr

exception BadResult of string

fun eval e =
    case e of
          Int _      => e 
        | Negate e1  => (case (eval e1) of
                              Int i => Int (~i)
                            | _ => raise BadResult "non-int in negation")
        | Add(e1,e2) => (case (eval e1, eval e2) of
                              (Int i, Int j) => Int (i+j)
                            | _ => raise BadResult "non-values passed to add_values")

fun to_string e =
    case e of 
          Int i      => Int.toString i
        | Negate e1  => "-(" ^ (to_string e1) ^ ")"
        | Add(e1,e2) =>  "(" ^ (to_string e1) ^ " + " ^ (to_string e2) ^ ")"

fun has_zero e =
    case e of 
          Int i      => i=0
        | Negate e1  => has_zero e1
        | Add(e1,e2) => (has_zero e1) orelse (has_zero e2)

val e = Add(Add(Int(3),Negate(Int(2))),Int(0))
val s = to_string e
val v = eval e
val t = has_zero e
