(*
use "sml/part-1/extra_practice.sml";

alternate [1,2,3,4] = -2
*)

fun alternate (xs: int list) = 
	(*
	Write a function that takes a list of numbers and adds them with alternating sign. 
		alternate [1,2,3,4] = 1 - 2 + 3 - 4 = -2;
	*)
	if null xs
	then 0
	else
		let
			val counter = 1
		in
			if counter mod 2 = 0
			then hd xs + alternate(tl xs)
			else hd xs - alternate(tl xs)
		end


fun min_max (xs: int list) =
	(*
	Write a function min_max that takes a non-empty list of numbers
	and returns a pair of the minimum and maximum of the numbers in the list
		min_max [30, 20, 10, 50, 20] = (10, 50);
	*)
	let 
		fun max (xs : int list) =
		    if null xs
		    then 0
		    else if null (tl xs)
		    then hd xs
		    else
		        let val tl_ans = max(tl xs)
		        in
		            if hd xs > tl_ans
		            then hd xs
		            else tl_ans
		        end

		fun min (xs : int list) =
		    if null xs
		    then 0
		    else if null (tl xs)
		    then hd xs
		    else
		        let val tl_ans = min(tl xs)
		        in
		            if hd xs < tl_ans
		            then hd xs
		            else tl_ans
		        end
	in
		(min(xs), max(xs))
	end

fun greeting(name: string option): string = 
	(*
	Write a function name greeting that given a string  option SOME name 
	returns the string "Hello there ...<Name>" Note that the name is given as an option
	so is NONE then replace the dots with you

	val name = SOME "Hooman";
	greeting name;
	*)
	if isSome(name)
	then "Hello there " ^ valOf(name)
	else "Hello there " ^ "You"



fun repeat (list1: int list, list2: int list) =
	(*	
	Given a list of integers and another list of nonnegative integers, 
	repeats the integers in the first list according to the numbers indicated by the second list. 
	
		repeat ([1,2,3], [4,0,3]) = [1,1,1,1,3,3,3];
	*)
	let
		fun repeat_int(counter : int, value: int): int list = 
			(* 	repeat_int(10, 2);	*)
			if counter > 0
			then value::repeat_int(counter-1, value)
			else []
	in
		if null list1
		then []
		else
		repeat_int(hd list2, hd list1) @ repeat(tl list1, tl list2)
	end	
