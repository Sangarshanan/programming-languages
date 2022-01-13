(* https://classes.engineering.wustl.edu/cse425s/index.php?title=SML_Practice_Problems_C *)


(*
Write a function do_until : (’a -> ’a) -> (’a -> bool) -> ’a -> ’a. 
`do_until f p x` will apply f to x and f again to that result and so on until p x is false.
*)

fun do_until f p x =
    if p x = false
    then x
    else do_until f p (f x)

(* function of type int->int that divides its argument by 2 until it reaches an odd number. *)
do_until (fn x => x div 2) (fn x => x mod 2 <> 1) 20 = 5

(* Use do_until to implement factorial. *)

fun factorial n =
  # 1 (do_until (fn (starter,x) => (starter*x, x-1)) (fn (_,x) => x <> 0) (1,n))

factorial 5 = 120

(* write a function fixed_point: (a -> a) -> a -> a 
that given a function f and an initial value x applies f to x until f x = x
*)

fun fixed_point f = do_until f (fn x => f x = x)