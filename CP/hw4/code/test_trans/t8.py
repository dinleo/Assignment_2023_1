
*** Source Program **
for s in [92,88,100,150,(- 1),67,55]:
    if ((s < 0) or (s > 100)):
        continue

    print(s)



*** Target Program **
   3 : .t4 = 0
   4 : __tidx__.t1 = .t4
   5 : .t6 = 92
   6 : .t8 = 88
   7 : .t10 = 100
   8 : .t12 = 150
   9 : .t15 = 1
  10 : .t14 = -.t15
  11 : .t17 = 67
  12 : .t19 = 55
  13 : .t20 = []
  14 : .t20 = .t19::.t20
  15 : .t18 = .t20
  16 : .t18 = .t17::.t18
  17 : .t16 = .t18
  18 : .t16 = .t14::.t16
  19 : .t13 = .t16
  20 : .t13 = .t12::.t13
  21 : .t11 = .t13
  22 : .t11 = .t10::.t11
  23 : .t9 = .t11
  24 : .t9 = .t8::.t9
  25 : .t7 = .t9
  26 : .t7 = .t6::.t7
  27 : .t5 = .t7
  28 : __titer__.t2 = .t5
  29 : .t22 = __titer__.t2
  30 : .t21 = len(.t22)
  31 : __tlen__.t3 = .t21
  32 : SKIP
  34 : .t24 = __tidx__.t1
  35 : .t25 = __tlen__.t3
  36 : .t23 = .t24 < .t25
  70 : iffalse .t23 goto 33
  37 : .t27 = __titer__.t2
  38 : .t28 = __tidx__.t1
  39 : .t26 = .t27[.t28]
  40 : s = .t26
  41 : .t30 = __tidx__.t1
  42 : .t31 = 1
  43 : .t29 = .t30 + .t31
  44 : __tidx__.t1 = .t29
  45 : .t34 = s
  46 : .t35 = 0
  47 : .t33 = .t34 < .t35
  48 : .t38 = s
  49 : .t39 = 100
  50 : .t37 = .t38 > .t39
  51 : .t40 = 0
  52 : .t36 = .t37 || .t40
  53 : .t32 = .t33 || .t36
  61 : if .t32 goto 55
  60 : goto 56
  55 : SKIP
  54 : goto 32
  59 : goto 57
  56 : SKIP
  58 : goto 57
  57 : SKIP
  62 : .t42 = s
  63 : .t43 = " "
  65 : write .t42
  64 : write .t43
  66 : .t44 = "\n"
  67 : write .t44
  68 : .t41 = None
  69 : goto 32
  33 : SKIP
   2 : HALT

92 
88 
100 
67 
55 
The number of instructions executed : 261
