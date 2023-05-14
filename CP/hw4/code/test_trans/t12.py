
*** Source Program **
x = 1
def f(a):
    return (a + x)

print(f(1))
x = 2
print(f(1))


*** Target Program **
   3 : .t1 = 1
   4 : x = .t1
  11 : def f(a)
       7 : .t4 = a
       8 : .t5 = x
       9 : .t3 = .t4 + .t5
      10 : return .t3
       5 : .t2 = None
       6 : return .t2

  12 : .t8 = f
  13 : .t9 = 1
  14 : .t7 := call(.t8, (.t9))
  15 : .t10 = " "
  17 : write .t7
  16 : write .t10
  18 : .t11 = "\n"
  19 : write .t11
  20 : .t6 = None
  21 : .t12 = 2
  22 : x = .t12
  23 : .t15 = f
  24 : .t16 = 1
  25 : .t14 := call(.t15, (.t16))
  26 : .t17 = " "
  28 : write .t14
  27 : write .t17
  29 : .t18 = "\n"
  30 : write .t18
  31 : .t13 = None
   2 : HALT

2 
3 
The number of instructions executed : 32
