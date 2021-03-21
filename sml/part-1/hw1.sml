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

fun number_in_month (dates: (int*int*int) list, month: int ) =
    (*
    Write a function number_in_month that takes a list of dates and a month (i.e., an int) and returns
    how many dates in the list are in the given month

    eg: number_in_month [(1,2,3), (5,2,10)], 2 => 2 ; [(1,2,3), (5,3,10)], 2 => 1

    foreach element in list if list[2] == given_month then counter+=1
    *)
    if null dates
    then 0
    else
        let 
            val counter = if #2 (hd dates) = month then 1 else 0
        in 
            counter + number_in_month(tl dates, month)
        end

fun number_in_months (dates: (int*int*int) list, months: int list ) = 
    (*
    Write a function number_in_months that takes a list of dates and a list of months (i.e., an int list)
    and returns the number of dates in the list of dates that are in any of the months in the list of months.
    Assume the list of months has no number repeated.

    number_in_months ([(10,2,28),(10,12,1),(10,3,31),(10,4,28)],[5,3,4]) = 3
    *)
    if null months
    then 0
    else
    number_in_month(dates, hd months) + number_in_months(dates, tl months);


fun dates_in_month (dates: (int*int*int) list, month: int ) =
    (* 
    Write a function dates_in_month that takes a list of dates and a month (i.e., an int) and returns a
    list holding the dates from the argument list of dates that are in the month. The returned list should
    contain dates in the order they were originally given.

    dates_in_month ([(12,2,28),(10,12,1)],2) = [(12,2,28)]
    *)
    if null dates
    then []
    else
    if #2 (hd dates) = month then hd dates::dates_in_month(tl dates, month) else []



