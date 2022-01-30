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

(*
write a function fixed_point: (a -> a) -> a -> a 
that given a function f and an initial value x applies f to x until f x = x
*)

fun fixed_point f = do_until f (fn x => f x = x)

(*
Write a function map2 : (’a -> ’b) -> ’a * ’a -> ’b * ’b 
that given a function that takes ’a values to ’b values and a pair of ’a values
returns the corresponding pair of ’b values.
*)

fun map2 (f,g) = (* map2 ((fn x => 2*x), (4,5)) *)
    case g of
        (x, y) => (f x, f y)

(* 
Foldr Vs Foldl 
Left vs Right folds
*)

fun foldl (f,acc,xs) =
    case xs of
        [] => acc
      | x::xs' => foldl (f, f(acc,x), xs')

(* val foldl = fn : ('a * 'b -> 'a) * 'a * 'b list -> 'a *)

fun foldr (f,acc,xs) =
    case xs of
        [] => acc
      | x::xs' => foldr (f, f(x, acc), xs')

(*
- List.foldr (fn (x,y) => x-y) 54 [10, 1, 2, 3];
val it = 62 : int

Fold from the right
10- (1 -(2 -(3 - 54))) = 62

- List.foldl (fn (x,y) => x-y) 54 [10, 1, 2, 3];
val it = 46 : int

Fold from the left
54 - (10- (1- (2 - 3))) = 46
*)

(*
Implement Map using List.foldr
*)

fun map f xs = (* map (fn x => x+1) [1,2,3] *)
  List.foldr (fn (x,y) => [f x] @ y) [] xs

(*
Implement Filter using List.foldr
*)
fun filter f xs = (* filter (fn x => x>10) [1,2,3,20] *)
  List.foldr (fn (x,y) => if f x then [x] @ y else y) [] xs

(*
Implement foldl using foldr (Challenging)

https://stackoverflow.com/questions/29715959/defining-foldl-in-terms-of-foldr-in-standard-ml
*)
fun foldl_using_foldr f acc xs = (* foldl_using_foldr (fn (x,y) => x-y) 54 [10, 1, 2, 3];*)
    let
      fun g(x, g) y = g(f(x, y))
    in
      List.foldr g (fn x => x) xs acc
    end
