
*** Source Program **
x = 0
if (not x):
    print(1)
else: 
    print(2)



*** Target Program **
   3 : .t1 = 0
   4 : x = .t1
   5 : .t3 = x
   6 : .t2 = !.t3
  27 : if .t2 goto 21
  26 : goto 22
  21 : SKIP
   7 : .t5 = 1
   8 : .t6 = " "
  10 : write .t5
   9 : write .t6
  11 : .t7 = "\n"
  12 : write .t7
  13 : .t4 = None
  25 : goto 23
  22 : SKIP
  14 : .t9 = 2
  15 : .t10 = " "
  17 : write .t9
  16 : write .t10
  18 : .t11 = "\n"
  19 : write .t11
  20 : .t8 = None
  24 : goto 23
  23 : SKIP
   2 : HALT

1 
The number of instructions executed : 16
