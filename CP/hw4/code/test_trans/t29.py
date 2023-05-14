
*** Source Program **
def f(x):
    x[0] = 0

a = [1,2,3]
f(a)
print(a)


*** Target Program **
   9 : def f(x)
       5 : .t2 = 0
       6 : .t3 = x
       7 : .t4 = 0
       8 : .t3[.t4] = .t2
       3 : .t1 = None
       4 : return .t1

  10 : .t6 = 1
  11 : .t8 = 2
  12 : .t10 = 3
  13 : .t11 = []
  14 : .t11 = .t10::.t11
  15 : .t9 = .t11
  16 : .t9 = .t8::.t9
  17 : .t7 = .t9
  18 : .t7 = .t6::.t7
  19 : .t5 = .t7
  20 : a = .t5
  21 : .t13 = f
  22 : .t14 = a
  23 : .t12 := call(.t13, (.t14))
  24 : .t16 = a
  25 : .t17 = " "
  27 : write .t16
  26 : write .t17
  28 : .t18 = "\n"
  29 : write .t18
  30 : .t15 = None
   2 : HALT

[0, 2, 3] 
The number of instructions executed : 29
