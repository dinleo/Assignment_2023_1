
*** Source Program **
x = 1
i = 0
while (i < 5):
    if ((not (x == 3)) and (not (x == 2)) and (x == 1)):
        print(x)
    else: 
        print((x + 1))

    i += 1



*** Target Program **
   3 : .t1 = 1
   4 : x = .t1
   5 : .t2 = 0
   6 : i = .t2
   7 : SKIP
   9 : .t4 = i
  10 : .t5 = 5
  11 : .t3 = .t4 < .t5
  55 : iffalse .t3 goto 8
  12 : .t9 = x
  13 : .t10 = 3
  14 : .t8 = .t9 == .t10
  15 : .t7 = !.t8
  16 : .t14 = x
  17 : .t15 = 2
  18 : .t13 = .t14 == .t15
  19 : .t12 = !.t13
  20 : .t18 = x
  21 : .t19 = 1
  22 : .t17 = .t18 == .t19
  23 : .t20 = 1
  24 : .t16 = .t17 && .t20
  25 : .t11 = .t12 && .t16
  26 : .t6 = .t7 && .t11
  49 : if .t6 goto 43
  48 : goto 44
  43 : SKIP
  27 : .t22 = x
  28 : .t23 = " "
  30 : write .t22
  29 : write .t23
  31 : .t24 = "\n"
  32 : write .t24
  33 : .t21 = None
  47 : goto 45
  44 : SKIP
  34 : .t27 = x
  35 : .t28 = 1
  36 : .t26 = .t27 + .t28
  37 : .t29 = " "
  39 : write .t26
  38 : write .t29
  40 : .t30 = "\n"
  41 : write .t30
  42 : .t25 = None
  46 : goto 45
  45 : SKIP
  50 : .t32 = i
  51 : .t33 = 1
  52 : .t31 = .t32 + .t33
  53 : i = .t31
  54 : goto 7
   8 : SKIP
   2 : HALT

1 
1 
1 
1 
1 
The number of instructions executed : 191
