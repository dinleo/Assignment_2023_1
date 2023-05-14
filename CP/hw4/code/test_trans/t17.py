
*** Source Program **
def sum_evens(n):
    sum = 0
    for i in range(1, (n + 1)):
        if ((i % 2) == 0):
            sum += i


    return sum

print(sum_evens(10))
print(sum_evens(100))


*** Target Program **
  51 : def sum_evens(n)
       5 : .t2 = 0
       6 : sum = .t2
       7 : .t6 = 0
       8 : __tidx__.t3 = .t6
       9 : .t8 = 1
      10 : .t10 = n
      11 : .t11 = 1
      12 : .t9 = .t10 + .t11
      13 : .t7 =  range(.t8, .t9)
      14 : __titer__.t4 = .t7
      15 : .t13 = __titer__.t4
      16 : .t12 = len(.t13)
      17 : __tlen__.t5 = .t12
      18 : SKIP
      20 : .t15 = __tidx__.t3
      21 : .t16 = __tlen__.t5
      22 : .t14 = .t15 < .t16
      48 : iffalse .t14 goto 19
      23 : .t18 = __titer__.t4
      24 : .t19 = __tidx__.t3
      25 : .t17 = .t18[.t19]
      26 : i = .t17
      27 : .t21 = __tidx__.t3
      28 : .t22 = 1
      29 : .t20 = .t21 + .t22
      30 : __tidx__.t3 = .t20
      31 : .t25 = i
      32 : .t26 = 2
      33 : .t24 = .t25 % .t26
      34 : .t27 = 0
      35 : .t23 = .t24 == .t27
      46 : if .t23 goto 40
      45 : goto 41
      40 : SKIP
      36 : .t29 = sum
      37 : .t30 = i
      38 : .t28 = .t29 + .t30
      39 : sum = .t28
      44 : goto 42
      41 : SKIP
      43 : goto 42
      42 : SKIP
      47 : goto 18
      19 : SKIP
      49 : .t31 = sum
      50 : return .t31
       3 : .t1 = None
       4 : return .t1

  52 : .t34 = sum_evens
  53 : .t35 = 10
  54 : .t33 := call(.t34, (.t35))
  55 : .t36 = " "
  57 : write .t33
  56 : write .t36
  58 : .t37 = "\n"
  59 : write .t37
  60 : .t32 = None
  61 : .t40 = sum_evens
  62 : .t41 = 100
  63 : .t39 := call(.t40, (.t41))
  64 : .t42 = " "
  66 : write .t39
  65 : write .t42
  67 : .t43 = "\n"
  68 : write .t43
  69 : .t38 = None
   2 : HALT

30 
2550 
The number of instructions executed : 2867
