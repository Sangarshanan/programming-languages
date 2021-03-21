(* 
https://courses.cs.washington.edu/courses/cse341/19sp/hw1.pdf

In all problems, a “date” is an SML value of type int*int*int, 
where the first part is the day, the second part is the month, and the
third part is the year. A “reasonable” date has a positive year, a month between 1 and 12, and a day no
greater than 31 (or less depending on the month)
*)

fun is_older (date1: (int*int*int), date2: (int*int*int)) =
	(*
	Write a function is_older that takes two dates and evaluates to true or false. It evaluates to true if
	the first argument is a date that comes before the second argument. (If the two dates are the same,
	the result is false.
	
	eg: (d1,m1,y1) (d2,m2,y2)

	(y2 > y1) or (y2 = y1 and m2 > m1) or (y2 = y1 and m2 = m1 and d2 > d1)
	*)
	(#3 date2 > #3 date1) orelse
	(#3 date2 = #3 date1 andalso #2 date2 > #2 date2) orelse 
	(#3 date2 = #3 date1 andalso #2 date2 = #2 date2 andalso #1 date2 > #1 date1)

