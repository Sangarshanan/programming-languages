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




