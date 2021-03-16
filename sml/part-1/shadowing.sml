(* Examples to Demonstrate Shadowing *)

val a = 10

val b = 2

val b = a * 2

val a = 5

val c = b

val d = a

val a = a + 1

(* next line does not type-check, f not in environment *)
(* val g = f - 3  *)

val f = a * 2

val a = 500

(*
use "sml/part-1/shadowing.sml";; 
*)