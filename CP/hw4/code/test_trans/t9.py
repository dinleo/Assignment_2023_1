
*** Source Program **
def fact(n):
    i = 1
    r = 1
    while (i <= n):
        r *= i
        i += 1

    return r

def factorial(n):
    return fact(n)

print(factorial(10))


*** Target Program **
  26 : def fact(n)
       5 : .t2 = 1
       6 : i = .t2
       7 : .t3 = 1
       8 : r = .t3
       9 : SKIP
      11 : .t5 = i
      12 : .t6 = n
      13 : .t4 = .t5 <= .t6
      23 : iffalse .t4 goto 10
      14 : .t8 = r
      15 : .t9 = i
      16 : .t7 = .t8 * .t9
      17 : r = .t7
      18 : .t11 = i
      19 : .t12 = 1
      20 : .t10 = .t11 + .t12
      21 : i = .t10
      22 : goto 9
      10 : SKIP
      24 : .t13 = r
      25 : return .t13
       3 : .t1 = None
       4 : return .t1

  33 : def factorial(n)
      29 : .t16 = fact
      30 : .t17 = n
      31 : .t15 := call(.t16, (.t17))
      32 : return .t15
      27 : .t14 = None
      28 : return .t14

  34 : .t20 = factorial
  35 : .t21 = 10
  36 : .t19 := call(.t20, (.t21))
  37 : .t22 = " "
  39 : write .t19
  38 : write .t22
  40 : .t23 = "\n"
  41 : write .t23
  42 : .t18 = None
   2 : HALT

3628800 
The number of instructions executed : 168
