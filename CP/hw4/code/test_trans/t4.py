
*** Source Program **
i = 0
sum = 0
while (i < 10):
    sum = (sum + i)
    i += 1

print(sum)


*** Target Program **
   3 : .t1 = 0
   4 : i = .t1
   5 : .t2 = 0
   6 : sum = .t2
   7 : SKIP
   9 : .t4 = i
  10 : .t5 = 10
  11 : .t3 = .t4 < .t5
  21 : iffalse .t3 goto 8
  12 : .t7 = sum
  13 : .t8 = i
  14 : .t6 = .t7 + .t8
  15 : sum = .t6
  16 : .t10 = i
  17 : .t11 = 1
  18 : .t9 = .t10 + .t11
  19 : i = .t9
  20 : goto 7
   8 : SKIP
  22 : .t13 = sum
  23 : .t14 = " "
  25 : write .t13
  24 : write .t14
  26 : .t15 = "\n"
  27 : write .t15
  28 : .t12 = None
   2 : HALT

45 
The number of instructions executed : 158
