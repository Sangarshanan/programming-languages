use "sml/part-1/hw1.sml";

val test_is_older_1 = is_older ((1,2,3),(1,2,3)) = false
val test_is_older_2 = is_older ((1,2,3),(4,5,6)) = true
val test_is_older_3 = is_older ((1,2,3),(4,5,3)) = true
val test_is_older_4 = is_older ((1,2,3),(10,2,3)) = true
val test_is_older_5 = is_older ((4,5,6),(1,2,3)) = false
