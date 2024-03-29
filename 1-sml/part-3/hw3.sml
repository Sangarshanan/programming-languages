(* Coursera Programming Languages, Homework 3, Provided Code *)

(* 1
Write a function only_capitals that takes a string list and returns a string list that has only
the strings in the argument that start with an uppercase letter. Assume all strings have at least 1
character. Use List.filter, Char.isUpper, and String.sub to make a 1-2 line solution
*)

fun only_capitals sl = List.filter (fn s => Char.isUpper(String.sub (s, 0))) sl

(* 2
Write a function longest_string1 that takes a string list and returns the longest string in the
list. If the list is empty, return "". In the case of a tie, return the string closest to the beginning of the
list. Use foldl, String.size
*)

fun longest_string1 sl = List.foldl (
	fn (s, acc) => if (String.size s > String.size acc) then s else acc) 
	"" 
	sl

(* 3
Write a function longest_string2 that is exactly like longest_string1 except in the case of ties
it returns the string closest to the end of the list. Your solution should be almost an exact copy of
longest_string1. Still use foldl and String.size
*)

fun longest_string2 sl = List.foldl (
	fn (s, acc) => if (String.size s >= String.size acc) then s else acc) 
	"" 
	sl

(* 4
Write longest_string_helper of type (int * int -> bool) -> string list -> string
notice the currying so it takes a fun as argument
If longest_string_helper is passed a function that behaves like > 
(so it returns true exactly when its first argument is stricly greater than its second)
then the function returned has the same behavior as longest_string1
*)

fun longest_string_helper f sl =
    List.foldl (fn (s, acc) => if f(String.size s, String.size acc) then s else acc) "" sl

(* 5
longest_string3 has the same behavior as longest_string1 and longest_string4 has the
same behavior as longest_string2.
These are defined with val-bindings and partial applications of longest_string_helper
*)

fun longest_string3(sl: string list) =
    let
        val greater = fn (a, b) => a > b
    in
        longest_string_helper greater sl
    end

fun longest_string4(sl: string list) =
    let
        val greater_or_equal = fn (a, b) => a >= b
    in
        longest_string_helper greater_or_equal sl
    end

(* 6
Write a function longest_capitalized that takes a string list and returns the longest string in
the list that begins with an uppercase letter, or "" if there are no such strings. Assume all strings
have at least 1 character. Use a val-binding and the ML librarys `o` operator for composing functions.
*)

fun longest_capitalized sl =
    let
        val longest_cap_fun = (longest_string1 o only_capitals)
    in
        longest_cap_fun sl
    end

(* 7
Write a function rev_string that takes a string and returns the string that is the same characters in
reverse order. Use ML o operator, the library function rev for reversing lists, and two library functions
in the String module. (Browse the module documentation to find the most useful functions.)
*)

fun rev_string s = (String.implode o List.rev o String.explode) s

(* 8
Write a function first_answer of type (’a -> ’b option) -> ’a list -> ’b (notice the 2 arguments are curried). 
The first argument should be applied to elements of the second argument in order
until the first time it returns SOME v for some v and then v is the result of the call to first_answer.
If the first argument returns NONE for all list elements, then first_answer should raise exception
*)
exception NoAnswer

fun first_answer f l =
    case l of
        [] => raise NoAnswer
      | x::xs => case f(x) of
                     NONE => first_answer f xs
                   | SOME value => value

(*9
Write a function all_answers of type (’a -> ’b list option) -> ’a list -> ’b list option
If it returns NONE for any element, then the result for all_answers is NONE. Else the
calls to the first argument will have produced SOME lst1, SOME lst2, ... SOME lstn and the result of
all_answers is SOME lst where lst is lst1, lst2, ..., lstn appended together
*)

fun all_answers f lst =
    let
        fun f_int (f, lst, acc) = 
			case lst of
				[] => SOME acc
				| x::xs => case f(x) of
							NONE => NONE
							| SOME v => f_int(f, xs, v @ acc)
    in
        f_int(f, lst, [])
    end

(*
PART QUESTION
*)

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
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

(* 10
Use g to define a function count_wildcards that takes a pattern and returns how many Wildcard
patterns it contain
*)

fun count_wildcards p = g (fn () => 1) (fn _ => 0) p

(* 11
Use g to define a function count_wild_and_variable_lengths that takes a pattern and returns
the number of Wildcard patterns it contains plus the sum of the string lengths of all the variables
in the variable patterns it contains. (Use String.size. We care only about variable names; the
constructor names are not relevant.)
*)

fun count_wild_and_variable_lengths p =  g (fn () => 1) (fn x => String.size x) p

(*12
Use g to define a function count_some_var that takes a string and a pattern (as a pair) and
returns the number of times the string appears as a variable in the pattern. We care only about
variable names; the constructor names are not relevant.
*)
fun count_some_var(s, p) =
	g (fn () => 0) (fn v => if v = s then 1 else 0) p

(*13
Write a function check_pat that takes a pattern and returns true if and only if all the variables
appearing in the pattern are distinct from each other (i.e., use different strings). The constructor
names are not relevant. Hints: The sample solution uses two helper functions. The first takes a
pattern and returns a list of all the strings it uses for variables. Using foldl with a function that uses
@ is useful in one case. The second takes a list of strings and decides if it has repeats. List.exists may
be useful. Sample solution is 15 lines. These are hints: We are not requiring foldl and List.exists
here, but they make it easier.
*)
fun check_pat p =
	let
		fun all_strings p =
			case p of
				Variable x        => [x]
				| TupleP ps         => List.foldl (fn (v,vs) => vs @ all_strings(v)) [] ps
				| ConstructorP(_,p) => all_strings(p)
				| _                 => []
		
		fun repeats ls =
			case ls of
				[] => true
				| x::xs => if List.exists (fn a => a = x) xs then false else repeats(xs)
    in
        (repeats o all_strings) p
    end


(*11
Write a function match that takes a valu * pattern and returns a (string * valu) list option,
namely NONE if the pattern does not match and SOME lst where lst is the list of bindings if it does.
Note that if the value matches but the pattern has no patterns of the form Variable s, then the result
is SOME []. Hints: Sample solution has one case expression with 7 branches. The branch for tuples
uses all_answers and ListPair.zip. Sample solution is 13 lines. Remember to look above for the
rules for what patterns match what values, and what bindings they produce. These are hints: We are
not requiring all_answers and ListPair.zip here, but they make it easier
*)
fun match(v, p) =
    case p of
        Variable x => SOME [(x, v)]
      | UnitP =>
        (case v of
             Unit => SOME []
           | _ => NONE)
      | Wildcard => SOME []
      | ConstP k =>
        (case v of
             Const(v) => if k = v then SOME [] else NONE
           | _ => NONE)
      | TupleP ps =>
        (case v of
             Tuple(vs) => if List.length vs = List.length ps
                          then all_answers match (ListPair.zip(vs, ps))
                          else NONE
           | _ => NONE)
      | ConstructorP(s1,pp) =>
        (case v of
             Constructor(s2,vv) =>
             if s1 = s2 then match(vv,pp) else NONE
           | _ => NONE)
            
(*12
Write a function first_match that takes a value and a list of patterns and returns a
(string * valu) list option, namely NONE if no pattern in the list matches or SOME lst where
lst is the list of bindings for the first pattern in the list that matches. Use first_answer and a
handle-expression. Hints: Sample solution is 3 lines.
*)
fun first_match v ps =
    SOME(first_answer (fn p => match(v, p)) ps) 
	handle NoAnswer => NONE
