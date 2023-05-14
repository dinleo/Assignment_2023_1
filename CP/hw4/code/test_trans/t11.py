
*** Source Program **
def even(n):
    if (n == 0):
        return True
    else: 
        if (n == 1):
            return False
        else: 
            return odd((n - 1))



def odd(n):
    if (n == 0):
        return False
    else: 
        if (n == 1):
            return True
        else: 
            return even((n - 1))



assert even(10)
assert odd(even(512))
print(even(100))
print(odd(101))


*** Target Program **
  35 : def even(n)
       5 : .t3 = n
       6 : .t4 = 0
       7 : .t2 = .t3 == .t4
      34 : if .t2 goto 28
      33 : goto 29
      28 : SKIP
       8 : .t5 = 1
       9 : return .t5
      32 : goto 30
      29 : SKIP
      10 : .t7 = n
      11 : .t8 = 1
      12 : .t6 = .t7 == .t8
      27 : if .t6 goto 21
      26 : goto 22
      21 : SKIP
      13 : .t9 = 0
      14 : return .t9
      25 : goto 23
      22 : SKIP
      15 : .t11 = odd
      16 : .t13 = n
      17 : .t14 = 1
      18 : .t12 = .t13 - .t14
      19 : .t10 := call(.t11, (.t12))
      20 : return .t10
      24 : goto 23
      23 : SKIP
      31 : goto 30
      30 : SKIP
       3 : .t1 = None
       4 : return .t1

  68 : def odd(n)
      38 : .t17 = n
      39 : .t18 = 0
      40 : .t16 = .t17 == .t18
      67 : if .t16 goto 61
      66 : goto 62
      61 : SKIP
      41 : .t19 = 0
      42 : return .t19
      65 : goto 63
      62 : SKIP
      43 : .t21 = n
      44 : .t22 = 1
      45 : .t20 = .t21 == .t22
      60 : if .t20 goto 54
      59 : goto 55
      54 : SKIP
      46 : .t23 = 1
      47 : return .t23
      58 : goto 56
      55 : SKIP
      48 : .t25 = even
      49 : .t27 = n
      50 : .t28 = 1
      51 : .t26 = .t27 - .t28
      52 : .t24 := call(.t25, (.t26))
      53 : return .t24
      57 : goto 56
      56 : SKIP
      64 : goto 63
      63 : SKIP
      36 : .t15 = None
      37 : return .t15

  69 : .t30 = even
  70 : .t31 = 10
  71 : .t29 := call(.t30, (.t31))
  72 : assert .t29
  73 : .t33 = odd
  74 : .t35 = even
  75 : .t36 = 512
  76 : .t34 := call(.t35, (.t36))
  77 : .t32 := call(.t33, (.t34))
  78 : assert .t32
  79 : .t39 = even
  80 : .t40 = 100
  81 : .t38 := call(.t39, (.t40))
  82 : .t41 = " "
  84 : write .t38
  83 : write .t41
  85 : .t42 = "\n"
  86 : write .t42
  87 : .t37 = None
  88 : .t45 = odd
  89 : .t46 = 101
  90 : .t44 := call(.t45, (.t46))
  91 : .t47 = " "
  93 : write .t44
  92 : write .t47
  94 : .t48 = "\n"
  95 : write .t48
  96 : .t43 = None
   2 : HALT

1 
1 
The number of instructions executed : 13038
