use "sml/part-1/hw1.sml";

val test_is_older_1 = is_older ((1,2,3),(1,2,3)) = false
val test_is_older_2 = is_older ((1,2,3),(4,5,6)) = true
val test_is_older_3 = is_older ((1,2,3),(4,5,3)) = true
val test_is_older_4 = is_older ((1,2,3),(10,2,3)) = true
val test_is_older_5 = is_older ((4,5,6),(1,2,3)) = false

val test_number_in_month_1 = number_in_month ([(1,2,3), (5,2,10)], 2) = 2
val test_number_in_month_2 = number_in_month ([(1,2,3), (5,3,10)], 2) = 1

val test_number_in_months = number_in_months ([(10,2,28),(10,12,1),(10,3,31),(10,4,28)],[2,3,4]) = 3

val test_dates_in_month_1 = dates_in_month ([(12,2,28),(10,12,1)],2) = [(12,2,28)]
val test_dates_in_month_2 = dates_in_month ([(12,2,28),(10,2,1),(1,5,3)],2) = [(12,2,28),(10,2,1)]

val test_dates_in_months = dates_in_months ([(10,2,28),(20,12,1),(30,3,31),(30,4,28)],[2,3,4]) = [(10,2,28),(30,3,31),(30,4,28)]

val test_get_nth = get_nth (["a", "b", "c", "d"], 2) = "b"

val test_date_to_string_1 = date_to_string (2020, 10, 5) = "October 5, 2020"
val test_date_to_string_2 = date_to_string (2019, 1, 10) = "January 10, 2019"

val test_number_before_reaching_sum = number_before_reaching_sum (10, [1,2,3,4,5]) = 3

val test_what_month_1 = what_month 50 = 2
val test_what_month_2 = what_month 150 = 5

val test_month_range = month_range (29, 35) = [1,1,1,2,2,2,2]

val test_oldest = oldest([(2020,2,28),(2012,2,10),(2019,4,28)]) = SOME (2012,2,10)

val test_cumulative_sum_1 = cumulative_sum [12,27,13] = [12,39,52]
val test_cumulative_sum_1 = cumulative_sum [1,1,1,1,1] = [1,2,3,4,5]

