
*** Source Program **
x = 1
y = 1
while (x < 10):
    x += 1
    y = (y * 2)

print(x)
print(y)


*** Target Program **
   3 : .t1 = 1
   4 : x = .t1
   5 : .t2 = 1
   6 : y = .t2
   7 : SKIP
   9 : .t4 = x
  10 : .t5 = 10
  11 : .t3 = .t4 < .t5
  21 : iffalse .t3 goto 8
  12 : .t7 = x
  13 : .t8 = 1
  14 : .t6 = .t7 + .t8
  15 : x = .t6
  16 : .t10 = y
  17 : .t11 = 2
  18 : .t9 = .t10 * .t11
  19 : y = .t9
  20 : goto 7
   8 : SKIP
  22 : .t13 = x
  23 : .t14 = " "
  25 : write .t13
  24 : write .t14
  26 : .t15 = "\n"
  27 : write .t15
  28 : .t12 = None
  29 : .t17 = y
  30 : .t18 = " "
  32 : write .t17
  31 : write .t18
  33 : .t19 = "\n"
  34 : write .t19
  35 : .t16 = None
   2 : HALT

10 
512 
The number of instructions executed : 151
