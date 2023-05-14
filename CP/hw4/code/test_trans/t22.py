
*** Source Program **
def even_squares(a):
    squares = []
    for x in a:
        if ((x % 2) == 0):
            squares.append((x ** 2))


    return squares

print(even_squares([1,2,3,4,5]))


*** Target Program **
  49 : def even_squares(a)
       5 : .t2 = []
       6 : squares = .t2
       7 : .t6 = 0
       8 : __tidx__.t3 = .t6
       9 : .t7 = a
      10 : __titer__.t4 = .t7
      11 : .t9 = __titer__.t4
      12 : .t8 = len(.t9)
      13 : __tlen__.t5 = .t8
      14 : SKIP
      16 : .t11 = __tidx__.t3
      17 : .t12 = __tlen__.t5
      18 : .t10 = .t11 < .t12
      46 : iffalse .t10 goto 15
      19 : .t14 = __titer__.t4
      20 : .t15 = __tidx__.t3
      21 : .t13 = .t14[.t15]
      22 : x = .t13
      23 : .t17 = __tidx__.t3
      24 : .t18 = 1
      25 : .t16 = .t17 + .t18
      26 : __tidx__.t3 = .t16
      27 : .t21 = x
      28 : .t22 = 2
      29 : .t20 = .t21 % .t22
      30 : .t23 = 0
      31 : .t19 = .t20 == .t23
      44 : if .t19 goto 38
      43 : goto 39
      38 : SKIP
      32 : .t25 = squares
      33 : .t27 = x
      34 : .t28 = 2
      35 : .t26 = .t27 ** .t28
      37 : .t24 = None
      36 : .t25 = .t25@[.t26]
      42 : goto 40
      39 : SKIP
      41 : goto 40
      40 : SKIP
      45 : goto 14
      15 : SKIP
      47 : .t29 = squares
      48 : return .t29
       3 : .t1 = None
       4 : return .t1

  50 : .t32 = even_squares
  51 : .t34 = 1
  52 : .t36 = 2
  53 : .t38 = 3
  54 : .t40 = 4
  55 : .t42 = 5
  56 : .t43 = []
  57 : .t43 = .t42::.t43
  58 : .t41 = .t43
  59 : .t41 = .t40::.t41
  60 : .t39 = .t41
  61 : .t39 = .t38::.t39
  62 : .t37 = .t39
  63 : .t37 = .t36::.t37
  64 : .t35 = .t37
  65 : .t35 = .t34::.t35
  66 : .t33 = .t35
  67 : .t31 := call(.t32, (.t33))
  68 : .t44 = " "
  70 : write .t31
  69 : write .t44
  71 : .t45 = "\n"
  72 : write .t45
  73 : .t30 = None
   2 : HALT

[4, 16] 
The number of instructions executed : 173
