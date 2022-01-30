(*
use "sml/part-1/list_stuff.sml";

sum_list [1,2,3];
countdown 6;
factorial 6;
*)

(*Add all elements in a list*)
fun sum_list (xs : int list) =
    if null xs
    then 0
    else hd xs + sum_list(tl xs);

(*Multiplies all elements in a list*)
fun product_list (xs : int list) =
    if null xs
    then 1
    else hd xs * product_list(tl xs);

(* CountDown *)
fun countdown (n : int) =
    if n = 0
    then []
    else n :: countdown(n-1)

(*Append two lists*)
fun append (xs : int list, ys : int list) =
    if null xs
    then ys
    else (hd xs) :: append ((tl xs), ys);

(*First element in a list of lists `[(1,2), (3,4)] -> [1,3]`*)
fun firsts (xs : (int * int) list) =
    if null xs
    then []
    else (#1 (hd xs)) :: firsts (tl xs);

(* Factorial *)
fun factorial (n: int) = 
    if n = 0
    then 1
    else product_list (countdown(n))
