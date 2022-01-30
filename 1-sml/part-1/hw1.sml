(* 
https://courses.cs.washington.edu/courses/cse341/19sp/hw1.pdf

In all problems, a “date” is an SML value of type int*int*int, 
where the first part is the day, the second part is the month, and the
third part is the year. A “reasonable” date has a positive year, a month between 1 and 12, and a day no
greater than 31 (or less depending on the month)
*)

fun is_older (date1: (int*int*int), date2: (int*int*int)) =
    (* 1
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
    (* 2
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
    (* 3
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
    (* 4
    Write a function dates_in_month that takes a list of dates and a month (i.e., an int) and returns a
    list holding the dates from the argument list of dates that are in the month. The returned list should
    contain dates in the order they were originally given.

    dates_in_month ([(12,2,28),(10,12,1)],2) = [(12,2,28)]
    *)
    if null dates
    then []
    else
    if #2 (hd dates) = month then hd dates::dates_in_month(tl dates, month) else dates_in_month(tl dates, month)


fun dates_in_months (dates : (int*int*int) list, months : int list) =
    (* 5
    Write a function dates_in_months that takes a list of dates and a list of months (i.e., an int list)
    and returns a list holding the dates from the argument list of dates that are in any of the months in
    the list of months. Assume the list of months has no number repeated

    dates_in_months ([(10,2,28),(20,12,1),(30,3,31),(30,4,28)],[2,3,4]) = [(10,2,28),(30,3,31),(30,4,28)]
    *)
    if null months
    then []
    else
    dates_in_month(dates, hd months) @ dates_in_months(dates, tl months);


fun get_nth(list_of_string, n: int) =
    (* 
    Write a function get_nth that takes a list of strings and an int n and returns the n
    th element of the list where the head of the list is 1st. 
    Do not worry about the case where the list has too few elements:
    your function may apply hd or tl to the empty list in this case, which is okay

    Psuedo: if n = 1 return the head of the list else n - 1 and list = tl list

    get_nth (["a", "b", "c", "d"], 2) = "b"
    *)
    if n = 1
    then hd list_of_string
    else
    get_nth(tl list_of_string, n-1)


fun date_to_string( date : (int*int*int) ) =

    (*
    Write a function date_to_string that takes a date and returns a string of the form September-10-2015
    (for example). Use the operator ^ for concatenating strings and the library function Int.toString
    for converting an int to a string. For producing the month part, do not use a bunch of conditionals.
    Instead, use a list holding 12 strings and your answer to the previous problem. For consistency, use
    hyphens exactly as in the example and use English month names: January, February, March, April,
    May, June, July, August, September, October, November, December 

    date_to_string (2020, 10, 5) = "October 5, 2020"
    *)
    let
        val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in 
        get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end


fun number_before_reaching_sum(sum: int, int_list: int list) =
    (*
    Write a function number_before_reaching_sum that takes an int called sum, which you can assume
    is positive, and an int list, which you can assume contains all positive numbers, and returns an int.
    You should return an int n such that the first n elements of the list add to less than sum, but the first
    n + 1 elements of the list add to sum or more. Assume the entire list sums to more than the passed in
    value; it is okay for an exception to occur if this is not the case

    number_before_reaching_sum (10, [1,2,3,4,5]) = 3

    *)
    if hd int_list >= sum
    then 0
    else
    1 + number_before_reaching_sum(sum - hd int_list, tl int_list)


fun what_month(day : int) =
    (*
    Write a function what_month that takes a day of year (i.e., an int between 1 and 365) and returns
    what month that day is in (1 for January, 2 for February, etc.). Use a list holding 12 integers and your
    answer to the previous problem

    what_month 50 = 2 # Non leap year
    *)
    let
        val lengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        1 + number_before_reaching_sum(day, lengths)
    end


fun month_range(day1: int, day2: int) =
    (*
    Write a function month_range that takes two days of the year day1 and day2 and returns an int list
    [m1,m2,...,mn] where m1 is the month of day1, m2 is the month of day1+1, ..., and mn is the month
    of day day2. Note the result will have length day2 - day1 + 1 or length 0 if day1>day2.

    month_range (31, 34) = [1,2,2,2]

    *)
    if day1 > day2
    then []
    else
    what_month(day1)::month_range(day1+1, day2)


fun oldest(dates: (int*int*int) list) =
    (*
    Write a function oldest that takes a list of dates and evaluates to an (int*int*int) option. It
    evaluates to NONE if the list has no dates else SOME d where the date d is the oldest date in the list.

    oldest([(2020,2,28),(2012,2,10),(2019,4,28)]) = SOME (2012,2,10)
    *)
    if null dates
    then NONE
    else
        let val tl_ans = oldest(tl dates)
        in
            if isSome tl_ans andalso is_older(valOf(tl_ans), hd dates)
            then tl_ans
            else SOME (hd dates)
        end


fun cumulative_sum(xs : int list) = 
    (*
    Write a function cumulative_sum that takes a list of numbers and returns a list of the partial sums
    of these numbers.

    cumulative_sum [12,27,13] = [12,39,52] i.e [12, 12+27, 12+27+13]
    *)
    let
        fun helper_cumsum(value: int, xs: int list) =
            if null xs
            then []
            else
            value + hd xs :: helper_cumsum(value + hd xs, tl xs)
    in
        helper_cumsum(0, xs)
    end

(*

Challenge Problem: Write functions number_in_months_challenge and dates_in_months_challenge
that are like your solutions to problems 3 and 5 except having a month in the second argument multiple
times has no more effect than having it once. (Hint: Remove duplicates, then use previous work.)

*)

fun remove_duplicates (xs: int list) =
    (*Remove duplicates From a list of integers*)
    let 
        fun exists(xs: int list, value: int) = 
            if null xs
            then false
            else
            (value=hd xs) orelse exists(tl xs, value)
    in
        if null xs
        then []
        else
            if exists(tl xs, hd xs)
            then remove_duplicates(tl xs)
            else
            hd xs:: remove_duplicates(tl xs)
    end


fun number_in_months_challenge (dates,months) =
    number_in_months (dates, remove_duplicates months)

fun dates_in_months_challenge (dates,months) =
    dates_in_months (dates, remove_duplicates months)


fun reasonable_date(date: (int*int*int)): bool =
    (*
    Challenge Problem: Write a function reasonable_date that takes a date and determines if it
    describes a real date in the common era. A “real date” has a positive year (year 0 did not exist)
    month between 1 and 12, and a day appropriate for the month. Solutions should properly handle leap
    years. Leap years are years that are either divisible by 400 or divisible by 4 but not divisible by 100.

        reasonable_date (1900,2,29)
        reasonable_date (1904,2,29)
    *)

    let
        val year = #1 date
        val leap_year = year mod 400 = 0 orelse (year mod 4 = 0 andalso year mod 100 <> 0)
        val month = #2 date
        val day = #3 date
        val days_in_months = [31,28,31,30,31,30,31,31,30,31,30,31]
        val days_in_months_leap = [31,29,31,30,31,30,31,31,30,31,30,31]
        val days_in_months = if leap_year then days_in_months_leap else days_in_months
    in
        (*Negative year Booo*)
        if year <= 0 then false else
            (*1 - 12 Months orelse Booo*)
            if month < 1 orelse month > 12 then false else
                if day > get_nth(days_in_months,month) then false else true
    end
