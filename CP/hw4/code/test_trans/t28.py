
*** Source Program **
x = print(1)
y = []
z = y.append(1)
print(x)
print(y)
print(z)


*** Target Program **
   3 : .t2 = 1
   4 : .t3 = " "
   6 : write .t2
   5 : write .t3
   7 : .t4 = "\n"
   8 : write .t4
   9 : .t1 = None
  10 : x = .t1
  11 : .t5 = []
  12 : y = .t5
  13 : .t7 = y
  14 : .t8 = 1
  16 : .t6 = None
  15 : .t7 = .t7@[.t8]
  17 : z = .t6
  18 : .t10 = x
  19 : .t11 = " "
  21 : write .t10
  20 : write .t11
  22 : .t12 = "\n"
  23 : write .t12
  24 : .t9 = None
  25 : .t14 = y
  26 : .t15 = " "
  28 : write .t14
  27 : write .t15
  29 : .t16 = "\n"
  30 : write .t16
  31 : .t13 = None
  32 : .t18 = z
  33 : .t19 = " "
  35 : write .t18
  34 : write .t19
  36 : .t20 = "\n"
  37 : write .t20
  38 : .t17 = None
   2 : HALT

1 
None 
[1] 
None 
The number of instructions executed : 37
