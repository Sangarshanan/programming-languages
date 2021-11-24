(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(*
1.
Write a function all_except_option: which takes a string and a string list. 
Return NONE if the string is not in the list, else return SOME lst where lst is 
identical to the argument list except the string is not in it.
You may assume the string is in the list at most once.
Use same_string provided to you to compare strings. 
*)

fun all_except_option (str1 : string, str_list : string list) =
   let fun remove_str1_from_list (str1, str_list) =
      case str_list of
         [] => []
       | x::xs => if 
                  same_string(str1, x)
                  then
                  remove_str1_from_list(str1, xs)
                  else
                  x::remove_str1_from_list(str1, xs)
      val filtered_list = remove_str1_from_list(str1, str_list)
   in
      if filtered_list = str_list then NONE else SOME filtered_list
   end

(*
2.
Write a function get_substitutions1 which takes
a list of strings (the substitutions) and a string s to return a string list
The result has all the strings that are in some list in substitutions that also has s
but s itself should not be in the result.

Example: 
get_substitutions1(
   [["Fred","Fredrick"],
   ["Elizabeth","Betty"],
   ["Freddie","Fred","F"]],
   "Fred"
)  Returns = ["Fredrick","Freddie","F"]

Assume each list in substitutions has no repeats.
The result will have repeats if s and another string are both in more than one list in substitutions.
*)
fun get_substitutions1(substitutions : string list list, s : string) =
   case substitutions of
      [] => []
      |  x :: xs => let val all_except_list = all_except_option(s,x)
   in
     case all_except_list of
        NONE => get_substitutions1(xs, s)
      | SOME subs_list => subs_list @ get_substitutions1(xs, s)
   end


(*
3.
Make get_substitutions1 Tail Recursive
by adding an accumulator
*)
fun get_substitutions2(substitutions : string list list, s : string) =
    let fun f (substitutions : string list list, matches : string list ) =
      case substitutions of
         [] => matches
         | x::xs => let val result = all_except_option(s,x) 
      in
         case result of
            NONE => f(xs, matches)
          | SOME subs_list => f(xs, matches @ subs_list)
      end
    in
        f(substitutions, [])
    end




(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
