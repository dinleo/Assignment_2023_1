
*** Source Program **
def fact(n):
    if (n == 0):
        return 1
    else: 
        return (n * fact((n - 1)))


print(fact(20))


*** Target Program **
  25 : def fact(n)
       5 : .t3 = n
       6 : .t4 = 0
       7 : .t2 = .t3 == .t4
      24 : if .t2 goto 18
      23 : goto 19
      18 : SKIP
       8 : .t5 = 1
       9 : return .t5
      22 : goto 20
      19 : SKIP
      10 : .t7 = n
      11 : .t9 = fact
      12 : .t11 = n
      13 : .t12 = 1
      14 : .t10 = .t11 - .t12
      15 : .t8 := call(.t9, (.t10))
      16 : .t6 = .t7 * .t8
      17 : return .t6
      21 : goto 20
      20 : SKIP
       3 : .t1 = None
       4 : return .t1

  26 : .t15 = fact
  27 : .t16 = 20
  28 : .t14 := call(.t15, (.t16))
  29 : .t17 = " "
  31 : write .t14
  30 : write .t17
  32 : .t18 = "\n"
  33 : write .t18
  34 : .t13 = None
   2 : HALT

2432902008176640000 
The number of instructions executed : 298
