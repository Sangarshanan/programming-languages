(* 
Extra practice problems
https://classes.engineering.wustl.edu/cse425s/index.php?title=SML_Practice_Problems_B#pass_or_fail
*)

(* PART *)

type student_id = int
type grade = int (* must be in 0 to 100 range *)
type final_grade = { id : student_id, grade : grade option }
datatype pass_fail = pass | fail

(*
Write a function 
pass_or_fail of type {grade : int option, id : 'a} -> pass_fail
that takes a final_grade and returns |pass|pass 
if the grade field contains SOME i for an i>=75 else fail.
*)
fun pass_or_fail {grade=grade, id=id} = 
    case grade of
     SOME x => if x >=75 then pass else fail
     | _ => fail

val test_1 = pass_or_fail {grade=SOME 10, id=1} = fail
val test_2 = pass_or_fail {grade=SOME 100, id=1} = pass

(*
Using pass_or_fail as a helper function, 
write a function has_passed of type {grade : int option, id : 'a} -> bool 
that returns true if and only if the the grade field contains SOME i for an i>=75
*)
fun has_passed {grade=grade, id=id} =
    if pass_or_fail {grade=grade, id=id}=pass then true else false

val test_3 = has_passed {grade=SOME 10, id=1} = false
val test_4 = has_passed {grade=SOME 100, id=1} = true

(*
Using has_passed as helper
write number_passed that takes a list of type final_grade
*)
fun number_passed(all_grades: final_grade list) =
    case all_grades of
        [] => 0
    |  x::xs => (if has_passed x=true then 1 else 0) + number_passed(xs)

val test_5 = number_passed([{grade=SOME 10, id=1}]) = 0
val test_6 = number_passed([
    {grade=SOME 10, id=1},
    {grade=SOME 100, id=2},
    {grade=SOME 90, id=3}
]) = 2

(*
Write a function number_misgraded of type (pass_fail * final_grade) list -> int 
that indicates how many list elements are "mislabeled" where 
mislabeling means a pair (pass,x) where has_passed x is false or (fail,x)
where has_passed x is true

number_misgraded([(pass, {grade=SOME 100, id=1})])
*)
fun number_misgraded(assigned_score: (pass_fail * final_grade) list) =
    case assigned_score of
        [] => 0
    |  (x,y)::xs => (if x=pass_or_fail y then 0 else 1) + number_misgraded(xs) 

val test_7 = number_misgraded([(pass, {grade=SOME 100, id=1})]) = 0
val test_8 = number_misgraded([
    (pass, {grade=SOME 10, id=1}),
    (fail, {grade=SOME 100, id=1})
]) = 2


(* PART *)
datatype 'a tree = leaf
                 | node of { value : 'a, left : 'a tree, right : 'a tree }
datatype flag = leave_me_alone | prune_me

val tree1 = node {value=5, left=leaf, right=leaf}
val tree2 = node {
        value= 10,
        left= node {
            value = 5,
            left=leaf,
            right=node { value = 7, left=leaf, right=leaf}
            },
        right= leaf}

val tree_flag = node {
        value= 10,
        left= node {
            value = 5,
            left=leaf,
            right=node { value = prune_me, left=leaf, right=leaf}
            },
        right= leaf}

(*
Write a function tree_height  that accepts an ’a tree and evaluates to a height of this tree. 
The height of a tree is the length of the longest path to a leaf.
Thus the height of a leaf is 0.
*)
fun tree_height(a) =
    case a of
        leaf => 0
    |   node {value=x,left=left,right=right} => 
        let 
            val left_height = tree_height(left)
            val right_height = tree_height(right)
        in
            if left_height > right_height then left_height + 1 else right_height + 1
        end

val test_9 = tree_height(tree1) = 1
val test_10 = tree_height(tree2) = 3

(*
Write a function sum_tree that takes an int tree 
and evaluates to the sum of all values in the nodes.
*)

fun sum_tree(a_tree) =
    case a_tree of
        leaf => 0
    |   node {value=x,left=left,right=right} => 
            x + sum_tree(left) + sum_tree(right)

val test_11 = sum_tree(tree1) = 5
val test_12 = sum_tree(tree2) = 22
