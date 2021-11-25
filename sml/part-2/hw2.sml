(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* 1.
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

(* 2.
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

(* 3.
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

(* 4.
Write a function similar_names which takes in a
string list list of substitution & full name of type {first:string,middle:string,last:string}

The result is all the full names you can produce by substituting for the first name using substitutions.
The answer should begin with the original name & then have 0 or more other names

Example:
similar_names(
   [["Fred","Fredrick"],
   ["Elizabeth","Betty"],
   ["Freddie","Fred","F"]],
   {first="Fred", middle="W", last="Smith"}
)

answer: [
   {first="Fred", last="Smith", middle="W"},
   {first="Fredrick", last="Smith", middle="W"},
   {first="Freddie", last="Smith", middle="W"},
   {first="F", last="Smith", middle="W"}
]
*)

fun similar_names(
   substitution: string list list,
   {first=f,middle=m,last=l}
) =
   let 
      val expected_names = f::get_substitutions2(substitution, f)
      fun helper(expected_names) =
         case expected_names of
            [] => []
            | x::xs => {first=x,middle=m,last=l} :: helper(xs)
   in
      helper(expected_names)
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

(* 5. 
Write a function card_color, which takes a card and returns its color
(spades and clubs are black, diamonds and hearts are red).
Note: One case-expression is enough.
*)
fun card_color(suit,_) = 
   case suit of
      (Clubs | Spades) => Black
    | (Diamonds | Hearts) => Red

(*6.
Write a function card_value, which takes a card and returns its value
numbered cards have their number as the value, aces are 11, everything else is 10
Note: One case-expression is enough.
*)
fun card_value(suit,rank) =
   case rank of
      Ace => 11
   |  Num x => x
   |  _ => 10

(* 7.
Write a function remove_card, which takes a list of cards cs, a card c,
and an exception e. It returns a list that has all the elements of cs except c.
If c is in the list more than once, remove only the first one. If c is not in the list,
raise the exception e. You can compare cards with =
*)
fun remove_card(list_card: card list, c: card, e) =
   let fun discard_card(list_card, c) =
      case list_card of
         []  => []
      | x::xs => if x=c then discard_card(xs, c)
                 else x::discard_card(xs, c)
      val cards_after_removal = discard_card(list_card, c)
   in
      if cards_after_removal = list_card then raise e else cards_after_removal
   end

(*8.
Write a function all_same_color, which takes a list of cards and returns
true if all the cards in the list are the same color
*)
fun all_same_color(cards: card list) =
   case cards of
      [] => true
      | first :: [] => true
      | first :: second :: rest => if card_color(first) = card_color(second)
                                   then all_same_color(second :: rest)
                                   else false
