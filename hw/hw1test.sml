(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw/hw1.sml";

val test1 = is_older ((1,2,3),(2,3,4)) = true

val test2 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1

val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3

val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]

val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"

val test7 = date_to_string (2013, 6, 1) = "June 1, 2013"

val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3

val test9 = what_month 70 = 3

val test10 = month_range (31, 34) = [1,2,2,2]

val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)

val test01_1 = is_older ((1,2,3),(2,3,4)) = true
val test01_2 = is_older ((1,2,3),(1,3,4)) = true
val test01_3 = is_older ((1,2,3),(1,2,4)) = true
val test01_4 = is_older ((1,2,3),(1,2,3)) = false
val test01_5 = is_older ((1,2,4),(1,2,3)) = false
val test01_6 = is_older ((2012,2,28),(2011,3,31)) = false
val test01_7 = is_older ((2012,2,28),(2012,2,28)) = false
val test01_8 = is_older ((2012,2,28),(2012,3,10)) = true

val test02_1 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1
val test02_2 = number_in_month ([(2012,3,28),(2013,12,1)],2) = 0

val test03_1 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,5]) = 3
val test03_2 = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,3,4,5]) = 3

val test04_1 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]
val test04_2 = dates_in_month ([(2012,3,28),(2013,12,1)],2) = []

val test05_1 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,5]) = [(2012,2,28),(2011,3,31),(2011,4,28)]
val test05_2 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[3,4,2,5]) = [(2011,3,31),(2011,4,28),(2012,2,28)]
val test05_3 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,2,5]) = [(2011,3,31),(2011,4,28),(2012,2,28)]

val test06_1 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"
val test06_2 = get_nth (["January","February","March","April","May","June","July","August","September","October","November","December"], #2 (2023,5,1)) = "May"

val test07_1 = date_to_string (2013, 6, 1) = "June 1, 2013"
val test07_2 = date_to_string (2023, 8, 1) = "August 1, 2023"

val test08_1 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test08_2 = number_before_reaching_sum (5 , [1,2,3,4,5]) = 2
val test08_3 = number_before_reaching_sum (1 , [2,2,3,4,5]) = 0
val test08_4 = number_before_reaching_sum (3 , [2,2,3,4,5]) = 1

val test09_1 = what_month 70 = 3
val test09_2 = what_month 32 = 2
val test09_3 = what_month 59 = 2
val test09_4 = what_month 60 = 3

val test10_1 = month_range (31, 34) = [1,2,2,2]
val test10_2 = month_range (31, 31) = [1]
val test10_3 = month_range (58, 61) = [2,2,3,3]
val test10_4 = month_range (89, 91) = [3,3,4]

val test11_1 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test11_2 = oldest([]) = NONE

val test12_1 = remove_duplicates([1,2,3]) = [1,2,3]
val test12_2 = remove_duplicates([1,2,2,3,1]) = [2,3,1]
val test12_3 = remove_duplicates([]) = []

val test13_1 = reasonable_date((2024,11,24)) = true
val test13_2 = reasonable_date((2024,2,29)) = true
val test13_3 = reasonable_date((2023,2,29)) = false
val test13_4 = reasonable_date((0,2,29)) = false
val test13_5 = reasonable_date((2024,13,29)) = false
val test13_6 = reasonable_date((2024,11,31)) = false